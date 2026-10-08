# eks-iam-access

This module creates following resources.

- `aws_eks_access_entry` (optional)
- `aws_eks_access_policy_association` (optional)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.12 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.12 |
| <a name="requirement_telemetry"></a> [telemetry](#requirement\_telemetry) | >= 0.1.1 |

## Providers

No providers.

## Modules

| Name | Source | Version |
| ---- | ------ | ------- |
| <a name="module_node"></a> [node](#module\_node) | ../eks-access-entry | n/a |
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | tedilabs/misc/aws//modules/resource-group | ~> 0.12.0 |
| <a name="module_user"></a> [user](#module\_user) | ../eks-access-entry | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | (Required) The name of the Amazon EKS cluster to create IAM access entries. | `string` | n/a | yes |
| <a name="input_module_tags_enabled"></a> [module\_tags\_enabled](#input\_module\_tags\_enabled) | (Optional) Whether to create AWS Resource Tags for the module informations. | `bool` | `true` | no |
| <a name="input_node_access_entries"></a> [node\_access\_entries](#input\_node\_access\_entries) | (Optional) A list of configurations for EKS access entries for nodes (EC2 instances, Fargate) that are allowed to access the EKS cluster. Each item of `node_access_entries` block as defined below.<br/>    (Required) `name` - A unique name for the access entry. This value is only used internally within Terraform code.<br/>    (Required) `type` - The type of the access entry. Valid values are `EC2`, `EC2_LINUX`, `EC2_WINDOWS`, `FARGATE_LINUX`, `HYBRID_LINUX`, `HYPERPOD_LINUX`.<br/>    (Required) `principal` - The ARN of one, and only one, existing IAM principal to grant access to Kubernetes objects on the cluster. An IAM principal can't be included in more than one access entry. | <pre>list(object({<br/>    name      = string<br/>    type      = string<br/>    principal = string<br/>  }))</pre> | `[]` | no |
| <a name="input_region"></a> [region](#input\_region) | (Optional) The region in which to create the module resources. If not provided, the module resources will be created in the provider's configured region. | `string` | `null` | no |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | (Optional) A configurations of Resource Group for this module. `resource_group` as defined below.<br/>    (Optional) `enabled` - Whether to create Resource Group to find and group AWS resources which are created by this module. Defaults to `true`.<br/>    (Optional) `name` - The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`. If not provided, a name will be generated using the module name and instance name.<br/>    (Optional) `description` - The description of Resource Group. Defaults to `Managed by Terraform.`. | <pre>object({<br/>    enabled     = optional(bool, true)<br/>    name        = optional(string, "")<br/>    description = optional(string, "Managed by Terraform.")<br/>  })</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A map of tags to add to all resources. | `map(string)` | `{}` | no |
| <a name="input_telemetry"></a> [telemetry](#input\_telemetry) | (Optional) A configuration to collect telemetry data for the module. This is used to improve the module and its features. The data collected is anonymous and does not contain any sensitive information. The default configuration enables telemetry collection for machine, network, git, github, github actions, terraform, and toolchain. You can disable telemetry collection by setting `enabled` to `false`. `telemetry` block as defined below.<br/>    (Optional) `enabled` - Whether to enable telemetry collection. Default is `true`.<br/>    (Optional) `capture_machine` - Whether to capture machine information. Default is `true`.<br/>    (Optional) `capture_network` - Whether to capture network information. Default is `true`.<br/>    (Optional) `capture_git` - Whether to capture git information. Default is `true`.<br/>    (Optional) `capture_github` - Whether to capture GitHub information. Default is `true`.<br/>    (Optional) `capture_github_actions` - Whether to capture GitHub Actions information. Default is `true`.<br/>    (Optional) `capture_terraform` - Whether to capture Terraform information. Default is `true`.<br/>    (Optional) `capture_toolchain` - Whether to capture toolchain information. Default is `true`. | <pre>object({<br/>    enabled = optional(bool, true)<br/><br/>    capture_machine        = optional(bool, true)<br/>    capture_network        = optional(bool, true)<br/>    capture_git            = optional(bool, true)<br/>    capture_github         = optional(bool, true)<br/>    capture_github_actions = optional(bool, true)<br/>    capture_terraform      = optional(bool, true)<br/>    capture_toolchain      = optional(bool, true)<br/>  })</pre> | `{}` | no |
| <a name="input_timeouts"></a> [timeouts](#input\_timeouts) | (Optional) How long to wait for the EKS access entry to be created/deleted. | <pre>object({<br/>    create = optional(string, "20m")<br/>    delete = optional(string, "40m")<br/>  })</pre> | `{}` | no |
| <a name="input_user_access_entries"></a> [user\_access\_entries](#input\_user\_access\_entries) | (Optional) A list of configurations for EKS access entries for users (IAM roles, users) that are allowed to access the EKS cluster. Each item of `user_access_entries` block as defined below.<br/>    (Required) `name` - A unique name for the access entry. This value is only used internally within Terraform code.<br/>    (Required) `principal` - The ARN of one, and only one, existing IAM principal to grant access to Kubernetes objects on the cluster. An IAM principal can't be included in more than one access entry.<br/>    (Optional) `kubernetes_username` - The username to authenticate to Kubernetes with. We recommend not specifying a username and letting Amazon EKS specify it for you. Defaults to the IAM principal ARN.<br/>    (Optional) `kubernetes_groups` - A set of groups within the Kubernetes cluster.<br/>    (Optional) `kubernetes_permissions` - A list of permissions for EKS access entry to the EKS cluster. Each item of `kubernetes_permissions` block as defined below.<br/>      (Required) `policy` - The ARN of the access policy that you're associating.<br/>      (Optional) `scope` - The type of access scope that you're associating. Valid values are `NAMESPACE`, `CLUSTER`. Defaults to `CLUSTER`.<br/>      (Optional) `namespaces` - A set of namespaces to which the access scope applies. You can enter plain text namespaces, or wildcard namespaces such as `dev-*`. | <pre>list(object({<br/>    name                = string<br/>    principal           = string<br/>    kubernetes_username = optional(string)<br/>    kubernetes_groups   = optional(set(string), [])<br/>    kubernetes_permissions = optional(list(object({<br/>      policy     = string<br/>      scope      = optional(string, "CLUSTER")<br/>      namespaces = optional(set(string), [])<br/>    })), [])<br/>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | The name of the EKS cluster. |
| <a name="output_node_access_entries"></a> [node\_access\_entries](#output\_node\_access\_entries) | The list of configurations for EKS access entries for nodes (EC2 instances, Fargate). |
| <a name="output_region"></a> [region](#output\_region) | The AWS region this module resources resides in. |
| <a name="output_resource_group"></a> [resource\_group](#output\_resource\_group) | The resource group created to manage resources in this module. |
| <a name="output_user_access_entries"></a> [user\_access\_entries](#output\_user\_access\_entries) | The list of configurations for EKS access entries for users (IAM roles, users). |
<!-- END_TF_DOCS -->
