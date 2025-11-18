variable "region" {
  description = "(Optional) The region in which to create the module resources. If not provided, the module resources will be created in the provider's configured region."
  type        = string
  default     = null
  nullable    = true
}

variable "name" {
  description = "(Required) Name of the EKS cluster. Must be between 1-100 characters in length. Must begin with an alphanumeric character, and must only contain alphanumeric characters, dashes and underscores."
  type        = string
  nullable    = false

  validation {
    condition     = length(var.name) <= 100
    error_message = "The name can have a maximum of 100 characters."
  }
}

variable "deletion_protection_enabled" {
  description = "(Optional) Whether to enable deletion protection for the cluster. When deletion protection is enabled, the cluster cannot be deleted unless this property is set to `false`. Defaults to `false`."
  type        = bool
  default     = false
  nullable    = false
}

variable "kubernetes_version" {
  description = "(Optional) Desired Kubernetes version to use for the EKS cluster. The value must be configured and increased to upgrade the version when desired. Downgrades are not supported by EKS. Defaults to `1.26`."
  type        = string
  default     = "1.26"
  nullable    = false
}

variable "upgrade_policy" {
  description = <<EOF
  (Optional) A configuration for the upgrade policy of the EKS cluster. `upgrade_policy` as defined below.
    (Optional) `force_upgrade` - Whether to force version upgrade by overriding upgrade-blocking readiness checks when upgrading a cluster. Defaults to `false`.
    (Optional) `support_type` - The support type for the EKS cluster. Valid values are `STANDARD` and `EXTENDED`. Defaults to `STANDARD`.
      - `STANDARD` - This option supports the Kubernetes version for 14 months after the release date. There is no additional cost. When standard support ends, your cluster will be auto upgraded to the next version.
      - `EXTENDED` - This option supports the Kubernetes version for 26 months after the release date. The extended support period has an additional hourly cost that begins after the standard support period ends. When extended support ends, your cluster will be auto upgraded to the next version.
  EOF
  type = object({
    force_upgrade = optional(bool, false)
    support_type  = optional(string, "STANDARD")
  })
  default  = {}
  nullable = false

  validation {
    condition     = contains(["STANDARD", "EXTENDED"], var.upgrade_policy.support_type)
    error_message = "Valid values for `upgrade_policy.support_type` are `STANDARD` and `EXTENDED`."
  }
}

variable "auto_mode" {
  description = <<EOF
  (Optional) A configuration for the Auto-mode of the EKS cluster. `auto_mode` as defined below.
    (Optional) `compute` - A configuration for the compute auto-mode. `compute` as defined below.
      (Optional) `enabled` - Whether to enable compute capability on EKS Auto-mode cluster. If the compute capability is enabled, EKS Auto Mode will create and delete EC2 Managed Instances. Defaults to `false`.
      (Optional) `builtin_node_pools` - A set of built-in node pools to enable on the EKS Auto-mode cluster. Valid values are `general-purpose` and `system`. Defaults to both `general-purpose` and `system`.
      (Optional) `node_role` - The ARN of the IAM Role to use for the EKS Auto-mode cluster nodes. If not provided, the default node role will be used if `default_node_role.enabled` is `true`. This value cannot be changed after the compute capability of EKS Auto Mode is enabled.
    (Optional) `network` - A configuration for the network auto-mode. `network` as defined below.
      (Optional) `elastic_load_balancing` - A configuration for the elastic load balancing capability on EKS Auto-mode cluster. `elastic_load_balancing` as defined below.
        (Optional) `enabled` - Whether to enable elastic load balancing capability on EKS auto-mode cluster. If the load balancing capability is enabled, EKS Auto Mode will create and delete load balancers. Defaults to `false`.
    (Optional) `storage` - A configuration for the storage auto-mode. `storage` as defined below.
      (Optional) `block_storage` - A configuration for the block storage of EKS auto-mode. `block_storage` as defined below.
        (Optional) `enabled` - Whether to enable block storage capability on EKS Auto-mode cluster. If the block storage capability is enabled, EKS Auto Mode will create and delete block storage volumes. Defaults to `false`.
  EOF
  type = object({
    compute = optional(object({
      enabled            = optional(bool, false)
      builtin_node_pools = optional(set(string), ["general-purpose", "system"])
      node_role          = optional(string)
    }), {})
    network = optional(object({
      elastic_load_balancing = optional(object({
        enabled = optional(bool, false)
      }), {})
    }), {})
    storage = optional(object({
      block_storage = optional(object({
        enabled = optional(bool, false)
      }), {})
    }), {})
  })
  default  = {}
  nullable = false

  validation {
    condition = alltrue([
      for node_pool in var.auto_mode.compute.builtin_node_pools :
      contains(["general-purpose", "system"], node_pool)
    ])
    error_message = "Valid values for `auto_mode.compute.builtin_node_pools` are `general-purpose` and `system`."
  }
}

