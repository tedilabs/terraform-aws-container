variable "instance_type" {
  description = "(Required) The type of instances to run in the EKS cluster node group."
  type        = string
}

variable "use_cni_custom_networking" {
  description = "(Optional) Use EKS CNI Custom Networking."
  type        = bool
  default     = true
  nullable    = false
}

variable "use_cni_eni_prefix_mode" {
  description = "(Optional) Use ENI Prefix Mode. Defaults to `false`."
  type        = bool
  default     = false
  nullable    = false
}
