resource "panos_log_forwarding_profile" "this" {
  for_each = var.mode_map[var.mode] == 1 ? var.profiles : {}

  name = each.key
  vsys = var.vsys

  description      = each.value.description
  enhanced_logging = each.value.enhanced_logging

  dynamic "match_list" {
    for_each = each.value.match_lists

    content {
      name                     = match_list.value.name
      description              = match_list.value.description
      log_type                 = match_list.value.log_type
      filter                   = match_list.value.filter
      send_to_panorama         = match_list.value.send_to_panorama
      snmptrap_server_profiles = match_list.value.snmptrap_server_profiles
      email_server_profiles    = match_list.value.email_server_profiles
      syslog_server_profiles   = match_list.value.syslog_server_profiles
      http_server_profiles     = match_list.value.http_server_profiles

      dynamic "action" {
        for_each = match_list.value.actions

        content {
          name = action.value.name

          dynamic "azure_integration" {
            for_each = try(action.value.azure_integration, null) != null ? [1] : []

            content {
              azure_integration = true
            }
          }

          dynamic "tagging_integration" {
            for_each = try(action.value.tagging_integration, null) != null ? [1] : []

            content {
              action  = action.value.tagging_integration.action
              target  = action.value.tagging_integration.target
              timeout = action.value.tagging_integration.timeout

              dynamic "local_registration" {
                for_each = try(action.value.tagging_integration.local_registration, null) != null ? [1] : []

                content {
                  tags = action.value.tagging_integration.local_registration.tags
                }
              }

              dynamic "panorama_registration" {
                for_each = try(action.value.tagging_integration.panorama_registration, null) != null ? [1] : []

                content {
                  tags = action.value.tagging_integration.panorama_registration.tags
                }
              }

              dynamic "remote_registration" {
                for_each = try(action.value.tagging_integration.remote_registration, null) != null ? [1] : []

                content {
                  http_profile = action.value.tagging_integration.remote_registration.http_profile
                  tags         = action.value.tagging_integration.remote_registration.tags
                }
              }
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

resource "panos_panorama_log_forwarding_profile" "this" {
  for_each = var.mode_map[var.mode] == 0 ? var.profiles : {}

  name         = each.key
  device_group = var.device_group

  description      = each.value.description
  enhanced_logging = each.value.enhanced_logging

  dynamic "match_list" {
    for_each = each.value.match_lists

    content {
      name                     = match_list.value.name
      description              = match_list.value.description
      log_type                 = match_list.value.log_type
      filter                   = match_list.value.filter
      send_to_panorama         = match_list.value.send_to_panorama
      snmptrap_server_profiles = match_list.value.snmptrap_server_profiles
      email_server_profiles    = match_list.value.email_server_profiles
      syslog_server_profiles   = match_list.value.syslog_server_profiles
      http_server_profiles     = match_list.value.http_server_profiles

      dynamic "action" {
        for_each = match_list.value.actions

        content {
          name = action.value.name

          dynamic "azure_integration" {
            for_each = try(action.value.azure_integration, null) != null ? [1] : []

            content {
              azure_integration = true
            }
          }

          dynamic "tagging_integration" {
            for_each = try(action.value.tagging_integration, null) != null ? [1] : []

            content {
              action  = action.value.tagging_integration.action
              target  = action.value.tagging_integration.target
              timeout = action.value.tagging_integration.timeout

              dynamic "local_registration" {
                for_each = try(action.value.tagging_integration.local_registration, null) != null ? [1] : []

                content {
                  tags = action.value.tagging_integration.local_registration.tags
                }
              }

              dynamic "panorama_registration" {
                for_each = try(action.value.tagging_integration.panorama_registration, null) != null ? [1] : []

                content {
                  tags = action.value.tagging_integration.panorama_registration.tags
                }
              }

              dynamic "remote_registration" {
                for_each = try(action.value.tagging_integration.remote_registration, null) != null ? [1] : []

                content {
                  http_profile = action.value.tagging_integration.remote_registration.http_profile
                  tags         = action.value.tagging_integration.remote_registration.tags
                }
              }
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