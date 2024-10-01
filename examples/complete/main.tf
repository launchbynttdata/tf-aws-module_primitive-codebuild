provider "aws" {
  region  = var.region
  profile = "launch-sandbox-admin"
}

module "codebuild" {
  source                      = "../../"
  description                 = "This is my awesome CodeBuild project"
  concurrent_build_limit      = 1
  cache_bucket_suffix_enabled = var.cache_bucket_suffix_enabled
  environment_variables       = var.environment_variables
  cache_expiration_days       = var.cache_expiration_days
  cache_type                  = var.cache_type
  project_name                = var.project_name
  source_location             = var.source_location
  source_type                 = var.source_type
  buildspec                   = var.buildspec
  artifact_type               = "NO_ARTIFACTS"

  context = module.this.context

}

# data "aws_s3_bucket" "test" {
#   bucket = "osahon-test-020127659860"

# }

# output "bucket" {
#   value = data.aws_s3_bucket.test.bucket
# }

# resource "aws_s3_bucket_policy" "test" {
#   bucket = data.aws_s3_bucket.test.bucket
#   policy = jsonencode(
#     {
#       "Version" : "2012-10-17",
#       "Statement" : [
#         {
#           "Effect" : "Allow",
#           "Principal" : {
#             "Service" : "codebuild.amazonaws.com"
#           },
#           "Action" : "s3:*",
#           "Resource" : [
#             "${data.aws_s3_bucket.test.arn}/*",
#             data.aws_s3_bucket.test.arn
#           ]
#         }
#       ]
#     }
#   )
# }
