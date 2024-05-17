# eks-addon

This module creates following resources.

- `aws_eks_addon`

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.42 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.50.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | tedilabs/misc/aws//modules/resource-group | ~> 0.10.0 |

## Resources

| Name | Type |
|------|------|
| [aws_eks_addon.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [aws_eks_addon_version.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_addon_version) | data source |
| [aws_eks_addon_version.latest](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_addon_version) | data source |
| [aws_eks_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | (Required) The name of the Amazon EKS cluster to add the EKS add-on to. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of the EKS add-on. | `string` | n/a | yes |
| <a name="input_addon_version"></a> [addon\_version](#input\_addon\_version) | (Optional) The version of the add-on. If not provided, this is configured with default compatibile version for the respective EKS cluster version. | `string` | `null` | no |
| <a name="input_configuration"></a> [configuration](#input\_configuration) | (Optional) The set of configuration values for the add-on. This JSON string value must match the JSON schema derived from `describe-addon-configuration`. | `string` | `null` | no |
| <a name="input_conflict_resolution_strategy_on_create"></a> [conflict\_resolution\_strategy\_on\_create](#input\_conflict\_resolution\_strategy\_on\_create) | (Optional) How to resolve field value conflicts when migrating a self-managed add-on to an EKS add-on. Valid values are `NONE` and `OVERWRITE`. Defaults to `OVERWRITE`.<br>    `NONE` - If the self-managed version of the add-on is installed on the cluster, Amazon EKS doesn't change the value. Creation of the add-on might fail.<br>    `OVERWRITE` - If the self-managed version of the add-on is installed on your cluster and the Amazon EKS default value is different than the existing value, Amazon EKS changes the value to the Amazon EKS default value. | `string` | `"OVERWRITE"` | no |
| <a name="input_conflict_resolution_strategy_on_update"></a> [conflict\_resolution\_strategy\_on\_update](#input\_conflict\_resolution\_strategy\_on\_update) | (Optional) How to resolve field value conflicts for an EKS add-on if you've changed a value from the EKS default value. Valid values are `NONE`, `OVERWRITE` and `PRESERVE`. Defaults to `OVERWRITE`.<br>    `NONE` - Amazon EKS doesn't change the value. The update might fail.<br>    `OVERWRITE` - Amazon EKS overwrites the changed value back to the Amazon EKS default value.<br>    `PRESERVE` - Amazon EKS preserves the value. If you choose this option, we recommend that you test any field and value changes on a non-production cluster before updating the add-on on the production cluster. | `string` | `"OVERWRITE"` | no |
| <a name="input_module_tags_enabled"></a> [module\_tags\_enabled](#input\_module\_tags\_enabled) | (Optional) Whether to create AWS Resource Tags for the module informations. | `bool` | `true` | no |
| <a name="input_preserve_on_delete"></a> [preserve\_on\_delete](#input\_preserve\_on\_delete) | (Optional) Whether to preserve the created Kubernetes resources on the cluster when deleting the EKS add-on. Defaults to `false`. | `bool` | `false` | no |
| <a name="input_resource_group_description"></a> [resource\_group\_description](#input\_resource\_group\_description) | (Optional) The description of Resource Group. | `string` | `"Managed by Terraform."` | no |
| <a name="input_resource_group_enabled"></a> [resource\_group\_enabled](#input\_resource\_group\_enabled) | (Optional) Whether to create Resource Group to find and group AWS resources which are created by this module. | `bool` | `true` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Optional) The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`. | `string` | `""` | no |
| <a name="input_service_account_role"></a> [service\_account\_role](#input\_service\_account\_role) | (Optional) The ARN (Amazon Resource Name) of the IAM Role to bind to the add-on's service account. The role must be assigned the IAM permissions required by the add-on. If you don't specify an existing IAM role, then the add-on uses the permissions assigned to the node IAM role. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A map of tags to add to all resources. | `map(string)` | `{}` | no |
| <a name="input_timeouts"></a> [timeouts](#input\_timeouts) | (Optional) How long to wait for the EKS Fargate Profile to be created/updated/deleted. | <pre>object({<br>    create = optional(string, "20m")<br>    update = optional(string, "20m")<br>    delete = optional(string, "40m")<br>  })</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the EKS add-on. |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | The name of the EKS cluster. |
| <a name="output_conflict_resolution_strategy_on_create"></a> [conflict\_resolution\_strategy\_on\_create](#output\_conflict\_resolution\_strategy\_on\_create) | How to resolve field value conflicts when migrating a self-managed add-on to an EKS add-on. |
| <a name="output_conflict_resolution_strategy_on_update"></a> [conflict\_resolution\_strategy\_on\_update](#output\_conflict\_resolution\_strategy\_on\_update) | How to resolve field value conflicts for an EKS add-on if you've changed a value from the EKS default value. |
| <a name="output_created_at"></a> [created\_at](#output\_created\_at) | Date and time in RFC3339 format that the EKS add-on was created. |
| <a name="output_default_version"></a> [default\_version](#output\_default\_version) | The default version of the EKS add-on compatible with the EKS cluster version. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the EKS add-on. |
| <a name="output_is_latest"></a> [is\_latest](#output\_is\_latest) | Whether the EKS add-on version is the latest available. |
| <a name="output_latest_version"></a> [latest\_version](#output\_latest\_version) | The latest version of the EKS add-on compatible with the EKS cluster version. |
| <a name="output_name"></a> [name](#output\_name) | The name of the EKS add-on. |
| <a name="output_service_account_role"></a> [service\_account\_role](#output\_service\_account\_role) | The ARN (Amazon Resource Name) of the IAM Role to bind to the add-on's service account |
| <a name="output_updated_at"></a> [updated\_at](#output\_updated\_at) | Date and time in RFC3339 format that the EKS add-on was updated. |
| <a name="output_version"></a> [version](#output\_version) | The version of the EKS add-on. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
