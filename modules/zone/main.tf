resource "panos_zone" "this" {
  for_each = var.zones

  template       = var.mode_map[var.mode] == 0 ? (var.template_stack == "" ? try(var.template, "default") : null) : null
  template_stack = var.mode_map[var.mode] == 0 ? var.template_stack == "" ? null : var.template_stack : null

  name           = each.key
  vsys           = each.value.vsys
  mode           = each.value.mode
  interfaces     = each.value.interfaces
  enable_user_id = each.value.enable_user_id
  include_acls   = each.value.include_acls
  exclude_acls   = each.value.exclude_acls

  lifecycle {
    create_before_destroy = true
  }
}
