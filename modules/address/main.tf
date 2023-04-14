locals {

  ## Address data normalization
  dg_addr_obj_raw = flatten([ for v in var.device_group : [ for i, j in var.addr_obj : merge({device_group=v},{name=i},j)] ])
  dg_addr_obj_normalized = { for v in local.dg_addr_obj_raw : "${v.name}_${try(v.device_group, "shared")}" => v }
  vsys_addr_obj_raw = flatten([ for v in var.vsys : [ for i, j in var.addr_obj : merge({dg=v},{name=i},j)] ])
  vsys_addr_obj_normalized = { for v in local.vsys_addr_obj_raw : "${v.name}_${try(v.vsys, "vsys1")}" => v }

  ## Address Group data normalization
  dg_addr_group_obj_raw = flatten([ for v in var.device_group : [ for i, j in var.addr_group : merge({device_group=v},{name=i},j)] ])
  dg_addr_group_obj_normalized = { for v in local.dg_addr_group_obj_raw : "${v.name}_${try(v.device_group, "shared")}" => v if var.panorama == true }
  vsys_addr_group_obj_raw = flatten([ for v in var.vsys : [ for i, j in var.addr_group : merge({vsys=v},{name=i},j)] ])
  vsys_addr_group_obj_normalized = { for v in local.vsys_addr_group_obj_raw : "${v.name}_${try(v.vsys, "vsys1")}" => v if var.panorama == false }

}

resource "panos_address_object" "this" {
#  for_each = length(local.dg_addr_obj) != 0 ? { for obj in var.addr_obj : obj.name => obj } : {}
  for_each = var.panorama == true && length(var.addr_obj) != 0 ? local.dg_addr_obj_normalized : var.panorama == false && length(var.addr_obj) != 0 ? local.vsys_addr_obj_normalized : {}

  device_group = var.panorama == true ? try(each.value.device_group, "shared") : null
  vsys         = var.panorama == false ? try(each.value.vsys, "vsys1") : null

  name        = each.value.name
  value       = each.value.value
  type        = each.value.type
  description = try(each.value.description, null)
  tags        = try(each.value.tags, null)

}

resource "panos_panorama_address_group" "this" {
#  for_each = var.panorama == true && length(var.addr_group) != 0 ? { for obj in var.addr_group : obj.name => obj } : {}
  for_each = local.dg_addr_group_obj_normalized

  name             = each.value.name
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
  for_each = local.vsys_addr_group_obj_normalized

  name             = each.value.name
  vsys             = try(each.value.vsys, "vsys1")
  static_addresses = try(each.value.members, null)
  dynamic_match    = try(each.value.dynamic_match, null)
  description      = try(each.value.description, null)
  tags             = try(each.value.tags, null)

  depends_on = [
    panos_address_object.this
  ]
}
