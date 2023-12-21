locals {
  mode_map = {
    panorama = 0
    ngfw     = 1
    # cloud_manager = 2 # Not yet supported
  }
}

resource "panos_panorama_template" "this" {
  for_each = local.mode_map[var.mode] == 0 ? var.templates : {}

  name        = each.key
  description = each.value.description

  lifecycle {
    create_before_destroy = true
  }
}
