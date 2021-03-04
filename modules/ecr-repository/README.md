# ecr-repository

This module creates following resources.

- `aws_ecr_repository`
- `aws_ecr_repository_policy` (optional)
- `aws_ecr_lifecycle_policy` (optional)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |
| aws | >= 3.30 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 3.30 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Desired name for the repository. | `string` | n/a | yes |
| encryption\_enabled | Enable Encryption for repository. | `bool` | `false` | no |
| encryption\_kms\_key | The ARN of the KMS key to use when encryption\_type is `KMS`. If not specified, uses the default AWS managed key for ECR. | `string` | `null` | no |
| encryption\_type | The encryption type to use for the repository. Valid values are `AES256` or `KMS`. | `string` | `"AES256"` | no |
| image\_scan\_on\_push\_enabled | Indicates whether images are scanned after being pushed to the repository or not scanned. | `bool` | `false` | no |
| image\_tag\_immutable\_enabled | Should be true if you want to disable to modify image tags. | `bool` | `false` | no |
| lifecycle\_policy | The policy document for ECR Repository Lifecycle. This is a JSON formatted string. | `string` | `""` | no |
| repository\_policy | The policy document for ECR Repository. This is a JSON formatted string. | `string` | `""` | no |
| tags | A map of tags to add to all resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | The ARN of the repository. |
| name | The name of the repository. |
| registry\_id | The registry ID where the repository was created. |
| url | The URL of the repository (in the form aws\_account\_id.dkr.ecr.region.amazonaws.com/repositoryName). |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
