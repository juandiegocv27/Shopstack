# infra-terraform

A Terraform infrastructure as code (IaC) project for provisioning and managing AWS cloud resources.

## Overview

This project provides a basic AWS infrastructure setup including:
- VPC (Virtual Private Cloud)
- Public subnets across multiple availability zones
- Internet Gateway for public internet access
- Route tables and associations
- Security groups with basic HTTP/HTTPS rules

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- [AWS CLI](https://aws.amazon.com/cli/) configured with appropriate credentials
- An AWS account with appropriate permissions

## AWS Credentials Setup

Before using this Terraform configuration, ensure your AWS credentials are configured. You can do this by:

1. Using AWS CLI:
   ```bash
   aws configure
   ```

2. Or by setting environment variables:
   ```bash
   export AWS_ACCESS_KEY_ID="your_access_key"
   export AWS_SECRET_ACCESS_KEY="your_secret_key"
   export AWS_DEFAULT_REGION="us-east-1"
   ```

3. Or by using AWS IAM roles (recommended for production)

## Project Structure

```
.
├── main.tf                    # Main Terraform configuration
├── variables.tf               # Variable definitions
├── outputs.tf                 # Output definitions
├── terraform.tfvars.example   # Example variables file
├── .gitignore                 # Git ignore file for Terraform
└── README.md                  # This file
```

## Getting Started

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd infra-terraform
   ```

2. **Configure variables**
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars with your desired values
   ```

3. **Initialize Terraform**
   ```bash
   terraform init
   ```

4. **Review the plan**
   ```bash
   terraform plan
   ```

5. **Apply the configuration**
   ```bash
   terraform apply
   ```

6. **View outputs**
   ```bash
   terraform output
   ```

## Configuration Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `aws_region` | AWS region where resources will be created | `us-east-1` |
| `environment` | Environment name (e.g., dev, staging, prod) | `dev` |
| `project_name` | Project name used for resource naming | `infra-terraform` |
| `vpc_cidr` | CIDR block for VPC | `10.0.0.0/16` |
| `availability_zones` | List of availability zones | `["us-east-1a", "us-east-1b"]` |

## Outputs

After applying the configuration, the following outputs will be available:

- `vpc_id` - ID of the created VPC
- `vpc_cidr` - CIDR block of the VPC
- `public_subnet_ids` - IDs of the public subnets
- `internet_gateway_id` - ID of the Internet Gateway
- `security_group_id` - ID of the security group
- `security_group_name` - Name of the security group

## Resource Tagging

All resources are automatically tagged with:
- `Environment` - The environment name
- `Project` - The project name
- `ManagedBy` - Set to "Terraform"

## Cleanup

To destroy all resources created by this configuration:

```bash
terraform destroy
```

## Security Considerations

- The security group allows HTTP (80) and HTTPS (443) traffic from anywhere (0.0.0.0/0)
- Modify security group rules according to your security requirements
- Never commit `terraform.tfvars` or any files containing sensitive information
- Use AWS IAM roles and least privilege principles
- Enable AWS CloudTrail for audit logging

## Best Practices

1. **State Management**: Consider using remote state storage (e.g., S3 with DynamoDB for locking)
2. **Secrets**: Use AWS Secrets Manager or Parameter Store for sensitive data
3. **Modules**: For larger projects, organize code into reusable modules
4. **Environments**: Use workspaces or separate directories for different environments
5. **Version Control**: Always commit your Terraform code to version control

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

This project is licensed under the MIT License.