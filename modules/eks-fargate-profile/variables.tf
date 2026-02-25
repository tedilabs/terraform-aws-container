variable "region" {
  description = "(Optional) The region in which to create the module resources. If not provided, the module resources will be created in the provider's configured region."
  type        = string
  default     = null
  nullable    = true
}

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
  (Optional) A configuration for the default pod execution role to use for pods that match the selectors in the Fargate profile. Use `pod_execution_role` if `default_pod_execution_role.enabled` is `false`. `default_pod_execution_role` as defined below.
    (Optional) `enabled` - Whether to create the default pod execution role. Defaults to `true`.
    (Optional) `name` - The name of the default pod execution role. Defaults to `eks-$${var.cluster_name}-fargate-profile-$${var.name}`.
    (Optional) `path` - The path of the default pod execution role. Defaults to `/`.
    (Optional) `description` - The description of the default pod execution role.
    (Optional) `policies` - A list of IAM policy ARNs to attach to the default pod execution role. `AmazonEKSFargatePodExecutionRolePolicy` is always attached. Defaults to `[]`.
    (Optional) `inline_policies` - A Map of inline IAM policies to attach to the default pod execution role. (`name` => `policy`).
    (Optional) `permissions_boundary` - The ARN of the IAM policy to use as permissions boundary for the default pod execution role.
  EOF
  type = object({
    enabled     = optional(bool, true)
    name        = optional(string)
    path        = optional(string, "/")
    description = optional(string, "Managed by Terraform.")

    policies             = optional(list(string), [])
    inline_policies      = optional(map(string), {})
    permissions_boundary = optional(string)
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
