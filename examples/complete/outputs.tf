output "project_name" {
  description = "Project name"
  value       = module.codebuild.project_name
}

output "project_id" {
  description = "Project ID"
  value       = module.codebuild.project_id
}

output "role_id" {
  description = "IAM Role ID"
  value       = aws_iam_role.codebuild_role.id
}

output "badge_url" {
  description = "The URL of the build badge when badge_enabled is enabled"
  value       = module.codebuild.badge_url
}

output "s3_bucket" {
  description = "the arn of the S3 bucket used for caching and or artifact"
  value = module.s3_bucket.arn
}