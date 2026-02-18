# codebuild

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.60 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.60 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_codebuild_project.catalog](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_project) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_codebuild_role_arn"></a> [codebuild\_role\_arn](#input\_codebuild\_role\_arn) | IAM role ARN for CodeBuild | `string` | n/a | yes |
| <a name="input_ecr_repository_url"></a> [ecr\_repository\_url](#input\_ecr\_repository\_url) | Full ECR repository URL for shopstack-catalog | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
