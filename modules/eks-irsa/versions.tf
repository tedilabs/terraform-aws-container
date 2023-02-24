terraform {
  required_version = ">= 1.2"

  required_providers {
    # tflint-ignore: terraform_unused_required_providers
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.45"
    }
  }
}
