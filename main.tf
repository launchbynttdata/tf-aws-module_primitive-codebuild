data "aws_caller_identity" "default" {}

# Optional: Lookup existing S3 bucket by name
data "aws_s3_bucket" "artifact_bucket" {
  bucket     = local.cache_bucket_name # Fetch information about the existing S3 bucket
  depends_on = [module.s3_bucket]
}

# Create the IAM role for CodeBuild
resource "aws_iam_role" "codebuild_role" {
  name               = "${var.project_name}-codebuild-role"
  assume_role_policy = data.aws_iam_policy_document.codebuild_assume_role_policy.json
}

# Assume role policy for CodeBuild service
data "aws_iam_policy_document" "codebuild_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
    effect = "Allow"
  }
}

# IAM policy for CodeBuild, granting access to S3, CloudWatch Logs, etc.
data "aws_iam_policy_document" "codebuild_policy" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "iam:PassRole",
      "s3:GetObject",
      "s3:PutObject",
      "s3:ListBucket",
      "s3:GetBucketAcl",
      "s3:GetBucketLocation",
      "codebuild:StartBuild",
      "codebuild:BatchGetBuilds",
      "codebuild:BatchGetProjects"
    ]
    resources = [
      module.s3_bucket.arn,
      "${module.s3_bucket.arn}/*",
      "arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.default.account_id}:log-group:/aws/codebuild/${var.project_name}*"
    ]
    effect = "Allow"
  }
}

# Attach the policy to the IAM role
resource "aws_iam_role_policy" "codebuild_policy" {
  name   = "${var.project_name}-codebuild-policy"
  role   = aws_iam_role.codebuild_role.id
  policy = data.aws_iam_policy_document.codebuild_policy.json
}

module "s3_bucket" {
  source = "github.com/launchbynttdata/tf-aws-module_collection-s3_bucket.git?ref=1.0.0"

  logical_product_family  = var.logical_product_family
  logical_product_service = var.logical_product_service
  region                  = var.aws_region
  class_env               = var.class_env

  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  restrict_public_buckets = var.restrict_public_buckets
  ignore_public_acls      = var.ignore_public_acls

  kms_s3_key_arn                     = aws_kms_key.kms_key.arn
  kms_s3_key_sse_algorithm           = var.kms_s3_key_sse_algorithm
  bucket_key_enabled                 = var.bucket_key_enabled
  use_default_server_side_encryption = var.use_default_server_side_encryption

  enable_versioning        = var.enable_versioning
  lifecycle_rule           = var.lifecycle_rule
  metric_configuration     = var.metric_configuration
  analytics_configuration  = var.analytics_configuration
  bucket_name              = local.cache_bucket_name
  tags                     = var.tags
  object_ownership         = var.object_ownership
  control_object_ownership = var.control_object_ownership
  acl                      = var.acl
}

# AWS KMS Key Resource
resource "aws_kms_key" "kms_key" {
  description             = var.kms_key_description
  deletion_window_in_days = var.kms_key_deletion_window_in_days
  enable_key_rotation     = true
}

resource "random_string" "bucket_prefix" {
  count   = var.codebuild_enabled ? 1 : 0
  length  = 12
  numeric = false
  upper   = false
  special = false
  lower   = true
}

resource "aws_codebuild_project" "default" {
  #count                  = var.codebuild_enabled ? 1 : 0
  name                   = var.project_name
  description            = var.description
  concurrent_build_limit = var.concurrent_build_limit
  service_role           = var.service_role_arn
  badge_enabled          = var.badge_enabled
  build_timeout          = var.build_timeout
  source_version         = var.source_version != "" ? var.source_version : null
  encryption_key         = var.encryption_key

  tags = merge(local.tags_context, var.tags)

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

  cache {
    type     = var.cache_type
    location = var.s3_cache_bucket_name
    modes    = [var.caches_modes]
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

# # Pull the github_token from the Secrets Manager
# data "aws_secretsmanager_secret" "secret" {
#   count = var.enable_github_authentication ? 1 : 0

#   arn = var.github_token
# }

# data "aws_secretsmanager_secret_version" "current_secret" {
#   count = var.enable_github_authentication ? 1 : 0

#   secret_id = data.aws_secretsmanager_secret.secret[0].id
# }

# # Aunthenticate with Github
# resource "aws_codebuild_source_credential" "github_authentication" {
#   count       = var.enable_github_authentication ? 1 : 0
#   auth_type   = var.source_credential_auth_type
#   server_type = var.source_credential_server_type
#   token       = data.aws_secretsmanager_secret_version.current_secret[0].secret_string
#   user_name   = var.source_credential_user_name
# }

# # Set up webhook for Github, Bitbucket
# resource "aws_codebuild_webhook" "webhook" {
#   count = var.create_webhooks ? 1 : 0

#   project_name = aws_codebuild_project.default[0].name
#   build_type   = var.webhook_build_type
#   dynamic "filter_group" {
#     for_each = length(var.webhook_filters) > 0 ? [1] : []
#     content {
#       dynamic "filter" {
#         for_each = var.webhook_filters
#         content {
#           type    = filter.key
#           pattern = filter.value
#         }
#       }
#     }
#   }
# }


