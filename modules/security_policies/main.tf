resource "panos_security_rule_group" "this" {
  for_each = var.sec_policy

  device_group = var.mode_map[var.mode] == 0 ? var.device_group : null
  rulebase     = var.mode_map[var.mode] == 0 ? try(each.value.rulebase, "pre-rulebase") : null
  vsys         = var.mode_map[var.mode] == 1 ? var.vsys : null

  position_keyword   = try(each.value.position_keyword, "")
  position_reference = try(each.value.position_reference, null)
  
  dynamic "rule" {
    for_each = [1]
    content {
      applications                       = try(each.value.applications, ["any"])
      categories                         = try(each.value.categories, ["any"])
      destination_addresses              = try(each.value.destination_addresses, ["any"])
      destination_zones                  = try(each.value.destination_zones, ["any"])
      name                               = each.key
      services                           = try(each.value.services, ["application-default"])
      source_addresses                   = try(each.value.source_addresses, ["any"])
      source_users                       = try(each.value.source_users, ["any"])
      source_zones                       = try(each.value.source_zones, ["any"])
      description                        = try(each.value.description, null)
      tags                               = try(each.value.tags, null)
      type                               = try(each.value.type, "universal")
      negate_source                      = try(each.value.negate_source, false)
      negate_destination                 = try(each.value.negate_destination, false)
      action                             = try(each.value.action, "allow")
      log_setting                        = try(each.value.log_setting, null)
      log_start                          = try(each.value.log_start, false)
      log_end                            = try(each.value.log_end, true)
      disabled                           = try(each.value.disabled, false)
      schedule                           = try(each.value.schedule, null)
      icmp_unreachable                   = try(each.value.icmp_unreachable, null)
      disable_server_response_inspection = try(each.value.disable_server_response_inspection, false)
      group                              = try(each.value.group, null)
      virus                              = try(each.value.virus, null)
      spyware                            = try(each.value.spyware, null)
      vulnerability                      = try(each.value.vulnerability, null)
      url_filtering                      = try(each.value.url_filtering, null)
      file_blocking                      = try(each.value.file_blocking, null)
      wildfire_analysis                  = try(each.value.wildfire_analysis, null)
      data_filtering                     = try(each.value.data_filtering, null)
      destination_devices                = try(each.value.destination_devices, ["any"])

      dynamic "target" {
        for_each = try(each.value.target, null) != null ? { for t in each.value.target : t.serial => t } : {}

        content {
          serial    = try(target.value.serial, null)
          vsys_list = try(target.value.vsys_list, null)
        }
      }
      negate_target = try(each.value.negate_target, false)
    }
  }
}
