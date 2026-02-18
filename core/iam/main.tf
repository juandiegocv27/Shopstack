data "aws_iam_policy_document" "codebuild_assume" {
  statement {
    sid     = "AllowCodeBuildAssume"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "codebuild" {
  name               = "shopstack-codebuild-role"
  assume_role_policy = data.aws_iam_policy_document.codebuild_assume.json

  tags = {
    Project   = "shopstack"
    ManagedBy = "terraform"
  }
}

data "aws_iam_policy_document" "codebuild_permissions" {

  # ECR auth token — must be *, cannot scope to a single repo
  statement {
    sid       = "ECRAuthToken"
    effect    = "Allow"
    actions   = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }

  # ECR push — scoped to the single catalog repo
  statement {
    sid    = "ECRPush"
    effect = "Allow"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
    ]
    resources = [var.ecr_repository_arn]
  }

  # Secrets Manager — read-only, scoped to shopstack secrets
  statement {
    sid       = "SecretsRead"
    effect    = "Allow"
    actions   = ["secretsmanager:GetSecretValue"]
    resources = [var.github_token_secret_arn]
  }

  # CloudWatch Logs — scoped to shopstack log groups
  statement {
    sid    = "CWLogs"
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = ["arn:aws:logs:us-east-1:770132776547:log-group:/aws/codebuild/shopstack-*"]
  }
}

resource "aws_iam_role_policy" "codebuild" {
  name   = "shopstack-codebuild-policy"
  role   = aws_iam_role.codebuild.id
  policy = data.aws_iam_policy_document.codebuild_permissions.json
}
