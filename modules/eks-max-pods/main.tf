# Maximum number of pods per instance type. See the docs and calculations below.
# https://docs.aws.amazon.com/eks/latest/userguide/pod-networking.html
# https://docs.aws.amazon.com/eks/latest/userguide/cni-custom-network.html
# Default CNI Networking maxPods = number of interfaces * (max IPv4 addresses per interface - 1) + 2
# CNI Custom Networking maxPods = (number of interfaces - 1) * (max IPv4 addresses per interface - 1) + 2

# ENI Prefix Mode
# https://docs.aws.amazon.com/eks/latest/userguide/cni-increase-ip-addresses.html
# ENI Prefix Mode maxPods = (number of interfaces) * (max IPv4 addresses per interface - 1) * 16 + 2

locals {
  data = jsondecode(file("${path.module}/data.json"))

  limits_per_instance_type = {
    for i in local.data :
    i.type => {
      max_enis               = i.max_enis
      max_ipv4_addrs_per_eni = i.max_ipv4_addrs_per_eni

      max_pods = min(
        (i.max_enis - (var.use_cni_custom_networking ? 1 : 0)) * ((i.max_ipv4_addrs_per_eni - 1) * (var.use_cni_eni_prefix_mode ? 16 : 1)) + 2,
        (i.vcpu > 30) ? 250 : 110
      )
    }
  }

  limits = local.limits_per_instance_type[var.instance_type]
}
