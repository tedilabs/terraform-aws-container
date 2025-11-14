# ecr-registry

This module creates following resources.

- `aws_ecr_account_setting`
- `aws_ecr_registry_policy` (optional)
- `aws_ecr_registry_scanning_configuration`
- `aws_ecr_replication_configuration` (optional)
- `aws_ecr_pull_through_cache_rule` (optional)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.12 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.12 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.21.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ecr_account_setting.basic_scan_type_version](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_account_setting) | resource |
| [aws_ecr_account_setting.registry_policy_scope](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_account_setting) | resource |
| [aws_ecr_pull_through_cache_rule.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_pull_through_cache_rule) | resource |
| [aws_ecr_registry_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_registry_policy) | resource |
| [aws_ecr_registry_scanning_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_registry_scanning_configuration) | resource |
| [aws_ecr_replication_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_replication_configuration) | resource |
| [aws_caller_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.pull_through_cache](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.replication](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_policy"></a> [policy](#input\_policy) | (Optional) The policy document for ECR registry. This is a JSON formatted string. | `string` | `null` | no |
| <a name="input_policy_version"></a> [policy\_version](#input\_policy\_version) | (Optional) The policy version of ECR registry. Valid values are `V1` or `V2`. Defaults to `V2`.<br/>    `V1` - Only support three actions: `ReplicateImage`, `BatchImportUpstreamImage`, and `CreateRepository`<br/>    `V2` - Support all ECR actions in the policy and enforce the registry policy in all ECR requests | `string` | `"V2"` | no |
| <a name="input_pull_through_cache_policies"></a> [pull\_through\_cache\_policies](#input\_pull\_through\_cache\_policies) | (Optional) A list of ECR Registry Policies for Pull Through Cache. Each block of `pull_through_cache_policies` as defined below.<br/>    (Required) `iam_entities` - One or more IAM principals to grant permission. Support the ARN of IAM entities, or AWS account ID.<br/>    (Optional) `allow_create_repository` - Whether to auto-create the cached repositories with the same name within the current registry. Defaults to `false`.<br/>    (Required) `repositories` - A list of target repositories. Support glob expressions for `repositories` like `*`. | <pre>list(object({<br/>    iam_entities            = list(string)<br/>    allow_create_repository = optional(bool, false)<br/>    repositories            = list(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_pull_through_cache_rules"></a> [pull\_through\_cache\_rules](#input\_pull\_through\_cache\_rules) | (Optional) A list of Pull Through Cache Rules for ECR registry. A `pull_through_cache_rules` block as defined below.<br/>    (Required) `upstream_url` - The registry URL of the upstream registry to use as the source.<br/>    (Optional) `upstream_prefix` - The upstream repository prefix associated with the pull through cache rule. Used if the upstream registry is an ECR private registry. Defaults to `ROOT`.<br/>    (Optional) `namespace` - The repository name prefix to use when caching images from the source registry. Default value is used if not provided.<br/>    (Optional) `credential` - The configuration for credential to use to authenticate against the registry. A `credential` block as defined below.<br/>      (Required) `secretsmanager_secret` - The ARN of the Secrets Manager secret to use for authentication.<br/>      (Optional) `iam_role` - The ARN of the IAM role associated with the pull through cache rule. Must be specified if the upstream registry is a cross-account ECR private registry. | <pre>list(object({<br/>    upstream_url    = string<br/>    upstream_prefix = optional(string, "ROOT")<br/>    namespace       = optional(string)<br/>    credential = optional(object({<br/>      secretsmanager_secret = string<br/>      iam_role              = optional(string)<br/>    }))<br/>  }))</pre> | `[]` | no |
| <a name="input_region"></a> [region](#input\_region) | (Optional) The region in which to create the module resources. If not provided, the module resources will be created in the provider's configured region. | `string` | `null` | no |
| <a name="input_replication_policies"></a> [replication\_policies](#input\_replication\_policies) | (Optional) A list of replication policies for ECR Registry. Each block of `replication_policies` as defined below.<br/>    (Required) `account` - The AWS account ID of the source registry owner.<br/>    (Optional) `allow_create_repository` - Whether to auto-create the replicated repositories with the same name within the current registry. Defaults to `false`.<br/>    (Required) `repositories` - A list of target repositories. Support glob expressions like `*`. | <pre>list(object({<br/>    account                 = string<br/>    allow_create_repository = optional(bool, false)<br/>    repositories            = list(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_replication_rules"></a> [replication\_rules](#input\_replication\_rules) | (Optional) A list of replication rules for ECR Registry. Each rule represents the replication destinations and repository filters for a replication configuration. Each block of `replication_rules` as defined below.<br/>    (Required) `destinations` - A list of destinations for replication rule. Each block of `destinations` as defined below.<br/>      (Optional) `account` - The AWS account ID of the ECR private registry to replicate to. Only required for cross-account replication.<br/>      (Required) `region` - The Region to replicate to.<br/>    (Optional) `filters` - The filter settings used with image replication. Specifying a repository filter to a replication rule provides a method for controlling which repositories in a private registry are replicated. If no filters are added, the contents of all repositories are replicated. Each block of `filters` as defined below.<br/>      (Optional) `type` - The repository filter type. The only supported value is `PREFIX_MATCH`, which is a repository name prefix. Defaults to `PREFIX_MATCH`.<br/>      (Required) `value` - The repository filter value. | <pre>list(object({<br/>    destinations = list(object({<br/>      account = optional(string)<br/>      region  = string<br/>    }))<br/>    filters = optional(list(object({<br/>      type  = optional(string, "PREFIX_MATCH")<br/>      value = string<br/>    })), [])<br/>  }))</pre> | `[]` | no |
| <a name="input_scanning_basic_version"></a> [scanning\_basic\_version](#input\_scanning\_basic\_version) | (Optional) The version of basic scanning for the registry. Valid values are `AWS_NATIVE` or `CLAIR`. Defaults to `AWS_NATIVE`. `CLAIR` was deprecated. | `string` | `"AWS_NATIVE"` | no |
| <a name="input_scanning_rules"></a> [scanning\_rules](#input\_scanning\_rules) | (Optional) A list of scanning rules to determine which repository filters are used and at what frequency scanning will occur. Each block of `scanning_rules` as defined below.<br/>    (Required) `frequency` - The frequency that scans are performed at for a private registry. Valid values are `SCAN_ON_PUSH`, `CONTINUOUS_SCAN` and `MANUAL`.<br/><br/>      - When the `ENHANCED` scan type is specified, the supported scan frequencies are `CONTINUOUS_SCAN` and `SCAN_ON_PUSH`.<br/>      - When the `BASIC` scan type is specified, the `SCAN_ON_PUSH` scan frequency is supported. If scan on push is not specified, then the `MANUAL` scan frequency is set by default.<br/>    (Optional) `filters` - The configuration of repository filters for image scanning.<br/>      (Optional) `type` - The repository filter type. The only supported value is `WILDCARD`. A filter with no wildcard will match all repository names that contain the filter. A filter with a wildcard (*) matches on any repository name where the wildcard replaces zero or more characters in the repository name. Defaults to `WILDCARD`.<br/>      (Required) `value` - The repository filter value. | <pre>list(object({<br/>    frequency = string<br/>    filters = optional(list(object({<br/>      type  = optional(string, "WILDCARD")<br/>      value = string<br/>    })), [])<br/>  }))</pre> | `[]` | no |
| <a name="input_scanning_type"></a> [scanning\_type](#input\_scanning\_type) | (Optional) The scanning type to set for the registry. Valid values are `ENHANCED` or `BASIC`. Defaults to `BASIC`. | `string` | `"BASIC"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the registry. |
| <a name="output_name"></a> [name](#output\_name) | The name of the registry. |
| <a name="output_policy"></a> [policy](#output\_policy) | The registry policy. |
| <a name="output_policy_version"></a> [policy\_version](#output\_policy\_version) | The policy version of ECR registry. |
| <a name="output_pull_through_cache_policies"></a> [pull\_through\_cache\_policies](#output\_pull\_through\_cache\_policies) | A list of Pull Through Cache policies for ECR Registry. |
| <a name="output_pull_through_cache_rules"></a> [pull\_through\_cache\_rules](#output\_pull\_through\_cache\_rules) | A list of Pull Through Cache Rules for ECR registry. |
| <a name="output_region"></a> [region](#output\_region) | The AWS region this module resources resides in. |
| <a name="output_replication_policies"></a> [replication\_policies](#output\_replication\_policies) | A list of replication policies for ECR Registry. |
| <a name="output_replication_rules"></a> [replication\_rules](#output\_replication\_rules) | A list of replication rules for ECR Registry. |
| <a name="output_scanning_basic_version"></a> [scanning\_basic\_version](#output\_scanning\_basic\_version) | The version of basic scanning for the registry. |
| <a name="output_scanning_rules"></a> [scanning\_rules](#output\_scanning\_rules) | A list of scanning rules to determine which repository filters are used and at what frequency scanning will occur. |
| <a name="output_scanning_type"></a> [scanning\_type](#output\_scanning\_type) | The scanning type to set for the registry. |
<!-- END_TF_DOCS -->
