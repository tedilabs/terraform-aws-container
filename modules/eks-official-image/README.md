# eks-official-image

This module creates following resources.

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
| [aws_ssm_parameter.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | (Required) Desired Kubernetes version to search the official EKS AMIs for the EKS cluster. | `string` | n/a | yes |
| <a name="input_os"></a> [os](#input\_os) | (Required) A configuration of OS (Operating System) to search EKS official AMIs. `os` block as defined below.<br/>    (Required) `name` - A name of the OS (Operating System). Valid values are `amazon-linux`, `ubuntu`, `ubuntu-pro`.<br/>    (Required) `release` - A release name of the OS.<br/>      `amazon-linux` - Valid values are `2`, `2023`.<br/>      `ubuntu` - Valid values are `18.04`, `20.04`, `22.04`, `24.04`, `26.04`.<br/>      `ubuntu-pro` - Same with `ubuntu`. | <pre>object({<br/>    name    = string<br/>    release = string<br/>  })</pre> | n/a | yes |
| <a name="input_arch"></a> [arch](#input\_arch) | (Optional) The type of the CPU architecture. Valid values are `amd64`, `arm64`. Defaults to `amd64`. | `string` | `"amd64"` | no |
| <a name="input_region"></a> [region](#input\_region) | (Optional) The region in which to create the module resources. If not provided, the module resources will be created in the provider's configured region. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arch"></a> [arch](#output\_arch) | The type of the CPU architecture. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the EKS official AMI. |
| <a name="output_kubernetes_version"></a> [kubernetes\_version](#output\_kubernetes\_version) | The version of Kubernetes. |
| <a name="output_os"></a> [os](#output\_os) | The configuration of OS (Operating System) of the AMI |
| <a name="output_parameter"></a> [parameter](#output\_parameter) | The parameter name of SSM Parameter Store. |
| <a name="output_region"></a> [region](#output\_region) | The AWS region this module resources resides in. |
<!-- END_TF_DOCS -->
