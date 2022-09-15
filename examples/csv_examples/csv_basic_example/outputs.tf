output "panos_zones" {
  value = [for zone in module.policy_as_code_network.panos_zones : zone.name]
}