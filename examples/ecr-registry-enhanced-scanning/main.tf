provider "aws" {
  region = "us-east-1"
}


###################################################
# ECR Registry
###################################################

module "registry" {
  source = "../../modules/ecr-registry"
  # source  = "tedilabs/container/aws//modules/ecr-registry"
  # version = "~> 0.27.0"

  scanning_type = "ENHANCED"
  scanning_rules = [
    {
      frequency = "SCAN_ON_PUSH"
      filters = [
        { value = "quay/*" },
        { value = "sre/*" },
      ]
    },
    {
      frequency = "CONTINUOUS_SCAN"
      filters = [
        { value = "example/example" },
      ]
    },
  ]
}
