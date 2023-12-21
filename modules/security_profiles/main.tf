locals {
  mode_map = {
    panorama = 0
    ngfw     = 1
    # cloud_manager = 2 # Not yet supported
  }
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