variable "project" {
  type    = string
  default = "shopstack"
}

variable "env" {
  type    = string
  default = "dev"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "cluster_version" {
  type    = string
  default = "1.31"
}

variable "node_instance_type" {
  type    = string
  default = "t3.small"
}

variable "vpc_id" {
  type = string
  default = "vpc-00154233cd16a656b"
}

