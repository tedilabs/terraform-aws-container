variable "name" {
  description = "Name of node group to create."
  type        = string
}

variable "cluster_name" {
  description = "Name of the EKS cluster."
  type        = string
}


###################################################
# Auto Scaling Group
###################################################

variable "min_size" {
  description = "The minimum number of instances to run in the EKS cluster node group."
  type        = number
}

variable "max_size" {
  description = "The maximum number of instances to run in the EKS cluster node group."
  type        = number
}

variable "desired_size" {
  description = "The number of instances that should be running in the group."
  type        = number
  default     = null
}

variable "subnet_ids" {
  description = "A list of subnets to place the EKS cluster node group within."
  type        = list(string)
}

variable "target_group_arns" {
  description = "A set of `aws_alb_target_group` ARNs, for use with Application or Network Load Balancing."
  type        = list(string)
  default     = []
}

variable "force_delete" {
  description = "Allows deleting the autoscaling group without waiting for all instances in the pool to terminate."
  type        = bool
  default     = false
}

variable "enabled_metrics" {
  description = "A list of metrics to collect. The allowed values are GroupDesiredCapacity, GroupInServiceCapacity, GroupPendingCapacity, GroupMinSize, GroupMaxSize, GroupInServiceInstances, GroupPendingInstances, GroupStandbyInstances, GroupStandbyCapacity, GroupTerminatingCapacity, GroupTerminatingInstances, GroupTotalCapacity, GroupTotalInstances."
  type        = list(string)
  default = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceCapacity",
    "GroupInServiceInstances",
    "GroupPendingCapacity",
    "GroupPendingInstances",
    "GroupStandbyCapacity",
    "GroupStandbyInstances",
    "GroupTerminatingCapacity",
    "GroupTerminatingInstances",
    "GroupTotalCapacity",
    "GroupTotalInstances",
  ]
}


###################################################
# Launch Template
###################################################

variable "instance_ami" {
  description = "The AMI to run on each instance in the EKS cluster node group."
  type        = string
}

variable "instance_type" {
  description = "The type of instances to run in the EKS cluster node group."
  type        = string
}

variable "instance_ssh_key" {
  description = "The name of the SSH Key that should be used to access the each nodes."
  type        = string
}

variable "instance_profile" {
  description = "The name attribute of the IAM instance profile to associate with launched instances."
  type        = string
}

variable "security_group_ids" {
  description = "All workers will be attached to those security groups."
  type        = list(string)
}

variable "associate_public_ip_address" {
  description = "Associate a public ip address with an instance in a VPC."
  type        = bool
  default     = false
}

variable "node_labels" {
  description = "A map of labels to add to the EKS cluster node group."
  type        = map(string)
  default     = {}
}

variable "node_taints" {
  description = "A list of taints to add to the EKS cluster node group."
  type        = list(string)
  default     = []
}

variable "bootstrap_extra_args" {
  description = "Extra arguments to add to the `/etc/eks/bootstrap.sh`."
  type        = list(string)
  default     = []
}

variable "kubelet_extra_args" {
  description = "Extra arguments to add to the kubelet. Useful for adding labels or taints."
  type        = list(string)
  default     = []
}

variable "cni_custom_networking_enabled" {
  description = "Whether to use EKS CNI Custom Networking."
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

variable "module_tags_enabled" {
  description = "Whether to create AWS Resource Tags for the module informations."
  type        = bool
  default     = true
}


###################################################
# Resource Group
###################################################

variable "resource_group_enabled" {
  description = "Whether to create Resource Group to find and group AWS resources which are created by this module."
  type        = bool
  default     = true
}

variable "resource_group_name" {
  description = "The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`."
  type        = string
  default     = ""
}

variable "resource_group_description" {
  description = "The description of Resource Group."
  type        = string
  default     = "Managed by Terraform."
}
