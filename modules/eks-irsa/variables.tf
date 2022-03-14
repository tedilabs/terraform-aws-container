variable "name" {
  description = "(Required) Desired name of the IAM role for EKS service accounts."
  type        = string
}

variable "path" {
  description = "(Optional) Desired path of the IAM role for EKS service accounts."
  type        = string
  default     = "/"
}

variable "description" {
  description = "(Optional) The description of the role."
  type        = string
  default     = ""
}

variable "max_session_duration" {
  description = "(Optional) Maximum CLI/API session duration in seconds between 3600 and 43200."
  type        = number
  default     = 3600
}

variable "force_detach_policies" {
  description = "(Optional) Specifies to force detaching any policies the role has before destroying it."
  type        = bool
  default     = false
}

variable "permissions_boundary" {
  description = "(Optional) The ARN of the policy that is used to set the permissions boundary for the role."
  type        = string
  default     = ""
}

variable "trusted_iam_entities" {
  description = "(Optional) A list of ARNs of AWS IAM entities who can assume the role."
  type        = list(string)
  default     = []
}

variable "trusted_service_accounts" {
  description = "(Optional) A list of Kubernetes service accounts which could be trusted to assume the role. The format should be `<namespace>:<service-account>`. The values can include a multi-character match wildcard (*) or a single-character match wildcard (?) anywhere in the string."
  type        = list(string)
  default     = []
}

variable "oidc_provider_urls" {
  description = "(Required) A list of URLs of OIDC identity providers."
  type        = list(string)
}

variable "trusted_oidc_conditions" {
  description = "(Optional) Required conditions to assume the role for OIDC providers."
  type = list(object({
    key       = string
    condition = string
    values    = list(string)
  }))
  default = []
}

variable "conditions" {
  description = "(Optional) Required conditions to assume the role."
  type = list(object({
    key       = string
    condition = string
    values    = list(string)
  }))
  default = []
}

variable "mfa_required" {
  description = "(Optional) Whether MFA should be required to assume the role."
  type        = bool
  default     = false
}

variable "mfa_ttl" {
  description = "(Optional) Max age of valid MFA (in seconds) for roles which require MFA."
  type        = number
  default     = 24 * 60 * 60
}

variable "effective_date" {
  description = "(Optional) Allow to assume IAM role only after a specific date and time."
  type        = string
  default     = null

  validation {
    # Fail if the variable is not a valid timestamp
    condition     = var.effective_date == null || can(formatdate("", var.effective_date))
    error_message = "Require a valid RFC 3339 timestamp."
  }
}

variable "expiration_date" {
  description = "(Optional) Allow to assume IAM role only before a specific date and time."
  type        = string
  default     = null

  validation {
    # Fail if the variable is not a valid timestamp
    condition     = var.expiration_date == null || can(formatdate("", var.expiration_date))
    error_message = "Require a valid RFC 3339 timestamp."
  }
}

variable "source_ip_whitelist" {
  description = "(Optional) A list of source IP addresses or CIDRs allowed to assume IAM role from."
  type        = list(string)
  default     = []
}

variable "source_ip_blacklist" {
  description = "(Optional) A list of source IP addresses or CIDRs denied to assume IAM role from."
  type        = list(string)
  default     = []
}

variable "assumable_roles" {
  description = "(Optional) List of IAM roles ARNs which can be assumed by the role."
  type        = list(string)
  default     = []
}

variable "policies" {
  description = "(Optional) List of IAM policies ARNs to attach to IAM role."
  type        = list(string)
  default     = []
}

variable "inline_policies" {
  description = "(Optional) Map of inline IAM policies to attach to IAM role. (`name` => `policy`)."
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "(Optional) A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

variable "module_tags_enabled" {
  description = "(Optional) Whether to create AWS Resource Tags for the module informations."
  type        = bool
  default     = true
}


###################################################
# Resource Group
###################################################

variable "resource_group_enabled" {
  description = "(Optional) Whether to create Resource Group to find and group AWS resources which are created by this module."
  type        = bool
  default     = true
}

variable "resource_group_name" {
  description = "(Optional) The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`."
  type        = string
  default     = ""
}

variable "resource_group_description" {
  description = "(Optional) The description of Resource Group."
  type        = string
  default     = "Managed by Terraform."
}
