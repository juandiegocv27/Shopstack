resource "aws_codebuild_project" "catalog" {
  name          = "shopstack-catalog-dev"
  description   = "Build and push catalog service to ECR; open GitOps PR"
  service_role  = var.codebuild_role_arn
  build_timeout = 20

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:7.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true # required for Docker daemon

    environment_variable {
      name  = "AWS_REGION"
      value = "us-east-1"
    }

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = "770132776547"
    }

    environment_variable {
      name  = "SERVICE_NAME"
      value = "catalog"
    }

    environment_variable {
      name  = "ECR_REPOSITORY"
      value = var.ecr_repository_url
    }

    environment_variable {
      name  = "BUILD_CONTEXT"
      value = "services/catalog"
    }

    environment_variable {
      name  = "CLUSTER_GITOPS_REPO"
      value = "https://github.com/juandiegocv27/cluster-gitops.git"
    }

    environment_variable {
      name  = "GITOPS_KUSTOMIZE_PATH"
      value = "apps/catalog/overlays/dev/kustomization.yaml"
    }

    # Value is the secret name in Secrets Manager — CodeBuild resolves it at runtime
    environment_variable {
      name  = "GITHUB_TOKEN"
      value = "shopstack/dev/github-token"
      type  = "SECRETS_MANAGER"
    }
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/juandiegocv27/apps-sre.git"
    buildspec       = "buildspec.yml"
    git_clone_depth = 1
  }

  logs_config {
    cloudwatch_logs {
      group_name = "/aws/codebuild/shopstack-catalog-dev"
      status     = "ENABLED"
    }
  }

  tags = {
    Project   = "shopstack"
    Env       = "dev"
    ManagedBy = "terraform"
  }
}
