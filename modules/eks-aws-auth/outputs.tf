output "config_map" {
  description = "The data of `kube-system/aws-auth` ConfigMap."
  value       = kubernetes_config_map.this
}
