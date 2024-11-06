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

variable "caches_modes" {
  type        = string
  default     = "LOCAL_CUSTOM_CACHE"
  description = "The type of data caching between builds. The inputs values are LOCAL_SOURCE_CACHE, LOCAL_DOCKER_LAYER_CACHE, LOCAL_CUSTOM_CACHE"
}

variable "concurrent_build_limit" {
  type        = number
  default     = null
  description = "Specify a maximum number of concurrent builds for the project. The value specified must be greater than 0 and less than the account concurrent running builds limit."
}

variable "cache_bucket_suffix_enabled" {
  type        = bool
  description = "The cache bucket generates a random 13 character string to generate a unique bucket name. If set to false it uses terraform-null-label's id value. It only works when cache_type is 'S3"
}

variable "badge_enabled" {
  type        = bool
  description = "Generates a publicly-accessible URL for the projects build badge. Available as badge_url attribute when enabled"
}

variable "build_image" {
  type        = string
  description = "Docker image for build environment, e.g. 'aws/codebuild/standard:2.0' or 'aws/codebuild/eb-nodejs-6.10.0-amazonlinux-64:4.0.0'. For more info: http://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref.html"
}

variable "build_compute_type" {
  type        = string
  description = "Instance type of the build instance"
}

variable "build_timeout" {
  type = number
  description = "How long in minutes, from 5 to 480 (8 hours), for AWS CodeBuild to wait until timing out any related build that does not get marked as completed"
}

variable "build_type" {
  type        = string
  description = "The type of build environment, e.g. 'LINUX_CONTAINER' or 'WINDOWS_CONTAINER'"
}

variable "privileged_mode" {
  type        = bool
  description = "(Optional) If set to true, enables running the Docker daemon inside a Docker container on the CodeBuild instance. Used when building Docker images"
}