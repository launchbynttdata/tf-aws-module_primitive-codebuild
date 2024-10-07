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

  context             = module.this.context
  artifacts           = var.artifacts
  secondary_artifacts = var.secondary_artifacts

}


