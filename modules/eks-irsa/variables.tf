variable "name" {
  description = "Desired name of the IAM role for EKS service accounts."
  type        = string
}

variable "path" {
  description = "Desired path of the IAM role for EKS service accounts."
  type        = string
  default     = "/"
}

variable "description" {
  description = "The description of the role."
  type        = string
  default     = ""
}

variable "max_session_duration" {
  description = "Maximum CLI/API session duration in seconds between 3600 and 43200."
  type        = number
  default     = 3600
}

variable "force_detach_policies" {
  description = "Specifies to force detaching any policies the role has before destroying it."
  type        = bool
  default     = false
}

variable "permissions_boundary" {
  description = "The ARN of the policy that is used to set the permissions boundary for the role."
  type        = string
  default     = ""
}

variable "trusted_service_accounts" {
  description = "A list of Kubernetes service accounts which could be trusted to assume the role. The format should be `<namespace>:<service-account>`. The values can include a multi-character match wildcard (*) or a single-character match wildcard (?) anywhere in the string."
  type        = list(string)
  default     = []
}

variable "oidc_provider_urls" {
  description = "A list of URLs of OIDC identity providers."
  type        = list(string)
}

variable "trusted_oidc_conditions" {
  description = "Required conditions to assume the role for OIDC providers."
  type = list(object({
    key       = string
    condition = string
    values    = list(string)
  }))
  default = []
}

variable "conditions" {
  description = "Required conditions to assume the role."
  type = list(object({
    key       = string
    condition = string
    values    = list(string)
  }))
  default = []
}

variable "effective_date" {
  description = "Allow to assume IAM role only after a specific date and time."
  type        = string
  default     = null

  validation {
    # Fail if the variable is not a valid timestamp
    condition     = var.effective_date == null || can(formatdate("", var.effective_date))
    error_message = "Require a valid RFC 3339 timestamp."
  }
}

variable "expiration_date" {
  description = "Allow to assume IAM role only before a specific date and time."
  type        = string
  default     = null

  validation {
    # Fail if the variable is not a valid timestamp
    condition     = var.expiration_date == null || can(formatdate("", var.expiration_date))
    error_message = "Require a valid RFC 3339 timestamp."
  }
}

variable "source_ip_whitelist" {
  description = "A list of source IP addresses or CIDRs allowed to assume IAM role from."
  type        = list(string)
  default     = []
}

variable "source_ip_blacklist" {
  description = "A list of source IP addresses or CIDRs denied to assume IAM role from."
  type        = list(string)
  default     = []
}

variable "policies" {
  description = "List of IAM policies ARNs to attach to IAM role."
  type        = list(string)
  default     = []
}

variable "inline_policies" {
  description = "Map of inline IAM policies to attach to IAM role. (`name` => `policy`)."
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}
