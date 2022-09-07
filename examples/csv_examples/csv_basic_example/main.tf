locals {
  tags = [
    for x in csvdecode(file(var.tags_file)) : {
      device_group = x.device_group
      name         = x.name
      color        = length(x.color) != 0 ? x.color : "color8"
      comment      = x.comment
    }
  ]
  services = [
    for x in csvdecode(file(var.services_file)) : {
      device_group     = x.device_group
      name             = x.name
      protocol         = x.protocol
      source_port      = x.source_port
      destination_port = x.destination_port
      tags             = length(x.tags) != 0 ? split(",", x.tags) : []
      description      = x.description
    }
  ]

  service_groups = [
    for x in csvdecode(file(var.service_groups_file)) : {
      device_group = x.device_group
      name         = x.name
      services     = length(x.services) != 0 ? split(",", x.services) : []
      tags         = length(x.tags) != 0 ? split(",", x.tags) : null
    }
  ]

  addr_object = [
    for x in csvdecode(file(var.addresses_file)) : {
      device_group = x.device_group
      name         = x.name
      value        = { x.type == "" ? "ip-netmask" : x.type = x.value }
      tags         = length(x.tags) != 0 ? split(",", x.tags) : []
      type         = x.type == "" ? "ip-netmask" : x.type
      description  = x.description
    }
  ]

  addr_groups = [
    for x in csvdecode(file(var.addr_groups_file)) : {
      device_group = x.device_group
      name         = x.name
      tags         = length(x.tags) != 0 ? split(",", lookup(x, "tags", "")) : []
      static_addresses = length(x.static_addresses) != 0 ? split(",", x.static_addresses) : []
      dynamic_match    = x.dynamic_match
      description      = x.description
    }
  ]

  sec_rules_dg = toset([for k, v in csvdecode(file(var.policy_file)) : v.device_group])
  sec_rules_rb = toset([for k, v in csvdecode(file(var.policy_file)) : v.rulebase])
  sec_rules = flatten([
    for dg in local.sec_rules_dg : [
      for rb in local.sec_rules_rb : merge(
        { "device_group" : dg },
        { "rulebase" : rb },
        {
          "rules" : [
            for x in csvdecode(file(var.policy_file)) :
            {
              name             = x.name
              description      = lookup(x, "description", null)
              applications     = split(",", lookup(x, "applications", "any"))
              tags             = length(x.tags) != 0 ? split(",", lookup(x, "tags", "")) : []
              source_zones     = split(",", lookup(x, "source_zones", "any"))
              source_addresses = split(",", lookup(x, "source_addresses", "any"))
              negate_source    = lookup(x, "negate_source", "false")
              source_users     = split(",", lookup(x, "source_users", "any"))
              destination_zones                  = split(",", lookup(x, "destination_zones", "any"))
              destination_addresses              = split(",", lookup(x, "destination_addresses", "any"))
              negate_destination                 = lookup(x, "negate_destination", "false")
              applications                       = split(",", lookup(x, "applications", ""))
              services                           = split(",", lookup(x, "services", ""))
              categories                         = split(",", lookup(x, "categories", null))
              action                             = lookup(x, "action", null)
              disable_server_response_inspection = lookup(x, "disable_server_response_inspection", null)
              log_setting                        = lookup(x, "log_setting", null)
              log_start                          = lookup(x, "log_start", false)
              log_end                            = lookup(x, "log_end", true)
              disabled                           = lookup(x, "disabled", false)
              group                              = lookup(x, "group", null)
              virus                              = lookup(x, "virus", null)
              spyware                            = lookup(x, "spyware", null)
              vulnerability                      = lookup(x, "vulnerability", null)
              url_filtering                      = lookup(x, "url_filtering", null)
              file_blocking                      = lookup(x, "file_blocking", null)
              wildfire_analysis                  = lookup(x, "wildfire_analysis", null)
            }
            if x.device_group == dg && x.rulebase == rb
          ]
        }
      )
    ]
    ]
  )

  nat_rules_dg = toset([for k, v in csvdecode(file(var.nat_file)) : v.device_group])
  nat_rules_rb = toset([for k, v in csvdecode(file(var.nat_file)) : v.rulebase])
  nat_rules = flatten([
    for dg in local.nat_rules_dg : [
      for rb in local.nat_rules_rb : merge(
        { "device_group" : dg },
        { "rulebase" : rb },
        {
          "rules" : [
            for x in csvdecode(file(var.nat_file)) : {
              name     = x.name
              tags     = length(x.tags) != 0 ? split(",", lookup(x, "tags", "")) : []
              disabled = tobool(lower(lookup(x, "disabled", "false")))
              original_packet : {
                source_zones          = split(",", lookup(x, "source_zones", "any"))
                destination_zone      = lookup(x, "destination_zone", "any")
                destination_interface = lookup(x, "destination_interface", "any")
                source_addresses      = split(",", lookup(x, "original_source_addresses", "any"))
                destination_addresses = split(",", lookup(x, "original_destination_addresses", "any"))
                service               = lookup(x, "original_service", null)
              }
              translated_packet : {
                ## source
                # dynamic_ip
                source               = x.translated_source_type
                translated_addresses = x.translated_source_type == "dynamic_ip" || (x.translated_source_type == "dynamic_ip_and_port" && x.translated_source_address_type == "translated_address") ? split(",", x.translated_source_address) : []
                # static_ip
                static_ip = x.translated_source_type == "static_ip" ? {
                  translated_address = x.translated_source_address
                  bi_directional     = tobool(lower(lookup(x, "bidirectional", "false")))
                } : {}
                # dynamic_ip_and_port
                interface_address = x.translated_source_type == "dynamic_ip_and_port" && x.translated_source_address_type == "interface_address" ? {
                  interface  = x.translated_source_interface
                  ip_address = x.translated_source_address
                } : {}

                # destination
                destination = x.translated_destination_type
                static_translation = x.translated_destination_type == "static_translation" ? {
                  address = x.translated_destination_address
                  port    = x.translated_destination_port
                } : {}
                dynamic_translation = x.translated_destination_type == "dynamic_translation" ? {
                  address = x.translated_destination_address
                  port    = x.translated_destination_port
                } : {}
              }
            }
          ]
        }
      )
    ]
    ]
  )
}

module "policy_as_code_objects" {
  source = "../../../modules/objects"

  tags           = try(local.tags, {})
  services       = try(local.services, {})
  service_groups = try(local.service_groups, {})
  addr_obj       = try(local.addr_object, {})
  addr_group     = try(local.addr_groups, {})
}

module "policy_as_code_policy" {
  source = "../../../modules/policy"

  sec_policy     = try(local.sec_rules, {})
  nat_policy     = try(local.nat_rules, {})
  panorama_mode  = var.panorama_mode

  depends_on = [module.policy_as_code_objects]
}
