region = "us-east-2"

namespace = "eg"

stage = "test"

name = "codebuild-test"

availability_zones = ["us-east-2a", "us-east-2b"]

vpc_cidr_block = "172.16.0.0/16"

cache_bucket_suffix_enabled = false

environment_variables = [
  {
    name  = "APP_URL"
    value = "https://app.example.com"
    type  = "PLAINTEXT"
  },
  {
    name  = "COMPANY_NAME"
    value = "Cloud Posse"
    type  = "PLAINTEXT"
  },
  {
    name  = "TIME_ZONE"
    value = "America/Los_Angeles"
    type  = "PLAINTEXT"
  }
]

cache_expiration_days = 7

cache_type = "S3"

artifacts = [{
  artifact_identifier    = "primary-artifacts"
  type                   = "NO_ARTIFACTS"
  location               = null
  name                   = null
  path                   = null
  namespace_type         = null
  packaging              = null
  encryption_disabled    = false
  override_artifact_name = false
}]

secondary_artifacts = [{
  artifact_identifier    = "secondary-artifact"
  type                   = "NO_ARTIFACTS"
  location               = null
  name                   = null
  path                   = null
  namespace_type         = null
  packaging              = null
  encryption_disabled    = false
  override_artifact_name = false
}]