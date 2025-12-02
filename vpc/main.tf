provider "aws" {
  region = var.region
}


# Base VPC module for the ShopStack environment.
# Uses terraform-aws-modules/vpc. NAT Gateway is disabled to reduce cost.
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.8.1"

  name = "${var.project}-${var.env}-vpc"
  cidr = var.vpc_cidr

  azs             = var.azs
  public_subnets  = var.public_subnet_cidrs
  private_subnets = var.private_subnet_cidrs

  # Mantenerlo barato / simple
  enable_nat_gateway = false
  single_nat_gateway = false

  tags = {
    Project = var.project
    Env     = var.env
  }
}
