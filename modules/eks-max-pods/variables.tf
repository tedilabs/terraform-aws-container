variable "instance_type" {
  description = "(Required) The type of instances to run in the EKS cluster node group."
  type        = string
}

variable "use_cni_custom_networking" {
  description = "(Optional) Use EKS CNI Custom Networking."
  type        = bool
  default     = true
}
