# # # Fetch information about the AWS account and region
# # data "aws_caller_identity" "default" {}
# # data "aws_region" "default" {}

# # # S3 Bucket for Cache
# # resource "aws_s3_bucket" "cache_bucket" {
# #   count         = module.this.enabled && local.create_s3_cache_bucket ? 1 : 0
# #   bucket        = local.cache_bucket_name_normalised
# #   force_destroy = true
# #   tags          = var.tags
# # }

# # resource "aws_s3_bucket_server_side_encryption_configuration" "cache_bucket_encryption" {
# #   bucket = aws_s3_bucket.cache_bucket[0].id
# #   rule {
# #     apply_server_side_encryption_by_default {
# #       sse_algorithm = "AES256"
# #     }
# #   }

# # }
# # # S3 Bucket Versioning (New syntax using a separate resource)
# # resource "aws_s3_bucket_versioning" "cache_bucket_versioning" {
# #   bucket = aws_s3_bucket.cache_bucket[0].id

# #   versioning_configuration {
# #     status = var.versioning_enabled ? "Enabled" : "Suspended"
# #   }
# # }

# # # S3 Bucket Lifecycle Configuration (New syntax using a separate resource)
# # resource "aws_s3_bucket_lifecycle_configuration" "cache_bucket_lifecycle" {
# #   bucket = aws_s3_bucket.cache_bucket[0].id

# #   rule {
# #     id     = "codebuildcache"
# #     status = var.lifecycle_rule_enabled ? "Enabled" : "Disabled"

# #     filter {
# #       prefix = "/"
# #     }

# #     expiration {
# #       days = var.cache_expiration_days
# #     }

# #   }
# # }

# # # IAM Role for CodeBuild
# # resource "aws_iam_role" "default" {
# #   count                 = module.this.enabled ? 1 : 0
# #   name                  = "${var.project_name}-role"
# #   assume_role_policy    = data.aws_iam_policy_document.role.json
# #   force_detach_policies = true
# #   path                  = var.iam_role_path
# #   permissions_boundary  = var.iam_permissions_boundary

# #   dynamic "inline_policy" {
# #     for_each = var.codebuild_iam != null ? [1] : []
# #     content {
# #       name   = "${var.project_name}-policy"
# #       policy = var.codebuild_iam
# #     }
# #   }

# #   tags = var.tags
# # }

# # # IAM Policy to Assume CodeBuild Role
# # data "aws_iam_policy_document" "role" {
# #   statement {
# #     sid     = ""
# #     actions = ["sts:AssumeRole"]

# #     principals {
# #       type        = "Service"
# #       identifiers = ["codebuild.amazonaws.com"]
# #     }

# #     effect = "Allow"
# #   }
# # }

# # # IAM Policy for Additional Permissions
# # data "aws_iam_policy_document" "permissions" {
# #   statement {
# #     sid = ""

# #     actions = compact(concat([
# #       "iam:PassRole",
# #       "logs:CreateLogGroup",
# #       "logs:CreateLogStream",
# #       "logs:PutLogEvents",
# #       "s3:GetObject",
# #       "s3:ListObject",
# #     ], var.extra_permissions))

# #     effect    = "Allow"
# #     resources = ["*"]
# #   }

# #   dynamic "statement" {
# #     for_each = var.secondary_artifact_location != null ? [1] : []
# #     content {
# #       sid     = ""
# #       actions = ["s3:PutObject", "s3:GetBucketAcl", "s3:GetBucketLocation"]
# #       effect  = "Allow"
# #       resources = [
# #         join("", data.aws_s3_bucket.secondary_artifact.*.arn),
# #         "${join("", data.aws_s3_bucket.secondary_artifact.*.arn)}/*",
# #       ]
# #     }
# #   }
# # }

# # # IAM Policy Attachment for Default Role
# # resource "aws_iam_policy" "default" {
# #   count  = module.this.enabled ? 1 : 0
# #   name   = "${var.project_name}-policy"
# #   path   = var.iam_policy_path
# #   policy = data.aws_iam_policy_document.combined_permissions.json
# #   tags   = var.tags
# # }

# # # S3 Bucket Data Source for Secondary Artifacts
# # data "aws_s3_bucket" "secondary_artifact" {
# #   count  = module.this.enabled && var.secondary_artifact_location != null ? 1 : 0
# #   bucket = var.secondary_artifact_location
# # }

