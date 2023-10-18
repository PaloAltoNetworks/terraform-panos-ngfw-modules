resource "panos_address_object" "this" {
  for_each = var.addresses_bulk_mode ? {} : var.address_objects

  device_group = var.mode_map[var.mode] == 0 ? var.device_group : null
  vsys         = var.mode_map[var.mode] == 1 ? var.vsys : null

  name        = each.key
  value       = each.value.value
  type        = each.value.type
  description = each.value.description
  tags        = each.value.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "panos_address_objects" "this" {
  for_each = var.addresses_bulk_mode ? toset([for mode in keys(var.mode_map) : mode if mode == var.mode]) : []

  device_group = var.mode_map[var.mode] == 0 ? var.device_group : null
  vsys         = var.mode_map[var.mode] == 1 ? var.vsys : null

  dynamic "object" {
    for_each = var.address_objects

    content {
      name        = object.key
      type        = object.value.type
      value       = object.value.value
      description = object.value.description
      tags        = object.value.tags
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "panos_panorama_address_group" "this" {
  for_each = var.mode_map[var.mode] == 0 ? var.address_groups : {}

  device_group = var.device_group

  name             = each.key
  static_addresses = each.value.members
  dynamic_match    = each.value.dynamic_match
  description      = each.value.description
  tags             = each.value.tags

  depends_on = [
    panos_address_object.this
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "panos_address_group" "this" {
  for_each = var.mode_map[var.mode] == 1 ? var.address_groups : {}

  vsys = var.vsys

  name             = each.key
  static_addresses = each.value.members
  dynamic_match    = each.value.dynamic_match
  description      = each.value.description
  tags             = each.value.tags

  depends_on = [
    panos_address_object.this
  ]

  lifecycle {
    create_before_destroy = true
  }
}
