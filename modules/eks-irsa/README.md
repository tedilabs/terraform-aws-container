# eks-irsa

This module creates following resources.

- `aws_iam_role`
- `aws_iam_role_policy` (optional)
- `aws_iam_role_policy_attachment` (optional)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.45 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.71.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_this"></a> [this](#module\_this) | tedilabs/account/aws//modules/iam-role | 0.19.0 |

## Resources

| Name | Type |
|------|------|
| [aws_resourcegroups_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/resourcegroups_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | (Required) Desired name of the IAM role for EKS service accounts. | `string` | n/a | yes |
| <a name="input_oidc_provider_urls"></a> [oidc\_provider\_urls](#input\_oidc\_provider\_urls) | (Required) A list of URLs of OIDC identity providers. | `list(string)` | n/a | yes |
| <a name="input_assumable_roles"></a> [assumable\_roles](#input\_assumable\_roles) | (Optional) List of IAM roles ARNs which can be assumed by the role. | `list(string)` | `[]` | no |
| <a name="input_conditions"></a> [conditions](#input\_conditions) | (Optional) Required conditions to assume the role. | <pre>list(object({<br>    key       = string<br>    condition = string<br>    values    = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_description"></a> [description](#input\_description) | (Optional) The description of the role. | `string` | `""` | no |
| <a name="input_effective_date"></a> [effective\_date](#input\_effective\_date) | (Optional) Allow to assume IAM role only after a specific date and time. | `string` | `null` | no |
| <a name="input_expiration_date"></a> [expiration\_date](#input\_expiration\_date) | (Optional) Allow to assume IAM role only before a specific date and time. | `string` | `null` | no |
| <a name="input_force_detach_policies"></a> [force\_detach\_policies](#input\_force\_detach\_policies) | (Optional) Specifies to force detaching any policies the role has before destroying it. | `bool` | `false` | no |
| <a name="input_inline_policies"></a> [inline\_policies](#input\_inline\_policies) | (Optional) Map of inline IAM policies to attach to IAM role. (`name` => `policy`). | `map(string)` | `{}` | no |
| <a name="input_max_session_duration"></a> [max\_session\_duration](#input\_max\_session\_duration) | (Optional) Maximum CLI/API session duration in seconds between 3600 and 43200. | `number` | `3600` | no |
| <a name="input_mfa_required"></a> [mfa\_required](#input\_mfa\_required) | (Optional) Whether MFA should be required to assume the role. | `bool` | `false` | no |
| <a name="input_mfa_ttl"></a> [mfa\_ttl](#input\_mfa\_ttl) | (Optional) Max age of valid MFA (in seconds) for roles which require MFA. | `number` | `86400` | no |
| <a name="input_module_tags_enabled"></a> [module\_tags\_enabled](#input\_module\_tags\_enabled) | (Optional) Whether to create AWS Resource Tags for the module informations. | `bool` | `true` | no |
| <a name="input_path"></a> [path](#input\_path) | (Optional) Desired path of the IAM role for EKS service accounts. | `string` | `"/"` | no |
| <a name="input_permissions_boundary"></a> [permissions\_boundary](#input\_permissions\_boundary) | (Optional) The ARN of the policy that is used to set the permissions boundary for the role. | `string` | `""` | no |
| <a name="input_policies"></a> [policies](#input\_policies) | (Optional) List of IAM policies ARNs to attach to IAM role. | `list(string)` | `[]` | no |
| <a name="input_resource_group_description"></a> [resource\_group\_description](#input\_resource\_group\_description) | (Optional) The description of Resource Group. | `string` | `"Managed by Terraform."` | no |
| <a name="input_resource_group_enabled"></a> [resource\_group\_enabled](#input\_resource\_group\_enabled) | (Optional) Whether to create Resource Group to find and group AWS resources which are created by this module. | `bool` | `true` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Optional) The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`. | `string` | `""` | no |
| <a name="input_source_ip_blacklist"></a> [source\_ip\_blacklist](#input\_source\_ip\_blacklist) | (Optional) A list of source IP addresses or CIDRs denied to assume IAM role from. | `list(string)` | `[]` | no |
| <a name="input_source_ip_whitelist"></a> [source\_ip\_whitelist](#input\_source\_ip\_whitelist) | (Optional) A list of source IP addresses or CIDRs allowed to assume IAM role from. | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A map of tags to add to all resources. | `map(string)` | `{}` | no |
| <a name="input_trusted_iam_entities"></a> [trusted\_iam\_entities](#input\_trusted\_iam\_entities) | (Optional) A list of ARNs of AWS IAM entities who can assume the role. | `list(string)` | `[]` | no |
| <a name="input_trusted_oidc_conditions"></a> [trusted\_oidc\_conditions](#input\_trusted\_oidc\_conditions) | (Optional) Required conditions to assume the role for OIDC providers. | <pre>list(object({<br>    key       = string<br>    condition = string<br>    values    = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_trusted_service_accounts"></a> [trusted\_service\_accounts](#input\_trusted\_service\_accounts) | (Optional) A list of Kubernetes service accounts which could be trusted to assume the role. The format should be `<namespace>:<service-account>`. The values can include a multi-character match wildcard (*) or a single-character match wildcard (?) anywhere in the string. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN assigned by AWS for this role. |
| <a name="output_assumable_roles"></a> [assumable\_roles](#output\_assumable\_roles) | List of ARNs of IAM roles which members of IAM role can assume. |
| <a name="output_description"></a> [description](#output\_description) | The description of the role. |
| <a name="output_effective_date"></a> [effective\_date](#output\_effective\_date) | Allow to assume IAM role only after this date and time. |
| <a name="output_expiration_date"></a> [expiration\_date](#output\_expiration\_date) | Allow to assume IAM role only before this date and time. |
| <a name="output_inline_policies"></a> [inline\_policies](#output\_inline\_policies) | List of names of inline IAM polices which are attached to IAM role. |
| <a name="output_mfa_required"></a> [mfa\_required](#output\_mfa\_required) | Whether MFA should be required to assume the role. |
| <a name="output_mfa_ttl"></a> [mfa\_ttl](#output\_mfa\_ttl) | Max age of valid MFA (in seconds) for roles which require MFA. |
| <a name="output_name"></a> [name](#output\_name) | IAM Role name. |
| <a name="output_policies"></a> [policies](#output\_policies) | List of ARNs of IAM policies which are atached to IAM role. |
| <a name="output_source_ip_blacklist"></a> [source\_ip\_blacklist](#output\_source\_ip\_blacklist) | A list of source IP addresses or CIDRs denied to assume IAM role from. |
| <a name="output_source_ip_whitelist"></a> [source\_ip\_whitelist](#output\_source\_ip\_whitelist) | A list of source IP addresses or CIDRs allowed to assume IAM role from. |
| <a name="output_unique_id"></a> [unique\_id](#output\_unique\_id) | The unique ID assigned by AWS. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
