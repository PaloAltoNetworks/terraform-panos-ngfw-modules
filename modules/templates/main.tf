resource "panos_panorama_template" "this" {
  for_each = var.mode_map[var.mode] == 0 ? var.templates : {}

  name        = each.key
  description = each.value.description

  lifecycle {
    create_before_destroy = true
  }
}
