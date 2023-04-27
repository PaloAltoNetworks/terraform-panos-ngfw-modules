resource "panos_address_object" "this" {
  for_each = var.address_objects

  device_group = var.mode_map[var.mode] == 0 ? var.device_group : null
  vsys         = var.mode_map[var.mode] == 1 ? var.vsys : null

  name        = each.key
  value       = each.value.value
  type        = each.value.type
  description = try(each.value.description, null)
  tags        = try(each.value.tags, null)

  lifecycle {
    create_before_destroy = true
  }
}

resource "panos_panorama_address_group" "this" {
  for_each = var.mode_map[var.mode] == 0 ? var.address_groups : {}

  name             = each.key
  device_group     = var.device_group
  static_addresses = try(each.value.members, null)
  dynamic_match    = try(each.value.dynamic_match, null)
  description      = try(each.value.description, null)
  tags             = try(each.value.tags, null)

  depends_on = [
    panos_address_object.this
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "panos_address_group" "this" {
  for_each = var.mode_map[var.mode] == 1 ? var.address_groups : {}

  name             = each.key
  vsys             = var.vsys
  static_addresses = try(each.value.members, null)
  dynamic_match    = try(each.value.dynamic_match, null)
  description      = try(each.value.description, null)
  tags             = try(each.value.tags, null)

  depends_on = [
    panos_address_object.this
  ]

  lifecycle {
    create_before_destroy = true
  }
}
