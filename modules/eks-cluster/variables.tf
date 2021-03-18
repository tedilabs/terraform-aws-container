variable "name" {
  description = "Name of the EKS cluster."
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version to use for the EKS cluster."
  type        = string
  default     = "1.19"
}

variable "subnet_ids" {
  description = "A list of subnets to creates cross-account elastic network interfaces to allow communication between your worker nodes and the Kubernetes control plane. Must be in at least two different availability zones."
  type        = list(string)
}

variable "service_cidr" {
  description = "The CIDR block to assign Kubernetes service IP addresses from. Recommend that you specify a block that does not overlap with resources in other networks that are peered or connected to your VPC. You can only specify a custom CIDR block when you create a cluster, changing this value will force a new cluster to be created."
  type        = string
  default     = "172.20.0.0/16"
}

variable "endpoint_public_access" {
  description = "Indicates whether or not the Amazon EKS public API server endpoint is enabled."
  type        = bool
  default     = false
}

variable "endpoint_private_access" {
  description = "Indicates whether or not the Amazon EKS private API server endpoint is enabled."
  type        = bool
  default     = true
}

variable "endpoint_public_access_cidrs" {
  description = "A list of allowed CIDR to communicate to the Amazon EKS public API server endpoint."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "endpoint_private_access_cidrs" {
  description = "A list of allowed CIDR to communicate to the Amazon EKS private API server endpoint."
  type        = list(string)
  default     = []
}

variable "endpoint_private_access_source_security_group_ids" {
  description = "A list of allowed source security group to communicate to the Amazon EKS private API server endpoint."
  type        = list(string)
  default     = []
}

variable "log_types" {
  description = "A list of the desired control plane logging to enable."
  type        = list(string)
  default     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

variable "log_retention_in_days" {
  description = "Number of days to retain log events. Default retention - 90 days. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653, and 0. If you select 0, the events in the log group are always retained and never expire."
  type        = number
  default     = 90
}

variable "log_encryption_kms_key" {
  description = "The ARN of the KMS Key to use when encrypting log data. Please note, after the AWS KMS CMK is disassociated from the log group, AWS CloudWatch Logs stops encrypting newly ingested data for the log group. All previously ingested data remains encrypted, and AWS CloudWatch Logs requires permissions for the CMK whenever the encrypted data is requested."
  type        = string
  default     = null
}

variable "encryption_enabled" {
  description = "Whether to encrypt kubernetes resources."
  type        = string
  default     = false
}

variable "encryption_kms_key" {
  description = "The ARN of the KMS customer master key (CMK) to encrypt resources. The CMK must be symmetric, created in the same region as the cluster, and if the CMK was created in a different account, the user must have access to the CMK."
  type        = string
  default     = null
}

variable "encryption_resources" {
  description = "List of strings with resources to be encrypted. Valid values: `secrets`."
  type        = list(string)
  default     = ["secrets"]
}

variable "timeouts" {
  description = "How long to wait for the EKS Cluster to be created/updated/deleted."
  type        = map(string)
  default = {
    create = "30m"
    update = "60m"
    delete = "15m"
  }
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

variable "module_tags_enabled" {
  description = "Whether to create AWS Resource Tags for the module informations."
  type        = bool
  default     = true
}


###################################################
# Resource Group
###################################################

variable "resource_group_enabled" {
  description = "Whether to create Resource Group to find and group AWS resources which are created by this module."
  type        = bool
  default     = true
}

variable "resource_group_name" {
  description = "The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`."
  type        = string
  default     = ""
}

variable "resource_group_description" {
  description = "The description of Resource Group."
  type        = string
  default     = "Managed by Terraform."
}
