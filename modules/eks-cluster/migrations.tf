# 2023-11-10
moved {
  from = aws_iam_openid_connect_provider.this
  to   = module.oidc_provider.aws_iam_openid_connect_provider.this
}

# 2022-10-20
moved {
  from = aws_resourcegroups_group.this[0]
  to   = module.resource_group[0].aws_resourcegroups_group.this
}
