output "gha_role_arn" {
  description = "IAM role ARN for GitHub Actions to assume"
  value       = aws_iam_role.gha_trigger.arn
}
