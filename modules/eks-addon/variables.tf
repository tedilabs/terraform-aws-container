variable "cluster_name" {
  description = "(Required) The name of the Amazon EKS cluster to add the EKS add-on to."
  type        = string
  nullable    = false
}

variable "name" {
  description = "(Required) The name of the EKS add-on."
  type        = string
  nullable    = false
}

variable "addon_version" {
  description = "(Optional) The version of the add-on. If not provided, this is configured with default compatibile version for the respective EKS cluster version."
  type        = string
  default     = null
  nullable    = true
}

variable "configuration" {
  description = "(Optional) The set of configuration values for the add-on. This JSON string value must match the JSON schema derived from `describe-addon-configuration`."
  type        = string
  default     = null
  nullable    = true
}

variable "service_account_role" {
  description = <<EOF
  (Optional) The ARN (Amazon Resource Name) of the IAM Role to bind to the add-on's service account. The role must be assigned the IAM permissions required by the add-on. If you don't specify an existing IAM role, then the add-on uses the permissions assigned to the node IAM role.
  EOF
  type        = string
  default     = null
  nullable    = true
}

variable "conflict_resolution_strategy_on_create" {
  description = <<EOF
  (Optional) How to resolve field value conflicts when migrating a self-managed add-on to an EKS add-on. Valid values are `NONE` and `OVERWRITE`. Defaults to `OVERWRITE`.
    `NONE` - If the self-managed version of the add-on is installed on the cluster, Amazon EKS doesn't change the value. Creation of the add-on might fail.
    `OVERWRITE` - If the self-managed version of the add-on is installed on your cluster and the Amazon EKS default value is different than the existing value, Amazon EKS changes the value to the Amazon EKS default value.
  EOF
  type        = string
  default     = "OVERWRITE"
  nullable    = false

  validation {
    condition     = contains(["NONE", "OVERWRITE"], var.conflict_resolution_strategy_on_create)
    error_message = "Valid values for `conflict_resolution_strategy_on_create` are `NONE` and `OVERWRITE`."
  }
}

variable "conflict_resolution_strategy_on_update" {
  description = <<EOF
  (Optional) How to resolve field value conflicts for an EKS add-on if you've changed a value from the EKS default value. Valid values are `NONE`, `OVERWRITE` and `PRESERVE`. Defaults to `OVERWRITE`.
    `NONE` - Amazon EKS doesn't change the value. The update might fail.
    `OVERWRITE` - Amazon EKS overwrites the changed value back to the Amazon EKS default value.
    `PRESERVE` - Amazon EKS preserves the value. If you choose this option, we recommend that you test any field and value changes on a non-production cluster before updating the add-on on the production cluster.

  EOF
  type        = string
  default     = "OVERWRITE"
  nullable    = false

  validation {
    condition     = contains(["NONE", "OVERWRITE", "PRESERVE"], var.conflict_resolution_strategy_on_update)
    error_message = "Valid values for `conflict_resolution_strategy_on_update` are `NONE`, `OVERWRITE` and `PRESERVE`."
  }
}

variable "preserve_on_delete" {
  description = <<EOF
  (Optional) Whether to preserve the created Kubernetes resources on the cluster when deleting the EKS add-on. Defaults to `false`.
  EOF
  type        = bool
  default     = false
  nullable    = false
}

variable "timeouts" {
  description = "(Optional) How long to wait for the EKS Fargate Profile to be created/updated/deleted."
  type = object({
    create = optional(string, "20m")
    update = optional(string, "20m")
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
