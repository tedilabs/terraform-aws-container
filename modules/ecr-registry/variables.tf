variable "region" {
  description = "(Optional) The region in which to create the module resources. If not provided, the module resources will be created in the provider's configured region."
  type        = string
  default     = null
  nullable    = true
}

variable "policy_version" {
  description = <<EOF
  (Optional) The policy version of ECR registry. Valid values are `V1` or `V2`. Defaults to `V2`.
    `V1` - Only support three actions: `ReplicateImage`, `BatchImportUpstreamImage`, and `CreateRepository`
    `V2` - Support all ECR actions in the policy and enforce the registry policy in all ECR requests
  EOF
  type        = string
  default     = "V2"
  nullable    = false

  validation {
    condition     = contains(["V1", "V2"], var.policy_version)
    error_message = "Valid values for `policy_version` are `V1`, `V2`."
  }
}

variable "policy" {
  description = "(Optional) The policy document for ECR registry. This is a JSON formatted string."
  type        = string
  default     = null
  nullable    = true
}

variable "replication_policies" {
  description = <<EOF
  (Optional) A list of replication policies for ECR Registry. Each block of `replication_policies` as defined below.
    (Required) `account` - The AWS account ID of the source registry owner.
    (Optional) `allow_create_repository` - Whether to auto-create the replicated repositories with the same name within the current registry. Defaults to `false`.
    (Required) `repositories` - A list of target repositories. Support glob expressions like `*`.
  EOF
  type = list(object({
    account                 = string
    allow_create_repository = optional(bool, false)
    repositories            = list(string)
  }))
  default  = []
  nullable = false
}

variable "replication_rules" {
  description = <<EOF
  (Optional) A list of replication rules for ECR Registry. Each rule represents the replication destinations and repository filters for a replication configuration. Each block of `replication_rules` as defined below.
    (Required) `destinations` - A list of destinations for replication rule. Each block of `destinations` as defined below.
      (Optional) `account` - The AWS account ID of the ECR private registry to replicate to. Only required for cross-account replication.
      (Required) `region` - The Region to replicate to.
    (Optional) `filters` - The filter settings used with image replication. Specifying a repository filter to a replication rule provides a method for controlling which repositories in a private registry are replicated. If no filters are added, the contents of all repositories are replicated. Each block of `filters` as defined below.
      (Optional) `type` - The repository filter type. The only supported value is `PREFIX_MATCH`, which is a repository name prefix. Defaults to `PREFIX_MATCH`.
      (Required) `value` - The repository filter value.
  EOF
  type = list(object({
    destinations = list(object({
      account = optional(string)
      region  = string
    }))
    filters = optional(list(object({
      type  = optional(string, "PREFIX_MATCH")
      value = string
    })), [])
  }))
  default  = []
  nullable = false

  validation {
    condition = alltrue([
      for rule in var.replication_rules :
      alltrue([
        for filter in rule.filters :
        contains(["PREFIX_MATCH"], filter.type)
      ])
    ])
    error_message = "Valid values for `type` are `PREFIX_MATCH`."
  }
}

variable "pull_through_cache_policies" {
  description = <<EOF
  (Optional) A list of ECR Registry Policies for Pull Through Cache. Each block of `pull_through_cache_policies` as defined below.
    (Required) `iam_entities` - One or more IAM principals to grant permission. Support the ARN of IAM entities, or AWS account ID.
    (Optional) `allow_create_repository` - Whether to auto-create the cached repositories with the same name within the current registry. Defaults to `false`.
    (Required) `repositories` - A list of target repositories. Support glob expressions for `repositories` like `*`.
  EOF
  type = list(object({
    iam_entities            = list(string)
    allow_create_repository = optional(bool, false)
    repositories            = list(string)
  }))
  default  = []
  nullable = false
}

