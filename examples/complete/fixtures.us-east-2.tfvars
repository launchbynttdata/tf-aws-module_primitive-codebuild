region = "us-east-2"

namespace = "eg"

stage = "test"

name = "codebuild-test"

source_location = "osahon-test-020127659860/trigger_pipeline.zip"

buildspec = "osahon-test-020127659860/buildspec.yml"



cache_bucket_suffix_enabled = true

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
