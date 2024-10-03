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

resource "random_string" "bucket_prefix" {
  count   = module.this.enabled ? 1 : 0
  length  = 12
  numeric = false
  upper   = false
  special = false
  lower   = true
}

resource "aws_codebuild_source_credential" "authorization" {
  count       = module.this.enabled && var.private_repository ? 1 : 0
  auth_type   = var.source_credential_auth_type
  server_type = var.source_credential_server_type
  token       = var.source_credential_token
  user_name   = var.source_credential_user_name
}

resource "aws_codebuild_project" "default" {
    count                  = module.this.enabled ? 1 : 0
  name                   = var.project_name
  description            = var.description
  concurrent_build_limit = var.concurrent_build_limit
  service_role           = join("", aws_iam_role.default.*.arn)
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
    type = var.artifact[0].type
    location = var.artifact_location
    name = var.artifa
  }
}