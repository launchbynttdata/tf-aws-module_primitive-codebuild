# AWS region where resources will be deployed
variable "aws_region" {
  description = "The AWS region to deploy the resources."
  type        = string
  default     = "us-west-2"
}

# The name of the project for identifying resources
variable "project_name" {
  description = "Name of the project for identification"
  type        = string
}

# Description of the CodeBuild project
variable "description" {
  description = "Description of the CodeBuild project"
  type        = string
  default     = "CodeBuild project for building and testing"
}

# Enable versioning for the S3 bucket
variable "versioning_enabled" {
  description = "Whether to enable versioning on the S3 bucket"
  type        = bool
  default     = true
}

# Access log bucket for the S3 bucket (empty to disable logging)
variable "access_log_bucket_name" {
  description = "The name of the S3 bucket for access logs. Leave empty to disable logging."
  type        = string
  default     = ""
}

# Number of days before cached objects in the S3 bucket expire
variable "cache_expiration_days" {
  description = "Number of days before cached objects expire"
  type        = number
  default     = 30
}

# Enable server-side encryption for the S3 bucket
variable "encryption_enabled" {
  description = "Whether to enable encryption for the S3 bucket"
  type        = bool
  default     = true
}

# IAM role path for the CodeBuild role
variable "iam_role_path" {
  description = "IAM role path for the CodeBuild role"
  type        = string
  default     = "/service-role/"
}

# Optional permissions boundary for the IAM role
variable "iam_permissions_boundary" {
  description = "Optional permissions boundary for the IAM role"
  type        = string
  default     = null
}

# Inline IAM policy document for CodeBuild
variable "codebuild_iam" {
  description = "IAM policy document for inline policies in the CodeBuild role"
  type        = string
  default     = null
}

# Additional permissions for the IAM role
variable "extra_permissions" {
  description = "Additional permissions to grant to the IAM role"
  type        = list(string)
  default     = []
}

# Secondary artifact location in S3 for CodeBuild
variable "secondary_artifact_location" {
  description = "S3 bucket location for secondary artifacts"
  type        = string
  default     = null
}

# Type of build artifact (e.g., S3 or NO_ARTIFACT)
variable "artifact_type" {
  description = "Type of build artifact (e.g., S3, NO_ARTIFACTS)"
  type        = string
  default     = "S3"
}

# Location to store build artifacts (e.g., S3 bucket)
variable "artifact_location" {
  description = "S3 bucket or location to store build artifacts"
  type        = string
  default     = null
}

# Enable build badge for the CodeBuild project
variable "badge_enabled" {
  description = "Whether to enable a build badge for the CodeBuild project"
  type        = bool
  default     = false
}

# Timeout for the build in minutes
variable "build_timeout" {
  description = "Build timeout in minutes"
  type        = number
  default     = 60
}

# Compute type for the CodeBuild project
variable "build_compute_type" {
  description = "Compute type for CodeBuild (e.g., BUILD_GENERAL1_SMALL)"
  type        = string
  default     = "BUILD_GENERAL1_SMALL"
}

# Docker image for the build environment
variable "build_image" {
  description = "Docker image for the build environment"
  type        = string
  default     = "aws/codebuild/standard:5.0"
}

# Enable privileged mode for the build
variable "privileged_mode" {
  description = "Enable privileged mode for the build"
  type        = bool
  default     = false
}

# Type of build environment (e.g., LINUX_CONTAINER)
variable "build_type" {
  description = "The environment type for the build (e.g., LINUX_CONTAINER)"
  type        = string
  default     = "LINUX_CONTAINER"
}

# Additional environment variables for the build
variable "environment_variables" {
  description = "Additional environment variables for the CodeBuild environment"
  type = list(object({
    name  = string
    value = string
    type  = string
  }))
  default = []
}

# Path to the buildspec.yml file
variable "buildspec" {
  description = "Path to the buildspec.yml file"
  type        = string
  default     = "buildspec.yml"
}

