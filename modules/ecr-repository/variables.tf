variable "name" {
  description = "(Required) Desired name for the repository."
  type        = string
  nullable    = false
}

variable "force_delete" {
  description = "(Optional) If `true`, will delete the repository even if it contains images. Defaults to `true`."
  type        = bool
  default     = true
  nullable    = false
}

variable "policy" {
  description = "(Optional) The policy document for ECR Repository. This is a JSON formatted string."
  type        = string
  default     = ""
  nullable    = false
}

variable "image_tag_immutable_enabled" {
  description = "(Optional) Whether to enable the image tag immutability setting for the repository. Enable tag immutability to prevent image tags from being overwritten by subsequent image pushes using the same tag. Disable tag immutability to allow image tags to be overwritten. Defaults to `false`."
  type        = bool
  default     = false
  nullable    = false
}

variable "image_scan_on_push_enabled" {
  description = "(Optional, Deprecated) Indicates whether images are scanned after being pushed to the repository or not scanned. This configuration is deprecated in favor of registry level scan filters. Defaults to `false`."
  type        = bool
  default     = false
  nullable    = false
}

variable "encryption" {
  description = <<EOF
  (Optional) The encryption configuration of the repository. `encryption` as defined below.
    (Optional) `type` - The encryption type to use for the repository. Valid values are `AES256` or `KMS`. Defaults to `AES256`.
    (Optional) `kms_key` - The ARN of the KMS key to use for encryption of the repository when `type` is `KMS`. If not specified, uses the default AWS managed key for ECR.
  EOF
  type = object({
    type    = optional(string, "AES256")
    kms_key = optional(string)
  })
  default  = {}
  nullable = false

  validation {
    condition     = contains(["AES256", "KMS"], var.encryption.type)
    error_message = "Valid values for `type` are `AES256`, `KMS`."
  }
}

variable "lifecycle_rules" {
  description = <<EOF
  (Optional) A list of Lifecycle rules for ECR repository. Each block of `lifecycle_rules` as defined below.
    (Required) `priority` - The order in which rules are applied, lowest to highest. A lifecycle policy rule with a priority of `1` will be applied first, a rule with priority of `2` will be next, and so on. Must be unique and do not need to be sequential across rules.
    (Optional) `descriptoin` - The description of the rule to describe the purpose of a rule within a lifecycle policy.
    (Required) `target` - The configuration of target images for the rule. `target` as defined below.

      (Required) `status` - Valid values are `tagged`, `untagged`, or `any`. When you specify `tagged` status, either `tag_patterns` or `tag_prefixes` are required, but not both.
      (Optional) `tag_patterns` - A list of tag patterns to filter target images. If you specify multiple tags, only the images with all specified tags are selected. There is a maximum limit of four wildcards (*) per string.
      (Optional) `tag_prefixes` - A list of tag prefixes to filter target images. If you specify multiple prefixes, only the images with all specified prefixes are selected.
    (Required) `expiration` - The configuration of expiration condition for the rule. `expiration` as defined below.

      (Optional) `count` - The maximum number of images to keep.
      (Optional) `days` - The maximum age of days to keep images.
  EOF
  type = list(object({
    priority    = number
    description = optional(string, "Managed by Terraform.")

    target = object({
      status       = string
      tag_patterns = optional(list(string), [])
      tag_prefixes = optional(list(string), [])
    })
    expiration = object({
      count = optional(number)
      days  = optional(number)
    })
  }))
  default  = []
  nullable = false

  validation {
    condition = alltrue([
      for rule in var.lifecycle_rules :
      contains(["tagged", "untagged", "any"], rule.target.status)
    ])
    error_message = "Valid values for `status` are `tagged`, `untagged`, `any`."
  }
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
