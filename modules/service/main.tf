#locals {
#
#  ## Service data normalization
#  dg_service_obj_raw          = flatten([for v in var.device_group : [for i, j in var.services : merge({ device_group = v }, { name = i }, j)]])
#  dg_service_obj_normalized   = { for v in local.dg_service_obj_raw : "${v.name}_${try(v.device_group, "shared")}" => v }
#  vsys_service_obj_raw        = flatten([for v in var.vsys : [for i, j in var.services : merge({ vsys = v }, { name = i }, j)]])
#  vsys_service_obj_normalized = { for v in local.vsys_service_obj_raw : "${v.name}_${try(v.vsys, "vsys1")}" => v }
#
#  ## Service Group data normalization
#  dg_service_group_obj_raw          = flatten([for v in var.device_group : [for i, j in var.services_group : merge({ device_group = v }, { name = i }, j)]])
#  dg_service_group_obj_normalized   = { for v in local.dg_service_group_obj_raw : "${v.name}_${try(v.device_group, "shared")}" => v if var.panorama == true }
#  vsys_service_group_obj_raw        = flatten([for v in var.vsys : [for i, j in var.services_group : merge({ vsys = v }, { name = i }, j)]])
#  vsys_service_group_obj_normalized = { for v in local.vsys_service_group_obj_raw : "${v.name}_${try(v.vsys, "vsys1")}" => v if var.panorama == false }
#
#}


resource "panos_panorama_service_object" "this" {
#  for_each = var.panorama == true && length(var.services) != 0 ? local.dg_service_obj_normalized : {}
  for_each = var.mode_map[var.mode] == 0 ? var.services : {}

  device_group     = var.device_group

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

}

resource "panos_service_object" "this" {
  for_each = var.mode_map[var.mode] == 1 ? var.services : {}

  vsys             = var.vsys

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

}

resource "panos_panorama_service_group" "this" {
#  for_each = var.panorama == true && length(var.services_group) != 0 ? local.dg_service_group_obj_normalized : {}
  for_each = var.mode_map[var.mode] == 0 ? var.services_group : {}

  device_group     = var.device_group

  name     = each.key
  services = try(each.value.members, [])
  tags     = try(each.value.tags, null)

  depends_on = [
    panos_panorama_service_object.this
  ]
}


resource "panos_service_group" "this" {
#  for_each = var.panorama == false && length(var.services_group) != 0 ? local.vsys_service_group_obj_normalized : {}
  for_each = var.mode_map[var.mode] == 1 ? var.services_group : {}

  vsys             = var.vsys

  name     = each.key
  services = try(each.value.members, [])
  tags     = try(each.value.tags, null)

  depends_on = [
    panos_service_object.this
  ]
}