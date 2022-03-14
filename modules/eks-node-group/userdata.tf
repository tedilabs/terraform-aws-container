# EKS CNI Custom Networking needs kubelet extra arg --max-pods. Default CNI Networking doesn't. See the doc below.
# https://docs.aws.amazon.com/eks/latest/userguide/cni-custom-network.html
module "eks_max_pods" {
  source = "../eks-max-pods"

  instance_type = var.instance_type
}

locals {
  node_labels = [for k, v in var.node_labels : format("%s=%s", k, v)]
  node_taints = var.node_taints

  bootstrap_extra_args = compact(concat(
    [
      var.cni_custom_networking_enabled ? "--use-max-pods false" : "",
    ],
    var.bootstrap_extra_args,
  ))
  kubelet_extra_args = compact(concat(
    [
      length(local.node_labels) > 0 ? "--node-labels ${join(",", local.node_labels)}" : "",
      length(local.node_taints) > 0 ? "--register-with-taints ${join(",", local.node_taints)}" : "",
      var.cni_custom_networking_enabled ? "--max-pods ${module.eks_max_pods.max_pods}" : "",
    ],
    var.kubelet_extra_args,
  ))
  userdata = templatefile("${path.module}/templates/userdata.sh.tpl", {
    cluster_name         = var.cluster_name,
    bootstrap_extra_args = join(" ", local.bootstrap_extra_args),
    kubelet_extra_args   = join(" ", local.kubelet_extra_args)
  })
}
