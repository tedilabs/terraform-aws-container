variable "name" {
  description = "(Required) Name of the EKS cluster. Must be between 1-100 characters in length. Must begin with an alphanumeric character, and must only contain alphanumeric characters, dashes and underscores."
  type        = string

  validation {
    condition     = length(var.name) <= 100
    error_message = "The name can have a maximum of 100 characters."
  }
}

variable "kubernetes_version" {
  description = "(Optional) Kubernetes version to use for the EKS cluster."
  type        = string
  default     = "1.21"
}

variable "subnet_ids" {
  description = "(Required) A list of subnets to creates cross-account elastic network interfaces to allow communication between your worker nodes and the Kubernetes control plane. Must be in at least two different availability zones."
  type        = list(string)
}

variable "service_cidr" {
  description = "(Optional) The CIDR block to assign Kubernetes service IP addresses from. Recommend that you specify a block that does not overlap with resources in other networks that are peered or connected to your VPC. You can only specify a custom CIDR block when you create a cluster, changing this value will force a new cluster to be created. Only valid if `ip_family` is `IPV4`."
  type        = string
  default     = "172.20.0.0/16"
}

variable "ip_family" {
  description = "(Optional) The IP family used to assign Kubernetes pod and service addresses. Valid values are `IPV4` and `IPV6`. Defaults to `IPV4`. You can only specify an IP family when you create a cluster, changing this value will force a new cluster to be created."
  type        = string
  default     = "IPV4"

  validation {
    condition     = contains(["IPV4", "IPV6"], var.ip_family)
    error_message = "The possible values are `IPV4` and `IPV6`."
  }
}

variable "endpoint_public_access" {
  description = "(Optional) Indicates whether or not the Amazon EKS public API server endpoint is enabled."
  type        = bool
  default     = false
}

variable "endpoint_private_access" {
  description = "(Optional) Indicates whether or not the Amazon EKS private API server endpoint is enabled."
  type        = bool
  default     = true
}

variable "endpoint_public_access_cidrs" {
  description = "(Optional) A list of allowed CIDR to communicate to the Amazon EKS public API server endpoint."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "endpoint_private_access_cidrs" {
  description = "(Optional) A list of allowed CIDR to communicate to the Amazon EKS private API server endpoint."
  type        = list(string)
  default     = []
}

variable "endpoint_private_access_source_security_group_ids" {
  description = "(Optional) A list of allowed source security group to communicate to the Amazon EKS private API server endpoint."
  type        = list(string)
  default     = []
}

variable "log_types" {
  description = "(Optional) A list of the desired control plane logging to enable."
  type        = list(string)
  default     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

variable "log_retention_in_days" {
  description = "(Optional) Number of days to retain log events. Default retention - 90 days. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653, and 0. If you select 0, the events in the log group are always retained and never expire."
  type        = number
  default     = 90
}

variable "log_encryption_kms_key" {
  description = "(Optional) The ARN of the KMS Key to use when encrypting log data. Please note, after the AWS KMS CMK is disassociated from the log group, AWS CloudWatch Logs stops encrypting newly ingested data for the log group. All previously ingested data remains encrypted, and AWS CloudWatch Logs requires permissions for the CMK whenever the encrypted data is requested."
  type        = string
  default     = null
}

variable "encryption_enabled" {
  description = "(Optional) Whether to encrypt kubernetes resources."
  type        = string
  default     = false
}

variable "encryption_kms_key" {
  description = "(Optional) The ARN of the KMS customer master key (CMK) to encrypt resources. The CMK must be symmetric, created in the same region as the cluster, and if the CMK was created in a different account, the user must have access to the CMK."
  type        = string
  default     = null
}

variable "encryption_resources" {
  description = "(Optional) List of strings with resources to be encrypted. Valid values: `secrets`."
  type        = list(string)
  default     = ["secrets"]
}

variable "timeouts" {
  description = "(Optional) How long to wait for the EKS Cluster to be created/updated/deleted."
  type        = map(string)
  default = {
    create = "30m"
    update = "60m"
    delete = "15m"
  }
}

variable "fargate_default_subnet_ids" {
  description = "(Optional) A list of defualt subnet IDs for the EKS Fargate Profile. Only used if you do not specified `subnet_ids` in Fargate Profile."
  type        = list(string)
  default     = []
}

variable "fargate_profiles" {
  description = <<EOF
  (Optional) A list of Fargate Profile definitions to create. `fargate_profiles` block as defined below.
    (Required) `name` - The name of Fargate Profile.
    (Required) `selectors` - Configuration block(s) for selecting Kubernetes Pods to execute with this EKS Fargate Profile. Each block of `selectors` block as defined below.
      (Required) `namespace` - Kubernetes namespace for selection.
      (Optional) `labels` - Key-value map of Kubernetes labels for selection.
    (Optional) `subnet_ids` - A list of subnet IDs for the EKS Fargate Profile. Use cluster subnet IDs if not provided.
  EOF
  type        = any
  default     = []
}

variable "oidc_identity_providers" {
  description = <<EOF
  (Optional) A list of OIDC Identity Providers to associate as an additional method for user authentication to your Kubernetes cluster. Each item of `oidc_identity_providers` block as defined below.
    (Required) `name` - A unique name for the Identity Provider Configuration.
    (Required) `issuer_url` - The OIDC Identity Provider issuer URL.
    (Required) `client_id` - The OIDC Identity Provider client ID.
    (Optional) `required_claims` - The key value pairs that describe required claims in the identity token.
    (Optional) `username_claim` - The JWT claim that the provider will use as the username.
    (Optional) `username_prefix` - A prefix that is prepended to username claims.
    (Optional) `groups_claim` - The JWT claim that the provider will use to return groups.
    (Optional) `groups_prefix` - A prefix that is prepended to group claims e.g., `oidc:`.
  EOF
  type        = any
  default     = []
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
