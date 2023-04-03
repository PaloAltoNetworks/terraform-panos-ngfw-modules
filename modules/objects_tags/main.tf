resource "panos_panorama_administrative_tag" "this" {
  for_each = var.panorama == true && length(var.tags) != 0 ? { for tag in var.tags : tag.name => tag } : {}

  name         = each.key
  color        = try(var.tag_color_map[lower(replace(each.value.color, " ", "_"))], null)
  comment      = try(each.value.comment, null)
  device_group = try(each.value.device_group, "shared")
}

resource "panos_administrative_tag" "this" {
  for_each = var.panorama == false && length(var.tags) != 0 ? { for tag in var.tags : tag.name => tag } : {}

  name    = each.key
  color   = try(each.value.color, null)
  comment = try(each.value.comment, null)
  vsys    = try(each.value.vsys, "vsys1")
}
