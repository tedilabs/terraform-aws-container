# terraform-aws-container

![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/tedilabs/terraform-aws-container?color=blue&sort=semver&style=flat-square)
![GitHub](https://img.shields.io/github/license/tedilabs/terraform-aws-container?color=blue&style=flat-square)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white&style=flat-square)](https://github.com/pre-commit/pre-commit)

Terraform module which creates resources for container services on AWS.


## Target AWS Services

Terraform Modules from [this package](https://github.com/tedilabs/terraform-aws-container) were written to manage the following AWS Services with Terraform.

- **AWS ECR (Elastic Container Registry)**
  - Private Registry
    - Repository
      - Lifecycle Policy
    - Pull-through Cache
    - Replication
    - Scanning
- **AWS EKS (Elastic Kubernetes Service)**
  - Control Plane
  - Node Group with ASG
  - Fargate Profile
  - IRSA (IAM Role for ServiceAccount)


## Self Promotion

Like this project? Follow the repository on [GitHub](https://github.com/tedilabs/terraform-aws-container). And if you're feeling especially charitable, follow **[posquit0](https://github.com/posquit0)** on GitHub.


## License

Provided under the terms of the [Apache License](LICENSE).

Copyright © 2021-2022, [Byungjin Park](https://www.posquit0.com).
