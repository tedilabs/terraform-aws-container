# ecr-registry

This module creates following resources.

- `aws_ecr_registry_policy` (optional)
- `aws_ecr_replication_configuration` (optional)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.42 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.42 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ecr_registry_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_registry_policy) | resource |
| [aws_ecr_replication_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_replication_configuration) | resource |
| [aws_resourcegroups_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/resourcegroups_group) | resource |
| [aws_caller_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_module_tags_enabled"></a> [module\_tags\_enabled](#input\_module\_tags\_enabled) | Whether to create AWS Resource Tags for the module informations. | `bool` | `true` | no |
| <a name="input_policy"></a> [policy](#input\_policy) | The policy document for ECR registry. This is a JSON formatted string. | `string` | `null` | no |
| <a name="input_replication_destinations"></a> [replication\_destinations](#input\_replication\_destinations) | A list of destinations for ECR registry replication. `registry_id` is the account ID of the destination registry to replicate to. `region` is required to replicate to. | <pre>list(object({<br>    registry_id = string<br>    region      = string<br>  }))</pre> | `[]` | no |
| <a name="input_replication_policies"></a> [replication\_policies](#input\_replication\_policies) | A list of ECR Registry Policies for replication. `account_id` is source AWS account for replication. If `allow_create_repository` is false, you need to create repositories with the same name whithin your registry. `repositories` is a list of target repositories. Support glob expressions for `repositories` like `*`. | <pre>list(object({<br>    account_id              = string<br>    allow_create_repository = bool<br>    repositories            = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_resource_group_description"></a> [resource\_group\_description](#input\_resource\_group\_description) | The description of Resource Group. | `string` | `"Managed by Terraform."` | no |
| <a name="input_resource_group_enabled"></a> [resource\_group\_enabled](#input\_resource\_group\_enabled) | Whether to create Resource Group to find and group AWS resources which are created by this module. | `bool` | `true` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`. | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the registry. |
| <a name="output_name"></a> [name](#output\_name) | The name of the registry. |
| <a name="output_policy"></a> [policy](#output\_policy) | The registry policy. |
| <a name="output_replication_destinations"></a> [replication\_destinations](#output\_replication\_destinations) | A list of destinations for ECR registry replication. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->