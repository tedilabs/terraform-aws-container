# eks-fargate-profile

This module creates following resources.

- `aws_eks_fargate_profile`
- `aws_iam_role` (optional)
- `aws_iam_role_policy` (optional)
- `aws_iam_role_policy_attachment` (optional)
- `aws_iam_instance_profile` (optional)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.12 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.12 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.21.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | tedilabs/misc/aws//modules/resource-group | ~> 0.12.0 |
| <a name="module_role"></a> [role](#module\_role) | tedilabs/account/aws//modules/iam-role | ~> 0.33.0 |

## Resources

| Name | Type |
|------|------|
| [aws_eks_fargate_profile.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_fargate_profile) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | (Required) The name of the Amazon EKS cluster to apply the Fargate profile to. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of Fargate Profile. | `string` | n/a | yes |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | (Required) The IDs of subnets to launch your pods into. At this time, pods running on Fargate are not assigned public IP addresses, so only private subnets (with no direct route to an Internet Gateway) are accepted | `list(string)` | n/a | yes |
| <a name="input_default_pod_execution_role"></a> [default\_pod\_execution\_role](#input\_default\_pod\_execution\_role) | (Optional) A configuration for the default pod execution role to use for pods that match the selectors in the Fargate profile. Use `pod_execution_role` if `default_pod_execution_role.enabled` is `false`. `default_pod_execution_role` as defined below.<br/>    (Optional) `enabled` - Whether to create the default pod execution role. Defaults to `true`.<br/>    (Optional) `name` - The name of the default pod execution role. Defaults to `eks-${var.cluster_name}-fargate-profile-${var.name}`.<br/>    (Optional) `path` - The path of the default pod execution role. Defaults to `/`.<br/>    (Optional) `description` - The description of the default pod execution role.<br/>    (Optional) `policies` - A list of IAM policy ARNs to attach to the default pod execution role. `AmazonEKSFargatePodExecutionRolePolicy` is always attached. Defaults to `[]`.<br/>    (Optional) `inline_policies` - A Map of inline IAM policies to attach to the default pod execution role. (`name` => `policy`). | <pre>object({<br/>    enabled     = optional(bool, true)<br/>    name        = optional(string)<br/>    path        = optional(string, "/")<br/>    description = optional(string, "Managed by Terraform.")<br/><br/>    policies        = optional(list(string), [])<br/>    inline_policies = optional(map(string), {})<br/>  })</pre> | `{}` | no |
| <a name="input_module_tags_enabled"></a> [module\_tags\_enabled](#input\_module\_tags\_enabled) | (Optional) Whether to create AWS Resource Tags for the module informations. | `bool` | `true` | no |
| <a name="input_pod_execution_role"></a> [pod\_execution\_role](#input\_pod\_execution\_role) | (Optional) The ARN (Amazon Resource Name) of the IAM Role that provides permissions for the EKS Fargate Profile. Only required if `default_pod_execution_role.enabled` is `false`. | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | (Optional) The region in which to create the module resources. If not provided, the module resources will be created in the provider's configured region. | `string` | `null` | no |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | (Optional) A configurations of Resource Group for this module. `resource_group` as defined below.<br/>    (Optional) `enabled` - Whether to create Resource Group to find and group AWS resources which are created by this module. Defaults to `true`.<br/>    (Optional) `name` - The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`. If not provided, a name will be generated using the module name and instance name.<br/>    (Optional) `description` - The description of Resource Group. Defaults to `Managed by Terraform.`. | <pre>object({<br/>    enabled     = optional(bool, true)<br/>    name        = optional(string, "")<br/>    description = optional(string, "Managed by Terraform.")<br/>  })</pre> | `{}` | no |
| <a name="input_selectors"></a> [selectors](#input\_selectors) | (Optional) A list of configurations for selecting Kubernetes Pods to execute with this EKS Fargate Profile. Each block of `selectors` as defined below.<br/>    (Required) `namespace` - Kubernetes namespace for selection.<br/>    (Optional) `labels` - Key-value map of Kubernetes labels for selection. | <pre>list(object({<br/>    namespace = string<br/>    labels    = optional(map(string), {})<br/>  }))</pre> | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A map of tags to add to all resources. | `map(string)` | `{}` | no |
| <a name="input_timeouts"></a> [timeouts](#input\_timeouts) | (Optional) How long to wait for the EKS Fargate Profile to be created/updated/deleted. | <pre>object({<br/>    create = optional(string, "10m")<br/>    delete = optional(string, "10m")<br/>  })</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the Fargate Profile. |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | The name of the EKS cluster. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the Fargate Profile. |
| <a name="output_name"></a> [name](#output\_name) | The name of the Fargate Profile. |
| <a name="output_pod_execution_role"></a> [pod\_execution\_role](#output\_pod\_execution\_role) | The ARN (Amazon Resource Name) of the IAM Role that provides permissions for the EKS Fargate Profile. |
| <a name="output_region"></a> [region](#output\_region) | The AWS region this module resources resides in. |
| <a name="output_resource_group"></a> [resource\_group](#output\_resource\_group) | The resource group created to manage resources in this module. |
| <a name="output_selectors"></a> [selectors](#output\_selectors) | A list of selectors to match for pods to use this Fargate profile. |
| <a name="output_status"></a> [status](#output\_status) | The status of the EKS Fargate Profile. |
| <a name="output_subnets"></a> [subnets](#output\_subnets) | The IDs of subnets in which to launch pods. |
<!-- END_TF_DOCS -->
