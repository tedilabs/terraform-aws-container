variable "cluster_name" {
  description = "(Required) The name of the Amazon EKS cluster to create IAM access entries."
  type        = string
  nullable    = false
}

variable "node_access_entries" {
  description = <<EOF
  (Optional) A list of configurations for EKS access entries for nodes (EC2 instances, Fargate) that are allowed to access the EKS cluster. Each item of `node_access_entries` block as defined below.
    (Required) `name` - A unique name for the access entry. This value is only used internally within Terraform code.
    (Required) `type` - The type of the access entry. Valid values are `EC2_LINUX`, `EC2_WINDOWS`, `FARGATE_LINUX`.
    (Required) `principal` - The ARN of one, and only one, existing IAM principal to grant access to Kubernetes objects on the cluster. An IAM principal can't be included in more than one access entry.
  EOF
  type = list(object({
    name      = string
    type      = string
    principal = string
  }))
  default  = []
  nullable = false

  validation {
    condition = alltrue([
      for entry in var.node_access_entries :
      contains(["EC2_LINUX", "EC2_WINDOWS", "FARGATE_LINUX"], entry.type)
    ])
    error_message = "Valid values for `type` are `EC2_LINUX`, `EC2_WINDOWS`, `FARGATE_LINUX`."
  }
}

variable "user_access_entries" {
  description = <<EOF
  (Optional) A list of configurations for EKS access entries for users (IAM roles, users) that are allowed to access the EKS cluster. Each item of `user_access_entries` block as defined below.
    (Required) `name` - A unique name for the access entry. This value is only used internally within Terraform code.
    (Required) `principal` - The ARN of one, and only one, existing IAM principal to grant access to Kubernetes objects on the cluster. An IAM principal can't be included in more than one access entry.
    (Optional) `username` - The username to authenticate to Kubernetes with. We recommend not specifying a username and letting Amazon EKS specify it for you. Defaults to the IAM principal ARN.
    (Optional) `groups` - A set of groups within the Kubernetes cluster.
  EOF
  type = list(object({
    name      = string
    principal = string
    username  = optional(string)
    groups    = optional(set(string), [])
  }))
  default  = []
  nullable = false
}

variable "timeouts" {
  description = "(Optional) How long to wait for the EKS Cluster to be created/updated/deleted."
  type = object({
    create = optional(string, "30m")
    update = optional(string, "60m")
    delete = optional(string, "15m")
  })
  default  = {}
  nullable = false
}

variable "tags" {
  description = "(Optional) A map of tags to add to all resources."
  type        = map(string)
  default     = {}
  nullable    = false
}

variable "module_tags_enabled" {
  description = "(Optional) Whether to create AWS Resource Tags for the module informations."
  type        = bool
  default     = true
  nullable    = false
}


###################################################
# Resource Group
###################################################

variable "resource_group_enabled" {
  description = "(Optional) Whether to create Resource Group to find and group AWS resources which are created by this module."
  type        = bool
  default     = true
  nullable    = false
}

variable "resource_group_name" {
  description = "(Optional) The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`."
  type        = string
  default     = ""
  nullable    = false
}

variable "resource_group_description" {
  description = "(Optional) The description of Resource Group."
  type        = string
  default     = "Managed by Terraform."
  nullable    = false
}
