output "vpc_id" {
  description = "ID of the VPC created by this module."
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "List of public subnet IDs created in the VPC."
  value       = module.vpc.public_subnets
}

output "private_subnets" {
  description = "List of private subnet IDs created in the VPC."
  value       = module.vpc.private_subnets
}

