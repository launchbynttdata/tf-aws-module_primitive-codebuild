output "project_name" {
  description = "Project name"
  value       = aws_codebuild_project.default[0].name
}

output "project_id" {
  description = "Project ID"
  value       = aws_codebuild_project.default[0].id
}

output "badge_url" {
  description = "The URL of the build badge when badge_enabled is enabled"
  value       = aws_codebuild_project.default[0].badge_url
}

output "project_arn" {
  description = "Project ARN"
  value       = aws_codebuild_project.default[0].arn
}

output "buildspec" {
  description = "The buildspec used with the CodeBuild project"
  value       = var.buildspec
}
