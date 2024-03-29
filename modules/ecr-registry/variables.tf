variable "policy" {
  description = "(Optional) The policy document for ECR registry. This is a JSON formatted string."
  type        = string
  default     = null
}

variable "replication_policies" {
  description = "(Optional) A list of ECR Registry Policies for replication. `account_id` is source AWS account for replication. If `allow_create_repository` is false, you need to create repositories with the same name whithin your registry. `repositories` is a list of target repositories. Support glob expressions for `repositories` like `*`."
  type = list(object({
    account_id              = string
    allow_create_repository = bool
    repositories            = list(string)
  }))
  default  = []
  nullable = false
}

variable "replication_destinations" {
  description = "(Optional) A list of destinations for ECR registry replication. `registry_id` is the account ID of the destination registry to replicate to. `region` is required to replicate to."
  type = list(object({
    registry_id = string
    region      = string
  }))
  default  = []
  nullable = false
}

variable "pull_through_cache_policies" {
  description = <<EOF
  (Optional) A list of ECR Registry Policies for Pull Through Cache. Each value of `pull_through_cache_policies` as defined below.
    (Required) `iam_entities` - Specify one or more IAM principals to grant permission. Support the ARN of IAM entities, or AWS account ID.
    (Required) `allow_create_repository` - Need to create target repositories if `allow_create_repository` is false.
    (Required) `repositories` - A list of target repositories. Support glob expressions for `repositories` like `*`.
  EOF
  type = list(object({
    iam_entities            = list(string)
    allow_create_repository = bool
    repositories            = list(string)
  }))
  default  = []
  nullable = false
}

variable "pull_through_cache_rules" {
  description = <<EOF
  (Optional) A list of Pull Through Cache Rules for ECR registry. A `pull_through_cache_rules` block as defined below.
    (Required) `upstream_url` - The registry URL of the upstream public registry to use as the source.
    (Optional) `namespace` - The repository name prefix to use when caching images from the source registry. Default value is used if not provided.
  EOF
  type        = list(any)
  default     = []
  nullable    = false
}

variable "scanning_type" {
  description = "(Optional) The scanning type to set for the registry. Can be either `ENHANCED` or `BASIC`."
  type        = string
  default     = "BASIC"
  nullable    = false
}

variable "scanning_on_push_filters" {
  description = "(Optional) A list of repository filter to scan on push. Wildcard character is allowed."
  type        = list(string)
  default     = []
  nullable    = false
}

variable "scanning_continuous_filters" {
  description = "(Optional) A list of repository filter to scan continuous. Wildcard character is allowed."
  type        = list(string)
  default     = []
  nullable    = false
}
