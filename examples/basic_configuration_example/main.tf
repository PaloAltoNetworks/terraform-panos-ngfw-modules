module "device_group" {
  source = "../../modules/device_group"
  mode   = var.mode

  device_group = var.device_group
}

module "policy_as_code_tag" {
  for_each = var.device_group
  source   = "../../modules/tag"
  mode     = var.mode

  device_group = each.key
  tags         = var.tags
}

module "policy_as_code_address" {
  for_each = var.device_group
  source   = "../../modules/address"
  mode     = var.mode

  device_group    = each.key
  address_objects = var.addresses

  depends_on = [module.policy_as_code_tag, module.device_group]
}

module "policy_as_code_address_groups" {
  for_each = var.device_group
  source   = "../../modules/address"
  mode     = var.mode

  device_group   = each.key
  address_groups = var.address_groups

  depends_on = [module.policy_as_code_tag, module.policy_as_code_address, module.device_group]
}

module "policy_as_code_service" {
  for_each = var.device_group
  source   = "../../modules/service"
  mode     = var.mode

  device_group = each.key
  services     = var.services

  depends_on = [module.policy_as_code_tag, module.device_group]
}

module "policy_as_code_service_groups" {
  for_each = var.device_group
  source   = "../../modules/service"
  mode     = var.mode

  device_group   = each.key
  services_group = var.services_group

  depends_on = [module.policy_as_code_tag, module.policy_as_code_service, module.device_group]
}

module "policy_as_code_interfaces" {
  source   = "../../modules/interface"
  for_each = var.templates
  mode     = var.mode
  template = each.key

  interfaces = var.interfaces

  depends_on = [
    module.policy_as_code_template,
    module.policy_as_code_template_stack,
    module.policy_as_code_management_profiles,
    module.policy_as_code_zones,
    module.policy_as_code_virtual_routers
  ]
}

module "policy_as_code_management_profiles" {
  source   = "../../modules/management_profile"
  for_each = var.templates
  mode     = var.mode
  template = each.key

  management_profiles = var.management_profiles

  depends_on = [
    module.policy_as_code_template,
    module.policy_as_code_template_stack,
  ]
}

module "policy_as_code_virtual_routers" {
  source   = "../../modules/virtual_router"
  for_each = var.templates
  mode     = var.mode
  template = each.key

  virtual_routers = var.virtual_routers

  depends_on = [
    module.policy_as_code_template,
    module.policy_as_code_template_stack,
  ]
}

module "policy_as_code_static_routes" {
  source   = "../../modules/static_route"
  for_each = var.templates
  mode     = var.mode
  template = each.key

  static_routes = var.static_routes

  depends_on = [
    module.policy_as_code_template,
    module.policy_as_code_template_stack,
    module.policy_as_code_virtual_routers,
    module.policy_as_code_interfaces
  ]
}

module "policy_as_code_zones" {
  source   = "../../modules/zone"
  for_each = var.templates
  mode     = var.mode
  template = each.key

  zones = var.zones

  depends_on = [
    module.policy_as_code_template,
    module.policy_as_code_template_stack,
  ]
}

module "policy_as_code_ipsec" {
  source   = "../../modules/ipsec"
  for_each = var.templates
  mode     = var.mode
  template = each.key

  ike_crypto_profiles   = var.ike_crypto_profiles
  ipsec_crypto_profiles = var.ipsec_crypto_profiles
  ike_gateways          = var.ike_gateways
  ipsec_tunnels         = var.ipsec_tunnels
  ipsec_tunnels_proxy   = {}

  depends_on = [
    module.policy_as_code_template,
    module.policy_as_code_template_stack,
    module.policy_as_code_virtual_routers,
    module.policy_as_code_zones,
    module.policy_as_code_interfaces
  ]
}

module "policy_as_code_template" {
  source = "../../modules/template"
  mode   = var.mode

  templates = var.templates

  depends_on = []
}

module "policy_as_code_template_stack" {
  source = "../../modules/template_stack"
  mode   = var.mode

  template_stacks = var.template_stacks

  depends_on = [module.policy_as_code_template]
}


module "policy_as_code_security_policies" {
  for_each = var.device_group
  source   = "../../modules/security_policies"
  mode     = var.mode

  device_group = each.key
  sec_policy   = var.security_policies_group

  depends_on = [
    module.policy_as_code_address_groups, module.policy_as_code_service_groups, module.policy_as_code_zones,
    module.device_group
  ]
}
