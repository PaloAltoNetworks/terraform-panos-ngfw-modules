module "policy_as_code_objects" {
  source     = "../../../modules/objects"
  tags       = try(yamldecode(file("./yaml/tags.yml")), {})
  services   = try(yamldecode(file("./yaml/services.yml")), {})
  addr_group = try(yamldecode(file("./yaml/addr_group.yml")), {})
  addr_obj   = try(yamldecode(file("./yaml/addr_obj.yml")), {})
}

module "policy_as_code_policy" {
  source = "../../../modules/policy"

  sec_policy = try(yamldecode(file("./yaml/sec_policy.yml")), {})
  nat_policy = try(yamldecode(file("./yaml/nat.yml")), {})
  depends_on = [module.policy_as_code_objects]
}

module "policy_as_code_security_profiles" {
  source = "../../../modules/security-profiles"

  antivirus     = try(yamldecode(file("./yaml/antivirus.yml")), {})
  file_blocking = try(yamldecode(file("./yaml/file_blocking.yml")), {})
  wildfire      = try(yamldecode(file("./yaml/wildfire.yml")), {})
  vulnerability = try(yamldecode(file("./yaml/vulnerability.yml")), {})
  spyware       = try(yamldecode(file("./yaml/spyware.yml")), {})

  depends_on = [module.policy_as_code_objects]
}