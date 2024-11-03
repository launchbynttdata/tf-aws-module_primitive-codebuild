variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "logical_product_family" {
  type        = string
  description = <<EOF
    (Required) Name of the product family for which the resource is created.
    Example: org_name, department_name.
  EOF
  nullable    = false

  validation {
    condition     = can(regex("^[_\\-A-Za-z0-9]+$", var.logical_product_family))
    error_message = "The variable must contain letters, numbers, -, _, and .."
  }

  default = "launch"
}

variable "logical_product_service" {
  type        = string
  description = <<EOF
    (Required) Name of the product service for which the resource is created.
    For example, backend, frontend, middleware etc.
  EOF
  nullable    = false

  validation {
    condition     = can(regex("^[_\\-A-Za-z0-9]+$", var.logical_product_service))
    error_message = "The variable must contain letters, numbers, -, _, and .."
  }

  default = "servicename"
}

variable "class_env" {
  type        = string
  default     = "dev"
  description = "(Required) Environment where resource is going to be deployed. For example. dev, qa, uat"
  nullable    = false

  validation {
    condition     = length(regexall("\\b \\b", var.class_env)) == 0
    error_message = "Spaces between the words are not allowed."
  }
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = <<-EOT
    Additional tags (e.g. `{'BusinessUnit': 'XYZ'}`).
    Neither the tag keys nor the tag values will be modified by this module.
    EOT
}

variable "cache_bucket_suffix_enabled" {
  type        = bool
  default     = true
  description = "The cache bucket generates a random 13 character string to generate a unique bucket name. If set to false it uses terraform-null-label's id value. It only works when cache_type is 'S3"
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

variable "cache_type" {
  type        = string
  description = "The type of storage that will be used for the AWS CodeBuild project cache. Valid values: NO_CACHE, LOCAL, and S3.  Defaults to NO_CACHE.  If cache_type is S3, it will create an S3 bucket for storing codebuild cache inside"
}

variable "project_name" {
  type = string
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

variable "codebuild_enabled" {
  type        = bool
  description = "Flag to enable or disable the module"
  default     = true
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

variable "bucket_name" {
  type        = string
  default     = null
  description = "Relevant if `cache_type` is set to `S3`."
}

variable "caches_modes" {
  type        = string
  default     = "LOCAL_CUSTOM_CACHE"
  description = "The type of data caching between builds. The inputs values are LOCAL_SOURCE_CACHE, LOCAL_DOCKER_LAYER_CACHE, LOCAL_CUSTOM_CACHE"
}

variable "aws_account_id" {
  type        = string
  default     = ""
  description = "(Optional) AWS Account ID. Used as CodeBuild ENV variable when building Docker images. For more info: http://docs.aws.amazon.com/codebuild/latest/userguide/sample-docker.html"
}

variable "create_ecr_access_policy" {
  type        = bool
  description = "Whether to create the ECR access policy"
  default     = true
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

variable "create_resources" {
  type        = bool
  description = "whether to create the IAM resources"
}