# # # Combined IAM Policy Document for Permissions
# # data "aws_iam_policy_document" "combined_permissions" {
# #   override_policy_documents = compact([data.aws_iam_policy_document.permissions.json])
# # }

# # # Attaching policy to role
# # resource "aws_iam_policy_attachment" "codebuild_policy_attachment" {
# #   name       = "${var.project_name}-policy_attachment"
# #   roles      = [aws_iam_role.default[0].name]
# #   policy_arn = aws_iam_policy.default[0].arn
# # }

# # resource "aws_codebuild_source_credential" "authorization" {
# #   count       = module.this.enabled && var.private_repository ? 1 : 0
# #   auth_type   = var.source_credential_auth_type
# #   server_type = var.source_credential_server_type
# #   token       = var.source_credential_token
# #   user_name   = var.source_credential_user_name
# # }

# # # CodeBuild Project Definition
# # resource "aws_codebuild_project" "default" {
# #   count                  = module.this.enabled ? 1 : 0
# #   name                   = var.project_name
# #   description            = var.description
# #   concurrent_build_limit = var.concurrent_build_limit
# #   service_role           = aws_iam_role.default[0].arn
# #   badge_enabled          = var.badge_enabled
# #   build_timeout          = var.build_timeout

# #   artifacts {
# #     type     = var.artifact_type
# #     location = var.artifact_location
# #   }

# #   dynamic "secondary_artifacts" {
# #     for_each = var.secondary_artifact_location != null ? [1] : []
# #     content {
# #       type                = "S3"
# #       location            = var.secondary_artifact_location
# #       artifact_identifier = var.secondary_artifact_identifier
# #       encryption_disabled = !var.secondary_artifact_encryption_enabled
# #       # According to AWS documention, in order to have the artifacts written
# #       # to the root of the bucket, the 'namespace_type' should be 'NONE'
# #       # (which is the default), 'name' should be '/', and 'path' should be
# #       # empty. For reference, see https://docs.aws.amazon.com/codebuild/latest/APIReference/API_ProjectArtifacts.html.
# #       # However, I was unable to get this to deploy to the root of the bucket
# #       # unless path was also set to '/'.
# #       path = "/"
# #       name = "/"
# #     }
# #   }

# #   cache {
# #     type     = lookup(local.cache, "type", null)
# #     location = lookup(local.cache, "location", null)
# #     modes    = lookup(local.cache, "modes", null)
# #   }

# #   environment {
# #     compute_type    = var.build_compute_type
# #     image           = var.build_image
# #     privileged_mode = var.privileged_mode
# #     type            = var.build_type

# #     environment_variable {
# #       name  = "AWS_REGION"
# #       value = data.aws_region.default.name
# #     }

# #     environment_variable {
# #       name  = "AWS_ACCOUNT_ID"
# #       value = data.aws_caller_identity.default.account_id
# #     }

# #     dynamic "environment_variable" {
# #       for_each = var.environment_variables
# #       content {
# #         name  = var.image_repo_name
# #         value = var.image_tag
# #         type  = environment_variable.value.type
# #       }
# #     }
# #   }

# #   source {
# #     buildspec           = var.buildspec
# #     type                = var.source_type
# #     location            = var.source_location
# #     report_build_status = var.report_build_status
# #     git_clone_depth     = var.git_clone_depth != null ? var.git_clone_depth : null

# #     dynamic "git_submodules_config" {
# #       for_each = var.fetch_git_submodules ? [""] : []
# #       content {
# #         fetch_submodules = true
# #       }
# #     }
# #   }

# #   dynamic "secondary_sources" {
# #     for_each = var.secondary_sources
# #     content {
# #       git_clone_depth     = secondary_source.value.git_clone_depth
# #       location            = secondary_source.value.location
# #       source_identifier   = secondary_source.value.source_identifier
# #       type                = secondary_source.value.type
# #       insecure_ssl        = secondary_source.value.insecure_ssl
# #       report_build_status = secondary_source.value.report_build_status

# #       git_submodules_config {
# #         fetch_submodules = secondary_source.value.fetch_submodules
# #       }
# #     }
# #   }
# #   dynamic "vpc_config" {
# #     for_each = length(var.vpc_config) > 0 ? [""] : []
# #     content {
# #       vpc_id             = lookup(var.vpc_config, "vpc_id", null)
# #       subnets            = lookup(var.vpc_config, "subnets", null)
# #       security_group_ids = lookup(var.vpc_config, "security_group_ids", null)
# #     }
# #   }

