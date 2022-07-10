output "registries" {
  value = {
    src = module.registry_src
    dst = module.registry_dst
  }
}
