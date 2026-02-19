locals {
  project = "shopstack"
  env     = "dev"
}

module "network" {
  source = "../../vpc"

  project              = local.project
  env                  = local.env
  region               = "us-east-1"
  vpc_cidr             = "10.0.0.0/16"
  azs                  = ["us-east-1a", "us-east-1b"]
  public_subnet_cidrs  = ["10.0.0.0/24", "10.0.1.0/24"]
  private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]
}

module "ecr" {
  source = "../../core/ecr"
}

module "secrets" {
  source = "../../core/secrets"
}

module "iam" {
  source = "../../core/iam"

  ecr_repository_arn      = module.ecr.repository_arn
  github_token_secret_arn = module.secrets.github_token_arn
}

module "codebuild" {
  source = "../../core/codebuild"

  codebuild_role_arn = module.iam.codebuild_role_arn
  ecr_repository_url = module.ecr.repository_url
}

module "github_oidc" {
  source = "../../core/github-oidc"
}
