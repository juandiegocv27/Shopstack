variable "codebuild_role_arn" {
  type        = string
  description = "IAM role ARN for CodeBuild"
}

variable "ecr_repository_url" {
  type        = string
  description = "Full ECR repository URL for shopstack-catalog"
}
