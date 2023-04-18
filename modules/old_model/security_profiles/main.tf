#antivirus
resource "panos_antivirus_security_profile" "this" {
  for_each = length(var.antivirus) != 0 ? { for virus in var.antivirus : virus.name => virus } : tomap()

  name              = each.key
  device_group      = try(each.value.device_group, "shared")
  description       = try(each.value.description, null)
  packet_capture    = try(each.value.packet_capture, false)
  threat_exceptions = try(each.value.threat_exceptions, null)

  dynamic "decoder" {
    for_each = try(each.value.decoder, null) != null ? { for d in each.value.decoder : d.name => d } : {}
    content {
      name                    = decoder.value.name
      action                  = try(decoder.value.action, "default")
      wildfire_action         = try(decoder.value.wildfire_action, "default")
      machine_learning_action = try(decoder.value.machine_learning, null)
    }
  }

  dynamic "application_exception" {
    for_each = try(each.value.application_exception, null) != null ? { for app in each.value.application_exception : app.application => app } : tomap({})
    content {
      application = application_exception.value.application
      action      = try(application_exception.value.action, "default")
    }
  }

  dynamic "machine_learning_model" {
    for_each = try(each.value.machine_learning_model, null) != null ? { for mod in each.value.machine_learning_model : mod.model => mod } : tomap({})
    content {
      model  = machine_learning_model.value.model
      action = try(machine_learning_model.value.action, "disable")
    }
  }

  dynamic "machine_learning_exception" {
    for_each = try(each.value.machine_learning_exception, null) != null ? { for ex in each.value.machine_learning_exception : ex.name => ex } : tomap({})
    content {
      name        = machine_learning_exception.value.name
      description = try(machine_learning_exception.value.description, null)
      filename    = try(machine_learning_exception.value.filename, null)
    }
  }

}

#anti-spyware
resource "panos_anti_spyware_security_profile" "this" {
  for_each = length(var.spyware) != 0 ? { for file in var.spyware : file.name => file } : tomap()

  name                  = each.key
  device_group          = try(each.value.device_group, "shared")
  description           = try(each.value.description, null)
  sinkhole_ipv4_address = try(each.value.sinkhole_ipv4_address, null)
  sinkhole_ipv6_address = try(each.value.sinkhole_ipv6_address, null)
  threat_exceptions     = try(each.value.threat_exceptions, null)

  dynamic "botnet_list" {
    for_each = try(each.value.botnet_list, null) != null ? { for botnet in each.value.botnet_list : botnet.name => botnet } : tomap({})
    content {
      name           = botnet_list.value.name
      action         = try(botnet_list.value.action, "default")
      packet_capture = try(botnet_list.value.packet_capture, "disable")
    }
  }

  dynamic "dns_category" {
    for_each = try(each.value.dns_category, null) != null ? { for cat in each.value.dns_category : cat.name => cat } : {}
    content {
      name           = dns_category.value.name
      action         = try(dns_category.value.action, "default")
      log_level      = try(dns_category.value.log_level, "default")
      packet_capture = try(dns_category.value.packet_capture, "disable")
    }
  }

  dynamic "white_list" {
    for_each = try(each.value.white_list, null) != null ? { for list in each.value.white_list : list.name => list } : {}
    content {
      name        = white_list.value.name
      description = try(white_list.value.description, null)
    }
  }

  dynamic "rule" {
    for_each = try(each.value.rule, null) != null ? { for rules in each.value.rule : rules.name => rules } : tomap({})
    content {
      name              = rule.value.name
      threat_name       = try(rule.value.threat_name, "any")
      severities        = try(rule.value.severities, ["any"])
      category          = try(rule.value.category, "any")
      action            = try(rule.value.action, "default")
      block_ip_track_by = try(rule.value.action, null) == "block-ip" ? try(rule.value.block_ip_track_by, null) : null
      block_ip_duration = try(rule.value.action, null) == "block-ip" ? try(rule.value.block_ip_duration) : null
      packet_capture    = try(rule.value.packet_capture, "disable")
    }
  }

  dynamic "exception" {
    for_each = try(each.value.exception, null) != null ? { for ex in each.value.exception : ex.name => ex } : tomap({})
    content {
      name              = exception.value.name
      action            = try(exception.value.action, "default")
      block_ip_track_by = try(exception.value.action, null) == "block-ip" ? try(exception.value.block_ip_track_by, null) : null
      block_ip_duration = try(exception.value.action, null) == "block-ip" ? try(exception.value.block_ip_duration, null) : null
      packet_capture    = try(exception.value.packet_capture, "disable")
      exempt_ips        = try(exception.value.exempt_ips, null)
    }
  }
}

