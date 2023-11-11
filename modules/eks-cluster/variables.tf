variable "name" {
  description = "(Required) Name of the EKS cluster. Must be between 1-100 characters in length. Must begin with an alphanumeric character, and must only contain alphanumeric characters, dashes and underscores."
  type        = string
  nullable    = false

  validation {
    condition     = length(var.name) <= 100
    error_message = "The name can have a maximum of 100 characters."
  }
}

variable "kubernetes_version" {
  description = "(Optional) Desired Kubernetes version to use for the EKS cluster. Defaults to `1.26`."
  type        = string
  default     = "1.26"
  nullable    = false
}

variable "kubernetes_network_config" {
  description = <<EOF
  (Optional) A configuration of Kubernetes network. `kubernetes_network_config` as defined below.
    (Optional) `service_ipv4_cidr` - The CIDR block to assign Kubernetes pod and service IP addresses from. If you don't specify a block, Kubernetes assigns addresses from either the `10.100.0.0/16` or `172.20.0.0/16` CIDR blocks. We recommend that you specify a block that does not overlap with resources in other networks that are peered or connected to your VPC. You can only specify a custom CIDR block when you create a cluster, changing this value will force a new cluster to be created.
    (Optional) `ip_family` - The IP family used to assign Kubernetes pod and service addresses. Valid values are `IPV4` and `IPV6`. Defaults to `IPV4`. You can only specify an IP family when you create a cluster, changing this value will force a new cluster to be created.
  EOF
  type = object({
    service_ipv4_cidr = optional(string)
    ip_family         = optional(string, "IPV4")
  })
  default  = {}
  nullable = false

  validation {
    condition     = contains(["IPV4", "IPV6"], var.kubernetes_network_config.ip_family)
    error_message = "Valid values for `kubernetes_network_config.ip_family` are `IPV4` and `IPV6`."
  }
}

variable "subnet_ids" {
  description = "(Required) A list of subnets to creates cross-account elastic network interfaces to allow communication between your worker nodes and the Kubernetes control plane. Must be in at least two different availability zones."
  type        = list(string)
  nullable    = false
}

variable "endpoint_public_access" {
  description = "(Optional) Indicates whether or not the Amazon EKS public API server endpoint is enabled."
  type        = bool
  default     = false
  nullable    = false
}

variable "endpoint_private_access" {
  description = "(Optional) Indicates whether or not the Amazon EKS private API server endpoint is enabled."
  type        = bool
  default     = true
  nullable    = false
}

variable "endpoint_public_access_cidrs" {
  description = "(Optional) A list of allowed CIDR to communicate to the Amazon EKS public API server endpoint."
  type        = list(string)
  default     = ["0.0.0.0/0"]
  nullable    = false
}

variable "endpoint_private_access_cidrs" {
  description = "(Optional) A list of allowed CIDR to communicate to the Amazon EKS private API server endpoint."
  type        = list(string)
  default     = []
  nullable    = false
}

variable "endpoint_private_access_source_security_group_ids" {
  description = "(Optional) A list of allowed source security group to communicate to the Amazon EKS private API server endpoint."
  type        = list(string)
  default     = []
  nullable    = false
}

variable "default_cluster_role" {
  description = <<EOF
  (Optional) A configuration for the default IAM role for EKS cluster. Use `cluster_role` if `default_cluster_role.enabled` is `false`. `default_cluster_role` as defined below.
    (Optional) `enabled` - Whether to create the default cluster role. Defaults to `true`.
    (Optional) `name` - The name of the default cluster role. Defaults to `eks-$${var.name}-cluster`.
    (Optional) `path` - The path of the default cluster role. Defaults to `/`.
    (Optional) `description` - The description of the default cluster role.
    (Optional) `policies` - A list of IAM policy ARNs to attach to the default cluster role. `AmazonEKSClusterPolicy` is always attached. Defaults to `[]`.
    (Optional) `inline_policies` - A Map of inline IAM policies to attach to the default cluster role. (`name` => `policy`).
  EOF
  type = object({
    enabled     = optional(bool, true)
    name        = optional(string)
    path        = optional(string, "/")
    description = optional(string, "Managed by Terraform.")

    policies        = optional(list(string), [])
    inline_policies = optional(map(string), {})
  })
  default  = {}
  nullable = false
}

