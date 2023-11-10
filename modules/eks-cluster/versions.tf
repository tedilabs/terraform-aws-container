terraform {
  required_version = ">= 1.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.47"
    }
    # tflint-ignore: terraform_unused_required_providers
    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.0"
    }
  }
}
