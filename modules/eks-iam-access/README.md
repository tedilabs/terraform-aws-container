# eks-iam-access

This module creates following resources.

- `aws_eks_access_entry` (optional)
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
| [aws_eks_access_entry.node](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_access_entry) | resource |
| [aws_eks_access_entry.user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_access_entry) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | (Required) The name of the Amazon EKS cluster to create IAM access entries. | `string` | n/a | yes |
| <a name="input_module_tags_enabled"></a> [module\_tags\_enabled](#input\_module\_tags\_enabled) | (Optional) Whether to create AWS Resource Tags for the module informations. | `bool` | `true` | no |
| <a name="input_node_access_entries"></a> [node\_access\_entries](#input\_node\_access\_entries) | (Optional) A list of configurations for EKS access entries for nodes (EC2 instances, Fargate) that are allowed to access the EKS cluster. Each item of `node_access_entries` block as defined below.<br>    (Required) `name` - A unique name for the access entry. This value is only used internally within Terraform code.<br>    (Required) `type` - The type of the access entry. Valid values are `EC2_LINUX`, `EC2_WINDOWS`, `FARGATE_LINUX`.<br>    (Required) `principal` - The ARN of one, and only one, existing IAM principal to grant access to Kubernetes objects on the cluster. An IAM principal can't be included in more than one access entry. | <pre>list(object({<br>    name      = string<br>    type      = string<br>    principal = string<br>  }))</pre> | `[]` | no |
| <a name="input_resource_group_description"></a> [resource\_group\_description](#input\_resource\_group\_description) | (Optional) The description of Resource Group. | `string` | `"Managed by Terraform."` | no |
| <a name="input_resource_group_enabled"></a> [resource\_group\_enabled](#input\_resource\_group\_enabled) | (Optional) Whether to create Resource Group to find and group AWS resources which are created by this module. | `bool` | `true` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Optional) The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`. | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A map of tags to add to all resources. | `map(string)` | `{}` | no |
| <a name="input_timeouts"></a> [timeouts](#input\_timeouts) | (Optional) How long to wait for the EKS Cluster to be created/updated/deleted. | <pre>object({<br>    create = optional(string, "30m")<br>    update = optional(string, "60m")<br>    delete = optional(string, "15m")<br>  })</pre> | `{}` | no |
| <a name="input_user_access_entries"></a> [user\_access\_entries](#input\_user\_access\_entries) | (Optional) A list of configurations for EKS access entries for users (IAM roles, users) that are allowed to access the EKS cluster. Each item of `user_access_entries` block as defined below.<br>    (Required) `name` - A unique name for the access entry. This value is only used internally within Terraform code.<br>    (Required) `principal` - The ARN of one, and only one, existing IAM principal to grant access to Kubernetes objects on the cluster. An IAM principal can't be included in more than one access entry.<br>    (Optional) `username` - The username to authenticate to Kubernetes with. We recommend not specifying a username and letting Amazon EKS specify it for you. Defaults to the IAM principal ARN.<br>    (Optional) `groups` - A set of groups within the Kubernetes cluster. | <pre>list(object({<br>    name      = string<br>    principal = string<br>    username  = optional(string)<br>    groups    = optional(set(string), [])<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | The name of the EKS cluster. |
| <a name="output_node_access_entries"></a> [node\_access\_entries](#output\_node\_access\_entries) | The list of configurations for EKS access entries for nodes (EC2 instances, Fargate). |
| <a name="output_user_access_entries"></a> [user\_access\_entries](#output\_user\_access\_entries) | The list of configurations for EKS access entries for users (IAM roles, users). |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
