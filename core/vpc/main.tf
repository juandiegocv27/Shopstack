module "vpc" {
  # Use the official AWS VPC module from the Terraform Registry
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.8.1"

  # Define VPC name based on project and environment
  name            = "${var.project}-${var.env}"

  # Set the CIDR block for the VPC
  cidr            = var.vpc_cidr

  # Define the Availability Zones to use
  azs             = var.azs

  # Define CIDR blocks for public and private subnets
  public_subnets  = var.public_subnet_cidrs
  private_subnets = var.private_subnet_cidrs

  # Enable NAT Gateway for outbound traffic from private subnets
  enable_nat_gateway   = false

  # Create one NAT Gateway per AZ for high availability
  single_nat_gateway   = false   
  one_nat_gateway_per_az = false

  # Enable DNS hostnames and DNS resolution support within the VPC
  enable_dns_hostnames = true
  enable_dns_support   = true

  # Common tags for resource identification and management
  tags = {
    Project = var.project
    Env     = var.env
    Managed = "terraform"
  }
}

# Output VPC and subnet identifiers
output "vpc_id"             { value = module.vpc.vpc_id }
output "public_subnet_ids"  { value = module.vpc.public_subnets }
output "private_subnet_ids" { value = module.vpc.private_subnets }
