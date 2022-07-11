provider "aws" {
  region = "us-east-1"
}


###################################################
# ECR Registry
###################################################

module "registry" {
  source = "../../modules/ecr-registry"
  # source  = "tedilabs/container/aws//modules/ecr-registry"
  # version = "~> 0.19.0"

  scanning_type               = "ENHANCED"
  scanning_on_push_filters    = ["quay/*", "sre/*"]
  scanning_continuous_filters = ["example/example"]

  tags = {
    "project" = "terraform-aws-container-examples"
  }
}
