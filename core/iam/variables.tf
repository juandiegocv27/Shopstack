variable "ecr_repository_arn" {
  type        = string
  description = "ARN of the ECR repository CodeBuild will push to"
}

variable "github_token_secret_arn" {
  type        = string
  description = "ARN of the Secrets Manager secret holding the GitHub PAT"
}
