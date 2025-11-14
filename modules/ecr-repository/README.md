# ecr-repository

This module creates following resources.

- `aws_ecr_repository`
- `aws_ecr_repository_policy` (optional)
- `aws_ecr_lifecycle_policy` (optional)

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

| Name | Source | Version |
|------|--------|---------|
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | tedilabs/misc/aws//modules/resource-group | ~> 0.12.0 |

## Resources

| Name | Type |
|------|------|
| [aws_ecr_lifecycle_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_lifecycle_policy) | resource |
| [aws_ecr_repository.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_ecr_repository_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository_policy) | resource |
| [aws_ecr_lifecycle_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ecr_lifecycle_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_image_tag_mutability"></a> [image\_tag\_mutability](#input\_image\_tag\_mutability) | (Optional) The image tag mutability setting for the repository. `image_tag_mutability` as defined below.<br/>    (Optional) `mode` - The tag mutability setting for the repository. Valid values are `MUTABLE`, `IMMUTABLE`, `MUTABLE_WITH_EXCLUSION` and `IMMUTABLE_WITH_EXCLUSION`. Defaults to `MUTABLE`.<br/>    (Optional) `exclusion_filters` - A list of tag exclusion filters for the repository. Each block of `exclusion_filters` as defined below.<br/>      (Optional) `type` - The type of filter to use. The only supported value is `WILDCARD`. Defaults to `WILDCARD`.<br/><br/>      (Required) `value` - The filter pattern to use for excluding image tags from the mutability setting. | <pre>object({<br/>    mode = optional(string, "MUTABLE")<br/>    exclusion_filters = optional(list(object({<br/>      type  = optional(string, "WILDCARD")<br/>      value = string<br/>    })), [])<br/>  })</pre> | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | (Required) Desired name for the repository. | `string` | n/a | yes |
| <a name="input_encryption"></a> [encryption](#input\_encryption) | (Optional) The encryption configuration of the repository. `encryption` as defined below.<br/>    (Optional) `type` - The encryption type to use for the repository. Valid values are `AES256` or `KMS`. Defaults to `AES256`.<br/>    (Optional) `kms_key` - The ARN of the KMS key to use for encryption of the repository when `type` is `KMS`. If not specified, uses the default AWS managed key for ECR. | <pre>object({<br/>    type    = optional(string, "AES256")<br/>    kms_key = optional(string)<br/>  })</pre> | `{}` | no |
| <a name="input_force_delete"></a> [force\_delete](#input\_force\_delete) | (Optional) If `true`, will delete the repository even if it contains images. Defaults to `true`. | `bool` | `true` | no |
| <a name="input_image_scan_on_push_enabled"></a> [image\_scan\_on\_push\_enabled](#input\_image\_scan\_on\_push\_enabled) | (Optional, Deprecated) Indicates whether images are scanned after being pushed to the repository or not scanned. This configuration is deprecated in favor of registry level scan filters. Defaults to `false`. | `bool` | `false` | no |
| <a name="input_lifecycle_rules"></a> [lifecycle\_rules](#input\_lifecycle\_rules) | (Optional) A list of Lifecycle rules for ECR repository. Each block of `lifecycle_rules` as defined below.<br/>    (Required) `priority` - The order in which rules are applied, lowest to highest. A lifecycle policy rule with a priority of `1` will be applied first, a rule with priority of `2` will be next, and so on. Must be unique and do not need to be sequential across rules.<br/>    (Optional) `descriptoin` - The description of the rule to describe the purpose of a rule within a lifecycle policy.<br/>    (Required) `target` - The configuration of target images for the rule. `target` as defined below.<br/><br/>      (Required) `status` - Valid values are `tagged`, `untagged`, or `any`. When you specify `tagged` status, either `tag_patterns` or `tag_prefixes` are required, but not both.<br/>      (Optional) `tag_patterns` - A list of tag patterns to filter target images. If you specify multiple tags, only the images with all specified tags are selected. There is a maximum limit of four wildcards (*) per string.<br/>      (Optional) `tag_prefixes` - A list of tag prefixes to filter target images. If you specify multiple prefixes, only the images with all specified prefixes are selected.<br/>    (Required) `expiration` - The configuration of expiration condition for the rule. `expiration` as defined below.<br/><br/>      (Optional) `count` - The maximum number of images to keep.<br/>      (Optional) `days` - The maximum age of days to keep images. | <pre>list(object({<br/>    priority    = number<br/>    description = optional(string, "Managed by Terraform.")<br/><br/>    target = object({<br/>      status       = string<br/>      tag_patterns = optional(list(string), [])<br/>      tag_prefixes = optional(list(string), [])<br/>    })<br/>    expiration = object({<br/>      count = optional(number)<br/>      days  = optional(number)<br/>    })<br/>  }))</pre> | `[]` | no |
| <a name="input_module_tags_enabled"></a> [module\_tags\_enabled](#input\_module\_tags\_enabled) | (Optional) Whether to create AWS Resource Tags for the module informations. | `bool` | `true` | no |
| <a name="input_policy"></a> [policy](#input\_policy) | (Optional) The policy document for ECR Repository. This is a JSON formatted string. | `string` | `""` | no |
| <a name="input_region"></a> [region](#input\_region) | (Optional) The region in which to create the module resources. If not provided, the module resources will be created in the provider's configured region. | `string` | `null` | no |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | (Optional) A configurations of Resource Group for this module. `resource_group` as defined below.<br/>    (Optional) `enabled` - Whether to create Resource Group to find and group AWS resources which are created by this module. Defaults to `true`.<br/>    (Optional) `name` - The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`. If not provided, a name will be generated using the module name and instance name.<br/>    (Optional) `description` - The description of Resource Group. Defaults to `Managed by Terraform.`. | <pre>object({<br/>    enabled     = optional(bool, true)<br/>    name        = optional(string, "")<br/>    description = optional(string, "Managed by Terraform.")<br/>  })</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A map of tags to add to all resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the repository. |
| <a name="output_encryption"></a> [encryption](#output\_encryption) | The encryption configuration of the repository. |
| <a name="output_image_scan_on_push_enabled"></a> [image\_scan\_on\_push\_enabled](#output\_image\_scan\_on\_push\_enabled) | Whether to scan image on push. |
| <a name="output_image_tag_immutable_enabled"></a> [image\_tag\_immutable\_enabled](#output\_image\_tag\_immutable\_enabled) | Whether to enable tag immutability to prevent image tags from being overwritten. |
| <a name="output_lifecycle_rules"></a> [lifecycle\_rules](#output\_lifecycle\_rules) | The lifecycle rules for the repository. |
| <a name="output_name"></a> [name](#output\_name) | The name of the repository. |
| <a name="output_region"></a> [region](#output\_region) | The AWS region this module resources resides in. |
| <a name="output_registry_id"></a> [registry\_id](#output\_registry\_id) | The registry ID where the repository was created. |
| <a name="output_resource_group"></a> [resource\_group](#output\_resource\_group) | The resource group created to manage resources in this module. |
| <a name="output_url"></a> [url](#output\_url) | The URL of the repository (in the form aws\_account\_id.dkr.ecr.region.amazonaws.com/repositoryName). |
<!-- END_TF_DOCS -->