variable "arc_zonal_shift" {
  description = <<EOF
  (Optional) A configuration for the ARC zonal shift for the EKS cluster. `arc_zonal_shift` as defined below.
    (Optional) `enabled` - Whether to enable ARC zonal shift for the EKS cluster. Defaults to `false`.
  EOF
  type = object({
    enabled = optional(bool, false)
  })
  default  = {}
  nullable = false
}

variable "subnets" {
  description = "(Required) A list of subnet IDs. Must be in at least two different availability zones. Amazon EKS creates cross-account elastic network interfaces in these subnets to allow communication between your worker nodes and the Kubernetes control plane."
  type        = list(string)
  nullable    = false

  validation {
    condition     = length(var.subnets) > 1
    error_message = "Must be in at least two different availability zones."
  }
}

variable "additional_security_groups" {
  description = "(Optional) A list of additional security group IDs to associate with the Kubernetes API server endpoint. The cluster security group always attached to the endpoint. You can specify additional security groups to use for the endpoint using this argument. Defaults to `[]`."
  type        = list(string)
  default     = []
  nullable    = false
}

variable "endpoint_access" {
  description = <<EOF
  (Optional) A configuration for the endpoint access to the Kubernetes API server endpoint. `endpoint_access` as defined below.
    (Optional) `private_access_enabled` - Whether to enable private access for your cluster's Kubernetes API server endpoint. If you enable private access, Kubernetes API requests from within your cluster's VPC use the private VPC endpoint. Defaults to `true`. If you disable private access and you have nodes or Fargate pods in the cluster, then ensure that `public_access_cidrs` includes the necessary CIDR blocks for communication with the nodes or Fargate pods.
    (Optional) `private_access_cidrs` - A list of allowed CIDR to communicate to the Amazon EKS private API server endpoint.
    (Optional) `private_access_security_groups` - A list of allowed source security group to communicate to the Amazon EKS private API server endpoint.
    (Optional) `public_access_enabled` - Whether to enable public access to your cluster's Kubernetes API server endpoint. If you disable public access, your cluster's Kubernetes API server can only receive requests from within the cluster VPC. Defaults to `false`.
    (Optional) `public_access_cidrs` - A list of CIDR blocks that are allowed access to your cluster's public Kubernetes API server endpoint. Defaults to `0.0.0.0/0` .
  EOF
  type = object({
    private_access_enabled         = optional(bool, true)
    private_access_cidrs           = optional(list(string), [])
    private_access_security_groups = optional(list(string), [])

    public_access_enabled = optional(bool, false)
    public_access_cidrs   = optional(list(string), ["0.0.0.0/0"])
  })
  default  = {}
  nullable = false
}

variable "outpost_config" {
  description = <<EOF
  (Optional) A configuration of the outpost for the EKS cluster. `outpost_config` as defined below.
    (Required) `outposts` - A set of the Outpost ARNs that you want to use for your local Amazon EKS cluster on Outposts.
    (Required) `control_plane` - A configuration of the local EKS control plane node on Outposts. `control_plane` as defined below.
      (Required) `instance_type` - The Amazon EC2 instance type that you want to use for your local Amazon EKS cluster on Outposts. The instance type that you specify is used for all Kubernetes control plane instances. The instance type can't be changed after cluster creation. Choose an instance type based on the number of nodes that your cluster will have.
        - 1–20 nodes, then we recommend specifying a large instance type.
        - 21–100 nodes, then we recommend specifying an xlarge instance type.
        - 101–250 nodes, then we recommend specifying a 2xlarge instance type.
      (Optional) `placement_group` - The name of the placement group for the Kubernetes control plane instances. This setting can't be changed after cluster creation.
  EOF
  type = object({
    outposts = set(string)
    control_plane = object({
      instance_type   = string
      placement_group = optional(string)
    })
  })
  default  = null
  nullable = true
}

