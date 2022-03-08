# ecr-repository

This module creates following resources.

- `aws_ecr_repository`
- `aws_ecr_repository_policy` (optional)
- `aws_ecr_lifecycle_policy` (optional)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.45 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.57.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ecr_lifecycle_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_lifecycle_policy) | resource |
| [aws_ecr_repository.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_ecr_repository_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository_policy) | resource |
| [aws_resourcegroups_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/resourcegroups_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | (Required) Desired name for the repository. | `string` | n/a | yes |
| <a name="input_encryption_enabled"></a> [encryption\_enabled](#input\_encryption\_enabled) | (Optional) Enable Encryption for repository. | `bool` | `false` | no |
| <a name="input_encryption_kms_key"></a> [encryption\_kms\_key](#input\_encryption\_kms\_key) | (Optional) The ARN of the KMS key to use when encryption\_type is `KMS`. If not specified, uses the default AWS managed key for ECR. | `string` | `null` | no |
| <a name="input_encryption_type"></a> [encryption\_type](#input\_encryption\_type) | (Optional) The encryption type to use for the repository. Valid values are `AES256` or `KMS`. | `string` | `"AES256"` | no |
| <a name="input_image_scan_on_push_enabled"></a> [image\_scan\_on\_push\_enabled](#input\_image\_scan\_on\_push\_enabled) | (Optional) Indicates whether images are scanned after being pushed to the repository or not scanned. | `bool` | `false` | no |
| <a name="input_image_tag_immutable_enabled"></a> [image\_tag\_immutable\_enabled](#input\_image\_tag\_immutable\_enabled) | (Optional) Should be true if you want to disable to modify image tags. | `bool` | `false` | no |
| <a name="input_lifecycle_rules"></a> [lifecycle\_rules](#input\_lifecycle\_rules) | (Optional) A list of ECR Repository Lifecycle rules. `priority` must be unique and do not need to be sequential across rules. `descriptoin` is optional. `type` is one of `tagged`, `untagged`, or `any`. `tag_prefixes` is required if you specified `tagged` type. Specify one of `expiration_days` or `expiration_count` | `any` | `[]` | no |
| <a name="input_module_tags_enabled"></a> [module\_tags\_enabled](#input\_module\_tags\_enabled) | (Optional) Whether to create AWS Resource Tags for the module informations. | `bool` | `true` | no |
| <a name="input_repository_policy"></a> [repository\_policy](#input\_repository\_policy) | (Optional) The policy document for ECR Repository. This is a JSON formatted string. | `string` | `""` | no |
| <a name="input_resource_group_description"></a> [resource\_group\_description](#input\_resource\_group\_description) | (Optional) The description of Resource Group. | `string` | `"Managed by Terraform."` | no |
| <a name="input_resource_group_enabled"></a> [resource\_group\_enabled](#input\_resource\_group\_enabled) | (Optional) Whether to create Resource Group to find and group AWS resources which are created by this module. | `bool` | `true` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Optional) The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`. | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A map of tags to add to all resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the repository. |
| <a name="output_name"></a> [name](#output\_name) | The name of the repository. |
| <a name="output_registry_id"></a> [registry\_id](#output\_registry\_id) | The registry ID where the repository was created. |
| <a name="output_url"></a> [url](#output\_url) | The URL of the repository (in the form aws\_account\_id.dkr.ecr.region.amazonaws.com/repositoryName). |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
