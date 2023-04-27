resource "panos_panorama_administrative_tag" "this" {
  for_each = var.mode_map[var.mode] == 0 ? var.tags : {}

  name         = each.key
  color        = try(var.tag_color_map[lower(replace(each.value.color, " ", "_"))], null)
  comment      = try(each.value.comment, null)
  device_group = var.device_group

  lifecycle {
    create_before_destroy = true
  }
}

resource "panos_administrative_tag" "this" {
  for_each = var.mode_map[var.mode] == 1 ? var.tags : {}

  name    = each.key
  color   = try(var.tag_color_map[lower(replace(each.value.color, " ", "_"))], null)
  comment = try(each.value.comment, null)
  vsys    = var.vsys

  lifecycle {
    create_before_destroy = true
  }
}
