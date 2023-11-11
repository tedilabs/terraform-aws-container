# eks-cluster

This module creates following resources.

- `aws_eks_cluster`
- `aws_eks_identity_provider_config` (optional)
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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.47 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.25.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_oidc_provider"></a> [oidc\_provider](#module\_oidc\_provider) | tedilabs/account/aws//modules/iam-oidc-identity-provider | ~> 0.27.0 |
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | tedilabs/misc/aws//modules/resource-group | ~> 0.10.0 |
| <a name="module_role"></a> [role](#module\_role) | tedilabs/account/aws//modules/iam-role | ~> 0.28.0 |
| <a name="module_role__node"></a> [role\_\_node](#module\_role\_\_node) | tedilabs/account/aws//modules/iam-role | ~> 0.28.0 |
| <a name="module_security_group__control_plane"></a> [security\_group\_\_control\_plane](#module\_security\_group\_\_control\_plane) | tedilabs/network/aws//modules/security-group | ~> 0.31.0 |
| <a name="module_security_group__node"></a> [security\_group\_\_node](#module\_security\_group\_\_node) | tedilabs/network/aws//modules/security-group | ~> 0.31.0 |
| <a name="module_security_group__pod"></a> [security\_group\_\_pod](#module\_security\_group\_\_pod) | tedilabs/network/aws//modules/security-group | ~> 0.31.0 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_eks_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) | resource |
| [aws_eks_identity_provider_config.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_identity_provider_config) | resource |
| [aws_security_group_rule.node](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.pod](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_subnet.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | (Required) Name of the EKS cluster. Must be between 1-100 characters in length. Must begin with an alphanumeric character, and must only contain alphanumeric characters, dashes and underscores. | `string` | n/a | yes |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | (Required) A list of subnet IDs. Must be in at least two different availability zones. Amazon EKS creates cross-account elastic network interfaces in these subnets to allow communication between your worker nodes and the Kubernetes control plane. | `list(string)` | n/a | yes |
| <a name="input_additional_security_groups"></a> [additional\_security\_groups](#input\_additional\_security\_groups) | (Optional) A list of additional security group IDs to associate with the Kubernetes API server endpoint. The cluster security group always attached to the endpoint. You can specify additional security groups to use for the endpoint using this argument. Defaults to `[]`. | `list(string)` | `[]` | no |
| <a name="input_cluster_role"></a> [cluster\_role](#input\_cluster\_role) | (Optional) The ARN (Amazon Resource Name) of the IAM Role for the EKS cluster role. Only required if `default_cluster_role.enabled` is `false`. | `string` | `null` | no |
| <a name="input_default_cluster_role"></a> [default\_cluster\_role](#input\_default\_cluster\_role) | (Optional) A configuration for the default IAM role for EKS cluster. Use `cluster_role` if `default_cluster_role.enabled` is `false`. `default_cluster_role` as defined below.<br>    (Optional) `enabled` - Whether to create the default cluster role. Defaults to `true`.<br>    (Optional) `name` - The name of the default cluster role. Defaults to `eks-${var.name}-cluster`.<br>    (Optional) `path` - The path of the default cluster role. Defaults to `/`.<br>    (Optional) `description` - The description of the default cluster role.<br>    (Optional) `policies` - A list of IAM policy ARNs to attach to the default cluster role. `AmazonEKSClusterPolicy` is always attached. Defaults to `[]`.<br>    (Optional) `inline_policies` - A Map of inline IAM policies to attach to the default cluster role. (`name` => `policy`). | <pre>object({<br>    enabled     = optional(bool, true)<br>    name        = optional(string)<br>    path        = optional(string, "/")<br>    description = optional(string, "Managed by Terraform.")<br><br>    policies        = optional(list(string), [])<br>    inline_policies = optional(map(string), {})<br>  })</pre> | `{}` | no |
| <a name="input_default_node_role"></a> [default\_node\_role](#input\_default\_node\_role) | (Optional) A configuration for the default IAM role for EKS nodes. `default_node_role` as defined below.<br>    (Optional) `enabled` - Whether to create the default node role. Defaults to `false`.<br>    (Optional) `name` - The name of the default node role. Defaults to `eks-${var.name}-node`.<br>    (Optional) `path` - The path of the default node role. Defaults to `/`.<br>    (Optional) `description` - The description of the default node role.<br>    (Optional) `policies` - A list of IAM policy ARNs to attach to the default node role. `AmazonEKSWorkerNodePolicy`, `AmazonEKS_CNI_Policy`, `AmazonEC2ContainerRegistryReadOnly` are always attached. Defaults to `[]`.<br>    (Optional) `inline_policies` - A Map of inline IAM policies to attach to the default node role. (`name` => `policy`). | <pre>object({<br>    enabled     = optional(bool, false)<br>    name        = optional(string)<br>    path        = optional(string, "/")<br>    description = optional(string, "Managed by Terraform.")<br><br>    policies        = optional(list(string), [])<br>    inline_policies = optional(map(string), {})<br>  })</pre> | `{}` | no |
| <a name="input_endpoint_access"></a> [endpoint\_access](#input\_endpoint\_access) | (Optional) A configuration for the endpoint access to the Kubernetes API server endpoint. `endpoint_access` as defined below.<br>    (Optional) `private_access_enabled` - Whether to enable private access for your cluster's Kubernetes API server endpoint. If you enable private access, Kubernetes API requests from within your cluster's VPC use the private VPC endpoint. Defaults to `true`. If you disable private access and you have nodes or Fargate pods in the cluster, then ensure that `public_access_cidrs` includes the necessary CIDR blocks for communication with the nodes or Fargate pods.<br>    (Optional) `private_access_cidrs` - A list of allowed CIDR to communicate to the Amazon EKS private API server endpoint.<br>    (Optional) `private_access_security_groups` - A list of allowed source security group to communicate to the Amazon EKS private API server endpoint.<br>    (Optional) `public_access_enabled` - Whether to enable public access to your cluster's Kubernetes API server endpoint. If you disable public access, your cluster's Kubernetes API server can only receive requests from within the cluster VPC. Defaults to `false`.<br>    (Optional) `public_access_cidrs` - A list of CIDR blocks that are allowed access to your cluster's public Kubernetes API server endpoint. Defaults to `0.0.0.0/0` . | <pre>object({<br>    private_access_enabled         = optional(bool, true)<br>    private_access_cidrs           = optional(list(string), [])<br>    private_access_security_groups = optional(list(string), [])<br><br>    public_access_enabled = optional(bool, false)<br>    public_access_cidrs   = optional(list(string), ["0.0.0.0/0"])<br>  })</pre> | `{}` | no |
| <a name="input_kubernetes_network_config"></a> [kubernetes\_network\_config](#input\_kubernetes\_network\_config) | (Optional) A configuration of Kubernetes network. `kubernetes_network_config` as defined below.<br>    (Optional) `service_ipv4_cidr` - The CIDR block to assign Kubernetes pod and service IP addresses from. If you don't specify a block, Kubernetes assigns addresses from either the `10.100.0.0/16` or `172.20.0.0/16` CIDR blocks. We recommend that you specify a block that does not overlap with resources in other networks that are peered or connected to your VPC. You can only specify a custom CIDR block when you create a cluster, changing this value will force a new cluster to be created.<br>    (Optional) `ip_family` - The IP family used to assign Kubernetes pod and service addresses. Valid values are `IPV4` and `IPV6`. Defaults to `IPV4`. You can only specify an IP family when you create a cluster, changing this value will force a new cluster to be created. | <pre>object({<br>    service_ipv4_cidr = optional(string)<br>    ip_family         = optional(string, "IPV4")<br>  })</pre> | `{}` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | (Optional) Desired Kubernetes version to use for the EKS cluster. Defaults to `1.26`. | `string` | `"1.26"` | no |
| <a name="input_log_encryption_kms_key"></a> [log\_encryption\_kms\_key](#input\_log\_encryption\_kms\_key) | (Optional) The ARN of the KMS Key to use when encrypting log data. Please note, after the AWS KMS CMK is disassociated from the log group, AWS CloudWatch Logs stops encrypting newly ingested data for the log group. All previously ingested data remains encrypted, and AWS CloudWatch Logs requires permissions for the CMK whenever the encrypted data is requested. | `string` | `null` | no |
| <a name="input_log_retention_in_days"></a> [log\_retention\_in\_days](#input\_log\_retention\_in\_days) | (Optional) Number of days to retain log events. Default retention - 90 days. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653, and 0. If you select 0, the events in the log group are always retained and never expire. | `number` | `90` | no |
| <a name="input_log_types"></a> [log\_types](#input\_log\_types) | (Optional) A set of the desired control plane logging to enable. | `set(string)` | <pre>[<br>  "api",<br>  "audit",<br>  "authenticator",<br>  "controllerManager",<br>  "scheduler"<br>]</pre> | no |
| <a name="input_module_tags_enabled"></a> [module\_tags\_enabled](#input\_module\_tags\_enabled) | (Optional) Whether to create AWS Resource Tags for the module informations. | `bool` | `true` | no |
| <a name="input_oidc_identity_providers"></a> [oidc\_identity\_providers](#input\_oidc\_identity\_providers) | (Optional) A list of OIDC Identity Providers to associate as an additional method for user authentication to your Kubernetes cluster. Each item of `oidc_identity_providers` block as defined below.<br>    (Required) `name` - A unique name for the Identity Provider Configuration.<br>    (Required) `issuer_url` - The OIDC Identity Provider issuer URL.<br>    (Required) `client_id` - The OIDC Identity Provider client ID.<br>    (Optional) `required_claims` - The key value pairs that describe required claims in the identity token.<br>    (Optional) `username_claim` - The JWT claim that the provider will use as the username.<br>    (Optional) `username_prefix` - A prefix that is prepended to username claims.<br>    (Optional) `groups_claim` - The JWT claim that the provider will use to return groups.<br>    (Optional) `groups_prefix` - A prefix that is prepended to group claims e.g., `oidc:`. | <pre>list(object({<br>    name       = string<br>    issuer_url = string<br>    client_id  = string<br><br>    required_claims = optional(map(string), {})<br>    username_claim  = optional(string)<br>    username_prefix = optional(string)<br>    groups_claim    = optional(string)<br>    groups_prefix   = optional(string)<br>  }))</pre> | `[]` | no |
| <a name="input_outpost_config"></a> [outpost\_config](#input\_outpost\_config) | (Optional) A configuration of the outpost for the EKS cluster. `outpost_config` as defined below.<br>    (Required) `outposts` - A list of the Outpost ARNs that you want to use for your local Amazon EKS cluster on Outposts. This argument is a list of arns, but only a single Outpost ARN is supported currently.<br>    (Required) `control_plane_instance_type` - The Amazon EC2 instance type that you want to use for your local Amazon EKS cluster on Outposts. The instance type that you specify is used for all Kubernetes control plane instances. The instance type can't be changed after cluster creation. Choose an instance type based on the number of nodes that your cluster will have.<br>      - 1–20 nodes, then we recommend specifying a large instance type.<br>      - 21–100 nodes, then we recommend specifying an xlarge instance type.<br>      - 101–250 nodes, then we recommend specifying a 2xlarge instance type.<br>    (Optional) `control_plane_placement_group` - The name of the placement group for the Kubernetes control plane instances. This setting can't be changed after cluster creation. | <pre>object({<br>    outposts                      = list(string)<br>    control_plane_instance_type   = string<br>    control_plane_placement_group = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_resource_group_description"></a> [resource\_group\_description](#input\_resource\_group\_description) | (Optional) The description of Resource Group. | `string` | `"Managed by Terraform."` | no |
| <a name="input_resource_group_enabled"></a> [resource\_group\_enabled](#input\_resource\_group\_enabled) | (Optional) Whether to create Resource Group to find and group AWS resources which are created by this module. | `bool` | `true` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Optional) The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`. | `string` | `""` | no |
| <a name="input_secrets_encryption"></a> [secrets\_encryption](#input\_secrets\_encryption) | (Optional) A configuration to encrypt Kubernetes secrets. Envelope encryption provides an additional layer of encryption for your Kubernetes secrets. Once turned on, secrets encryption cannot be modified or removed. `secrets_encryption` as defined below.<br>    (Optional) `enabled` - Whether to enable envelope encryption of Kubernetes secrets. Defaults to `false`.<br>    (Optional) `kms_key` - The ID of AWS KMS key to use for envelope encryption of Kubernetes secrets. | <pre>object({<br>    enabled = optional(bool, false)<br>    kms_key = optional(string)<br>  })</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A map of tags to add to all resources. | `map(string)` | `{}` | no |
| <a name="input_timeouts"></a> [timeouts](#input\_timeouts) | (Optional) How long to wait for the EKS Cluster to be created/updated/deleted. | <pre>object({<br>    create = optional(string, "30m")<br>    update = optional(string, "60m")<br>    delete = optional(string, "15m")<br>  })</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_additional_security_groups"></a> [additional\_security\_groups](#output\_additional\_security\_groups) | The list of additional security groups for the EKS control plane. |
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the cluster. |
| <a name="output_ca_cert"></a> [ca\_cert](#output\_ca\_cert) | The base64 encoded certificate data required to communicate with your cluster. Add this to the `certificate-authority-data` section of the `kubeconfig` file for your cluster. |
| <a name="output_cluster_role"></a> [cluster\_role](#output\_cluster\_role) | The IAM Role for the EKS cluster. |
| <a name="output_cluster_security_group"></a> [cluster\_security\_group](#output\_cluster\_security\_group) | The security group that was created by EKS for the cluster. Managed node groups use this security group for control-plane-to-data-plane communication. |
| <a name="output_created_at"></a> [created\_at](#output\_created\_at) | The Unix epoch timestamp in seconds for when the cluster was created. |
| <a name="output_default_cluster_role"></a> [default\_cluster\_role](#output\_default\_cluster\_role) | The default IAM Role for the EKS cluster. |
| <a name="output_default_node_role"></a> [default\_node\_role](#output\_default\_node\_role) | The default IAM Role for the EKS node. |
| <a name="output_endpoint"></a> [endpoint](#output\_endpoint) | The endpoint for the Kubernetes API server. |
| <a name="output_endpoint_access"></a> [endpoint\_access](#output\_endpoint\_access) | The configuration for the endpoint access to the Kubernetes API server endpoint. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the cluster. |
| <a name="output_irsa_oidc_provider"></a> [irsa\_oidc\_provider](#output\_irsa\_oidc\_provider) | The configurations of the OIDC provider for IRSA (IAM Roles for Service Accounts).<br>    `arn` - The ARN assigned by AWS for this provider.<br>    `url` - The URL of the identity provider.<br>    `urn` - The URN of the identity provider.<br>    `audiences` - A list of audiences (also known as client IDs) for the IAM OIDC provider. |
| <a name="output_kubernetes_network_config"></a> [kubernetes\_network\_config](#output\_kubernetes\_network\_config) | The configurations of Kubernetes network.<br>    `service_ipv4_cidr` - The IPv4 CIDR block which is assigned to Kubernetes service IP addresses.<br>    `service_ipv6_cidr` - The IPv6 CIDR block that Kubernetes pod and service IP addresses are assigned from if you specified `IPV6` for `ip_family` when you created the cluster. Kubernetes assigns service addresses from the unique local address range (fc00::/7) because you can't specify a custom IPv6 CIDR block when you create the cluster.<br>    `ip_family` - The IP family used to assign Kubernetes pod and service addresses. |
| <a name="output_logging"></a> [logging](#output\_logging) | The configurations of the control plane logging. |
| <a name="output_name"></a> [name](#output\_name) | The name of the cluster. |
| <a name="output_oidc_identity_providers"></a> [oidc\_identity\_providers](#output\_oidc\_identity\_providers) | A map of all associated OIDC Identity Providers to the cluster. |
| <a name="output_outpost_config"></a> [outpost\_config](#output\_outpost\_config) | The configurations of the outpost for the EKS cluster.<br>    `outposts` - The list of the Outposts ARNs.<br>    `control_plane_instance_type` - The EC2 instance type of the local EKS control plane node on Outposts.<br>    `control_plane_placement_group` - The name of the placement group for the EKS control plane node on Outposts. |
| <a name="output_platform_version"></a> [platform\_version](#output\_platform\_version) | The platform version for the cluster. |
| <a name="output_secrets_encryption"></a> [secrets\_encryption](#output\_secrets\_encryption) | The configurations of the encryption of Kubernetes secrets. |
| <a name="output_security_group_ids"></a> [security\_group\_ids](#output\_security\_group\_ids) | Security groups that were created for the EKS cluster. |
| <a name="output_status"></a> [status](#output\_status) | The status of the EKS cluster. One of `CREATING`, `ACTIVE`, `DELETING`, `FAILED`. |
| <a name="output_subnets"></a> [subnets](#output\_subnets) | The IDs of subnets which the ENIs of Kubernetes control plane are located in. |
| <a name="output_version"></a> [version](#output\_version) | The Kubernetes server version for the cluster. |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of VPC associated with the cluster. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
