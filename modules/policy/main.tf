resource "panos_security_rule_group" "this" {
  for_each = length(var.sec_policy) != 0 ? {
    for item in var.sec_policy :
    "${try(item.device_group, "shared")}_${replace(try(item.rulebase, "pre-rulebase"), "-", "_")}_${replace(try(item.position_keyword, ""), " ", "_")}"
    => item
  } : {}

  device_group = var.panorama_mode == true ? try(each.value.device_group, "shared") : null
  rulebase     = var.panorama_mode == true ? try(each.value.rulebase, "pre-rulebase") : null
  vsys         = var.panorama_mode == false ? try(each.value.vsys, "vsys1") : null

  position_keyword   = try(each.value.position_keyword, "")
  position_reference = try(each.value.position_reference, null)

  dynamic "rule" {
    for_each = [for policy in each.value.rules : policy]
    content {
      applications                       = try(rule.value.applications, ["any"])
      categories                         = try(rule.value.categories, ["any"])
      destination_addresses              = try(rule.value.destination_addresses, ["any"])
      destination_zones                  = try(rule.value.destination_zones, ["any"])
      name                               = rule.value.name
      services                           = try(rule.value.services, ["application-default"])
      source_addresses                   = try(rule.value.source_addresses, ["any"])
      source_users                       = try(rule.value.source_users, ["any"])
      source_zones                       = try(rule.value.source_zones, ["any"])
      description                        = try(rule.value.description, null)
      tags                               = try(rule.value.tags, null)
      type                               = try(rule.value.type, "universal")
      negate_source                      = try(rule.value.negate_source, false)
      negate_destination                 = try(rule.value.negate_destination, false)
      action                             = try(rule.value.action, "allow")
      log_setting                        = try(rule.value.log_setting, null)
      log_start                          = try(rule.value.log_start, false)
      log_end                            = try(rule.value.log_end, true)
      disabled                           = try(rule.value.disabled, false)
      schedule                           = try(rule.value.schedule, null)
      icmp_unreachable                   = try(rule.value.icmp_unreachable, null)
      disable_server_response_inspection = try(rule.value.disable_server_response_inspection, false)
      group                              = try(rule.value.group, null)
      virus                              = try(rule.value.virus, null)
      spyware                            = try(rule.value.spyware, null)
      vulnerability                      = try(rule.value.vulnerability, null)
      url_filtering                      = try(rule.value.url_filtering, null)
      file_blocking                      = try(rule.value.file_blocking, null)
      wildfire_analysis                  = try(rule.value.wildfire_analysis, null)
      data_filtering                     = try(rule.value.data_filtering, null)

      dynamic "target" {
        for_each = try(rule.value.target, null) != null ? { for t in rule.value.target : t.serial => t } : {}

        content {
          serial    = try(target.value.serial, null)
          vsys_list = try(target.value.vsys_list, null)
        }
      }
      negate_target = try(rule.value.negate_target, false)
    }
  }
}

