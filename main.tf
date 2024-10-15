data "aws_caller_identity" "default" {}


resource "random_string" "bucket_prefix" {
  count   = module.this.enabled ? 1 : 0
  length  = 12
  numeric = false
  upper   = false
  special = false
  lower   = true
}

resource "aws_codebuild_project" "default" {
  count                  = module.this.enabled ? 1 : 0
  name                   = var.project_name
  description            = var.description
  concurrent_build_limit = var.concurrent_build_limit
  service_role           = var.service_role_arn
  badge_enabled          = var.badge_enabled
  build_timeout          = var.build_timeout
  source_version         = var.source_version != "" ? var.source_version : null
  encryption_key         = var.encryption_key


  tags = {
    for name, value in module.this.tags :
    name => value
    if length(value) > 0
  }
  artifacts {
    type                   = var.artifacts[0].type
    location               = var.artifacts[0].location
    name                   = var.artifacts[0].name
    path                   = var.artifacts[0].path
    namespace_type         = var.artifacts[0].namespace_type
    packaging              = var.artifacts[0].packaging
    encryption_disabled    = var.artifacts[0].encryption_disabled
    override_artifact_name = var.artifacts[0].override_artifact_name
  }

  # Secondary Artifacts
  dynamic "secondary_artifacts" {
    for_each = slice(var.secondary_artifacts, 1, length(var.secondary_artifacts))
    content {
      artifact_identifier    = secondary_artifacts.value.artifact_identifier
      type                   = secondary_artifacts.value.type
      location               = secondary_artifacts.value.location
      name                   = secondary_artifacts.value.name
      path                   = secondary_artifacts.value.path
      namespace_type         = secondary_artifacts.value.namespace_type
      packaging              = secondary_artifacts.value.packaging
      encryption_disabled    = secondary_artifacts.value.encryption_disabled
      override_artifact_name = secondary_artifacts.value.override_artifact_name
    }
  }

  # Since the output type is restricted to S3 by the provider (this appears to
  # be an bug in AWS, rather than an architectural decision; see this issue for
  # discussion: https://github.com/hashicorp/terraform-provider-aws/pull/9652),
  # this cannot be a CodePipeline output. Otherwise, _all_ of the artifacts
  # would need to be secondary if there were more than one. For reference, see
  # https://docs.aws.amazon.com/codepipeline/latest/userguide/action-reference-CodeBuild.html#action-reference-CodeBuild-config.

  # According to AWS documention, in order to have the artifacts written
  # to the root of the bucket, the 'namespace_type' should be 'NONE'
  # (which is the default), 'name' should be '/', and 'path' should be
  # empty. For reference, see https://docs.aws.amazon.com/codebuild/latest/APIReference/API_ProjectArtifacts.html.
  # However, I was unable to get this to deploy to the root of the bucket
  # unless path was also set to '/'.
  # path = "/"
  #name = "/"
  # }


  cache {
    type     = var.cache_type
    location = var.s3_cache_bucket_name
    modes = [var.local_caches_modes]
  }

  environment {
    compute_type                = var.build_compute_type
    image                       = var.build_image
    image_pull_credentials_type = var.build_image_pull_credentials_type
    type                        = var.build_type
    privileged_mode             = var.privileged_mode

    dynamic "environment_variable" {
      for_each = var.environment_variables
      content {
        name  = environment_variable.value.name
        value = environment_variable.value.value
        type  = environment_variable.value.type
      }
    }

  }

  source {
    buildspec           = var.buildspec
    type                = var.source_type
    location            = var.source_location
    report_build_status = var.report_build_status
    git_clone_depth     = var.git_clone_depth != null ? var.git_clone_depth : null

    dynamic "git_submodules_config" {
      for_each = var.fetch_git_submodules ? [""] : []
      content {
        fetch_submodules = true
      }
    }
  }

  dynamic "secondary_sources" {
    for_each = var.secondary_sources
    content {
      git_clone_depth     = secondary_source.value.git_clone_depth
      location            = secondary_source.value.location
      source_identifier   = secondary_source.value.source_identifier
      buildspec           = secondary_source.value.buildspec
      type                = secondary_source.value.type
      insecure_ssl        = secondary_source.value.insecure_ssl
      report_build_status = secondary_source.value.report_build_status

      git_submodules_config {
        fetch_submodules = secondary_source.value.fetch_submodules
      }
    }
  }

  dynamic "vpc_config" {
    for_each = (lookup(var.vpc_config, "vpc_id", null) != null && length(lookup(var.vpc_config, "subnets", [])) > 0 && length(lookup(var.vpc_config, "security_group_ids", [])) > 0) ? [1] : []
    content {
      vpc_id             = lookup(var.vpc_config, "vpc_id", null)
      subnets            = lookup(var.vpc_config, "subnets", null)
      security_group_ids = lookup(var.vpc_config, "security_group_ids", null)
    }
  }

  dynamic "logs_config" {
    for_each = length(var.logs_config) > 0 ? [""] : []
    content {
      dynamic "cloudwatch_logs" {
        for_each = contains(keys(var.logs_config), "cloudwatch_logs") ? { key = var.logs_config["cloudwatch_logs"] } : {}
        content {
          status      = lookup(cloudwatch_logs.value, "status", null)
          group_name  = lookup(cloudwatch_logs.value, "group_name", null)
          stream_name = lookup(cloudwatch_logs.value, "stream_name", null)
        }
      }

      dynamic "s3_logs" {
        for_each = contains(keys(var.logs_config), "s3_logs") ? { key = var.logs_config["s3_logs"] } : {}
        content {
          status              = lookup(s3_logs.value, "status", null)
          location            = lookup(s3_logs.value, "location", null)
          encryption_disabled = lookup(s3_logs.value, "encryption_disabled", null)
        }
      }
    }
  }

  dynamic "file_system_locations" {
    for_each = length(var.file_system_locations) > 0 ? [""] : []
    content {
      identifier    = lookup(file_system_locations.value, "identifier", null)
      location      = lookup(file_system_locations.value, "location", null)
      mount_options = lookup(file_system_locations.value, "mount_options", null)
      mount_point   = lookup(file_system_locations.value, "mount_point", null)
      type          = lookup(file_system_locations.value, "type", null)
    }
  }
}

# Pull the github_token from the Secrets Manager
data "aws_secretsmanager_secret" "secret" {
  count = var.enable_github_authentication ? 1 : 0

  arn = var.github_token
}

data "aws_secretsmanager_secret_version" "current_secret" {
  count = var.enable_github_authentication ? 1 : 0

  secret_id = data.aws_secretsmanager_secret.secret[0].id
}

# Aunthenticate with Github
resource "aws_codebuild_source_credential" "github_authentication" {
  count       = var.enable_github_authentication ? 1 : 0
  auth_type   = var.source_credential_auth_type
  server_type = var.source_credential_server_type
  token       = data.aws_secretsmanager_secret_version.current_secret[0].secret_string
  user_name   = var.source_credential_user_name
}

# Set up webhook for Github, Bitbucket
resource "aws_codebuild_webhook" "webhook" {
  count = var.create_webhooks ? 1 : 0

  project_name = aws_codebuild_project.default[0].name
  build_type   = var.webhook_build_type
  dynamic "filter_group" {
    for_each = length(var.webhook_filters) > 0 ? [1] : []
    content {
      dynamic "filter" {
        for_each = var.webhook_filters
        content {
          type    = filter.key
          pattern = filter.value
        }
      }
    }
  }
}
