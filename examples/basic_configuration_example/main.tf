module "policy_as_code_tag" {
  source   = "../../modules/tag"
  panorama = var.panorama

  device_group = var.device_group
  tags = var.tags
}

module "policy_as_code_address" {
  source = "../../modules/address"
  panorama = var.panorama

  device_group = var.device_group
  addr_obj = var.addresses

  depends_on = [module.policy_as_code_tag]
}

module "policy_as_code_address_groups" {
  source = "../../modules/address"
  panorama = var.panorama

  device_group = var.device_group
  addr_group = var.address_groups

  depends_on = [module.policy_as_code_tag, module.policy_as_code_address]
}

module "policy_as_code_service" {
  source = "../../modules/service"
  panorama = var.panorama

  device_group = var.device_group
  services = var.services

  depends_on = [module.policy_as_code_tag]
}

module "policy_as_code_service_groups" {
  source = "../../modules/service"
  panorama = var.panorama

  device_group = var.device_group
  services_group = var.services_group

  depends_on = [module.policy_as_code_tag, module.policy_as_code_service]
}

