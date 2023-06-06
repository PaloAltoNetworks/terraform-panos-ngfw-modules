resource "panos_panorama_nat_rule_group" "this" {
  for_each = var.mode_map[var.mode] == 0 ? var.nat_policies : {}

  device_group = var.mode_map[var.mode] == 0 ? var.device_group : null
  rulebase     = var.mode_map[var.mode] == 0 ? each.value.rulebase : null

  position_keyword   = each.value.position_keyword
  position_reference = each.value.position_reference


  dynamic "rule" {
    for_each = each.value.rules

    content {
      name          = rule.value.name
      audit_comment = rule.value.audit_comment
      description   = rule.value.description
      tags          = rule.value.tags
      type          = rule.value.type
      disabled      = rule.value.disabled
      group_tag     = rule.value.group_tag
      uuid          = rule.value.uuid

      original_packet {
        destination_addresses = rule.value.original_packet.destination_addresses
        destination_zone      = rule.value.original_packet.destination_zone
        source_addresses      = rule.value.original_packet.source_addresses
        source_zones          = rule.value.original_packet.source_zones
        service               = rule.value.original_packet.service
      }

      translated_packet {

        destination {
          dynamic "static_translation" {
            for_each = try(rule.value.translated_packet.destination.static_translation, null) != null ? [1] : []
            content {
              address = rule.value.translated_packet.destination.static_translation.address
              port    = rule.value.translated_packet.destination.static_translation.port
            }
          }
          dynamic "dynamic_translation" {
            for_each = try(rule.value.translated_packet.destination.dynamic_translation, null) != null ? [1] : []
            content {
              address      = rule.value.translated_packet.destination.dynamic_translation.address
              port         = rule.value.translated_packet.destination.dynamic_translation.port
              distribution = rule.value.translated_packet.destination.dynamic_translation.distribution
            }
          }
        }

        source {
          dynamic "dynamic_ip_and_port" {
            for_each = try(rule.value.translated_packet.source.dynamic_ip_and_port, null) != null ? [1] : []
            content {
              dynamic "translated_address" {
                for_each = try(rule.value.translated_packet.source.dynamic_ip_and_port.translated_address, null) != null ? [1] : []
                content {
                  translated_addresses = rule.value.translated_packet.source.dynamic_ip_and_port.translated_address.translated_addresses
                }
              }
              dynamic "interface_address" {
                for_each = try(rule.value.translated_packet.source.dynamic_ip_and_port.interface_address, null) != null ? [1] : []
                content {
                  interface  = rule.value.translated_packet.source.dynamic_ip_and_port.interface_address.interface
                  ip_address = rule.value.translated_packet.source.dynamic_ip_and_port.interface_address.ip_address
                }
              }
            }
          }

          dynamic "dynamic_ip" {
            for_each = try(rule.value.translated_packet.source.dynamic_ip, null) != null ? [1] : []
            content {
              translated_addresses = rule.value.translated_packet.source.dynamic_ip.translated_addresses
              dynamic "fallback" {
                for_each = try(rule.value.translated_packet.source.dynamic_ip.fallback, null) != null ? [1] : []
                content {
                  dynamic "translated_address" {
                    for_each = try(rule.value.translated_packet.source.dynamic_ip.fallback.translated_address, null) != null ? [1] : []
                    content {
                      translated_addresses = rule.value.translated_packet.source.dynamic_ip.fallback.translated_address.translated_addresses
                    }
                  }
                  dynamic "interface_address" {
                    for_each = try(rule.value.translated_packet.source.dynamic_ip.fallback.interface_address, null) != null ? [1] : []
                    content {
                      interface  = rule.value.translated_packet.source.dynamic_ip.fallback.interface_address.interface
                      type       = rule.value.translated_packet.source.dynamic_ip.fallback.interface_address.type
                      ip_address = rule.value.translated_packet.source.dynamic_ip.fallback.interface_address.ip_address
                    }
                  }
                }
              }
            }
          }

          dynamic "static_ip" {
            for_each = try(rule.value.translated_packet.source.static_ip, null) != null ? [1] : []
            content {
              translated_address = rule.value.translated_packet.source.static_ip.translated_address
              bi_directional     = rule.value.translated_packet.source.static_ip.bi_directional
            }
          }
        }
      }

      dynamic "target" {
        for_each = try(rule.value.target, null) != null ? { for t in rule.value.target : t.serial => t } : {}
        content {
          serial    = target.value.serial
          vsys_list = target.value.vsys_list
        }
      }

      negate_target = rule.value.negate_target
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}


resource "panos_nat_rule_group" "this" {
  for_each = var.mode_map[var.mode] == 1 ? var.nat_policies : {}

  vsys = var.mode_map[var.mode] == 1 ? var.vsys : null

  position_keyword   = each.value.position_keyword
  position_reference = each.value.position_reference


  dynamic "rule" {
    for_each = each.value.rules

    content {
      name        = rule.value.name
      description = rule.value.description
      tags        = rule.value.tags
      type        = rule.value.type
      disabled    = rule.value.disabled

      dynamic "target" {
        for_each = try(rule.value.target, null) != null ? { for t in rule.value.target : t.serial => t } : {}
        content {
          serial    = target.value.serial
          vsys_list = target.value.vsys_list
        }
      }

      negate_target = rule.value.negate_target

      original_packet {
        destination_addresses = rule.value.original_packet.destination_addresses
        destination_zone      = rule.value.original_packet.destination_zone
        source_addresses      = rule.value.original_packet.source_addresses
        source_zones          = rule.value.original_packet.source_zones
        service               = rule.value.original_packet.service
      }

      translated_packet {

        destination {
          dynamic "static_translation" {
            for_each = try(rule.value.translated_packet.destination.static_translation, null) != null ? [1] : []
            content {
              address = rule.value.translated_packet.destination.static_translation.address
              port    = rule.value.translated_packet.destination.static_translation.port
            }
          }
          dynamic "dynamic_translation" {
            for_each = try(rule.value.translated_packet.destination.dynamic_translation, null) != null ? [1] : []
            content {
              address      = rule.value.translated_packet.destination.dynamic_translation.address
              port         = rule.value.translated_packet.destination.dynamic_translation.port
              distribution = rule.value.translated_packet.destination.dynamic_translation.distribution
            }
          }
        }

        source {
          dynamic "dynamic_ip_and_port" {
            for_each = try(rule.value.translated_packet.source.dynamic_ip_and_port, null) != null ? [1] : []
            content {
              dynamic "translated_address" {
                for_each = try(rule.value.translated_packet.source.dynamic_ip_and_port.translated_address, null) != null ? [1] : []
                content {
                  translated_addresses = rule.value.translated_packet.source.dynamic_ip_and_port.translated_address.translated_addresses
                }
              }
              dynamic "interface_address" {
                for_each = try(rule.value.translated_packet.source.dynamic_ip_and_port.interface_address, null) != null ? [1] : []
                content {
                  interface  = rule.value.translated_packet.source.dynamic_ip_and_port.interface_address.interface
                  ip_address = rule.value.translated_packet.source.dynamic_ip_and_port.interface_address.ip_address
                }
              }
            }
          }

          dynamic "dynamic_ip" {
            for_each = try(rule.value.translated_packet.source.dynamic_ip, null) != null ? [1] : []
            content {
              translated_addresses = rule.value.translated_packet.source.dynamic_ip.translated_addresses
              dynamic "fallback" {
                for_each = try(rule.value.translated_packet.source.dynamic_ip.fallback, null) != null ? [1] : []
                content {
                  dynamic "translated_address" {
                    for_each = try(rule.value.translated_packet.source.dynamic_ip.fallback.translated_address, null) != null ? [1] : []
                    content {
                      translated_addresses = rule.value.translated_packet.source.dynamic_ip.fallback.translated_address.translated_addresses
                    }
                  }
                  dynamic "interface_address" {
                    for_each = try(rule.value.translated_packet.source.dynamic_ip.fallback.interface_address, null) != null ? [1] : []
                    content {
                      interface  = rule.value.translated_packet.source.dynamic_ip.fallback.interface_address.interface
                      type       = rule.value.translated_packet.source.dynamic_ip.fallback.interface_address.type
                      ip_address = rule.value.translated_packet.source.dynamic_ip.fallback.interface_address.ip_address
                    }
                  }
                }
              }
            }
          }

          dynamic "static_ip" {
            for_each = try(rule.value.translated_packet.source.static_ip, null) != null ? [1] : []
            content {
              translated_address = try(rule.value.translated_packet.source.static_ip.translated_address, null)
              bi_directional     = try(rule.value.translated_packet.source.static_ip.bi_directional, false)
            }
          }
        }
      }
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}
