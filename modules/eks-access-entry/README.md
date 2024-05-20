# eks-access-entry

This module creates following resources.

- `aws_eks_access_entry`
- `aws_eks_access_policy_association` (optional)

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
| [aws_eks_access_entry.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_access_entry) | resource |
| [aws_eks_access_policy_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_access_policy_association) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | (Required) The name of the Amazon EKS cluster to create IAM access entries. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of the Amazon EKS access entry. | `string` | n/a | yes |
| <a name="input_principal"></a> [principal](#input\_principal) | (Required) The ARN of one, and only one, existing IAM principal to grant access to Kubernetes objects on the cluster. An IAM principal can't be included in more than one access entry. | `string` | n/a | yes |
| <a name="input_kubernetes_groups"></a> [kubernetes\_groups](#input\_kubernetes\_groups) | (Optional) A set of groups within the Kubernetes cluster. Only used when `type` is `STANDARD`. | `set(string)` | `[]` | no |
| <a name="input_kubernetes_permissions"></a> [kubernetes\_permissions](#input\_kubernetes\_permissions) | (Optional) A list of permissions for EKS access entry to the EKS cluster. Each item of `kubernetes_permissions` block as defined below.<br>    (Required) `policy` - The ARN of the access policy that you're associating.<br>    (Optional) `scope` - The type of access scope that you're associating. Valid values are `NAMESPACE`, `CLUSTER`. Defaults to `CLUSTER`.<br>    (Optional) `namespaces` - A set of namespaces to which the access scope applies. You can enter plain text namespaces, or wildcard namespaces such as `dev-*`. | <pre>list(object({<br>    policy     = string<br>    scope      = optional(string, "CLUSTER")<br>    namespaces = optional(set(string), [])<br>  }))</pre> | `[]` | no |
| <a name="input_kubernetes_username"></a> [kubernetes\_username](#input\_kubernetes\_username) | (Optional) The username to authenticate to Kubernetes with. We recommend not specifying a username and letting Amazon EKS specify it for you. Defaults to the IAM principal ARN. Only used when `type` is `STANDARD`. | `string` | `null` | no |
| <a name="input_module_tags_enabled"></a> [module\_tags\_enabled](#input\_module\_tags\_enabled) | (Optional) Whether to create AWS Resource Tags for the module informations. | `bool` | `true` | no |
| <a name="input_resource_group_description"></a> [resource\_group\_description](#input\_resource\_group\_description) | (Optional) The description of Resource Group. | `string` | `"Managed by Terraform."` | no |
| <a name="input_resource_group_enabled"></a> [resource\_group\_enabled](#input\_resource\_group\_enabled) | (Optional) Whether to create Resource Group to find and group AWS resources which are created by this module. | `bool` | `true` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Optional) The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`. | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A map of tags to add to all resources. | `map(string)` | `{}` | no |
| <a name="input_timeouts"></a> [timeouts](#input\_timeouts) | (Optional) How long to wait for the EKS access entry to be created/deleted. | <pre>object({<br>    create = optional(string, "20m")<br>    delete = optional(string, "40m")<br>  })</pre> | `{}` | no |
| <a name="input_type"></a> [type](#input\_type) | (Optional) The type of the access entry. Valid values are `EC2_LINUX`, `EC2_WINDOWS`, `FARGATE_LINUX`, `STANDARD`. Defaults to `STANDARD`. | `string` | `"STANDARD"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The Amazon Resource Name (ARN) of the EKS access entry. |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | The name of the EKS cluster. |
| <a name="output_created_at"></a> [created\_at](#output\_created\_at) | Date and time in RFC3339 format that the EKS access entry was created. |
| <a name="output_kubernetes_groups"></a> [kubernetes\_groups](#output\_kubernetes\_groups) | The authenticated groups in Kubernetes cluster. |
| <a name="output_kubernetes_permissions"></a> [kubernetes\_permissions](#output\_kubernetes\_permissions) | The list of permissions for EKS access entry to the EKS cluster. |
| <a name="output_kubernetes_username"></a> [kubernetes\_username](#output\_kubernetes\_username) | The authenticated username in Kubernetes cluster. |
| <a name="output_name"></a> [name](#output\_name) | The name of the EKS access entry. |
| <a name="output_principal"></a> [principal](#output\_principal) | The ARN of one, and only one, existing IAM principal to grant access to Kubernetes objects on the cluster. |
| <a name="output_type"></a> [type](#output\_type) | The type of the access entry. |
| <a name="output_updated_at"></a> [updated\_at](#output\_updated\_at) | Date and time in RFC3339 format that the EKS access entry was updated. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
