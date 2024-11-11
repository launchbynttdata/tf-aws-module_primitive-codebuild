output "project_name" {
  description = "Project name"
  value       = aws_codebuild_project.default.name
}

output "project_id" {
  description = "Project ID"
  value       = aws_codebuild_project.default.id
}

output "badge_url" {
  description = "The URL of the build badge when badge_enabled is enabled"
  value       = aws_codebuild_project.default.badge_url
}

output "project_arn" {
  description = "Project ARN"
  value       = aws_codebuild_project.default.arn
}

output "buildspec" {
  description = "The buildspec used with the CodeBuild project"
  value       = var.buildspec
}

output "service_role_arn" {
  description = "The arn of the service role created for the codebuild project"
  value = aws_iam_role.codebuild_role.arn
}