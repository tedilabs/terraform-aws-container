# 2023-11-10: Add variable to decide whether to create IAM role for EKS node
moved {
  from = module.role__node
  to   = module.role__node[0]
}

# 2023-11-10: Add variable to decide whether to create IAM role for EKS cluster
moved {
  from = module.role__control_plane
  to   = module.role[0]
}

# 2023-11-10: Migrate OIDC provider from resource to module
moved {
  from = aws_iam_openid_connect_provider.this
  to   = module.oidc_provider.aws_iam_openid_connect_provider.this
}

# 2022-10-20
moved {
  from = aws_resourcegroups_group.this[0]
  to   = module.resource_group[0].aws_resourcegroups_group.this
}
