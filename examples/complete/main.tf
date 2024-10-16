data "aws_caller_identity" "default" {}



# Optional: Lookup existing S3 bucket by name
data "aws_s3_bucket" "artifact_bucket" {
  bucket = var.bucket_name # Fetch information about the existing S3 bucket
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
      "s3:GetObject",
      "s3:PutObject",
      "s3:ListBucket",
      "s3:GetBucketLocation",
      "codebuild:StartBuild",
      "codebuild:BatchGetBuilds",
      "codebuild:BatchGetProjects"
    ]
    resources = [
      data.aws_s3_bucket.artifact_bucket.arn,        # Use dynamically fetched ARN
      "${data.aws_s3_bucket.artifact_bucket.arn}/*", # S3 bucket objects for artifacts
      data.aws_s3_bucket.artifact_bucket.arn,        # Use for cache as well
      "${data.aws_s3_bucket.artifact_bucket.arn}/*", # S3 bucket objects for cache
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
  policy                   = var.policy
  lifecycle_rule           = var.lifecycle_rule
  metric_configuration     = var.metric_configuration
  analytics_configuration  = var.analytics_configuration
  bucket_name              = local.cache_bucket_name
  tags                     = local.tags
  object_ownership         = var.object_ownership
  control_object_ownership = var.control_object_ownership
  acl                      = var.acl
}


module "codebuild" {
  source = "../.."
  # project_name           = var.project_name
  description            = "This is my awesome Codebuild project"
  concurrent_build_limit = 1
  #cache_bucket_suffix_enabled = var.cache_bucket_suffix_enabled
  environment_variables = var.environment_variables
  cache_expiration_days = var.cache_expiration_days
  cache_type            = var.cache_type
  aws_region            = var.aws_region
  source_location       = var.source_location
  source_type           = var.source_type
  buildspec             = var.buildspec
  artifact_type         = "NO_ARTIFACTS"

  artifacts                     = var.artifacts
  secondary_artifacts           = var.secondary_artifacts
  source_credential_auth_type   = ""
  source_credential_server_type = ""
  source_credential_user_name   = ""
  create_resources              = var.create_resources
  service_role_arn              = aws_iam_role.codebuild_role.arn
  s3_cache_bucket_name          = module.s3_bucket.arn
  caches_modes                  = var.caches_modes
}

