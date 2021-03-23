locals {
  map_roles = concat(
    [
      for role in var.node_roles : {
        rolearn  = role
        username = "system:node:{{EC2PrivateDNSName}}"
        groups   = ["system:bootstrappers", "system:nodes"]
      }
    ],
    [
      for role in var.fargate_profile_roles : {
        rolearn  = role
        username = "system:node:{{SessionName}}"
        groups   = ["system:bootstrappers", "system:nodes", "system:node-proxier"]
      }
    ],
    [
      for map_role in var.map_roles : {
        rolearn  = map_role.iam_role
        username = map_role.username
        groups   = try(map_role.groups, [])
      }
    ]
  )
  map_users = [
    for map_user in var.map_users : {
      userarn  = map_user.iam_user
      username = map_user.username
      groups   = try(map_user.groups, [])
    }
  ]
  map_accounts = var.map_accounts
}


###################################################
# ConfigMap for AWS Auth Mapping
###################################################

resource "kubernetes_config_map" "this" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles    = yamlencode(local.map_roles)
    mapUsers    = yamlencode(local.map_users)
    mapAccounts = yamlencode(local.map_accounts)
  }
}
