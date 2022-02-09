# ecr-registry

This module creates following resources.

- `aws_ecr_registry_policy` (optional)
- `aws_ecr_replication_configuration` (optional)
- `aws_ecr_pull_through_cache_rule` (optional)
- `aws_ecr_registry_scanning_configuration`

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.70 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.70.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ecr_pull_through_cache_rule.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_pull_through_cache_rule) | resource |
| [aws_ecr_registry_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_registry_policy) | resource |
| [aws_ecr_registry_scanning_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_registry_scanning_configuration) | resource |
| [aws_ecr_replication_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_replication_configuration) | resource |
| [aws_resourcegroups_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/resourcegroups_group) | resource |
| [aws_caller_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.pull_through_cache](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.replication](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_module_tags_enabled"></a> [module\_tags\_enabled](#input\_module\_tags\_enabled) | (Optional) Whether to create AWS Resource Tags for the module informations. | `bool` | `true` | no |
| <a name="input_policy"></a> [policy](#input\_policy) | (Optional) The policy document for ECR registry. This is a JSON formatted string. | `string` | `null` | no |
| <a name="input_pull_through_cache_policies"></a> [pull\_through\_cache\_policies](#input\_pull\_through\_cache\_policies) | (Optional) A list of ECR Registry Policies for Pull Through Cache. Each value of `pull_through_cache_policies` as defined below.<br>    (Required) `iam_entities` - Specify one or more IAM principals to grant permission. Support the ARN of IAM entities, or AWS account ID.<br>    (Required) `allow_create_repository` - Need to create target repositories if `allow_create_repository` is false.<br>    (Required) `repositories` - A list of target repositories. Support glob expressions for `repositories` like `*`. | <pre>list(object({<br>    iam_entities            = list(string)<br>    allow_create_repository = bool<br>    repositories            = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_pull_through_cache_rules"></a> [pull\_through\_cache\_rules](#input\_pull\_through\_cache\_rules) | (Optional) A list of Pull Through Cache Rules for ECR registry. A `pull_through_cache_rules` block as defined below.<br>    (Required) `upstream_url` - The registry URL of the upstream public registry to use as the source.<br>    (Optional) `namespace` - The repository name prefix to use when caching images from the source registry. Default value is used if not provided. | `list(any)` | `[]` | no |
| <a name="input_replication_destinations"></a> [replication\_destinations](#input\_replication\_destinations) | (Optional) A list of destinations for ECR registry replication. `registry_id` is the account ID of the destination registry to replicate to. `region` is required to replicate to. | <pre>list(object({<br>    registry_id = string<br>    region      = string<br>  }))</pre> | `[]` | no |
| <a name="input_replication_policies"></a> [replication\_policies](#input\_replication\_policies) | (Optional) A list of ECR Registry Policies for replication. `account_id` is source AWS account for replication. If `allow_create_repository` is false, you need to create repositories with the same name whithin your registry. `repositories` is a list of target repositories. Support glob expressions for `repositories` like `*`. | <pre>list(object({<br>    account_id              = string<br>    allow_create_repository = bool<br>    repositories            = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_resource_group_description"></a> [resource\_group\_description](#input\_resource\_group\_description) | (Optional) The description of Resource Group. | `string` | `"Managed by Terraform."` | no |
| <a name="input_resource_group_enabled"></a> [resource\_group\_enabled](#input\_resource\_group\_enabled) | (Optional) Whether to create Resource Group to find and group AWS resources which are created by this module. | `bool` | `true` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Optional) The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`. | `string` | `""` | no |
| <a name="input_scanning_continuous_filters"></a> [scanning\_continuous\_filters](#input\_scanning\_continuous\_filters) | (Optional) A list of repository filter to scan continuous. Wildcard character is allowed. | `list(string)` | `[]` | no |
| <a name="input_scanning_on_push_filters"></a> [scanning\_on\_push\_filters](#input\_scanning\_on\_push\_filters) | (Optional) A list of repository filter to scan on push. Wildcard character is allowed. | `list(string)` | `[]` | no |
| <a name="input_scanning_type"></a> [scanning\_type](#input\_scanning\_type) | (Optional) The scanning type to set for the registry. Can be either `ENHANCED` or `BASIC`. | `string` | `"BASIC"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A map of tags to add to all resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the registry. |
| <a name="output_name"></a> [name](#output\_name) | The name of the registry. |
| <a name="output_policy"></a> [policy](#output\_policy) | The registry policy. |
| <a name="output_pull_through_cache_rules"></a> [pull\_through\_cache\_rules](#output\_pull\_through\_cache\_rules) | A list of Pull Through Cache Rules for ECR registry. |
| <a name="output_replication_destinations"></a> [replication\_destinations](#output\_replication\_destinations) | A list of destinations for ECR registry replication. |
| <a name="output_scanning_continuous_filters"></a> [scanning\_continuous\_filters](#output\_scanning\_continuous\_filters) | A list of repository filter to scan continuous. |
| <a name="output_scanning_on_push_filters"></a> [scanning\_on\_push\_filters](#output\_scanning\_on\_push\_filters) | A list of repository filter to scan on push. |
| <a name="output_scanning_type"></a> [scanning\_type](#output\_scanning\_type) | The scanning type for the registry. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
