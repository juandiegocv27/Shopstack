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

module "worker" {
  source = "../../ec2"

  project           = local.project
  env               = local.env
  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids

  talos_ami_id       = "ami-013b54d09638284e9"
  control_plane_cidr = "177.93.0.152/32"
}
