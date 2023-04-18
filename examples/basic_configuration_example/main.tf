module "policy_as_code_tag" {
  source = "../../modules/tag"
  mode   = var.mode

  device_group = var.device_group
  tags         = var.tags
}

module "policy_as_code_address" {
  source = "../../modules/address"
  mode   = var.mode

  device_group    = var.device_group
  address_objects = var.addresses

  depends_on = [module.policy_as_code_tag]
}

module "policy_as_code_address_groups" {
  source = "../../modules/address"
  mode   = var.mode

  device_group   = var.device_group
  address_groups = var.address_groups

  depends_on = [module.policy_as_code_tag, module.policy_as_code_address]
}

module "policy_as_code_service" {
  source = "../../modules/service"
  mode   = var.mode

  device_group = var.device_group
  services     = var.services

  depends_on = [module.policy_as_code_tag]
}

module "policy_as_code_service_groups" {
  source = "../../modules/service"
  mode   = var.mode

  device_group   = var.device_group
  services_group = var.services_group

  depends_on = [module.policy_as_code_tag, module.policy_as_code_service]
}

module "policy_as_code_interfaces" {
  source = "../../modules/interface"
  mode   = var.mode

  template       = var.template
  template_stack = var.template_stack

  interfaces = var.interfaces

  depends_on = [module.policy_as_code_management_profiles, module.policy_as_code_zones, module.policy_as_code_virtual_routers]
}

module "policy_as_code_management_profiles" {
  source = "../../modules/management_profile"
  mode   = var.mode

  template       = var.template
  template_stack = var.template_stack

  management_profiles = var.management_profiles

  depends_on = []
}

module "policy_as_code_virtual_routers" {
  source = "../../modules/virtual_router"
  mode   = var.mode

  template       = var.template
  template_stack = var.template_stack

  virtual_routers = var.virtual_routers

  depends_on = []
}

module "policy_as_code_static_routes" {
  source = "../../modules/static_route"
  mode   = var.mode

  template       = var.template
  template_stack = var.template_stack

  static_routes = var.static_routes

  depends_on = [module.policy_as_code_virtual_routers, module.policy_as_code_interfaces]
}

module "policy_as_code_zones" {
  source = "../../modules/zone"
  mode   = var.mode

  template       = var.template
  template_stack = var.template_stack

  zones = var.zones

  depends_on = []
}

module "policy_as_code_ipsec" {
  source = "../../modules/ipsec"
  mode   = var.mode

  template       = var.template
  template_stack = var.template_stack

  ike_crypto_profiles   = var.ike_crypto_profiles
  ipsec_crypto_profiles = var.ipsec_crypto_profiles
  ike_gateways          = var.ike_gateways
  ipsec_tunnels         = var.ipsec_tunnels
  ipsec_tunnels_proxy   = {}

  depends_on = [module.policy_as_code_virtual_routers, module.policy_as_code_interfaces]
}

module "policy_as_code_security_policies" {
  source = "../../modules/security_policies"
  mode   = var.mode

  device_group = var.device_group
  sec_policy   = var.security_policies_group

  depends_on = [module.policy_as_code_address_groups, module.policy_as_code_service_groups]
}
