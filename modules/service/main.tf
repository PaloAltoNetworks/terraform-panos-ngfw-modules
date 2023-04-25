resource "panos_panorama_service_object" "this" {
  for_each = var.mode_map[var.mode] == 0 ? var.services : {}

  device_group = var.device_group

  destination_port = each.value.destination_port
  name             = each.key
  protocol         = each.value.protocol

  description                  = try(each.value.description, null)
  source_port                  = try(each.value.source_port, null)
  tags                         = try(each.value.tags, null)
  override_session_timeout     = try(each.value.override_session_timeout, false)
  override_timeout             = try(each.value.override_timeout, null)
  override_half_closed_timeout = try(each.value.override_half_closed_timeout, null)
  override_time_wait_timeout   = try(each.value.override_time_wait_timeout, null)

  lifecycle {
    create_before_destroy = true
  }
}

resource "panos_service_object" "this" {
  for_each = var.mode_map[var.mode] == 1 ? var.services : {}

  vsys = var.vsys

  destination_port = each.value.destination_port
  name             = each.key
  protocol         = each.value.protocol

  description                  = try(each.value.description, null)
  source_port                  = try(each.value.source_port, null)
  tags                         = try(each.value.tags, null)
  override_session_timeout     = try(each.value.override_session_timeout, false)
  override_timeout             = try(each.value.override_timeout, null)
  override_half_closed_timeout = try(each.value.override_half_closed_timeout, null)
  override_time_wait_timeout   = try(each.value.override_time_wait_timeout, null)

  lifecycle {
    create_before_destroy = true
  }
}

resource "panos_panorama_service_group" "this" {
  for_each = var.mode_map[var.mode] == 0 ? var.services_group : {}

  device_group = var.device_group

  name     = each.key
  services = try(each.value.members, [])
  tags     = try(each.value.tags, null)

  depends_on = [
    panos_panorama_service_object.this
  ]

  lifecycle {
    create_before_destroy = true
  }
}


resource "panos_service_group" "this" {
  for_each = var.mode_map[var.mode] == 1 ? var.services_group : {}

  vsys = var.vsys

  name     = each.key
  services = try(each.value.members, [])
  tags     = try(each.value.tags, null)

  depends_on = [
    panos_service_object.this
  ]

  lifecycle {
    create_before_destroy = true
  }
}