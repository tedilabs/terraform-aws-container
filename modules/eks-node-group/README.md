# eks-node-group

This module creates following resources.

- `aws_launch_configuration`
- `aws_autoscaling_group`

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |
| aws | >= 3.34 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 3.34 |
| template | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster\_name | Name of the EKS cluster. | `string` | n/a | yes |
| instance\_ami | The AMI to run on each instance in the EKS cluster node group. | `string` | n/a | yes |
| instance\_profile | The name attribute of the IAM instance profile to associate with launched instances. | `string` | n/a | yes |
| instance\_ssh\_key | The name of the SSH Key that should be used to access the each nodes. | `string` | n/a | yes |
| instance\_type | The type of instances to run in the EKS cluster node group. | `string` | n/a | yes |
| max\_size | The maximum number of instances to run in the EKS cluster node group. | `number` | n/a | yes |
| min\_size | The minimum number of instances to run in the EKS cluster node group. | `number` | n/a | yes |
| name | Name of node group to create. | `string` | n/a | yes |
| security\_group\_ids | All workers will be attached to those security groups. | `list(string)` | n/a | yes |
| subnet\_ids | A list of subnets to place the EKS cluster node group within. | `list(string)` | n/a | yes |
| associate\_public\_ip\_address | Associate a public ip address with an instance in a VPC. | `bool` | `false` | no |
| bootstrap\_extra\_args | Extra arguments to add to the `/etc/eks/bootstrap.sh`. | `list(string)` | `[]` | no |
| cni\_custom\_networking\_enabled | Whether to use EKS CNI Custom Networking. | `bool` | `false` | no |
| desired\_size | The number of instances that should be running in the group. | `number` | `null` | no |
| enabled\_metrics | A list of metrics to collect. The allowed values are GroupDesiredCapacity, GroupInServiceCapacity, GroupPendingCapacity, GroupMinSize, GroupMaxSize, GroupInServiceInstances, GroupPendingInstances, GroupStandbyInstances, GroupStandbyCapacity, GroupTerminatingCapacity, GroupTerminatingInstances, GroupTotalCapacity, GroupTotalInstances. | `list(string)` | <pre>[<br>  "GroupMinSize",<br>  "GroupMaxSize",<br>  "GroupDesiredCapacity",<br>  "GroupInServiceCapacity",<br>  "GroupInServiceInstances",<br>  "GroupPendingCapacity",<br>  "GroupPendingInstances",<br>  "GroupStandbyCapacity",<br>  "GroupStandbyInstances",<br>  "GroupTerminatingCapacity",<br>  "GroupTerminatingInstances",<br>  "GroupTotalCapacity",<br>  "GroupTotalInstances"<br>]</pre> | no |
| force\_delete | Allows deleting the autoscaling group without waiting for all instances in the pool to terminate. | `bool` | `false` | no |
| kubelet\_extra\_args | Extra arguments to add to the kubelet. Useful for adding labels or taints. | `list(string)` | `[]` | no |
| module\_tags\_enabled | Whether to create AWS Resource Tags for the module informations. | `bool` | `true` | no |
| node\_labels | A map of labels to add to the EKS cluster node group. | `map(string)` | `{}` | no |
| node\_taints | A list of taints to add to the EKS cluster node group. | `list(string)` | `[]` | no |
| resource\_group\_description | The description of Resource Group. | `string` | `"Managed by Terraform."` | no |
| resource\_group\_enabled | Whether to create Resource Group to find and group AWS resources which are created by this module. | `bool` | `true` | no |
| resource\_group\_name | The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`. | `string` | `""` | no |
| tags | A map of tags to add to all resources. | `map(string)` | `{}` | no |
| target\_group\_arns | A set of `aws_alb_target_group` ARNs, for use with Application or Network Load Balancing. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| asg\_arn | n/a |
| asg\_id | ################################################## EKS ################################################## |
| asg\_name | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
