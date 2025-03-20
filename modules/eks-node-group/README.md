# eks-node-group

This module creates following resources.

- `aws_launch_configuration`
- `aws_autoscaling_group`

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.10 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.47 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.91.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eks_max_pods"></a> [eks\_max\_pods](#module\_eks\_max\_pods) | ../eks-max-pods | n/a |
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | tedilabs/misc/aws//modules/resource-group | ~> 0.10.0 |
| <a name="module_security_group"></a> [security\_group](#module\_security\_group) | tedilabs/network/aws//modules/security-group | ~> 0.31.0 |

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_launch_template.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_default_tags.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/default_tags) | data source |
| [aws_subnet.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | (Required) Name of the EKS cluster. | `string` | n/a | yes |
| <a name="input_instance_ami"></a> [instance\_ami](#input\_instance\_ami) | (Required) The AMI to run on each instance in the EKS cluster node group. | `string` | n/a | yes |
| <a name="input_instance_profile"></a> [instance\_profile](#input\_instance\_profile) | (Required) The name attribute of the IAM instance profile to associate with launched instances. | `string` | n/a | yes |
| <a name="input_instance_ssh_key"></a> [instance\_ssh\_key](#input\_instance\_ssh\_key) | (Required) The name of the SSH Key that should be used to access the each nodes. | `string` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | (Required) The type of instances to run in the EKS cluster node group. | `string` | n/a | yes |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | (Required) The maximum number of instances to run in the EKS cluster node group. | `number` | n/a | yes |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | (Required) The minimum number of instances to run in the EKS cluster node group. | `number` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | (Required) Name of node group to create. | `string` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | (Required) A list of subnets to place the EKS cluster node group within. | `list(string)` | n/a | yes |
| <a name="input_associate_public_ip_address"></a> [associate\_public\_ip\_address](#input\_associate\_public\_ip\_address) | (Optional) Associate a public ip address with an instance in a VPC. | `bool` | `false` | no |
| <a name="input_bootstrap_extra_args"></a> [bootstrap\_extra\_args](#input\_bootstrap\_extra\_args) | (Optional) Extra arguments to add to the `/etc/eks/bootstrap.sh`. | `list(string)` | `[]` | no |
| <a name="input_cni_custom_networking_enabled"></a> [cni\_custom\_networking\_enabled](#input\_cni\_custom\_networking\_enabled) | (Optional) Whether to use EKS CNI Custom Networking. | `bool` | `false` | no |
| <a name="input_cni_eni_prefix_mode_enabled"></a> [cni\_eni\_prefix\_mode\_enabled](#input\_cni\_eni\_prefix\_mode\_enabled) | (Optional) Whether to use ENI Prefix Mode of EKS CNI. | `bool` | `false` | no |
| <a name="input_default_security_group"></a> [default\_security\_group](#input\_default\_security\_group) | (Optional) The configuration of the default security group for the EKS node group. `default_security_group` block as defined below.<br/>    (Optional) `enabled` - Whether to use the default security group. Defaults to `true`.<br/>    (Optional) `name` - The name of the default security group. If not provided, the node group name is used for the name of security group.<br/>    (Optional) `description` - The description of the default security group.<br/>    (Optional) `ingress_rules` - A list of ingress rules in a security group. Defaults to `[]`. Each block of `ingress_rules` as defined below.<br/>      (Optional) `id` - The ID of the ingress rule. This value is only used internally within Terraform code.<br/>      (Optional) `description` - The description of the rule.<br/>      (Required) `protocol` - The protocol to match. Note that if `protocol` is set to `-1`, it translates to all protocols, all port ranges, and `from_port` and `to_port` values should not be defined.<br/>      (Required) `from_port` - The start of port range for the protocols.<br/>      (Required) `to_port` - The end of port range for the protocols.<br/>      (Optional) `ipv4_cidrs` - The IPv4 network ranges to allow, in CIDR notation.<br/>      (Optional) `ipv6_cidrs` - The IPv6 network ranges to allow, in CIDR notation.<br/>      (Optional) `prefix_lists` - The prefix list IDs to allow.<br/>      (Optional) `security_groups` - The source security group IDs to allow.<br/>      (Optional) `self` - Whether the security group itself will be added as a source to this ingress rule.<br/>    (Optional) `egress_rules` - A list of egress rules in a security group. Defaults to `[{ id = "default", protocol = -1, from_port = 1, to_port=65535, ipv4_cidrs = ["0.0.0.0/0"] }]`. Each block of `egress_rules` as defined below.<br/>      (Optional) `id` - The ID of the egress rule. This value is only used internally within Terraform code.<br/>      (Optional) `description` - The description of the rule.<br/>      (Required) `protocol` - The protocol to match. Note that if `protocol` is set to `-1`, it translates to all protocols, all port ranges, and `from_port` and `to_port` values should not be defined.<br/>      (Required) `from_port` - The start of port range for the protocols.<br/>      (Required) `to_port` - The end of port range for the protocols.<br/>      (Optional) `ipv4_cidrs` - The IPv4 network ranges to allow, in CIDR notation.<br/>      (Optional) `ipv6_cidrs` - The IPv6 network ranges to allow, in CIDR notation.<br/>      (Optional) `prefix_lists` - The prefix list IDs to allow.<br/>      (Optional) `security_groups` - The source security group IDs to allow.<br/>      (Optional) `self` - Whether the security group itself will be added as a source to this ingress rule. | <pre>object({<br/>    enabled     = optional(bool, true)<br/>    name        = optional(string)<br/>    description = optional(string, "Managed by Terraform.")<br/>    ingress_rules = optional(<br/>      list(object({<br/>        id              = optional(string)<br/>        description     = optional(string, "Managed by Terraform.")<br/>        protocol        = string<br/>        from_port       = number<br/>        to_port         = number<br/>        ipv4_cidrs      = optional(list(string), [])<br/>        ipv6_cidrs      = optional(list(string), [])<br/>        prefix_lists    = optional(list(string), [])<br/>        security_groups = optional(list(string), [])<br/>        self            = optional(bool, false)<br/>      })),<br/>      []<br/>    )<br/>    egress_rules = optional(<br/>      list(object({<br/>        id              = string<br/>        description     = optional(string, "Managed by Terraform.")<br/>        protocol        = string<br/>        from_port       = number<br/>        to_port         = number<br/>        ipv4_cidrs      = optional(list(string), [])<br/>        ipv6_cidrs      = optional(list(string), [])<br/>        prefix_lists    = optional(list(string), [])<br/>        security_groups = optional(list(string), [])<br/>        self            = optional(bool, false)<br/>      })),<br/>      [{<br/>        id          = "default"<br/>        description = "Allow all outbound traffic."<br/>        protocol    = "-1"<br/>        from_port   = 1<br/>        to_port     = 65535<br/>        ipv4_cidrs  = ["0.0.0.0/0"]<br/>      }]<br/>    )<br/>  })</pre> | `{}` | no |
| <a name="input_desired_size"></a> [desired\_size](#input\_desired\_size) | (Optional) The number of instances that should be running in the group. | `number` | `null` | no |
| <a name="input_ebs_optimized"></a> [ebs\_optimized](#input\_ebs\_optimized) | (Optional) If true, the launched EC2 instance will be EBS-optimized. | `bool` | `false` | no |
| <a name="input_enabled_metrics"></a> [enabled\_metrics](#input\_enabled\_metrics) | (Optional) A list of metrics to collect. The allowed values are GroupDesiredCapacity, GroupInServiceCapacity, GroupPendingCapacity, GroupMinSize, GroupMaxSize, GroupInServiceInstances, GroupPendingInstances, GroupStandbyInstances, GroupStandbyCapacity, GroupTerminatingCapacity, GroupTerminatingInstances, GroupTotalCapacity, GroupTotalInstances. | `list(string)` | <pre>[<br/>  "GroupMinSize",<br/>  "GroupMaxSize",<br/>  "GroupDesiredCapacity",<br/>  "GroupInServiceCapacity",<br/>  "GroupInServiceInstances",<br/>  "GroupPendingCapacity",<br/>  "GroupPendingInstances",<br/>  "GroupStandbyCapacity",<br/>  "GroupStandbyInstances",<br/>  "GroupTerminatingCapacity",<br/>  "GroupTerminatingInstances",<br/>  "GroupTotalCapacity",<br/>  "GroupTotalInstances"<br/>]</pre> | no |
| <a name="input_force_delete"></a> [force\_delete](#input\_force\_delete) | (Optional) Allows deleting the autoscaling group without waiting for all instances in the pool to terminate. | `bool` | `false` | no |
| <a name="input_kubelet_extra_args"></a> [kubelet\_extra\_args](#input\_kubelet\_extra\_args) | (Optional) Extra arguments to add to the kubelet. Useful for adding labels or taints. | `list(string)` | `[]` | no |
| <a name="input_module_tags_enabled"></a> [module\_tags\_enabled](#input\_module\_tags\_enabled) | (Optional) Whether to create AWS Resource Tags for the module informations. | `bool` | `true` | no |
| <a name="input_monitoring_enabled"></a> [monitoring\_enabled](#input\_monitoring\_enabled) | (Optional) If true, the launched EC2 instance will have detailed monitoring enabled. | `bool` | `false` | no |
| <a name="input_node_labels"></a> [node\_labels](#input\_node\_labels) | (Optional) A map of labels to add to the EKS cluster node group. | `map(string)` | `{}` | no |
| <a name="input_node_taints"></a> [node\_taints](#input\_node\_taints) | (Optional) A list of taints to add to the EKS cluster node group. | `list(string)` | `[]` | no |
| <a name="input_resource_group_description"></a> [resource\_group\_description](#input\_resource\_group\_description) | (Optional) The description of Resource Group. | `string` | `"Managed by Terraform."` | no |
| <a name="input_resource_group_enabled"></a> [resource\_group\_enabled](#input\_resource\_group\_enabled) | (Optional) Whether to create Resource Group to find and group AWS resources which are created by this module. | `bool` | `true` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Optional) The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`. | `string` | `""` | no |
| <a name="input_root_volume_encryption_enabled"></a> [root\_volume\_encryption\_enabled](#input\_root\_volume\_encryption\_enabled) | (Optional) Enables EBS encryption on the root volume. | `bool` | `false` | no |
| <a name="input_root_volume_encryption_kms_key_id"></a> [root\_volume\_encryption\_kms\_key\_id](#input\_root\_volume\_encryption\_kms\_key\_id) | (Optional) The ARN of the AWS Key Management Service (AWS KMS) customer master key (CMK) to use when creating the encrypted volume. `root_volume_encryption_enabled` must be set to true when this is set. | `string` | `null` | no |
| <a name="input_root_volume_iops"></a> [root\_volume\_iops](#input\_root\_volume\_iops) | (Optional) The amount of provisioned IOPS for the root volume. | `number` | `null` | no |
| <a name="input_root_volume_size"></a> [root\_volume\_size](#input\_root\_volume\_size) | (Optional) The size of the root volume in gigabytes. | `number` | `20` | no |
| <a name="input_root_volume_throughput"></a> [root\_volume\_throughput](#input\_root\_volume\_throughput) | (Optional) The throughput to provision for a gp3 volume in MiB/s (specified as an integer, e.g. 500), with a maximum of 1,000 MiB/s. | `number` | `null` | no |
| <a name="input_root_volume_type"></a> [root\_volume\_type](#input\_root\_volume\_type) | (Optional) The volume type for root volume. Can be standard, `gp2`, `gp3`, `io1`, `io2`, `sc1` or `st1`. | `string` | `"gp2"` | no |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | (Optional) A list of security group IDs to assign to the node group. | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A map of tags to add to all resources. | `map(string)` | `{}` | no |
| <a name="input_target_group_arns"></a> [target\_group\_arns](#input\_target\_group\_arns) | (Optional) A set of `aws_alb_target_group` ARNs, for use with Application or Network Load Balancing. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_asg_arn"></a> [asg\_arn](#output\_asg\_arn) | The ARN of ASG(Auto-Scaling Group). |
| <a name="output_asg_id"></a> [asg\_id](#output\_asg\_id) | The ID of ASG(Auto-Scaling Group). |
| <a name="output_asg_name"></a> [asg\_name](#output\_asg\_name) | The name of ASG(Auto-Scaling Group). |
| <a name="output_default_security_group"></a> [default\_security\_group](#output\_default\_security\_group) | The default security group ID of the EKS node group. |
| <a name="output_desired_size"></a> [desired\_size](#output\_desired\_size) | The number of instances in the EKS cluster node group. |
| <a name="output_instance_ami"></a> [instance\_ami](#output\_instance\_ami) | The AMI of the EKS cluster node group. |
| <a name="output_instance_profile"></a> [instance\_profile](#output\_instance\_profile) | The name of the IAM instance profile which is attached to instances of the EKS cluster node group. |
| <a name="output_instance_ssh_key"></a> [instance\_ssh\_key](#output\_instance\_ssh\_key) | The name of the SSH Key of the EKS cluster node group. |
| <a name="output_instance_type"></a> [instance\_type](#output\_instance\_type) | The instance type of the EKS cluster node group. |
| <a name="output_max_size"></a> [max\_size](#output\_max\_size) | The maximum number of instances in the EKS cluster node group. |
| <a name="output_min_size"></a> [min\_size](#output\_min\_size) | The minimum number of instances in the EKS cluster node group. |
| <a name="output_name"></a> [name](#output\_name) | The name of the node group. |
| <a name="output_security_groups"></a> [security\_groups](#output\_security\_groups) | A set of security group IDs which is assigned to the load balancer. |
<!-- END_TF_DOCS -->
