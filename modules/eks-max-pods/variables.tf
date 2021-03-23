variable "instance_type" {
  description = "The type of instances to run in the EKS cluster node group."
  type        = string
}

variable "use_cni_custom_networking" {
  description = "Use EKS CNI Custom Networking."
  type        = bool
  default     = true
}
