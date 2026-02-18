locals {
  tags = {
    Project   = "shopstack"
    Env       = "dev"
    ManagedBy = "terraform"
  }
}

resource "aws_secretsmanager_secret" "github_token" {
  name                    = "shopstack/dev/github-token"
  description             = "GitHub PAT used by CodeBuild to push PRs to cluster-gitops"
  recovery_window_in_days = 0 # immediate deletion if destroyed (dev only)

  tags = local.tags
}
