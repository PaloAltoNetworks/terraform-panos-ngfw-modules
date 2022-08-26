module "policy_as_code_objects" {
  source = "../../../modules/objects"

  tags       = try(jsondecode(file("./json/tags.json")), {})
  services   = try(jsondecode(file("./json/services.json")), {})
  addr_group = try(jsondecode(file("./json/addr_group.json")), {})
  addr_obj   = try(jsondecode(file("./json/addr_obj.json")), {})
}

module "policy_as_code_policy" {
  source = "../../../modules/policy"

  sec_policy = try(jsondecode(file("./json/sec_policy.json")), {})
  nat_policy = try(jsondecode(file("./json/nat.json")), {})
  depends_on = [module.policy_as_code_objects]
}

module "policy_as_code_security_profiles" {
  source = "../../../modules/security-profiles"

  antivirus     = try(jsondecode(file("./json/antivirus.json")), {})
  file_blocking = try(jsondecode(file("./json/file_blocking.json")), {})
  wildfire      = try(jsondecode(file("./json/wildfire.json")), {})
  vulnerability = try(jsondecode(file("./json/vulnerability.json")), {})
  spyware       = try(jsondecode(file("./json/spyware.json")), {})

  depends_on = [module.policy_as_code_objects]
}