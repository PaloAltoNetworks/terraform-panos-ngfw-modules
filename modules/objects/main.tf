resource "panos_panorama_administrative_tag" "this" {
  for_each = var.panorama_mode == true && length(var.tags) != 0 ? { for tag in var.tags : tag.name => tag } : {}

  name         = each.key
  color        = try(each.value.color, null)
  comment      = try(each.value.comment, null)
  device_group = try(each.value.device_group, "shared")
}

resource "panos_administrative_tag" "this" {
  for_each = var.panorama_mode == false && length(var.tags) != 0 ? { for tag in var.tags : tag.name => tag } : {}

  name    = each.key
  color   = try(each.value.color, null)
  comment = try(each.value.comment, null)
  vsys    = try(each.value.vsys, "vsys1")
}


resource "panos_address_object" "this" {
  for_each = length(var.addr_obj) != 0 ? { for obj in var.addr_obj : obj.name => obj } : {}

  device_group = var.panorama_mode == true ? try(each.value.device_group, "shared") : null
  vsys         = var.panorama_mode == false ? try(each.value.vsys, "vsys1") : null

  name        = each.key
  value       = lookup(each.value.value, each.value.type)
  type        = each.value.type
  description = try(each.value.description, null)
  tags        = try(each.value.tags, null)

  depends_on = [
    panos_panorama_administrative_tag.this,
    panos_administrative_tag.this,
  ]
}

resource "panos_panorama_address_group" "this" {
  for_each = var.panorama_mode == true && length(var.addr_group) != 0 ? { for obj in var.addr_group : obj.name => obj } : {}

  name             = each.key
  device_group     = try(each.value.device_group, "shared")
  static_addresses = try(each.value.static_addresses, null)
  dynamic_match    = try(each.value.dynamic_match, null)
  description      = try(each.value.description, null)
  tags             = try(each.value.tags, null)

  depends_on = [
    panos_panorama_administrative_tag.this,
    panos_address_object.this
  ]
}

resource "panos_address_group" "this" {
  for_each = var.panorama_mode == false && length(var.addr_group) != 0 ? { for obj in var.addr_group : obj.name => obj } : {}

  name             = each.key
  vsys             = try(each.value.vsys, "vsys1")
  static_addresses = try(each.value.static_addresses, null)
  dynamic_match    = try(each.value.dynamic_match, null)
  description      = try(each.value.description, null)
  tags             = try(each.value.tags, null)

  depends_on = [
    panos_panorama_administrative_tag.this,
    panos_address_object.this
  ]
}

resource "panos_panorama_service_object" "this" {
  for_each = var.panorama_mode == true && length(var.services) != 0 ? { for obj in var.services : obj.name => obj } : {}

  destination_port             = each.value.destination_port
  name                         = each.key
  protocol                     = each.value.protocol
  device_group                 = try(each.value.device_group, "shared")
  description                  = try(each.value.description, null)
  source_port                  = try(each.value.source_port, null)
  tags                         = try(each.value.tags, null)
  override_session_timeout     = try(each.value.override_session_timeout, false)
  override_timeout             = try(each.value.override_timeout, null)
  override_half_closed_timeout = try(each.value.override_half_closed_timeout, null)
  override_time_wait_timeout   = try(each.value.override_time_wait_timeout, null)

  depends_on = [
    panos_panorama_administrative_tag.this,
  ]
}

resource "panos_service_object" "this" {
  for_each = var.panorama_mode == false && length(var.services) != 0 ? { for obj in var.services : obj.name => obj } : {}

  vsys = try(each.value.vsys, "vsys1")

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

  depends_on = [
    panos_administrative_tag.this,
  ]
}

resource "panos_panorama_service_group" "this" {
  for_each = var.panorama_mode == true && length(var.addr_group) != 0 ? { for obj in var.service_groups : obj.name => obj } : tomap({})

  device_group = try(each.value.device_group, "shared")

  name     = each.key
  services = try(each.value.services, [])
  tags     = try(each.value.tags, null)

  depends_on = [
    panos_panorama_administrative_tag.this,
    panos_panorama_service_object.this
  ]
}


resource "panos_service_group" "this" {
  for_each = var.panorama_mode == true && length(var.addr_group) != 0 ? { for obj in var.service_groups : obj.name => obj } : tomap({})

  vsys = try(each.value.vsys, "vsys1")

  name     = each.key
  services = try(each.value.services, [])
  tags     = try(each.value.tags, null)

  depends_on = [
    panos_administrative_tag.this,
    panos_service_object.this
  ]
}