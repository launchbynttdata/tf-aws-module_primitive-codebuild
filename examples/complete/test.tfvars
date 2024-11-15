
project_name = "codebuild_project_1"

source_type = "GITHUB"

source_location = "https://github.com/debasish-sahoo-nttd/sample-dotnetcore-app.git"

buildspec = "buildspec.yml"

cache_type = "NO_CACHE"

badge_enabled = false

build_type = "LINUX_CONTAINER"

build_image = "aws/codebuild/standard:2.0"
  
build_compute_type = "BUILD_GENERAL1_SMALL"

build_timeout = 60

privileged_mode = false

tags = {
  name        = "platform_engineering"
  environment = "sandbox"
}

concurrent_build_limit = 1

environment_variables = [
  {
    name  = "APP_URL"
    value = "https://app.example.com"
    type  = "PLAINTEXT"
  },
  {
    name  = "COMPANY_NAME"
    value = "test-build"
    type  = "PLAINTEXT"
  },
  {
    name  = "TIME_ZONE"
    value = "America/Los_Angeles"
    type  = "PLAINTEXT"
  },
  {
    name  = "AWS_REGION"
    value = "us-east-2"
    type  = "PLAINTEXT"
  },
  {
    name  = "AWS_ACCOUNT_ID"
    value = "020127659860"
    type  = "PLAINTEXT"
  },
  {
    name  = "IMAGE_REPO_NAME"
    value = "UNSET"
    type  = "PLAINTEXT"
  },
  {
    name  = "IMAGE_TAG"
    value = "latest"
    type  = "PLAINTEXT"
  }
]

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

