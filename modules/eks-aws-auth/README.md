# eks-aws-auth

This module creates following resources.

- `kubernetes_config_map`

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |
| kubernetes | >= 2.0 |

## Providers

| Name | Version |
|------|---------|
| kubernetes | >= 2.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| fargate\_profile\_roles | A list of ARNs of AWS IAM Roles for EKS fargate profiles. | `list(string)` | `[]` | no |
| map\_accounts | AWS account numbers to automatically map IAM ARNs from. | `list(string)` | `[]` | no |
| map\_roles | Additional mapping for IAM roles and Kubernetes RBAC. | <pre>list(object({<br>    iam_role = string<br>    username = string<br>    groups   = list(string)<br>  }))</pre> | `[]` | no |
| map\_users | Additional mapping for IAM users and Kubernetes RBAC. | <pre>list(object({<br>    iam_user = string<br>    username = string<br>    groups   = list(string)<br>  }))</pre> | `[]` | no |
| node\_roles | A list of ARNs of AWS IAM Roles for EKS node. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| config\_map | The data of `kube-system/aws-auth` ConfigMap. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
