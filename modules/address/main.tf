# Retrieve mode
module "mode_lookup" {
  source = "../mode_lookup"
  mode   = var.mode
}

resource "panos_address_object" "this" {
  for_each = var.address_objects

  device_group = module.mode_lookup.mode == 0 ? try(each.value.device_group, "shared") : null
  vsys         = module.mode_lookup.mode == 1 ? try(each.value.vsys, "vsys1") : null

  name        = each.key
  value       = each.value.value
  type        = each.value.type
  description = try(each.value.description, null)
  tags        = try(each.value.tags, null)

}

resource "panos_panorama_address_group" "this" {
  for_each = module.mode_lookup.mode == 0 ? var.address_groups : {}

  name             = each.key
  device_group     = try(each.value.device_group, "shared")
  static_addresses = try(each.value.members, null)
  dynamic_match    = try(each.value.dynamic_match, null)
  description      = try(each.value.description, null)
  tags             = try(each.value.tags, null)

  depends_on = [
    panos_address_object.this
  ]
}

resource "panos_address_group" "this" {
  for_each = module.mode_lookup.mode == 1 ? var.address_groups : {}

  name             = each.key
  vsys             = try(each.value.vsys, "vsys1")
  static_addresses = try(each.value.members, null)
  dynamic_match    = try(each.value.dynamic_match, null)
  description      = try(each.value.description, null)
  tags             = try(each.value.tags, null)

  depends_on = [
    panos_address_object.this
  ]
}
