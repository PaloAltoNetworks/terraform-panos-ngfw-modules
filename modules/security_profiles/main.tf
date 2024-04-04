locals {
  mode_map = {
    panorama = 0
    ngfw     = 1
    # cloud_manager = 2 # Not yet supported
  }
}

resource "panos_security_profile_group" "this" {
  for_each = var.security_profile_groups

  device_group = local.mode_map[var.mode] == 0 ? var.device_group : null
  vsys         = local.mode_map[var.mode] == 1 ? var.vsys : null
  name              = each.key
  antivirus_profile = try(each.value.antivirus_profile, null)
  anti_spyware_profile = try(each.value.anti_spyware_profile, null)
  vulnerability_profile = try(each.value.vulnerability_profile, null)
  url_filtering_profile = try(each.value.url_filtering_profile, null)
  file_blocking_profile = try(each.value.file_blocking_profile, null)
  data_filtering_profile = try(each.value.data_filtering_profile, null)
  wildfire_analysis_profile = try(each.value.wildfire_analysis_profile, null)
  gtp_profile = try(each.value.gtp_profile, null)
  sctp_profile = try(each.value.sctp_profile, null)
}

# Antivirus profiles
resource "panos_antivirus_security_profile" "this" {
  for_each = var.antivirus_profiles

  device_group = local.mode_map[var.mode] == 0 ? var.device_group : null
  vsys         = local.mode_map[var.mode] == 1 ? var.vsys : null

  name              = each.key
  description       = each.value.description
  packet_capture    = each.value.packet_capture
  threat_exceptions = each.value.threat_exceptions

  dynamic "decoder" {
    for_each = each.value.decoders

    content {
      name                    = decoder.value.name
      action                  = decoder.value.action
      wildfire_action         = decoder.value.wildfire_action
      machine_learning_action = decoder.value.machine_learning_action
    }
  }

  dynamic "application_exception" {
    for_each = each.value.application_exceptions

    content {
      application = application_exception.value.application
      action      = application_exception.value.action
    }
  }

  dynamic "machine_learning_model" {
    for_each = each.value.machine_learning_models

    content {
      model  = machine_learning_model.value.model
      action = machine_learning_model.value.action
    }
  }

  dynamic "machine_learning_exception" {
    for_each = each.value.machine_learning_exceptions

    content {
      name        = machine_learning_exception.value.name
      description = machine_learning_exception.value.description
      filename    = machine_learning_exception.value.filename
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Anti-spyware profiles
resource "panos_anti_spyware_security_profile" "this" {
  for_each = var.antispyware_profiles

  device_group = local.mode_map[var.mode] == 0 ? var.device_group : null
  vsys         = local.mode_map[var.mode] == 1 ? var.vsys : null

  name                  = each.key
  description           = each.value.description
  sinkhole_ipv4_address = each.value.sinkhole_ipv4_address
  sinkhole_ipv6_address = each.value.sinkhole_ipv6_address
  threat_exceptions     = each.value.threat_exceptions

  dynamic "botnet_list" {
    for_each = each.value.botnet_lists

    content {
      name           = botnet_list.value.name
      action         = botnet_list.value.action
      packet_capture = botnet_list.value.packet_capture
    }
  }

  dynamic "dns_category" {
    for_each = each.value.dns_categories

    content {
      name           = dns_category.value.name
      action         = dns_category.value.action
      log_level      = dns_category.value.log_level
      packet_capture = dns_category.value.packet_capture
    }
  }

  dynamic "white_list" {
    for_each = each.value.white_lists

    content {
      name        = white_list.value.name
      description = white_list.value.description
    }
  }

  dynamic "rule" {
    for_each = each.value.rules

    content {
      name              = rule.value.name
      threat_name       = rule.value.threat_name
      severities        = rule.value.severities
      category          = rule.value.category
      action            = rule.value.action
      packet_capture    = rule.value.packet_capture
      block_ip_track_by = rule.value.action == "block-ip" ? rule.value.block_ip_track_by : null
      block_ip_duration = rule.value.action == "block-ip" ? rule.value.block_ip_duration : null
    }
  }

  dynamic "exception" {
    for_each = each.value.exceptions

    content {
      name              = exception.value.name
      action            = exception.value.action
      block_ip_track_by = exception.value.action == "block-ip" ? exception.value.block_ip_track_by : null
      block_ip_duration = exception.value.action == "block-ip" ? exception.value.block_ip_duration : null
      packet_capture    = exception.value.packet_capture
      exempt_ips        = exception.value.exempt_ips
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

# File Blocking profiles
resource "panos_file_blocking_security_profile" "this" {
  for_each = var.file_blocking_profiles

  device_group = local.mode_map[var.mode] == 0 ? var.device_group : null
  vsys         = local.mode_map[var.mode] == 1 ? var.vsys : null

  name        = each.key
  description = try(each.value.description, null)

  dynamic "rule" {
    for_each = each.value.rules

    content {
      name         = rule.value.name
      applications = rule.value.applications
      file_types   = rule.value.file_types
      direction    = rule.value.direction
      action       = rule.value.action
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Vulnerability Protection profiles
resource "panos_vulnerability_security_profile" "this" {
  for_each = var.vulnerability_protection_profiles

  device_group = local.mode_map[var.mode] == 0 ? var.device_group : null
  vsys         = local.mode_map[var.mode] == 1 ? var.vsys : null

  name        = each.key
  description = try(each.value.description, null)

  dynamic "rule" {
    for_each = each.value.rules

    content {
      name              = rule.value.name
      threat_name       = rule.value.threat_name
      cves              = rule.value.cves
      host              = rule.value.host
      vendor_ids        = rule.value.vendor_ids
      severities        = rule.value.severities
      category          = rule.value.category
      action            = rule.value.action
      block_ip_track_by = rule.value.action == "block-ip" ? rule.value.block_ip_track_by : null
      block_ip_duration = rule.value.action == "block-ip" ? rule.value.block_ip_duration : null
      packet_capture    = rule.value.packet_capture
    }
  }

  dynamic "exception" {
    for_each = each.value.exceptions

    content {
      name              = exception.value.name
      action            = exception.value.action
      block_ip_track_by = exception.value.action == "block-ip" ? exception.value.block_ip_track_by : null
      block_ip_duration = exception.value.action == "block-ip" ? exception.value.block_ip_duration : null
      packet_capture    = exception.value.packet_capture
      time_interval     = exception.value.time_interval
      time_threshold    = exception.value.time_threshold
      time_track_by     = exception.value.time_track_by
      exempt_ips        = exception.value.exempt_ips
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

# WildFire Analysis profiles
resource "panos_wildfire_analysis_security_profile" "this" {
  for_each = var.wildfire_analysis_profiles

  device_group = local.mode_map[var.mode] == 0 ? var.device_group : null
  vsys         = local.mode_map[var.mode] == 1 ? var.vsys : null

  name        = each.key
  description = try(each.value.description, null)

  dynamic "rule" {
    for_each = each.value.rules

    content {
      name         = rule.value.name
      applications = rule.value.applications
      file_types   = rule.value.file_types
      direction    = rule.value.direction
      analysis     = rule.value.analysis
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "panos_url_filtering_security_profile" "this" {
  for_each = var.url_filtering_profiles

  device_group = local.mode_map[var.mode] == 0 ? var.device_group : null
  vsys         = local.mode_map[var.mode] == 1 ? var.vsys : null

  name        = each.key
  description = try(each.value.description, null)

  allow_categories = each.value.allow_categories
  alert_categories = each.value.alert_categories
  block_categories = each.value.block_categories
  continue_categories = each.value.continue_categories
  override_categories = each.value.override_categories
  track_container_page = each.value.track_container_page
  log_container_page_only = each.value.log_container_page_only
  safe_search_enforcement = each.value.safe_search_enforcement
  log_http_header_xff = each.value.log_http_header_xff
  log_http_header_user_agent = each.value.log_http_header_user_agent
  log_http_header_referer = each.value.log_http_header_referer
  ucd_mode = each.value.ucd_mode
  ucd_mode_group_mapping = each.value.ucd_mode_group_mapping
  ucd_log_severity = each.value.ucd_log_severity
  ucd_allow_categories = each.value.ucd_allow_categories
  ucd_alert_categories = each.value.ucd_alert_categories
  ucd_block_categories = each.value.ucd_block_categories
  ucd_continue_categories = each.value.ucd_continue_categories

  dynamic "http_header_insertion" {
    for_each = each.value.http_header_insertion

    content {
      name       = http_header_insertion.value.name
      type       = http_header_insertion.value.type
      domains    = http_header_insertion.value.domains

      dynamic "http_header" {
        for_each = each.value.http_header_insertion.http_header
        content {
          name = http_header.value.name
          header = http_header.value.header
          value = http_header.value.value
          log = http_header.value.log
        }
      }
    }
  }
  dynamic "machine_learning_model" {
    for_each = each.value.machine_learning_model

    content {
      model              = machine_learning_model.value.model
      action            = machine_learning_model.value.action
    }
  }
  
  machine_learning_exceptions = each.value.machine_learning_exceptions

  lifecycle {
    create_before_destroy = true
  }
}

resource "panos_data_filtering_security_profile" "this" {
  for_each = var.data_filtering_profiles

  device_group = local.mode_map[var.mode] == 0 ? var.device_group : null
  vsys         = local.mode_map[var.mode] == 1 ? var.vsys : null

  name        = each.key
  description = try(each.value.description, null)

  data_capture = each.value.data_capture

  dynamic "rule" {
    for_each = each.value.rule

    content {
      data_pattern       = rule.value.data_pattern
      applications    = rule.value.applications
      file_types = rule.value.file_types
      direction = rule.value.direction
      alert_threshold = rule.value.alert_threshold
      block_threshold = rule.value.block_threshold
      log_severity = rule.value.log_severity
    }
  }

  lifecycle {
    create_before_destroy = true
  }
  depends_on = [ panos_custom_data_pattern_object.this ]
}


resource "panos_custom_data_pattern_object" "this" {
  for_each = var.data_pattern_objects

  device_group = local.mode_map[var.mode] == 0 ? var.device_group : null
  vsys         = local.mode_map[var.mode] == 1 ? var.vsys : null

  name        = each.key
  description = try(each.value.description, null)

  type = each.value.type
  
  dynamic "predefined_pattern" {
    for_each = each.value.predefined_pattern

    content {
      name           = predefined_pattern.value.name
      file_types     = predefined_pattern.value.file_types
    }
  }
  dynamic "regex" {
    for_each = each.value.regex

    content {
      name           = regex.value.name
      file_types     = regex.value.file_types
      regex          = regex.value.regex
    }
  }
  dynamic "file_property" {
    for_each = each.value.file_property

    content {
      name           = file_property.value.name
      file_type      = file_property.value.file_type
      file_property  = file_property.value.file_property
      property_value     = file_property.value.property_value
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}