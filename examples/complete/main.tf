module "codebuild" {
  source                 = "../.."
  description            = "This is my awesome Codebuild project"
  concurrent_build_limit = var.concurrent_build_limit
  environment_variables  = var.environment_variables
  cache_type             = var.cache_type
  aws_region             = var.aws_region
  source_location        = var.source_location
  source_type            = var.source_type
  buildspec              = var.buildspec

  artifacts                     = var.artifacts
  secondary_artifacts           = var.secondary_artifacts
  service_role_arn              = module.codebuild.service_role_arn
  s3_cache_bucket_name          = module.codebuild.s3_bucket_arn
  caches_modes                  = var.caches_modes
}




