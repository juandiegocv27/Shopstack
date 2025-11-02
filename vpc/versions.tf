terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.60"
    }
  }
  backend "s3" {
    bucket         = "shopstack-dev-tfstate"
    key            = "shopstack/dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "shopstack-dev-tflock"
    encrypt        = true
  }
}

provider "aws" {
  region = var.region
}
