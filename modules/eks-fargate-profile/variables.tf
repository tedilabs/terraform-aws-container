variable "cluster_name" {
  description = "(Required) The name of the Amazon EKS cluster to apply the Fargate profile to."
  type        = string
  nullable    = false
}

variable "name" {
  description = "(Required) The name of Fargate Profile."
  type        = string
  nullable    = false
}

variable "subnets" {
  description = "(Required) The IDs of subnets to launch your pods into. At this time, pods running on Fargate are not assigned public IP addresses, so only private subnets (with no direct route to an Internet Gateway) are accepted"
  type        = list(string)
  nullable    = false
}

variable "default_pod_execution_role" {
  description = <<EOF
  (Optional) A configuration for the default pod execution role to use for pods that match the selectors in the Fargate profile. Only one of `default_pod_execution_role.role` or `pod_execution_role` can be specified. `default_pod_execution_role` as defined below.
    (Optional) `enabled` - Whether to create the default pod execution role. Defaults to `true`.
    (Optional) `name` - The name of the default pod execution role. Defaults to `eks-$${var.cluster_name}-fargate-profile-$${var.name}`.
    (Optional) `path` - The path of the default pod execution role. Defaults to `/`.
    (Optional) `description` - The description of the default pod execution role.
  EOF
  type = object({
    enabled     = optional(bool, true)
    name        = optional(string)
    path        = optional(string, "/")
    description = optional(string, "Managed by Terraform.")
  })
  default  = {}
  nullable = false
}

variable "pod_execution_role" {
  description = <<EOF
  (Optional) The ARN (Amazon Resource Name) of the IAM Role that provides permissions for the EKS Fargate Profile. Only required if `default_pod_execution_role.enabled` is `false`.
  EOF
  type        = string
  default     = null
  nullable    = true
}

variable "selectors" {
  description = <<EOF
  (Optional) A list of configurations for selecting Kubernetes Pods to execute with this EKS Fargate Profile. Each block of `selectors` as defined below.
    (Required) `namespace` - Kubernetes namespace for selection.
    (Optional) `labels` - Key-value map of Kubernetes labels for selection.
  EOF
  type = list(object({
    namespace = string
    labels    = optional(map(string), {})
  }))
  default  = []
  nullable = false
}

variable "timeouts" {
  description = "(Optional) How long to wait for the EKS Fargate Profile to be created/updated/deleted."
  type = object({
    create = optional(string, "10m")
    delete = optional(string, "10m")
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
