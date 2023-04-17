resource "panos_security_rule_group" "this" {
  for_each = var.sec_policy

  device_group = var.mode_map[var.mode] == 0 ? var.device_group : null
  rulebase     = var.mode_map[var.mode] == 0 ? try(each.value.rulebase, "pre-rulebase") : null
  vsys         = var.mode_map[var.mode] == 1 ? var.vsys : null

  position_keyword   = try(each.value.position_keyword, "")
  position_reference = try(each.value.position_reference, null)
  
  dynamic "rule" {
    for_each = each.value.policies_rules
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
      destination_devices                = try(rule.value.destination_devices, ["any"])

      dynamic "target" {
        for_each = try(rule.value.target, null) != null ? { for t in rule.value.target : t.serial => t } : {}

        content {
          serial    = try(target.value.serial, null)
          vsys_list = try(target.value.vsys_list, null)
        }
      }
      negate_target = try(each.value.negate_target, false)
    }
  }
}
