#locals {
#  dg_tags_obj   = toset(flatten([for v in var.device_group : [for i, j in var.tags : merge({ dg = v }, { name = i }, j)]]))
#  vsys_tags_obj = toset(flatten([for v in var.vsys : [for i, j in var.tags : merge({ dg = v }, { name = i }, j)]]))
#}

resource "panos_panorama_administrative_tag" "this" {
  for_each = var.mode_map[var.mode] == 0 ? var.tags : {}

  name         = each.key
  color        = try(var.tag_color_map[lower(replace(each.value.color, " ", "_"))], null)
  comment      = try(each.value.comment, null)
  device_group = var.device_group
}

resource "panos_administrative_tag" "this" {
  for_each = var.mode_map[var.mode] == 1 ? var.tags : {}

  name    = each.key
  color   = try(var.tag_color_map[lower(replace(each.value.color, " ", "_"))], null)
  comment = try(each.value.comment, null)
  vsys    = var.vsys
}