# #   dynamic "logs_config" {
# #     for_each = length(var.logs_config) > 0 ? [""] : []
# #     content {
# #       dynamic "cloudwatch_logs" {
# #         for_each = contains(keys(var.logs_config), "cloudwatch_logs") ? { key = var.logs_config["cloudwatch_logs"] } : {}
# #         content {
# #           status      = lookup(cloudwatch_logs.value, "status", null)
# #           group_name  = lookup(cloudwatch_logs.value, "group_name", null)
# #           stream_name = lookup(cloudwatch_logs.value, "stream_name", null)
# #         }
# #       }

# #       dynamic "s3_logs" {
# #         for_each = contains(keys(var.logs_config), "s3_logs") ? { key = var.logs_config["s3_logs"] } : {}
# #         content {
# #           status              = lookup(s3_logs.value, "status", null)
# #           location            = lookup(s3_logs.value, "location", null)
# #           encryption_disabled = lookup(s3_logs.value, "encryption_disabled", null)
# #         }
# #       }
# #     }
# #   }

# #   dynamic "file_system_locations" {
# #     for_each = length(var.file_system_locations) > 0 ? [""] : []
# #     content {
# #       identifier    = lookup(file_system_locations.value, "identifier", null)
# #       location      = lookup(file_system_locations.value, "location", null)
# #       mount_options = lookup(file_system_locations.value, "mount_options", null)
# #       mount_point   = lookup(file_system_locations.value, "mount_point", null)
# #       type          = lookup(file_system_locations.value, "type", null)
# #     }
# #   }
# # }

# # # Pull the github_token from the Secrets Manager
# # data "aws_secretsmanager_secret" "secret" {
# #   count = var.enable_github_authentication ? 1 : 0

# #   arn = var.github_token
# # }

# # data "aws_secretsmanager_secret_version" "current_secret" {
# #   count = var.enable_github_authentication ? 1 : 0

# #   secret_id = data.aws_secretsmanager_secret.secret[0].id
# # }

# # # Aunthenticate with Github
# # resource "aws_codebuild_source_credential" "github_authentication" {
# #   count       = var.enable_github_authentication ? 1 : 0
# #   auth_type   = "PERSONAL_ACCESS_TOKEN"
# #   server_type = "GITHUB"
# #   token       = data.aws_secretsmanager_secret_version.current_secret[0].secret_string
# # }

# # # Set up webhook for Github, Bitbucket
# # resource "aws_codebuild_webhook" "webhook" {
# #   count = var.create_webhooks ? 1 : 0

# #   project_name = aws_codebuild_project.default[0].name
# #   build_type   = var.webhook_build_type
# #   dynamic "filter_group" {
# #     for_each = length(var.webhook_filters) > 0 ? [1] : []
# #     content {
# #       dynamic "filter" {
# #         for_each = var.webhook_filters
# #         content {
# #           type    = filter.key
# #           pattern = filter.value
# #         }
# #       }
# #     }
# #   }
# # }


# # Fetch information about the AWS account and region
# data "aws_caller_identity" "default" {}
# data "aws_region" "default" {}

# # S3 Bucket for Cache
# resource "aws_s3_bucket" "cache_bucket" {
#   count         = module.this.enabled && local.create_s3_cache_bucket ? 1 : 0
#   bucket        = local.cache_bucket_name_normalised
#   force_destroy = true
#   tags          = var.tags
# }

# resource "aws_s3_bucket_server_side_encryption_configuration" "cache_bucket_encryption" {
#   bucket = aws_s3_bucket.cache_bucket[0].id
#   rule {
#     apply_server_side_encryption_by_default {
#       sse_algorithm = "AES256"
#     }
#   }

# }
# # S3 Bucket Versioning (New syntax using a separate resource)
# resource "aws_s3_bucket_versioning" "cache_bucket_versioning" {
#   bucket = aws_s3_bucket.cache_bucket[0].id

#   versioning_configuration {
#     status = var.versioning_enabled ? "Enabled" : "Suspended"
#   }
# }

# # S3 Bucket Lifecycle Configuration (New syntax using a separate resource)
# resource "aws_s3_bucket_lifecycle_configuration" "cache_bucket_lifecycle" {
#   bucket = aws_s3_bucket.cache_bucket[0].id

