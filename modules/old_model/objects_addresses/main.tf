resource "panos_address_object" "this" {
  for_each = length(var.addr_obj) != 0 ? { for obj in var.addr_obj : obj.name => obj } : {}

  device_group = var.panorama == true ? try(each.value.device_group, "shared") : null
  vsys         = var.panorama == false ? try(each.value.vsys, "vsys1") : null

  name        = each.key
  value       = lookup(each.value.value, each.value.type)
  type        = each.value.type
  description = try(each.value.description, null)
  tags        = try(each.value.tags, null)

}

resource "panos_panorama_address_group" "this" {
  for_each = var.panorama == true && length(var.addr_group) != 0 ? { for obj in var.addr_group : obj.name => obj } : {}

  name             = each.key
  device_group     = try(each.value.device_group, "shared")
  static_addresses = try(each.value.static_addresses, null)
  dynamic_match    = try(each.value.dynamic_match, null)
  description      = try(each.value.description, null)
  tags             = try(each.value.tags, null)

  depends_on = [
    panos_address_object.this
  ]
}

resource "panos_address_group" "this" {
  for_each = var.panorama == false && length(var.addr_group) != 0 ? { for obj in var.addr_group : obj.name => obj } : {}

  name             = each.key
  vsys             = try(each.value.vsys, "vsys1")
  static_addresses = try(each.value.static_addresses, null)
  dynamic_match    = try(each.value.dynamic_match, null)
  description      = try(each.value.description, null)
  tags             = try(each.value.tags, null)

  depends_on = [
    panos_address_object.this
  ]
}
