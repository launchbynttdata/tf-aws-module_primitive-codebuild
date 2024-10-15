data "aws_caller_identity" "default" {}



# Optional: Lookup existing S3 bucket by name
data "aws_s3_bucket" "artifact_bucket" {
  bucket = var.s3_cache_bucket_name # Fetch information about the existing S3 bucket
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


module "codebuild" {
  source                      = "../.."
  project_name                = var.project_name
  description                 = "This is my awesome Codebuild project"
  concurrent_build_limit      = 1
  #cache_bucket_suffix_enabled = var.cache_bucket_suffix_enabled
  environment_variables       = var.environment_variables
  cache_expiration_days       = var.cache_expiration_days
  cache_type                  = var.cache_type
  aws_region                  = var.aws_region
  source_location             = var.source_location
  source_type                 = var.source_type
  buildspec                   = var.buildspec
  artifact_type               = "NO_ARTIFACTS"

  context = module.this.context

  artifacts                     = var.artifacts
  secondary_artifacts           = var.secondary_artifacts
  source_credential_auth_type   = ""
  source_credential_server_type = ""
  source_credential_user_name   = ""
  create_resources              = var.create_resources
  service_role_arn              = aws_iam_role.codebuild_role.arn
  s3_cache_bucket_name          = var.s3_cache_bucket_name
  local_caches_modes            = var.local_caches_modes
}