#   rule {
#     id     = "codebuildcache"
#     status = var.lifecycle_rule_enabled ? "Enabled" : "Disabled"

#     filter {
#       prefix = "/"
#     }

#     expiration {
#       days = var.cache_expiration_days
#     }

#   }
# }

# # IAM Role for CodeBuild
# resource "aws_iam_role" "default" {
#   count                 = module.this.enabled ? 1 : 0
#   name                  = "${var.project_name}-role"
#   assume_role_policy    = data.aws_iam_policy_document.role.json
#   force_detach_policies = true
#   path                  = var.iam_role_path
#   permissions_boundary  = var.iam_permissions_boundary

#   dynamic "inline_policy" {
#     for_each = var.codebuild_iam != null ? [1] : []
#     content {
#       name   = "${var.project_name}-policy"
#       policy = var.codebuild_iam
#     }
#   }

#   tags = var.tags
# }

# # IAM Policy to Assume CodeBuild Role
# data "aws_iam_policy_document" "role" {
#   statement {
#     sid     = ""
#     actions = ["sts:AssumeRole"]

#     principals {
#       type        = "Service"
#       identifiers = ["codebuild.amazonaws.com"]
#     }

#     effect = "Allow"
#   }
# }

# # IAM Policy for Additional Permissions
# data "aws_iam_policy_document" "permissions" {
#   statement {
#     sid = ""

#     actions = compact(concat([
#       "iam:PassRole",
#       "logs:CreateLogGroup",
#       "logs:CreateLogStream",
#       "logs:PutLogEvents",
#       "s3:GetObject",
#       "s3:ListObject",
#     ], var.extra_permissions))

#     effect    = "Allow"
#     resources = ["*"]
#   }

#   dynamic "statement" {
#     for_each = var.secondary_artifact_location != null ? [1] : []
#     content {
#       sid     = ""
#       actions = ["s3:PutObject", "s3:GetBucketAcl", "s3:GetBucketLocation"]
#       effect  = "Allow"
#       resources = [
#         join("", data.aws_s3_bucket.secondary_artifact.*.arn),
#         "${join("", data.aws_s3_bucket.secondary_artifact.*.arn)}/*",
#       ]
#     }
#   }
# }

# # IAM Policy Attachment for Default Role
# resource "aws_iam_policy" "default" {
#   count  = module.this.enabled ? 1 : 0
#   name   = "${var.project_name}-policy"
#   path   = var.iam_policy_path
#   policy = data.aws_iam_policy_document.combined_permissions.json
#   tags   = var.tags
# }

# # S3 Bucket Data Source for Secondary Artifacts
# data "aws_s3_bucket" "secondary_artifact" {
#   count  = module.this.enabled && var.secondary_artifact_location != null ? 1 : 0
#   bucket = var.secondary_artifact_location
# }

# # Combined IAM Policy Document for Permissions
# data "aws_iam_policy_document" "combined_permissions" {
#   override_policy_documents = compact([data.aws_iam_policy_document.permissions.json])
# }

# # Attaching policy to role
# resource "aws_iam_policy_attachment" "codebuild_policy_attachment" {
#   name       = "${var.project_name}-policy_attachment"
#   roles      = [aws_iam_role.default[0].name]
#   policy_arn = aws_iam_policy.default[0].arn
# }

# resource "aws_codebuild_source_credential" "authorization" {
#   count       = module.this.enabled && var.private_repository ? 1 : 0
#   auth_type   = var.source_credential_auth_type
#   server_type = var.source_credential_server_type
#   token       = var.source_credential_token
#   user_name   = var.source_credential_user_name
# }

# # CodeBuild Project Definition
# resource "aws_codebuild_project" "default" {
#   count                  = module.this.enabled ? 1 : 0
#   name                   = var.project_name
#   description            = var.description
#   concurrent_build_limit = var.concurrent_build_limit
#   service_role           = aws_iam_role.default[0].arn
#   badge_enabled          = var.badge_enabled
#   build_timeout          = var.build_timeout

#   artifacts {
#     type     = var.artifact_type
#     location = var.artifact_location
#   }

