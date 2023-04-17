module "policy_as_code_tag" {
  source   = "../../modules/tag"
  panorama = var.mode == "panorama"

  device_group = var.device_group
  tags         = var.tags
}

module "policy_as_code_address" {
  source   = "../../modules/address"
  for_each = { for device_group in var.device_group : device_group => device_group }

  mode            = var.mode
  device_group    = each.value
  address_objects = var.addresses

  depends_on = [module.policy_as_code_tag]
}

module "policy_as_code_address_groups" {
  source   = "../../modules/address"
  for_each = { for device_group in var.device_group : device_group => device_group }

  mode           = var.mode
  device_group   = each.value
  address_groups = var.address_groups

  depends_on = [module.policy_as_code_tag, module.policy_as_code_address]
}

module "policy_as_code_service" {
  source   = "../../modules/service"
  panorama = var.mode == "panorama"

  device_group = var.device_group
  services     = var.services

  depends_on = [module.policy_as_code_tag]
}

module "policy_as_code_service_groups" {
  source   = "../../modules/service"
  panorama = var.mode == "panorama"

  device_group   = var.device_group
  services_group = var.services_group

  depends_on = [module.policy_as_code_tag, module.policy_as_code_service]
}

module "policy_as_code_interfaces" {
  source = "../../modules/interface"

  mode           = var.mode
  template       = var.template
  template_stack = var.template_stack
  interfaces     = var.interfaces

  depends_on = [module.policy_as_code_management_profiles, module.policy_as_code_zones, module.policy_as_code_virtual_routers]
}

module "policy_as_code_management_profiles" {
  source = "../../modules/management_profile"

  mode                = var.mode
  template            = var.template
  template_stack      = var.template_stack
  management_profiles = var.management_profiles

  depends_on = []
}

module "policy_as_code_virtual_routers" {
  source = "../../modules/virtual_router"

  mode            = var.mode
  template        = var.template
  template_stack  = var.template_stack
  virtual_routers = var.virtual_routers

  depends_on = []
}

locals {
  static_routes_list = flatten([for k, v in var.virtual_routers : [for rk, rv in v.route_tables : [for sk, sv in rv.routes : { virtual_router = k, route_table = rk, route_name = sk, route = sv }]]])
  static_routes      = { for static_route in local.static_routes_list : "${static_route.virtual_router}_${static_route.route_table}_${static_route.route_name}" => static_route }
}

module "policy_as_code_static_routes" {
  source = "../../modules/static_route"

  mode           = var.mode
  template       = var.template
  template_stack = var.template_stack
  static_routes  = local.static_routes

  depends_on = [module.policy_as_code_virtual_routers, module.policy_as_code_interfaces]
}

module "policy_as_code_zones" {
  source = "../../modules/zone"

  mode           = var.mode
  template       = var.template
  template_stack = var.template_stack
  zones          = var.zones

  depends_on = []
}

module "policy_as_code_ipsec" {
  source = "../../modules/ipsec"

  mode                  = var.mode
  template              = var.template
  template_stack        = var.template_stack
  ike_crypto_profiles   = var.ike_crypto_profiles
  ipsec_crypto_profiles = var.ipsec_crypto_profiles
  ike_gateways          = var.ike_gateways
  ipsec_tunnels         = var.ipsec_tunnels
  ipsec_tunnels_proxy   = {}

  depends_on = [module.policy_as_code_virtual_routers, module.policy_as_code_interfaces]
}