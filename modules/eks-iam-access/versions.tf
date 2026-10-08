terraform {
  required_version = ">= 1.12"

  required_providers {
    # tflint-ignore: terraform_unused_required_providers
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.12"
    }
    telemetry = {
      source  = "tedilabs/telemetry"
      version = ">= 0.1.1"
    }
  }
}
