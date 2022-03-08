# eks-aws-auth

This module creates following resources.

- `kubernetes_config_map`

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.4.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [kubernetes_config_map.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_fargate_profile_roles"></a> [fargate\_profile\_roles](#input\_fargate\_profile\_roles) | (Optional) A list of ARNs of AWS IAM Roles for EKS fargate profiles. | `list(string)` | `[]` | no |
| <a name="input_map_accounts"></a> [map\_accounts](#input\_map\_accounts) | (Optional) AWS account numbers to automatically map IAM ARNs from. | `list(string)` | `[]` | no |
| <a name="input_map_roles"></a> [map\_roles](#input\_map\_roles) | (Optional) Additional mapping for IAM roles and Kubernetes RBAC. | <pre>list(object({<br>    iam_role = string<br>    username = string<br>    groups   = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_map_users"></a> [map\_users](#input\_map\_users) | (Optional) Additional mapping for IAM users and Kubernetes RBAC. | <pre>list(object({<br>    iam_user = string<br>    username = string<br>    groups   = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_node_roles"></a> [node\_roles](#input\_node\_roles) | (Optional) A list of ARNs of AWS IAM Roles for EKS node. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_config_map"></a> [config\_map](#output\_config\_map) | The data of `kube-system/aws-auth` ConfigMap. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
