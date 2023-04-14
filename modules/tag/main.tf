locals {
  dg_tags_obj   = toset(flatten([for v in var.device_group : [for i, j in var.tags : merge({ dg = v }, { name = i }, j)]]))
  vsys_tags_obj = toset(flatten([for v in var.vsys : [for i, j in var.tags : merge({ dg = v }, { name = i }, j)]]))
}

resource "panos_panorama_administrative_tag" "this" {
  for_each = var.panorama == true && length(var.tags) != 0 ? { for v in local.dg_tags_obj : "${v.name}_${try(v.dg, "shared")}" => v } : {}

  name         = each.value.name
  color        = try(var.tag_color_map[lower(replace(each.value.color, " ", "_"))], null)
  comment      = try(each.value.comment, null)
  device_group = try(each.value.dg, "shared")
}

resource "panos_administrative_tag" "this" {
  for_each = var.panorama == false && length(var.tags) != 0 ? { for v in local.vsys_tags_obj : "${v.name}_${try(v.vsys, "vsys1")}" => v } : {}

  name    = each.value.name
  color   = try(var.tag_color_map[lower(replace(each.value.color, " ", "_"))], null)
  comment = try(each.value.comment, null)
  vsys    = try(each.value.vsys, "vsys1")
}
