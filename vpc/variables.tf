variable "project" {
  type        = string
  description = "Project name used for resource naming and tagging."
}

variable "env" {
  type        = string
  description = "Deployment environment (e.g., dev, prod)."
}

variable "region" {
  type        = string
  description = "AWS region where the VPC resources are created."
}

variable "vpc_cidr" {
  type        = string
  description = "Primary CIDR block for the VPC."
}

variable "azs" {
  type        = list(string)
  description = "List of Availability Zones where subnets will be created."
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "List of CIDR blocks for the public subnets."
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "List of CIDR blocks for the private subnets."
}