variable "pull_through_cache_rules" {
  description = <<EOF
  (Optional) A list of Pull Through Cache Rules for ECR registry. A `pull_through_cache_rules` block as defined below.
    (Required) `upstream_url` - The registry URL of the upstream registry to use as the source.
    (Optional) `upstream_prefix` - The upstream repository prefix associated with the pull through cache rule. Used if the upstream registry is an ECR private registry. Defaults to `ROOT`.
    (Optional) `namespace` - The repository name prefix to use when caching images from the source registry. Default value is used if not provided.
    (Optional) `credential` - The configuration for credential to use to authenticate against the registry. A `credential` block as defined below.
      (Required) `secretsmanager_secret` - The ARN of the Secrets Manager secret to use for authentication.
      (Optional) `iam_role` - The ARN of the IAM role associated with the pull through cache rule. Must be specified if the upstream registry is a cross-account ECR private registry.
  EOF
  type = list(object({
    upstream_url    = string
    upstream_prefix = optional(string, "ROOT")
    namespace       = optional(string)
    credential = optional(object({
      secretsmanager_secret = string
      iam_role              = optional(string)
    }))
  }))
  default  = []
  nullable = false
}

variable "scanning_type" {
  description = <<EOF
  (Optional) The scanning type to set for the registry. Valid values are `ENHANCED` or `BASIC`. Defaults to `BASIC`.
  EOF
  type        = string
  default     = "BASIC"
  nullable    = false

  validation {
    condition     = contains(["ENHANCED", "BASIC"], var.scanning_type)
    error_message = "Valid values for `scanning_type` are `ENHANCED`, `BASIC`."
  }
}

variable "scanning_basic_version" {
  description = <<EOF
  (Optional) The version of basic scanning for the registry. Valid values are `AWS_NATIVE` or `CLAIR`. Defaults to `AWS_NATIVE`. `CLAIR` was deprecated.
  EOF
  type        = string
  default     = "AWS_NATIVE"
  nullable    = false

  validation {
    condition     = contains(["AWS_NATIVE", "CLAIR"], var.scanning_basic_version)
    error_message = "Valid values for `scanning_basic_version` are `AWS_NATIVE`, `CLAIR`."
  }
}

variable "scanning_rules" {
  description = <<EOF
  (Optional) A list of scanning rules to determine which repository filters are used and at what frequency scanning will occur. Each block of `scanning_rules` as defined below.
    (Required) `frequency` - The frequency that scans are performed at for a private registry. Valid values are `SCAN_ON_PUSH`, `CONTINUOUS_SCAN` and `MANUAL`.

      - When the `ENHANCED` scan type is specified, the supported scan frequencies are `CONTINUOUS_SCAN` and `SCAN_ON_PUSH`.
      - When the `BASIC` scan type is specified, the `SCAN_ON_PUSH` scan frequency is supported. If scan on push is not specified, then the `MANUAL` scan frequency is set by default.
    (Optional) `filters` - The configuration of repository filters for image scanning.
      (Optional) `type` - The repository filter type. The only supported value is `WILDCARD`. A filter with no wildcard will match all repository names that contain the filter. A filter with a wildcard (*) matches on any repository name where the wildcard replaces zero or more characters in the repository name. Defaults to `WILDCARD`.
      (Required) `value` - The repository filter value.
  EOF
  type = list(object({
    frequency = string
    filters = optional(list(object({
      type  = optional(string, "WILDCARD")
      value = string
    })), [])
  }))
  default  = []
  nullable = false

  validation {
    condition = alltrue([
      for rule in var.scanning_rules :
      contains(["SCAN_ON_PUSH", "CONTINUOUS_SCAN", "MANUAL"], rule.frequency)
    ])
    error_message = "Valid values for `frequency` are `SCAN_ON_PUSH`, `CONTINUOUS_SCAN` and `MANUAL."
  }

  validation {
    condition = alltrue([
      for rule in var.scanning_rules :
      (
        (var.scanning_type == "ENHANCED" && contains(["CONTINUOUS_SCAN", "SCAN_ON_PUSH"], rule.frequency)) ||
        (var.scanning_type == "BASIC" && contains(["SCAN_ON_PUSH", "MANUAL"], rule.frequency))
      )
    ])
    error_message = "For `ENHANCED` scanning_type, valid frequencies are `CONTINUOUS_SCAN` and `SCAN_ON_PUSH`. For `BASIC` scanning_type, valid frequencies are `SCAN_ON_PUSH` and `MANUAL`."
  }

  validation {
    condition = alltrue([
      for rule in var.scanning_rules :
      alltrue([
        for filter in rule.filters :
        contains(["WILDCARD"], filter.type)
      ])
    ])
    error_message = "Valid values for `type` are `WILDCARD`."
  }
}
