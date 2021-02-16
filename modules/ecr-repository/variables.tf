variable "name" {
  description = "Desired name for the repository."
  type        = string
}

variable "image_tag_immutable_enabled" {
  description = "Should be true if you want to disable to modify image tags."
  type        = bool
  default     = false
}

variable "image_scan_on_push_enabled" {
  description = "Indicates whether images are scanned after being pushed to the repository or not scanned."
  type        = bool
  default     = false
}

variable "encryption_enabled" {
  description = "Enable Encryption for repository."
  type        = bool
  default     = false
}

variable "encryption_type" {
  description = "The encryption type to use for the repository. Valid values are `AES256` or `KMS`."
  type        = string
  default     = "AES256"
}

variable "encryption_kms_key" {
  description = "The ARN of the KMS key to use when encryption_type is `KMS`. If not specified, uses the default AWS managed key for ECR."
  type        = string
  default     = null
}

variable "repository_policy" {
  description = "The policy document for ECR Repository. This is a JSON formatted string."
  type        = string
  default     = ""
}

variable "lifecycle_policy" {
  description = "The policy document for ECR Repository Lifecycle. This is a JSON formatted string."
  type        = string
  default     = ""
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}