resource "panos_panorama_nat_rule_group" "panorama_mode" {
  for_each = length(var.nat_policy) != 0 && var.panorama_mode == true ? {
    for item in var.nat_policy :
    "${try(item.device_group, "shared")}_${replace(try(item.rulebase, "pre-rulebase"), "-", "_")}_${replace(try(item.position_keyword, ""), " ", "_")}"
    => item
  } : tomap({})

  device_group = var.panorama_mode == true ? try(each.value.device_group, "shared") : null
  rulebase     = var.panorama_mode == true ? try(each.value.rulebase, "pre-rulebase") : null

  position_keyword   = try(each.value.position_keyword, "")
  position_reference = try(each.value.position_reference, null)


  dynamic "rule" {
    for_each = [for policy in each.value.rules : policy if !can(policy.target)]

    content {
      name        = rule.value.name
      description = try(rule.value.description, null)
      tags        = try(rule.value.tags, null)
      type        = try(rule.value.type, "ipv4")
      disabled    = try(rule.value.disabled, false)

      dynamic "target" {
        for_each = can(rule.value.target) ? { for t in rule.value.target : t.serial => t } : {}

        content {
          serial    = lookup(target.value, "serial", null)
          vsys_list = lookup(target.value, "vsys_list", null)
        }
      }

      negate_target = try(rule.value.negate_target, false)


      original_packet {
        destination_addresses = try(rule.value.original_packet.destination_addresses, ["any"])
        destination_zone      = try(rule.value.original_packet.destination_zone, "any")
        source_addresses      = try(rule.value.original_packet.source_addresses, ["any"])
        source_zones          = try(rule.value.original_packet.source_zones, ["any"])
        service               = try(rule.value.original_packet.service, "any")
      }

      translated_packet {
        destination {

          dynamic "static_translation" {
            for_each = rule.value.translated_packet.destination == "static_translation" ? [1] : []
            content {
              address = try(rule.value.translated_packet.static_translation.address, null)
              port    = try(rule.value.translated_packet.static_translation.port, null)
            }
          }

          dynamic "dynamic_translation" {
            for_each = rule.value.translated_packet.destination == "dynamic_translation" ? [1] : []
            content {
              address      = try(rule.value.translated_packet.dynamic_translation.address, null)
              port         = try(rule.value.translated_packet.dynamic_translation.port, null)
              distribution = try(rule.value.translated_packet.dynamic_translation.distribution, null)
            }
          }
        }

        source {
          dynamic "dynamic_ip_and_port" {
            for_each = rule.value.translated_packet.source == "dynamic_ip_and_port" ? [1] : []
            content {

              dynamic "translated_address" {
                for_each = length(try(rule.value.translated_packet.translated_addresses, {})) != 0 ? [1] : []
                content {
                  translated_addresses = try(rule.value.translated_packet.translated_addresses, null)
                }
              }

              dynamic "interface_address" {
                for_each = length(try(rule.value.translated_packet.interface_address, {})) != 0 ? [1] : []
                content {
                  interface  = try(rule.value.translated_packet.interface_address.interface, null)
                  ip_address = try(rule.value.translated_packet.interface_address.ip_address, null)
                }
              }
            }
          }

          dynamic "dynamic_ip" {
            for_each = rule.value.translated_packet.source == "dynamic_ip" ? [1] : []
            content {
              translated_addresses = try(rule.value.translated_packet.translated_addresses, [])

              dynamic "fallback" {
                for_each = try(rule.value.translated_packet.fallback, null) != null ? [1] : []

                content {
                  dynamic "translated_address" {
                    for_each = try(rule.value.translated_packet.fallback.translated_addresses, null) != null ? [1] : []
                    content {
                      translated_addresses = try(rule.value.translated_packet.fallback.translated_addresses, null)
                    }
                  }

                  dynamic "interface_address" {
                    for_each = try(rule.value.translated_packet.fallback.interface_address, null) != null ? [1] : []
                    content {
                      interface  = try(rule.value.translated_packet.fallback.interface_address.interface, null)
                      type       = try(rule.value.translated_packet.fallback.interface_address.type, "ip")
                      ip_address = try(rule.value.translated_packet.fallback.interface_address.ip_address, null)
                    }
                  }
                }
              }
            }
          }

          dynamic "static_ip" {
            for_each = rule.value.translated_packet.source == "static_ip" ? [1] : []
            content {
              translated_address = try(rule.value.translated_packet.static_ip.translated_address, null)
              bi_directional     = try(rule.value.translated_packet.static_ip.bi_directional, false)
            }
          }
        }
      }
    }
  }
}

