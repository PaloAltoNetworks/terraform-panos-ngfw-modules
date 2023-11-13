module "device_groups" {
  source = "../../modules/device_groups"
  mode   = var.mode

  device_groups = var.device_groups
}

module "tags" {
  for_each = var.device_groups
  source   = "../../modules/tags"
  mode     = var.mode

  device_group = each.key
  tags         = var.tags
}

module "addresses" {
  for_each = var.device_groups
  source   = "../../modules/addresses"
  mode     = var.mode

  device_group    = each.key
  address_objects = var.addresses

  depends_on = [module.tags, module.device_groups]
}

module "address_groups" {
  for_each = var.device_groups
  source   = "../../modules/addresses"
  mode     = var.mode

  device_group   = each.key
  address_groups = var.address_groups

  depends_on = [module.tags, module.addresses, module.device_groups]
}

module "services" {
  for_each = var.device_groups
  source   = "../../modules/services"
  mode     = var.mode

  device_group = each.key
  services     = var.services

  depends_on = [module.tags, module.device_groups]
}

module "service_groups" {
  for_each = var.device_groups
  source   = "../../modules/services"
  mode     = var.mode

  device_group   = each.key
  service_groups = var.service_groups

  depends_on = [module.tags, module.services, module.device_groups]
}

module "interfaces" {
  source   = "../../modules/interfaces"
  for_each = var.templates
  mode     = var.mode
  template = each.key

  interfaces = var.interfaces

  depends_on = [
    module.templates,
    module.template_stacks,
    module.management_profiles,
    module.zones,
    module.virtual_routers
  ]
}

module "management_profiles" {
  source   = "../../modules/management_profiles"
  for_each = var.templates
  mode     = var.mode
  template = each.key

  management_profiles = var.management_profiles

  depends_on = [
    module.templates,
    module.template_stacks,
  ]
}

module "virtual_routers" {
  source   = "../../modules/virtual_routers"
  for_each = var.templates
  mode     = var.mode
  template = each.key

  virtual_routers = var.virtual_routers

  depends_on = [
    module.templates,
    module.template_stacks,
  ]
}

module "static_routes" {
  source   = "../../modules/static_routes"
  for_each = var.templates
  mode     = var.mode
  template = each.key

  static_routes = var.static_routes

  depends_on = [
    module.templates,
    module.template_stacks,
    module.virtual_routers,
    module.interfaces
  ]
}

module "zones" {
  source   = "../../modules/zones"
  for_each = var.templates
  mode     = var.mode
  template = each.key

  zones = var.zones

  depends_on = [
    module.templates,
    module.template_stacks,
  ]
}

module "ipsec" {
  source   = "../../modules/ipsec"
  for_each = var.templates
  mode     = var.mode
  template = each.key

  ike_crypto_profiles   = var.ike_crypto_profiles
  ipsec_crypto_profiles = var.ipsec_crypto_profiles
  ike_gateways          = var.ike_gateways
  ipsec_tunnels         = var.ipsec_tunnels
  ipsec_tunnel_proxies  = {}

  depends_on = [
    module.templates,
    module.template_stacks,
    module.virtual_routers,
    module.zones,
    module.interfaces
  ]
}

module "templates" {
  source = "../../modules/templates"
  mode   = var.mode

  templates = var.templates

  depends_on = []
}

module "template_stacks" {
  source = "../../modules/template_stacks"
  mode   = var.mode

  template_stacks = var.template_stacks

  depends_on = [module.templates]
}

module "security_policies_post_rules" {
  for_each = var.device_groups
  source   = "../../modules/security_policy"
  mode     = var.mode

  device_group = each.key
  rulebase     = "post-rulebase"
  rules        = var.security_post_rules
}

module "security_rule_groups" {
  for_each = var.device_groups
  source   = "../../modules/security_rule_groups"
  mode     = var.mode

  device_group         = each.key
  security_rule_groups = var.security_rule_groups

  depends_on = [
    module.address_groups, module.service_groups, module.zones,
    module.device_groups
  ]
}

module "nat_policies" {
  for_each = var.device_groups
  source   = "../../modules/nat_policies"
  mode     = var.mode

  device_group = each.key
  nat_policies = var.nat_policies

  depends_on = [
    module.address_groups, module.service_groups, module.zones,
    module.device_groups
  ]
}

module "security_profiles" {
  for_each = var.device_groups
  source   = "../../modules/security_profiles"

  mode         = var.mode
  device_group = each.key

  antivirus_profiles                = var.security_profiles.antivirus
  antispyware_profiles              = var.security_profiles.antispyware
  file_blocking_profiles            = var.security_profiles.file_blocking
  vulnerability_protection_profiles = var.security_profiles.vulnerability
  wildfire_analysis_profiles        = var.security_profiles.wildfire

  depends_on = [module.device_groups]
}

module "log_forwarding_profiles_shared" {
  source = "../../modules/log_forwarding_profiles"

  mode         = var.mode
  device_group = "shared"

  profiles = var.log_forwarding_profiles_shared
}
