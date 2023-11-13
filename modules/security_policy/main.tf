resource "panos_security_policy" "this" {

  device_group = var.mode_map[var.mode] == 0 ? var.device_group : null
  rulebase     = var.mode_map[var.mode] == 0 ? var.rulebase : null
  vsys         = var.mode_map[var.mode] == 1 ? var.vsys : null

  dynamic "rule" {
    for_each = var.rules

    content {
      name                               = rule.value.name
      description                        = rule.value.description
      applications                       = rule.value.applications
      categories                         = rule.value.categories
      destination_addresses              = rule.value.destination_addresses
      destination_zones                  = rule.value.destination_zones
      destination_devices                = rule.value.destination_devices
      services                           = rule.value.services
      source_addresses                   = rule.value.source_addresses
      source_users                       = rule.value.source_users
      source_zones                       = rule.value.source_zones
      source_devices                     = rule.value.source_devices
      hip_profiles                       = rule.value.hip_profiles
      tags                               = rule.value.tags
      type                               = rule.value.type
      negate_source                      = rule.value.negate_source
      negate_destination                 = rule.value.negate_destination
      action                             = rule.value.action
      log_setting                        = rule.value.log_setting
      log_start                          = rule.value.log_start
      log_end                            = rule.value.log_end
      disabled                           = rule.value.disabled
      schedule                           = rule.value.schedule
      icmp_unreachable                   = rule.value.icmp_unreachable
      disable_server_response_inspection = rule.value.disable_server_response_inspection
      group                              = rule.value.group
      virus                              = rule.value.virus
      spyware                            = rule.value.spyware
      vulnerability                      = rule.value.vulnerability
      url_filtering                      = rule.value.url_filtering
      file_blocking                      = rule.value.file_blocking
      wildfire_analysis                  = rule.value.wildfire_analysis
      data_filtering                     = rule.value.data_filtering
      audit_comment                      = rule.value.audit_comment
      group_tag                          = rule.value.group_tag
      negate_target                      = rule.value.negate_target

      dynamic "target" {
        for_each = try(rule.value.target, null) != null ? { for t in rule.value.target : t.serial => t } : {}
        content {
          serial    = target.value.serial
          vsys_list = target.value.vsys_list
        }
      }
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}
