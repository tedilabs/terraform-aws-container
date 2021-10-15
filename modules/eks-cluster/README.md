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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.45 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | >= 3.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.63.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 3.1.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_role__control_plane"></a> [role\_\_control\_plane](#module\_role\_\_control\_plane) | tedilabs/account/aws//modules/iam-role | 0.16.1 |
| <a name="module_role__fargate_profile"></a> [role\_\_fargate\_profile](#module\_role\_\_fargate\_profile) | tedilabs/account/aws//modules/iam-role | 0.16.1 |
| <a name="module_role__node"></a> [role\_\_node](#module\_role\_\_node) | tedilabs/account/aws//modules/iam-role | 0.16.1 |
| <a name="module_security_group__control_plane"></a> [security\_group\_\_control\_plane](#module\_security\_group\_\_control\_plane) | tedilabs/network/aws//modules/security-group | 0.24.0 |
| <a name="module_security_group__node"></a> [security\_group\_\_node](#module\_security\_group\_\_node) | tedilabs/network/aws//modules/security-group | 0.24.0 |
| <a name="module_security_group__pod"></a> [security\_group\_\_pod](#module\_security\_group\_\_pod) | tedilabs/network/aws//modules/security-group | 0.24.0 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_eks_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) | resource |
| [aws_iam_openid_connect_provider.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider) | resource |
| [aws_resourcegroups_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/resourcegroups_group) | resource |
| [aws_subnet.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [tls_certificate.this](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Name of the EKS cluster. | `string` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | A list of subnets to creates cross-account elastic network interfaces to allow communication between your worker nodes and the Kubernetes control plane. Must be in at least two different availability zones. | `list(string)` | n/a | yes |
| <a name="input_encryption_enabled"></a> [encryption\_enabled](#input\_encryption\_enabled) | Whether to encrypt kubernetes resources. | `string` | `false` | no |
| <a name="input_encryption_kms_key"></a> [encryption\_kms\_key](#input\_encryption\_kms\_key) | The ARN of the KMS customer master key (CMK) to encrypt resources. The CMK must be symmetric, created in the same region as the cluster, and if the CMK was created in a different account, the user must have access to the CMK. | `string` | `null` | no |
| <a name="input_encryption_resources"></a> [encryption\_resources](#input\_encryption\_resources) | List of strings with resources to be encrypted. Valid values: `secrets`. | `list(string)` | <pre>[<br>  "secrets"<br>]</pre> | no |
| <a name="input_endpoint_private_access"></a> [endpoint\_private\_access](#input\_endpoint\_private\_access) | Indicates whether or not the Amazon EKS private API server endpoint is enabled. | `bool` | `true` | no |
| <a name="input_endpoint_private_access_cidrs"></a> [endpoint\_private\_access\_cidrs](#input\_endpoint\_private\_access\_cidrs) | A list of allowed CIDR to communicate to the Amazon EKS private API server endpoint. | `list(string)` | `[]` | no |
| <a name="input_endpoint_private_access_source_security_group_ids"></a> [endpoint\_private\_access\_source\_security\_group\_ids](#input\_endpoint\_private\_access\_source\_security\_group\_ids) | A list of allowed source security group to communicate to the Amazon EKS private API server endpoint. | `list(string)` | `[]` | no |
| <a name="input_endpoint_public_access"></a> [endpoint\_public\_access](#input\_endpoint\_public\_access) | Indicates whether or not the Amazon EKS public API server endpoint is enabled. | `bool` | `false` | no |
| <a name="input_endpoint_public_access_cidrs"></a> [endpoint\_public\_access\_cidrs](#input\_endpoint\_public\_access\_cidrs) | A list of allowed CIDR to communicate to the Amazon EKS public API server endpoint. | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | Kubernetes version to use for the EKS cluster. | `string` | `"1.19"` | no |
| <a name="input_log_encryption_kms_key"></a> [log\_encryption\_kms\_key](#input\_log\_encryption\_kms\_key) | The ARN of the KMS Key to use when encrypting log data. Please note, after the AWS KMS CMK is disassociated from the log group, AWS CloudWatch Logs stops encrypting newly ingested data for the log group. All previously ingested data remains encrypted, and AWS CloudWatch Logs requires permissions for the CMK whenever the encrypted data is requested. | `string` | `null` | no |
| <a name="input_log_retention_in_days"></a> [log\_retention\_in\_days](#input\_log\_retention\_in\_days) | Number of days to retain log events. Default retention - 90 days. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653, and 0. If you select 0, the events in the log group are always retained and never expire. | `number` | `90` | no |
| <a name="input_log_types"></a> [log\_types](#input\_log\_types) | A list of the desired control plane logging to enable. | `list(string)` | <pre>[<br>  "api",<br>  "audit",<br>  "authenticator",<br>  "controllerManager",<br>  "scheduler"<br>]</pre> | no |
| <a name="input_module_tags_enabled"></a> [module\_tags\_enabled](#input\_module\_tags\_enabled) | Whether to create AWS Resource Tags for the module informations. | `bool` | `true` | no |
| <a name="input_resource_group_description"></a> [resource\_group\_description](#input\_resource\_group\_description) | The description of Resource Group. | `string` | `"Managed by Terraform."` | no |
| <a name="input_resource_group_enabled"></a> [resource\_group\_enabled](#input\_resource\_group\_enabled) | Whether to create Resource Group to find and group AWS resources which are created by this module. | `bool` | `true` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`. | `string` | `""` | no |
| <a name="input_service_cidr"></a> [service\_cidr](#input\_service\_cidr) | The CIDR block to assign Kubernetes service IP addresses from. Recommend that you specify a block that does not overlap with resources in other networks that are peered or connected to your VPC. You can only specify a custom CIDR block when you create a cluster, changing this value will force a new cluster to be created. | `string` | `"172.20.0.0/16"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources. | `map(string)` | `{}` | no |
| <a name="input_timeouts"></a> [timeouts](#input\_timeouts) | How long to wait for the EKS Cluster to be created/updated/deleted. | `map(string)` | <pre>{<br>  "create": "30m",<br>  "delete": "15m",<br>  "update": "60m"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the cluster. |
| <a name="output_ca_cert"></a> [ca\_cert](#output\_ca\_cert) | The base64 encoded certificate data required to communicate with your cluster. Add this to the `certificate-authority-data` section of the `kubeconfig` file for your cluster. |
| <a name="output_endpoint"></a> [endpoint](#output\_endpoint) | The endpoint for the Kubernetes API server. |
| <a name="output_iam_roles"></a> [iam\_roles](#output\_iam\_roles) | IAM Roles for the EKS cluster. |
| <a name="output_log_group_arn"></a> [log\_group\_arn](#output\_log\_group\_arn) | The Amazon Resource Name (ARN) specifying the log group. |
| <a name="output_log_group_name"></a> [log\_group\_name](#output\_log\_group\_name) | The Name of the log group. |
| <a name="output_log_types"></a> [log\_types](#output\_log\_types) | A list of the enabled control plane logging. |
| <a name="output_name"></a> [name](#output\_name) | The name of the cluster. |
| <a name="output_oidc_provider_arn"></a> [oidc\_provider\_arn](#output\_oidc\_provider\_arn) | The Amazon Resource Name (ARN) for the OpenID Connect identity provider. |
| <a name="output_oidc_provider_url"></a> [oidc\_provider\_url](#output\_oidc\_provider\_url) | Issuer URL for the OpenID Connect identity provider. |
| <a name="output_oidc_provider_urn"></a> [oidc\_provider\_urn](#output\_oidc\_provider\_urn) | Issuer URN for the OpenID Connect identity provider. |
| <a name="output_platform_version"></a> [platform\_version](#output\_platform\_version) | The platform version for the cluster. |
| <a name="output_security_group_ids"></a> [security\_group\_ids](#output\_security\_group\_ids) | Security groups that were created for the EKS cluster. |
| <a name="output_service_cidr"></a> [service\_cidr](#output\_service\_cidr) | The CIDR block which is assigned to Kubernetes service IP addresses. |
| <a name="output_status"></a> [status](#output\_status) | The status of the EKS cluster. One of `CREATING`, `ACTIVE`, `DELETING`, `FAILED`. |
| <a name="output_subnet_ids"></a> [subnet\_ids](#output\_subnet\_ids) | Subnets which the ENIs of Kubernetes control plane are located in. |
| <a name="output_version"></a> [version](#output\_version) | The Kubernetes server version for the cluster. |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of VPC associated with the cluster. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