#   dynamic "secondary_artifacts" {
#     for_each = var.secondary_artifact_location != null ? [1] : []
#     content {
#       type                = "S3"
#       location            = var.secondary_artifact_location
#       artifact_identifier = var.secondary_artifact_identifier
#       encryption_disabled = !var.secondary_artifact_encryption_enabled
#       # According to AWS documention, in order to have the artifacts written
#       # to the root of the bucket, the 'namespace_type' should be 'NONE'
#       # (which is the default), 'name' should be '/', and 'path' should be
#       # empty. For reference, see https://docs.aws.amazon.com/codebuild/latest/APIReference/API_ProjectArtifacts.html.
#       # However, I was unable to get this to deploy to the root of the bucket
#       # unless path was also set to '/'.
#       path = "/"
#       name = "/"
#     }
#   }

#   cache {
#     type     = lookup(local.cache, "type", null)
#     location = lookup(local.cache, "location", null)
#     modes    = lookup(local.cache, "modes", null)
#   }

#   environment {
#     compute_type    = var.build_compute_type
#     image           = var.build_image
#     privileged_mode = var.privileged_mode
#     type            = var.build_type

#     environment_variable {
#       name  = "AWS_REGION"
#       value = data.aws_region.default.name
#     }

#     environment_variable {
#       name  = "AWS_ACCOUNT_ID"
#       value = data.aws_caller_identity.default.account_id
#     }

#     dynamic "environment_variable" {
#       for_each = var.environment_variables
#       content {
#         name  = var.image_repo_name
#         value = var.image_tag
#         type  = environment_variable.value.type
#       }
#     }
#   }

#   source {
#     buildspec           = var.buildspec
#     type                = var.source_type
#     location            = var.source_location
#     report_build_status = var.report_build_status
#     git_clone_depth     = var.git_clone_depth != null ? var.git_clone_depth : null

#     dynamic "git_submodules_config" {
#       for_each = var.fetch_git_submodules ? [""] : []
#       content {
#         fetch_submodules = true
#       }
#     }
#   }

#   dynamic "secondary_sources" {
#     for_each = var.secondary_sources
#     content {
#       git_clone_depth     = secondary_source.value.git_clone_depth
#       location            = secondary_source.value.location
#       source_identifier   = secondary_source.value.source_identifier
#       type                = secondary_source.value.type
#       insecure_ssl        = secondary_source.value.insecure_ssl
#       report_build_status = secondary_source.value.report_build_status

#       git_submodules_config {
#         fetch_submodules = secondary_source.value.fetch_submodules
#       }
#     }
#   }
#   dynamic "vpc_config" {
#     for_each = length(var.vpc_config) > 0 ? [""] : []
#     content {
#       vpc_id             = lookup(var.vpc_config, "vpc_id", null)
#       subnets            = lookup(var.vpc_config, "subnets", null)
#       security_group_ids = lookup(var.vpc_config, "security_group_ids", null)
#     }
#   }

#   dynamic "logs_config" {
#     for_each = length(var.logs_config) > 0 ? [""] : []
#     content {
#       dynamic "cloudwatch_logs" {
#         for_each = contains(keys(var.logs_config), "cloudwatch_logs") ? { key = var.logs_config["cloudwatch_logs"] } : {}
#         content {
#           status      = lookup(cloudwatch_logs.value, "status", null)
#           group_name  = lookup(cloudwatch_logs.value, "group_name", null)
#           stream_name = lookup(cloudwatch_logs.value, "stream_name", null)
#         }
#       }

#       dynamic "s3_logs" {
#         for_each = contains(keys(var.logs_config), "s3_logs") ? { key = var.logs_config["s3_logs"] } : {}
#         content {
#           status              = lookup(s3_logs.value, "status", null)
#           location            = lookup(s3_logs.value, "location", null)
#           encryption_disabled = lookup(s3_logs.value, "encryption_disabled", null)
#         }
#       }
#     }
#   }

#   dynamic "file_system_locations" {
#     for_each = length(var.file_system_locations) > 0 ? [""] : []
#     content {
#       identifier    = lookup(file_system_locations.value, "identifier", null)
#       location      = lookup(file_system_locations.value, "location", null)
#       mount_options = lookup(file_system_locations.value, "mount_options", null)
#       mount_point   = lookup(file_system_locations.value, "mount_point", null)
#       type          = lookup(file_system_locations.value, "type", null)
#     }
#   }
# }

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
#   auth_type   = "PERSONAL_ACCESS_TOKEN"
#   server_type = "GITHUB"
#   token       = data.aws_secretsmanager_secret_version.current_secret[0].secret_string
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

