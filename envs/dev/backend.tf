terraform {
  backend "s3" {
    bucket         = "shopstack-dev-tfstate"
    key            = "envs/dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "shopstack-dev-tflock"
    encrypt        = true
  }
}
