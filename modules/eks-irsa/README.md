# eks-irsa

This module creates following resources.

- `aws_iam_role`
- `aws_iam_role_policy` (optional)
- `aws_iam_role_policy_attachment` (optional)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |
| aws | >= 3.30 |

## Providers

No provider.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Desired name of the IAM role for EKS service accounts. | `string` | n/a | yes |
| oidc\_provider\_urls | A list of URLs of OIDC identity providers. | `list(string)` | n/a | yes |
| conditions | Required conditions to assume the role. | <pre>list(object({<br>    key       = string<br>    condition = string<br>    values    = list(string)<br>  }))</pre> | `[]` | no |
| description | The description of the role. | `string` | `""` | no |
| effective\_date | Allow to assume IAM role only after a specific date and time. | `string` | `null` | no |
| expiration\_date | Allow to assume IAM role only before a specific date and time. | `string` | `null` | no |
| force\_detach\_policies | Specifies to force detaching any policies the role has before destroying it. | `bool` | `false` | no |
| inline\_policies | Map of inline IAM policies to attach to IAM role. (`name` => `policy`). | `map(string)` | `{}` | no |
| max\_session\_duration | Maximum CLI/API session duration in seconds between 3600 and 43200. | `number` | `3600` | no |
| path | Desired path of the IAM role for EKS service accounts. | `string` | `"/"` | no |
| permissions\_boundary | The ARN of the policy that is used to set the permissions boundary for the role. | `string` | `""` | no |
| policies | List of IAM policies ARNs to attach to IAM role. | `list(string)` | `[]` | no |
| source\_ip\_blacklist | A list of source IP addresses or CIDRs denied to assume IAM role from. | `list(string)` | `[]` | no |
| source\_ip\_whitelist | A list of source IP addresses or CIDRs allowed to assume IAM role from. | `list(string)` | `[]` | no |
| tags | A map of tags to add to all resources. | `map(string)` | `{}` | no |
| trusted\_oidc\_conditions | Required conditions to assume the role for OIDC providers. | <pre>list(object({<br>    key       = string<br>    condition = string<br>    values    = list(string)<br>  }))</pre> | `[]` | no |
| trusted\_service\_accounts | A list of Kubernetes service accounts which could be trusted to assume the role. The format should be `<namespace>:<service-account>`. The values can include a multi-character match wildcard (\*) or a single-character match wildcard (?) anywhere in the string. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | The ARN assigned by AWS for this role. |
| description | The description of the role. |
| effective\_date | Allow to assume IAM role only after this date and time. |
| expiration\_date | Allow to assume IAM role only before this date and time. |
| inline\_policies | List of names of inline IAM polices which are attached to IAM role. |
| name | IAM Role name. |
| policies | List of ARNs of IAM policies which are atached to IAM role. |
| source\_ip\_blacklist | A list of source IP addresses or CIDRs denied to assume IAM role from. |
| source\_ip\_whitelist | A list of source IP addresses or CIDRs allowed to assume IAM role from. |
| unique\_id | The unique ID assigned by AWS. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
