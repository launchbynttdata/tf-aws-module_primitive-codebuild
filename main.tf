# Fetch information about the AWS account and region
data "aws_caller_identity" "default" {}
data "aws_region" "default" {}

# S3 Bucket for Cache
resource "aws_s3_bucket" "cache_bucket" {
  count         = module.this.enabled && local.create_s3_cache_bucket ? 1 : 0
  bucket        = local.cache_bucket_name_normalised
  force_destroy = true
  tags          = var.tags
}

resource "aws_s3_bucket_server_side_encryption_configuration" "cache_bucket_encryption" {
  bucket = aws_s3_bucket.cache_bucket[0].id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }

}
# S3 Bucket Versioning (New syntax using a separate resource)
resource "aws_s3_bucket_versioning" "cache_bucket_versioning" {
  bucket = aws_s3_bucket.cache_bucket[0].id

  versioning_configuration {
    status = var.versioning_enabled ? "Enabled" : "Suspended"
  }
}

# S3 Bucket Lifecycle Configuration (New syntax using a separate resource)
resource "aws_s3_bucket_lifecycle_configuration" "cache_bucket_lifecycle" {
  bucket = aws_s3_bucket.cache_bucket[0].id

  rule {
    id     = "codebuildcache"
    status = var.lifecycle_rule_enabled ? "Enabled" : "Disabled"

    filter {
      prefix = "/"
    }

    expiration {
      days = var.cache_expiration_days
    }

  }
}

# IAM Role for CodeBuild
resource "aws_iam_role" "default" {
  count                 = module.this.enabled ? 1 : 0
  name                  = var.project_name
  assume_role_policy    = data.aws_iam_policy_document.role.json
  force_detach_policies = true
  path                  = var.iam_role_path
  permissions_boundary  = var.iam_permissions_boundary

  dynamic "inline_policy" {
    for_each = var.codebuild_iam != null ? [1] : []
    content {
      name   = var.project_name
      policy = var.codebuild_iam
    }
  }

  tags = var.tags
}

# IAM Policy to Assume CodeBuild Role
data "aws_iam_policy_document" "role" {
  statement {
    sid     = ""
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }

    effect = "Allow"
  }
}

# IAM Policy for Additional Permissions
data "aws_iam_policy_document" "permissions" {
  statement {
    sid = ""

    actions = compact(concat([
      "iam:PassRole",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ], var.extra_permissions))

    effect    = "Allow"
    resources = ["*"]
  }

  dynamic "statement" {
    for_each = var.secondary_artifact_location != null ? [1] : []
    content {
      sid     = ""
      actions = ["s3:PutObject", "s3:GetBucketAcl", "s3:GetBucketLocation"]
      effect  = "Allow"
      resources = [
        join("", data.aws_s3_bucket.secondary_artifact.*.arn),
        "${join("", data.aws_s3_bucket.secondary_artifact.*.arn)}/*",
      ]
    }
  }
}

# IAM Policy Attachment for Default Role
resource "aws_iam_policy" "default" {
  count  = module.this.enabled ? 1 : 0
  name   = var.project_name
  path   = var.iam_policy_path
  policy = data.aws_iam_policy_document.combined_permissions.json
  tags   = var.tags
}

# S3 Bucket Data Source for Secondary Artifacts
data "aws_s3_bucket" "secondary_artifact" {
  count  = module.this.enabled && var.secondary_artifact_location != null ? 1 : 0
  bucket = var.secondary_artifact_location
}

# Combined IAM Policy Document for Permissions
data "aws_iam_policy_document" "combined_permissions" {
  override_policy_documents = compact([data.aws_iam_policy_document.permissions.json])
}

# CodeBuild Project Definition
resource "aws_codebuild_project" "default" {
  count                  = module.this.enabled ? 1 : 0
  name                   = var.project_name
  description            = var.description
  concurrent_build_limit = var.concurrent_build_limit
  service_role           = aws_iam_role.default[0].arn
  badge_enabled          = var.badge_enabled
  build_timeout          = var.build_timeout

  artifacts {
    type     = var.artifact_type
    location = var.artifact_location
  }

  cache {
    type     = lookup(local.cache, "type", null)
    location = lookup(local.cache, "location", null)
    modes    = lookup(local.cache, "modes", null)
  }

  environment {
    compute_type    = var.build_compute_type
    image           = var.build_image
    privileged_mode = var.privileged_mode
    type            = var.build_type

    environment_variable {
      name  = "AWS_REGION"
      value = data.aws_region.default.name
    }

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = data.aws_caller_identity.default.account_id
    }

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
}

resource "random_string" "bucket_prefix" {
  length  = 12
  numeric = false
  upper   = false
  special = false
  lower   = true
}
