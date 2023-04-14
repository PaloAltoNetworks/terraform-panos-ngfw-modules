resource "panos_panorama_nat_rule_group" "panorama" {
  for_each = length(var.nat_policy) != 0 && var.panorama == true ? {
    for item in var.nat_policy :
    "${try(item.device_group, "shared")}_${replace(try(item.rulebase, "pre-rulebase"), "-", "_")}_${replace(try(item.position_keyword, ""), " ", "_")}"
    => item
  } : tomap({})

  device_group = var.panorama == true ? try(each.value.device_group, "shared") : null
  rulebase     = var.panorama == true ? try(each.value.rulebase, "pre-rulebase") : null

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
  for_each = length(var.nat_policy) != 0 && var.panorama == false ? {
    for item in var.nat_policy :
    "${try(item.device_group, "shared")}_${replace(try(item.rulebase, "pre-rulebase"), "-", "_")}_${replace(try(item.position_keyword, ""), " ", "_")}"
    => item
  } : tomap({})
  vsys = var.panorama == false ? try(each.value.vsys, "vsys1") : null

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
