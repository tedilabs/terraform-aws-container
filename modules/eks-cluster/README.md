# eks-cluster

This module creates following resources.

- `aws_eks_cluster`
- `aws_cloudwatch_log_group`
- `aws_iam_role`
- `aws_iam_role_policy`
- `aws_iam_role_policy_attachment`
- `aws_iam_instance_profile`
- `aws_iam_openid_connect_provider`
- `aws_security_group`
- `aws_security_group_rule`

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |
| aws | >= 3.30 |
| tls | >= 3.1 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 3.30 |
| tls | >= 3.1 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster\_name | Name of the EKS cluster. | `string` | n/a | yes |
| subnet\_ids | A list of subnets to creates cross-account elastic network interfaces to allow communication between your worker nodes and the Kubernetes control plane. Must be in at least two different availability zones. | `list(string)` | n/a | yes |
| cluster\_version | Kubernetes version to use for the EKS cluster. | `string` | `"1.19"` | no |
| encryption\_enabled | Whether to encrypt kubernetes resources. | `string` | `false` | no |
| encryption\_kms\_key | The ARN of the KMS customer master key (CMK) to encrypt resources. The CMK must be symmetric, created in the same region as the cluster, and if the CMK was created in a different account, the user must have access to the CMK. | `string` | `null` | no |
| encryption\_resources | List of strings with resources to be encrypted. Valid values: `secrets`. | `list(string)` | <pre>[<br>  "secrets"<br>]</pre> | no |
| endpoint\_private\_access | Indicates whether or not the Amazon EKS private API server endpoint is enabled. | `bool` | `true` | no |
| endpoint\_private\_access\_cidrs | A list of allowed CIDR to communicate to the Amazon EKS private API server endpoint. | `list(string)` | `[]` | no |
| endpoint\_private\_access\_source\_security\_group\_ids | A list of allowed source security group to communicate to the Amazon EKS private API server endpoint. | `list(string)` | `[]` | no |
| endpoint\_public\_access | Indicates whether or not the Amazon EKS public API server endpoint is enabled. | `bool` | `false` | no |
| endpoint\_public\_access\_cidrs | A list of allowed CIDR to communicate to the Amazon EKS public API server endpoint. | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| log\_encryption\_kms\_key | The ARN of the KMS Key to use when encrypting log data. Please note, after the AWS KMS CMK is disassociated from the log group, AWS CloudWatch Logs stops encrypting newly ingested data for the log group. All previously ingested data remains encrypted, and AWS CloudWatch Logs requires permissions for the CMK whenever the encrypted data is requested. | `string` | `null` | no |
| log\_retention\_in\_days | Number of days to retain log events. Default retention - 90 days. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653, and 0. If you select 0, the events in the log group are always retained and never expire. | `number` | `90` | no |
| log\_types | A list of the desired control plane logging to enable. | `list(string)` | <pre>[<br>  "api",<br>  "audit",<br>  "authenticator",<br>  "controllerManager",<br>  "scheduler"<br>]</pre> | no |
| service\_cidr | The CIDR block to assign Kubernetes service IP addresses from. Recommend that you specify a block that does not overlap with resources in other networks that are peered or connected to your VPC. You can only specify a custom CIDR block when you create a cluster, changing this value will force a new cluster to be created. | `string` | `"172.20.0.0/16"` | no |
| tags | A map of tags to add to all resources. | `map(string)` | `{}` | no |
| timeouts | How long to wait for the EKS Cluster to be created/updated/deleted. | `map(string)` | <pre>{<br>  "create": "30m",<br>  "delete": "15m",<br>  "update": "60m"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | The ARN of the cluster. |
| certificate\_authority | The base64 encoded certificate data required to communicate with your cluster. Add this to the `certificate-authority-data` section of the `kubeconfig` file for your cluster. |
| endpoint | The endpoint for the Kubernetes API server. |
| iam\_roles | IAM Roles for the EKS cluster. |
| log\_group\_arn | The Amazon Resource Name (ARN) specifying the log group. |
| log\_group\_name | The Name of the log group. |
| log\_types | A list of the enabled control plane logging. |
| name | The name of the cluster. |
| oidc\_provider\_arn | The Amazon Resource Name (ARN) for the OpenID Connect identity provider. |
| oidc\_provider\_url | Issuer URL for the OpenID Connect identity provider. |
| oidc\_provider\_urn | Issuer URN for the OpenID Connect identity provider. |
| platform\_version | The platform version for the cluster. |
| security\_group\_ids | Security groups that were created for the EKS cluster. |
| service\_cidr | The CIDR block which is assigned to Kubernetes service IP addresses. |
| status | The status of the EKS cluster. One of `CREATING`, `ACTIVE`, `DELETING`, `FAILED`. |
| subnet\_ids | Subnets which the ENIs of Kubernetes control plane are located in. |
| version | The Kubernetes server version for the cluster. |
| vpc\_id | The ID of VPC associated with the cluster. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
