output "max_enis" {
  description = "The maximum number of ENIs for given instance type."
  value       = local.limits.max_enis
}

output "max_ipv4_addrs_per_eni" {
  description = "The maximum number of IPv4 addresses per ENI for given instance type."
  value       = local.limits.max_ipv4_addrs_per_eni
}

output "max_pods" {
  description = "The maximum number of pods for given instance type."
  value       = local.limits.max_pods
}
