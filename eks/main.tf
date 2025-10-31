terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.60"
    }
  }
}

provider "aws" {
  region = var.region
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.24.1"

  cluster_name    = "${var.project}-${var.env}-eks"
  cluster_version = var.cluster_version

  vpc_id     = var.vpc_id
  subnet_ids = ["subnet-0ad21afa719ea0f5f", "subnet-02e577a76ce593e6d"]

  enable_irsa = true

  eks_managed_node_groups = {
    default = {
      instance_types = [var.node_instance_type]
      desired_size   = 1
      min_size       = 1
      max_size       = 2
      ami_type       = "AL2_x86_64"
      subnet_ids     = ["subnet-0ad21afa719ea0f5f", "subnet-02e577a76ce593e6d"]
    }
  }

  tags = {
    Project = var.project
    Env     = var.env
    Managed = "terraform"
  }
}
