module "policy_as_code_tag" {
  source   = "../../modules/tag"
  mode = var.mode

  device_group = var.device_group
  tags         = var.tags
}

module "policy_as_code_address" {
  source   = "../../modules/address"
  mode = var.mode

  device_group = var.device_group
  address_objects     = var.addresses

  depends_on = [module.policy_as_code_tag]
}

module "policy_as_code_address_groups" {
  source   = "../../modules/address"
  mode = var.mode

  device_group = var.device_group
  address_groups   = var.address_groups

  depends_on = [module.policy_as_code_tag, module.policy_as_code_address]
}

module "policy_as_code_service" {
  source   = "../../modules/service"
  mode = var.mode

  device_group = var.device_group
  services     = var.services

  depends_on = [module.policy_as_code_tag]
}

module "policy_as_code_service_groups" {
  source   = "../../modules/service"
  mode = var.mode

  device_group   = var.device_group
  services_group = var.services_group

  depends_on = [module.policy_as_code_tag, module.policy_as_code_service]
}

module "policy_as_code_security_policies" {
  source = "../../modules/security_policies"
  mode = var.mode

  device_group = var.device_group
  sec_policy = var.security_policies

  depends_on = [module.policy_as_code_address_groups, module.policy_as_code_service_groups]
}