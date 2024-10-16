
module "vpc" {
  source                  = "cloudposse/vpc/aws"
  version                 = "2.1.0"
  ipv4_primary_cidr_block = var.vpc_cidr_block

  context = module.this.context
}

module "subnets" {
  source               = "cloudposse/dynamic-subnets/aws"
  version              = "2.3.0"
  availability_zones   = var.availability_zones
  vpc_id               = module.vpc.vpc_id
  igw_id               = [module.vpc.igw_id]
  ipv4_cidr_block      = [module.vpc.vpc_cidr_block]
  nat_gateway_enabled  = true
  nat_instance_enabled = false

  context = module.this.context
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