# The source type for CodeBuild (e.g., S3, GITHUB, CODECOMMIT)
variable "source_type" {
  description = "The source type for CodeBuild (e.g., S3, GITHUB, CODECOMMIT)"
  type        = string
  default     = "GITHUB"
}

# Location of the source code for the build
variable "source_location" {
  description = "Location of the source code (e.g., GitHub URL or S3 path)"
  type        = string
  default     = ""
}

# Report build status back to the source provider (e.g., GitHub)
variable "report_build_status" {
  description = "Whether to report the build status back to the source provider"
  type        = bool
  default     = true
}

# Depth of Git clone for shallow clones
variable "git_clone_depth" {
  description = "Git clone depth (null for no limit)"
  type        = number
  default     = null
}

# Whether to fetch Git submodules
variable "fetch_git_submodules" {
  description = "Whether to fetch Git submodules"
  type        = bool
  default     = false
}

# Number of concurrent builds for the CodeBuild project
variable "concurrent_build_limit" {
  description = "Number of concurrent builds for CodeBuild"
  type        = number
  default     = 1
}

# Cache modes for local caching in CodeBuild
variable "local_cache_modes" {
  description = "Cache modes for local caching in CodeBuild (e.g., LOCAL_SOURCE_CACHE)"
  type        = list(string)
  default     = []
}

# The S3 bucket name for cache (null to auto-generate a name)
variable "s3_cache_bucket_name" {
  description = "The S3 cache bucket name, set to null for automatic naming"
  type        = string
  default     = null
}

# Cache type for the CodeBuild project (e.g., S3, LOCAL, or NO_CACHE)
variable "cache_type" {
  description = "The cache type for CodeBuild (e.g., S3, LOCAL, NO_CACHE)"
  type        = string
  default     = "S3"
}

# Whether to enable a suffix for the S3 cache bucket name
variable "cache_bucket_suffix_enabled" {
  description = "Whether to enable a suffix for the S3 cache bucket name"
  type        = bool
  default     = true
}

variable "lifecycle_rule_enabled" {
  description = "Whether to enable the lifecycle rule."
  type        = bool
  default     = true
}

variable "iam_policy_path" {
  type        = string
  default     = "/service-role/"
  description = "Path to the policy."
}

variable "secondary_sources" {
  type = list(object(
    {
      git_clone_depth     = number
      location            = string
      source_identifier   = string
      type                = string
      fetch_submodules    = bool
      insecure_ssl        = bool
      report_build_status = bool
  }))
  default     = []
  description = "(Optional) secondary source for the codebuild project in addition to the primary location"
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_project#vpc_config
variable "vpc_config" {
  type        = any
  default     = {}
  description = "Configuration for the builds to run inside a VPC."
}

variable "file_system_locations" {
  type        = any
  default     = {}
  description = "A set of file system locations to to mount inside the build. File system locations are documented below."
}

variable "logs_config" {
  type        = any
  default     = {}
  description = "Configuration for the builds to store log data to CloudWatch or S3."
}

variable "enable_github_authentication" {
  description = <<EOF
    Whether to enable Github authentication using Personal Access token.
    If true, it uses the github_token  and github_token_type must be of type SECRETS_MANAGER to authenticate
  EOF
  type        = bool
  default     = false
}

variable "github_token" {
  type        = string
  default     = ""
  description = "(Optional) GitHub auth token environment variable (`GITHUB_TOKEN`)"
}

variable "create_webhooks" {
  description = "Whether to create webhooks for Github, GitHub Enterprise or Bitbucket"
  type        = bool
  default     = false
}

variable "webhook_build_type" {
  description = "Webhook build type. Choose between BUILD or BUILD_BATCH"
  type        = string
  default     = "BUILD"
}

variable "webhook_filters" {
  description = "Filters supported by webhook. EVENT, BASE_REF, HEAD_REF, ACTOR_ACCOUNT_ID, FILE_PATH, COMMIT_MESSAGE"
  type        = map(string)
  default     = {}
}