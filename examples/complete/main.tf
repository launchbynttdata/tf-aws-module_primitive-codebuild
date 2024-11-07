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
  tags                   = var.tags
  artifacts              = var.artifacts
  secondary_artifacts    = var.secondary_artifacts
  service_role_arn       = module.codebuild.service_role_arn
  caches_modes           = var.caches_modes
  project_name           = var.project_name
  codebuild_enabled      = var.codebuild_enabled
  badge_enabled = var.badge_enabled
  build_type = var.build_type
  build_image = var.build_image
  build_compute_type = var.build_compute_type
  build_timeout = var.build_timeout
  privileged_mode = var.privileged_mode
}