variable "kubernetes_network_config" {
  description = <<EOF
  (Optional) A configuration of Kubernetes network. `kubernetes_network_config` as defined below.
    (Optional) `service_ipv4_cidr` - The CIDR block to assign Kubernetes pod and service IP addresses from. If you don't specify a block, Kubernetes assigns addresses from either the `10.100.0.0/16` or `172.20.0.0/16` CIDR blocks. We recommend that you specify a block that does not overlap with resources in other networks that are peered or connected to your VPC. You can only specify a custom CIDR block when you create a cluster, changing this value will force a new cluster to be created.
    (Optional) `ip_family` - The IP family used to assign Kubernetes pod and service addresses. Valid values are `IPv4` and `IPv6`. Defaults to `IPv4`. You can only specify an IP family when you create a cluster, changing this value will force a new cluster to be created.
  EOF
  type = object({
    service_ipv4_cidr = optional(string)
    ip_family         = optional(string, "IPv4")
  })
  default  = {}
  nullable = false

  validation {
    condition     = contains(["IPv4", "IPv6"], var.kubernetes_network_config.ip_family)
    error_message = "Valid values for `kubernetes_network_config.ip_family` are `IPv4` and `IPv6`."
  }
}

variable "remote_network_config" {
  description = <<EOF
  (Optional) A configuration of remote network for the EKS Hybrid nodes. `remote_network_config` as defined below.
    (Optional) `node_ipv4_cidrs` - A set of IPv4 CIDR blocks for the EKS Hybrid nodes.
    (Optional) `pod_ipv4_cidrs` - A set of IPv4 CIDR blocks for the pods running on the EKS Hybrid nodes.
  EOF
  type = object({
    node_ipv4_cidrs = optional(set(string), [])
    pod_ipv4_cidrs  = optional(set(string), [])
  })
  default  = {}
  nullable = false
}

variable "authentication_mode" {
  description = <<EOF
  (Optional) The authentication mode for the cluster. Valid values are `CONFIG_MAP`, `API` or `API_AND_CONFIG_MAP`. Defaults to `API_AND_CONFIG_MAP`.
  EOF
  type        = string
  default     = "API_AND_CONFIG_MAP"
  nullable    = false

  validation {
    condition     = contains(["CONFIG_MAP", "API", "API_AND_CONFIG_MAP"], var.authentication_mode)
    error_message = "Valid values for `authentication_mode` are `CONFIG_MAP`, `API` or `API_AND_CONFIG_MAP`."
  }
}

variable "bootstrap_cluster_creator_admin_access" {
  description = <<EOF
  (Optional) Whether to set the cluster creator IAM principal as a cluster admin access entry during cluster creation time. Defaults to `false`.
  EOF
  type        = bool
  default     = false
  nullable    = false
}

variable "bootstrap_self_managed_addons" {
  description = <<EOF
  (Optional) Whether to install the self-managed core add-ons (kube-proxy, CoreDNS, and VPC CNI) during cluster creation time. If false, you must manually install desired add-ons. Changing this value will force a new cluster to be created. Defaults to `true`.
  EOF
  type        = bool
  default     = true
  nullable    = false
}

