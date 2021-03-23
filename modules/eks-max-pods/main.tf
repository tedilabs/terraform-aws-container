# Maximum number of pods per instance type. See the docs and calculations below.
# https://docs.aws.amazon.com/eks/latest/userguide/pod-networking.html
# https://docs.aws.amazon.com/eks/latest/userguide/cni-custom-network.html
# Default CNI Networking maxPods = number of interfaces * (max IPv4 addresses per interface - 1) + 2
# CNI Custom Networking maxPods = (number of interfaces - 1) * (max IPv4 addresses per interface - 1) + 2

locals {
  max_enis = local.ips_per_eni_per_instance_type[var.instance_type][0]
  max_ips  = local.ips_per_eni_per_instance_type[var.instance_type][1]
  max_pods = (var.use_cni_custom_networking ? (local.max_enis - 1) : local.max_enis) * (local.max_ips - 1) + 2
}
