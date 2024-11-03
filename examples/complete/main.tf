module "codebuild" {
  source                 = "../.."
  description            = "This is my awesome Codebuild project"
  concurrent_build_limit = 1
  environment_variables  = var.environment_variables
  cache_expiration_days  = var.cache_expiration_days
  cache_type             = var.cache_type
  aws_region             = var.aws_region
  source_location        = var.source_location
  source_type            = var.source_type
  buildspec              = var.buildspec
  artifact_type          = "NO_ARTIFACTS"

  artifacts                     = var.artifacts
  secondary_artifacts           = var.secondary_artifacts
  source_credential_auth_type   = ""
  source_credential_server_type = ""
  source_credential_user_name   = ""
  create_resources              = var.create_resources
  service_role_arn              = module.codebuild.service_role_arn
  s3_cache_bucket_name          = module.codebuild.s3_bucket_arn
  caches_modes                  = var.caches_modes
}

# resource "random_string" "bucket_prefix" {
#   count   = var.codebuild_enabled ? 1 : 0
#   length  = 12
#   numeric = false
#   upper   = false
#   special = false
#   lower   = true
# }


