variable "region" {
  type        = string
  description = "AWS region"
}

variable "environment_variables" {
  type = list(object(
    {
      name  = string
      value = string
      type  = string
  }))

  default = [
    {
      name  = "NO_ADDITIONAL_BUILD_VARS"
      value = "TRUE"
      type  = "PLAINTEXT"
  }]

  description = "A list of maps, that contain the keys 'name', 'value', and 'type' to be used as additional environment variables for the build. Valid types are 'PLAINTEXT', 'PARAMETER_STORE', or 'SECRETS_MANAGER'"
}

variable "cache_expiration_days" {
  type        = number
  description = "How many days should the build cache be kept. It only works when cache_type is 'S3'"
}

variable "cache_bucket_suffix_enabled" {
  type        = bool
  description = "The cache bucket generates a random 13 character string to generate a unique bucket name. If set to false it uses terraform-null-label's id value"
}

variable "cache_type" {
  type        = string
  description = "The type of storage that will be used for the AWS CodeBuild project cache. Valid values: NO_CACHE, LOCAL, and S3.  Defaults to NO_CACHE.  If cache_type is S3, it will create an S3 bucket for storing codebuild cache inside"
}
variable "project_name" {
  type    = string
}

variable "source_location" {
  description = "Location of the source code (e.g., GitHub URL or S3 path)"
  type        = string
  default     = ""
}
variable "source_type" {
  description = "The source type for CodeBuild (e.g., S3, GITHUB, CODECOMMIT)"
  type        = string
}

variable "buildspec" {
  description = "Path to the buildspec.yml file"
  type        = string
  default     = "buildspec.yml"
}

variable "artifacts" {
  description = "list of artifacts for the codebuild project"
  type = list(object({
    artifact_identifier    = string
    type                   = string
    location               = string
    name                   = string
    path                   = string
    namespace_type         = string
    packaging              = string
    encryption_disabled    = bool
    override_artifact_name = bool
  }))
}

variable "secondary_artifacts" {
  description = "List of secondary artifacts for the codebuild project"
  type = list(object({
    artifact_identifier    = string
    type                   = string
    location               = string
    name                   = string
    path                   = string
    namespace_type         = string
    packaging              = string
    encryption_disabled    = bool
    override_artifact_name = bool
  }))
}

variable "source_credential_auth_type" {
  type        = string
  default     = "PERSONAL_ACCESS_TOKEN"
  description = "The type of authentication used to connect to a GitHub, GitHub Enterprise, or Bitbucket repository."
}

variable "source_credential_server_type" {
  type        = string
  default     = "GITHUB"
  description = "The source provider used for this project."
}

variable "source_credential_user_name" {
  type        = string
  default     = ""
  description = "The Bitbucket username when the authType is BASIC_AUTH. This parameter is not valid for other types of source providers or connections."
}

variable "service_role_arn" {
  type = list(string)
  description = "The ARN of the IAM rol for Codebuild. This is to be provided by the user"
}

variable "cache_enabled" {
  type        = bool
  description = "Flag to enable or disable the module"
  default     = true
}

variable "iam_role_path" {
  type        = string
  default     = null
  description = "Path to the role."
}

variable "iam_permissions_boundary" {
  type        = string
  default     = null
  description = "ARN of the policy that is used to set the permissions boundary for the role."
}

variable "codebuild_iam" {
  description = "Additional IAM policies to add to CodePipeline IAM role."
  type        = string
  default     = null
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_project#vpc_config
variable "vpc_config" {
  type        = any
  default     = {}
  description = "Configuration for the builds to run inside a VPC."
}

variable "iam_policy_path" {
  type        = string
  default     = "/service-role/"
  description = "Path to the policy."
}

variable "s3_cache_bucket_name" {
  type        = string
  default     = null
  description = "Use an existing s3 bucket name for cache. Relevant if `cache_type` is set to `S3`."
}

variable "local_cache_modes" {
  default     = "NO_CACHE"
  description = "The type of storage that will be used for the AWS CodeBuild project cache. Valid values: NO_CACHE, LOCAL, and S3.  Defaults to NO_CACHE.  If cache_type is S3, it will create an S3 bucket for storing codebuild cache inside"
}

variable "aws_region" {
  description = "(Optional) If set to true, enables running the Docker daemon inside a Docker container on the CodeBuild instance. Used when building Docker images"
}

variable "aws_account_id" {
  type        = string
  default     = ""
  description = "(Optional) AWS Account ID. Used as CodeBuild ENV variable when building Docker images. For more info: http://docs.aws.amazon.com/codebuild/latest/userguide/sample-docker.html"
}

variable "create_ecr_access_policy" {
  type = bool
  description = "Whether to create the ECR access policy"
  default = true
}

variable "secondary_artifact_location" {
  type        = string
  default     = null
  description = "Location of secondary artifact. Must be an S3 reference"
}

variable "extra_permissions" {
  type        = list(any)
  default     = []
  description = "List of action strings which will be added to IAM service account permissions."
}
