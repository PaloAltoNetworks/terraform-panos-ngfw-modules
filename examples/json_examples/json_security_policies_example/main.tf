module "policy_as_code_objects" {
  source = "../../../modules/objects"

  tags       = try(jsondecode(file("./iron_skillet/tags.json")), {})
}

module "policy_as_code_policy" {
  source = "../../../modules/policy"

  sec_policy = try(jsondecode(file("./iron_skillet/sec_policy.json")), {})
  depends_on = [module.policy_as_code_objects]
}

module "policy_as_code_security_profiles" {
  source = "../../../modules/security-profiles"

  antivirus     = try(jsondecode(file("./iron_skillet/antivirus.json")), {})
  file_blocking = try(jsondecode(file("./iron_skillet/file_blocking.json")), {})
  wildfire      = try(jsondecode(file("./iron_skillet/wildfire.json")), {})
  vulnerability = try(jsondecode(file("./iron_skillet/vulnerability.json")), {})
  spyware       = try(jsondecode(file("./iron_skillet/spyware.json")), {})

  depends_on = [module.policy_as_code_objects]
}
