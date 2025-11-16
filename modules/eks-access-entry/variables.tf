variable "region" {
  description = "(Optional) The region in which to create the module resources. If not provided, the module resources will be created in the provider's configured region."
  type        = string
  default     = null
  nullable    = true
}

variable "name" {
  description = "(Required) The name of the Amazon EKS access entry."
  type        = string
  nullable    = false
}

variable "cluster_name" {
  description = "(Required) The name of the Amazon EKS cluster to create IAM access entries."
  type        = string
  nullable    = false
}

variable "type" {
  description = "(Optional) The type of the access entry. Valid values are `EC2` (for EKS Auto Mode), `EC2_LINUX`, `EC2_WINDOWS`, `FARGATE_LINUX`, `HYBRID_LINUX`, `HYPERPOD_LINUX`, `STANDARD`. Defaults to `STANDARD`."
  type        = string
  default     = "STANDARD"
  nullable    = false

  validation {
    condition     = contains(["EC2", "EC2_LINUX", "EC2_WINDOWS", "FARGATE_LINUX", "HYBRID_LINUX", "HYPERPOD_LINUX", "STANDARD"], var.type)
    error_message = "Valid values for `type` are `EC2`, `EC2_LINUX`, `EC2_WINDOWS`, `FARGATE_LINUX`, `HYBRID_LINUX`, `HYPERPOD_LINUX`, `STANDARD`."
  }
}

variable "principal" {
  description = "(Required) The ARN of one, and only one, existing IAM principal to grant access to Kubernetes objects on the cluster. An IAM principal can't be included in more than one access entry."
  type        = string
  nullable    = false
}

variable "kubernetes_username" {
  description = "(Optional) The username to authenticate to Kubernetes with. We recommend not specifying a username and letting Amazon EKS specify it for you. Defaults to the IAM principal ARN. Only used when `type` is `STANDARD`."
  type        = string
  default     = null
  nullable    = true
}

variable "kubernetes_groups" {
  description = "(Optional) A set of groups within the Kubernetes cluster. Only used when `type` is `STANDARD`."
  type        = set(string)
  default     = []
  nullable    = false
}

variable "kubernetes_permissions" {
  description = <<EOF
  (Optional) A list of permissions for EKS access entry to the EKS cluster. Each item of `kubernetes_permissions` block as defined below.
    (Required) `policy` - The ARN of the access policy that you're associating.
    (Optional) `scope` - The type of access scope that you're associating. Valid values are `NAMESPACE`, `CLUSTER`. Defaults to `CLUSTER`.
    (Optional) `namespaces` - A set of namespaces to which the access scope applies. You can enter plain text namespaces, or wildcard namespaces such as `dev-*`.
  EOF
  type = list(object({
    policy     = string
    scope      = optional(string, "CLUSTER")
    namespaces = optional(set(string), [])
  }))
  default  = []
  nullable = false

  validation {
    condition = alltrue([
      for permission in var.kubernetes_permissions :
      contains(["NAMESPACE", "CLUSTER"], permission.scope)
    ])
    error_message = "Valid values for `scope` are `NAMESPACE`, `CLUSTER`."
  }
  validation {
    condition = alltrue([
      for permission in var.kubernetes_permissions :
      startswith(permission.policy, "arn:aws:eks::aws:cluster-access-policy/")
    ])
    error_message = "Valid values for `policy` are `arn:aws:eks::aws:cluster-access-policy/*`."
  }
}

variable "timeouts" {
  description = "(Optional) How long to wait for the EKS access entry to be created/deleted."
  type = object({
    create = optional(string, "20m")
    delete = optional(string, "40m")
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

variable "resource_group" {
  description = <<EOF
  (Optional) A configurations of Resource Group for this module. `resource_group` as defined below.
    (Optional) `enabled` - Whether to create Resource Group to find and group AWS resources which are created by this module. Defaults to `true`.
    (Optional) `name` - The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`. If not provided, a name will be generated using the module name and instance name.
    (Optional) `description` - The description of Resource Group. Defaults to `Managed by Terraform.`.
  EOF
  type = object({
    enabled     = optional(bool, true)
    name        = optional(string, "")
    description = optional(string, "Managed by Terraform.")
  })
  default  = {}
  nullable = false
}