variable "cluster_role" {
  description = <<EOF
  (Optional) The ARN (Amazon Resource Name) of the IAM Role for the EKS cluster role. Only required if `default_cluster_role.enabled` is `false`.
  EOF
  type        = string
  default     = null
  nullable    = true
}

variable "default_node_role" {
  description = <<EOF
  (Optional) A configuration for the default IAM role for EKS nodes. `default_node_role` as defined below.
    (Optional) `enabled` - Whether to create the default node role. Defaults to `false`.
    (Optional) `name` - The name of the default node role. Defaults to `eks-$${var.name}-node`.
    (Optional) `path` - The path of the default node role. Defaults to `/`.
    (Optional) `description` - The description of the default node role.
    (Optional) `policies` - A list of IAM policy ARNs to attach to the default node role. `AmazonEKSWorkerNodePolicy`, `AmazonEKS_CNI_Policy`, `AmazonEC2ContainerRegistryReadOnly` are always attached. Defaults to `[]`.
    (Optional) `inline_policies` - A Map of inline IAM policies to attach to the default node role. (`name` => `policy`).
  EOF
  type = object({
    enabled     = optional(bool, false)
    name        = optional(string)
    path        = optional(string, "/")
    description = optional(string, "Managed by Terraform.")

    policies        = optional(list(string), [])
    inline_policies = optional(map(string), {})
  })
  default  = {}
  nullable = false
}

variable "log_types" {
  description = "(Optional) A set of the desired control plane logging to enable."
  type        = set(string)
  default     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  nullable    = false
}

variable "log_retention_in_days" {
  description = "(Optional) Number of days to retain log events. Default retention - 90 days. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653, and 0. If you select 0, the events in the log group are always retained and never expire."
  type        = number
  default     = 90
  nullable    = false
}

variable "log_encryption_kms_key" {
  description = "(Optional) The ARN of the KMS Key to use when encrypting log data. Please note, after the AWS KMS CMK is disassociated from the log group, AWS CloudWatch Logs stops encrypting newly ingested data for the log group. All previously ingested data remains encrypted, and AWS CloudWatch Logs requires permissions for the CMK whenever the encrypted data is requested."
  type        = string
  default     = null
}

variable "secrets_encryption" {
  description = <<EOF
  (Optional) A configuration to encrypt Kubernetes secrets. Envelope encryption provides an additional layer of encryption for your Kubernetes secrets. Once turned on, secrets encryption cannot be modified or removed. `secrets_encryption` as defined below.
    (Optional) `enabled` - Whether to enable envelope encryption of Kubernetes secrets. Defaults to `false`.
    (Optional) `kms_key` - The ID of AWS KMS key to use for envelope encryption of Kubernetes secrets.
  EOF
  type = object({
    enabled = optional(bool, false)
    kms_key = optional(string)
  })
  default  = {}
  nullable = false
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
  type = list(object({
    name       = string
    issuer_url = string
    client_id  = string

    required_claims = optional(map(string), {})
    username_claim  = optional(string)
    username_prefix = optional(string)
    groups_claim    = optional(string)
    groups_prefix   = optional(string)
  }))
  default  = []
  nullable = false
}

variable "outpost_config" {
  description = <<EOF
  (Optional) A configuration of the outpost for the EKS cluster. `outpost_config` as defined below.
    (Required) `outposts` - A list of the Outpost ARNs that you want to use for your local Amazon EKS cluster on Outposts. This argument is a list of arns, but only a single Outpost ARN is supported currently.
    (Required) `control_plane_instance_type` - The Amazon EC2 instance type that you want to use for your local Amazon EKS cluster on Outposts. The instance type that you specify is used for all Kubernetes control plane instances. The instance type can't be changed after cluster creation. Choose an instance type based on the number of nodes that your cluster will have.
      - 1–20 nodes, then we recommend specifying a large instance type.
      - 21–100 nodes, then we recommend specifying an xlarge instance type.
      - 101–250 nodes, then we recommend specifying a 2xlarge instance type.
    (Optional) `control_plane_placement_group` - The name of the placement group for the Kubernetes control plane instances. This setting can't be changed after cluster creation.
  EOF
  type = object({
    outposts                      = list(string)
    control_plane_instance_type   = string
    control_plane_placement_group = optional(string)
  })
  default  = null
  nullable = true
}

variable "timeouts" {
  description = "(Optional) How long to wait for the EKS Cluster to be created/updated/deleted."
  type = object({
    create = optional(string, "30m")
    update = optional(string, "60m")
    delete = optional(string, "15m")
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