#file-blocking
resource "panos_file_blocking_security_profile" "this" {
  for_each = length(var.file_blocking) != 0 ? { for file in var.file_blocking : file.name => file } : tomap()

  name         = each.key
  device_group = try(each.value.device_group, "shared")
  description  = try(each.value.description, null)

  dynamic "rule" {
    for_each = try(each.value.rule, null) != null ? { for rules in each.value.rule : rules.name => rules } : tomap({})
    content {
      name         = rule.value.name
      applications = try(rule.value.applications, ["any"])
      file_types   = try(rule.value.file_types, ["any"])
      direction    = try(rule.value.direction, "both")
      action       = try(rule.value.action, "alert")
    }
  }
}

#vulnerability
resource "panos_vulnerability_security_profile" "this" {
  for_each = length(var.vulnerability) != 0 ? { for file in var.vulnerability : file.name => file } : tomap()

  name         = each.key
  device_group = try(each.value.device_group, "shared")
  description  = try(each.value.description, null)

  dynamic "rule" {
    for_each = try(each.value.rule, null) != null ? { for rules in each.value.rule : rules.name => rules } : tomap({})
    content {
      name              = rule.value.name
      threat_name       = try(rule.value.threat_name, "any")
      cves              = try(rule.value.cves, ["any"])
      host              = try(rule.value.host, "any")
      vendor_ids        = try(rule.value.vendor_ids, ["any"])
      severities        = try(rule.value.severities, ["any"])
      category          = try(rule.value.category, "any")
      action            = try(rule.value.action, "default")
      block_ip_track_by = try(rule.value.action, null) == "block-ip" ? try(rule.value.block_ip_track_by, null) : null
      block_ip_duration = try(rule.value.action, null) == "block-ip" ? try(rule.value.block_ip_duration, null) : null
      packet_capture    = try(rule.value.packet_capture, "disable")
    }
  }

  dynamic "exception" {
    for_each = try(each.value.exception, null) != null ? { for ex in each.value.exception : ex.name => ex } : tomap({})
    content {
      name              = exception.value.name
      action            = try(exception.value.action, "default")
      block_ip_track_by = try(exception.value.action, null) == "block-ip" ? try(exception.value.block_ip_track_by, null) : null
      block_ip_duration = try(exception.value.action, null) == "block-ip" ? try(exception.value.block_ip_duration, null) : null
      packet_capture    = try(exception.value.packet_capture, "disable")
      time_interval     = try(exception.value.time_interval, null)
      time_threshold    = try(exception.value.time_threshold, null)
      time_track_by     = try(exception.value.time_track_by, null)
      exempt_ips        = try(exception.value.exempt_ips, null)
    }
  }
}

#wildfire analysis
resource "panos_wildfire_analysis_security_profile" "this" {
  for_each = length(var.wildfire) != 0 ? { for file in var.wildfire : file.name => file } : tomap()

  name         = each.key
  device_group = try(each.value.device_group, "shared")
  description  = try(each.value.description, null)

  dynamic "rule" {
    for_each = try(each.value.rule, null) != null ? { for rules in each.value.rule : rules.name => rules } : tomap({})
    content {
      name         = rule.value.name
      applications = try(rule.value.applications, ["any"])
      file_types   = try(rule.value.file_types, ["any"])
      direction    = try(rule.value.direction, "both")
      analysis     = try(rule.value.analysis, "public-cloud")
    }
  }
}