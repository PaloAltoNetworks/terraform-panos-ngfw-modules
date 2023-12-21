locals {
  mode_map = {
    panorama = 0
    ngfw     = 1
    # cloud_manager = 2 # Not yet supported
  }
  dg_entries = flatten([for dk, dv in var.device_groups : [for ds in dv.serial : { dg = dk, serial = ds, vsys_list = dv.vsys_list }]])
}

resource "panos_device_group" "this" {
  for_each = local.mode_map[var.mode] == 0 ? var.device_groups : {}

  name        = each.key
  description = each.value.description

  lifecycle {
    create_before_destroy = true
  }
}

resource "panos_device_group_entry" "this" {
  for_each = local.mode_map[var.mode] == 0 ? { for i in local.dg_entries : "${i.dg}_${i.serial}" => i } : {}

  device_group = each.value.dg
  serial       = each.value.serial
  vsys_list    = each.value.vsys_list

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [panos_device_group.this]
}

resource "panos_device_group_parent" "this" {
  for_each = local.mode_map[var.mode] == 0 ? { for k, v in var.device_groups : k => v if try(v.parent, null) != null } : {}

  device_group = each.key
  parent       = each.value.parent

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [panos_device_group.this]
}