variable "secrets_encryption" {
  description = <<EOF
  (Optional) A configuration to encrypt Kubernetes secrets. Envelope encryption provides an additional layer of encryption for your Kubernetes secrets. Once turned on, secrets encryption cannot be modified or removed. `secrets_encryption` as defined below.
    (Optional) `enabled` - Whether to enable envelope encryption of Kubernetes secrets. Defaults to `false`.
    (Optional) `kms_key` - The ID of AWS KMS key to use for envelope encryption of Kubernetes secrets. The CMK must be symmetric, created in the same region as the cluster, and if the CMK was created in a different account, the user must have access to the CMK.
  EOF
  type = object({
    enabled = optional(bool, false)
    kms_key = optional(string)
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

variable "default_node_role" {
  description = <<EOF
  (Optional) A configuration for the default IAM role for EKS nodes. `default_node_role` as defined below.
    (Optional) `enabled` - Whether to create the default node role. Defaults to `false`.
    (Optional) `name` - The name of the default node role. Defaults to `eks-$${var.name}-node`.
    (Optional) `path` - The path of the default node role. Defaults to `/`.
    (Optional) `description` - The description of the default node role.
    (Optional) `policies` - A list of IAM policy ARNs to attach to the default node role. `AmazonEKSWorkerNodePolicy`, `AmazonEC2ContainerRegistryReadOnly` are always attached. Defaults to `[]`.
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

variable "logging" {
  description = <<EOF
  (Optional) A configuration for the control plane logging. `logging` as defined below.
    (Optional) `enabled` - Whether to enable control plane logging. Defaults to `false`.
    (Optional) `log_types` - A set of the desired control plane logging to enable. Valid values are `api`, `audit`, `authenticator`, `controllerManager`, `scheduler`. Defaults to all.
  EOF
  type = object({
    enabled   = optional(bool, false)
    log_types = optional(set(string), ["api", "audit", "authenticator", "controllerManager", "scheduler"])
  })
  default  = {}
  nullable = false

  validation {
    condition = alltrue([
      for log_type in var.logging.log_types :
      contains(["api", "audit", "authenticator", "controllerManager", "scheduler"], log_type)
    ])
    error_message = "Valid values for `logging.log_types` are `api`, `audit`, `authenticator`, `controllerManager`, `scheduler`."
  }
}

variable "irsa_oidc_provider" {
  description = <<EOF
  (Optional) A configuration for the IAM OIDC provider for the EKS cluster to use IAM Roles for Service Accounts (IRSA). `irsa_oidc_provider` as defined below.
    (Optional) `enabled` - Whether to create the IAM OIDC provider for the EKS cluster. Defaults to `true`.
  EOF
  type = object({
    enabled = optional(bool, true)
  })
  default  = {}
  nullable = false
}

variable "pod_identity_associations" {
  description = <<EOF
  (Optional) A list of Pod Identity Associations to create for the EKS cluster. Each item of `pod_identity_associations` block as defined below.
    (Required) `namespace` - The name of the Kubernetes namespace inside the cluster to create the association in. The service account and the pods that use the service account must be in this namespace.
    (Required) `service_account` - The name of the Kubernetes service account inside the cluster to associate the IAM credentials with.
    (Required) `role` - The ARN (Amazon Resource Name) of the IAM Role to associate with the service account. The EKS Pod Identity agent manages credentials to assume this role for applications in the containers in the pods that use this service account.
    (Optional) `target_role` - The ARN (Amazon Resource Name) of the IAM Role to be chained to the the IAM role specified as `role`.
    (Optional) `session_tagging_enabled` - Whether to enable the automatic sessions tags that are appended by EKS Pod Identity. EKS Pod Identity adds a pre-defined set of session tags when it assumes the role. You can use these tags to author a single role that can work across resources by allowing access to AWS resources based on matching tags. By default, EKS Pod Identity attaches six tags, including tags for cluster name, namespace, and service account name. Defaults to `true`.
    (Optional) `tags` - A map of tags to add to the Pod Identity Association.
  EOF
  type = list(object({
    namespace               = string
    service_account         = string
    role                    = string
    target_role             = optional(string)
    session_tagging_enabled = optional(bool, true)
    tags                    = optional(map(string), {})
  }))
  default  = []
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

variable "resource_group" {
  description = <<EOF
  (Optional) A configurations of Resource Group for this module. `resource_group` as defined below.
    (Optional) `enabled` - Whether to create Resource Group to find and group AWS resources which are created by this module. Defaults to `true`.
    (Optional) `name` - The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`. If not provided, a name will be generated using the module name and instance name.
    (Optional) `description` - The description of Resource Group. Defaults to `Managed by Terraform.`.
  EOF
  type = object({
    enabled     = optional(bool, true)
    name        = optional(string, "")
    description = optional(string, "Managed by Terraform.")
  })
  default  = {}
  nullable = false
}