resource "panos_nat_rule_group" "fw_mode" {
  for_each = length(var.nat_policy) != 0 && var.panorama_mode == false ? {
    for item in var.nat_policy :
    "${try(item.device_group, "shared")}_${replace(try(item.rulebase, "pre-rulebase"), "-", "_")}_${replace(try(item.position_keyword, ""), " ", "_")}"
    => item
  } : tomap({})
  vsys = var.panorama_mode == false ? try(each.value.vsys, "vsys1") : null

  position_keyword   = try(each.value.position_keyword, "")
  position_reference = try(each.value.position_reference, null)


  dynamic "rule" {
    for_each = [for policy in each.value.rules : policy if !can(policy.target)]

    content {
      name        = rule.value.name
      description = try(rule.value.description, null)
      tags        = try(rule.value.tags, null)
      type        = try(rule.value.type, "ipv4")
      disabled    = try(rule.value.disabled, false)

      dynamic "target" {
        for_each = can(rule.value.target) ? { for t in rule.value.target : t.serial => t } : {}

        content {
          serial    = lookup(target.value, "serial", null)
          vsys_list = lookup(target.value, "vsys_list", null)
        }
      }

      negate_target = try(rule.value.negate_target, false)


      original_packet {
        destination_addresses = try(rule.value.original_packet.destination_addresses, ["any"])
        destination_zone      = try(rule.value.original_packet.destination_zone, "any")
        source_addresses      = try(rule.value.original_packet.source_addresses, ["any"])
        source_zones          = try(rule.value.original_packet.source_zones, ["any"])
        service               = try(rule.value.original_packet.service, "any")
      }

      translated_packet {
        destination {

          dynamic "static_translation" {
            for_each = rule.value.translated_packet.destination == "static_translation" ? [1] : []
            content {
              address = try(rule.value.translated_packet.static_translation.address, null)
              port    = try(rule.value.translated_packet.static_translation.port, null)
            }
          }

          dynamic "dynamic_translation" {
            for_each = rule.value.translated_packet.destination == "dynamic_translation" ? [1] : []
            content {
              address      = try(rule.value.translated_packet.dynamic_translation.address, null)
              port         = try(rule.value.translated_packet.dynamic_translation.port, null)
              distribution = try(rule.value.translated_packet.dynamic_translation.distribution, null)
            }
          }
        }

        source {
          dynamic "dynamic_ip_and_port" {
            for_each = rule.value.translated_packet.source == "dynamic_ip_and_port" ? [1] : []
            content {

              dynamic "translated_address" {
                for_each = length(try(rule.value.translated_packet.translated_addresses, {})) != 0 ? [1] : []
                content {
                  translated_addresses = try(rule.value.translated_packet.translated_addresses, null)
                }
              }

              dynamic "interface_address" {
                for_each = length(try(rule.value.translated_packet.interface_address, {})) != 0 ? [1] : []
                content {
                  interface  = try(rule.value.translated_packet.interface_address.interface, null)
                  ip_address = try(rule.value.translated_packet.interface_address.ip_address, null)
                }
              }
            }
          }

          dynamic "dynamic_ip" {
            for_each = rule.value.translated_packet.source == "dynamic_ip" ? [1] : []
            content {
              translated_addresses = try(rule.value.translated_packet.translated_addresses, [])

              dynamic "fallback" {
                for_each = try(rule.value.translated_packet.fallback, null) != null ? [1] : []

                content {
                  dynamic "translated_address" {
                    for_each = try(rule.value.translated_packet.fallback.translated_addresses, null) != null ? [1] : []
                    content {
                      translated_addresses = try(rule.value.translated_packet.fallback.translated_addresses, null)
                    }
                  }

                  dynamic "interface_address" {
                    for_each = try(rule.value.translated_packet.fallback.interface_address, null) != null ? [1] : []
                    content {
                      interface  = try(rule.value.translated_packet.fallback.interface_address.interface, null)
                      type       = try(rule.value.translated_packet.fallback.interface_address.type, "ip")
                      ip_address = try(rule.value.translated_packet.fallback.interface_address.ip_address, null)
                    }
                  }
                }
              }
            }
          }

          dynamic "static_ip" {
            for_each = rule.value.translated_packet.source == "static_ip" ? [1] : []
            content {
              translated_address = try(rule.value.translated_packet.static_ip.translated_address, null)
              bi_directional     = try(rule.value.translated_packet.static_ip.bi_directional, false)
            }
          }
        }
      }
    }
  }
}
