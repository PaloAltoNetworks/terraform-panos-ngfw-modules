resource "panos_zone" "this" {
  for_each = var.zones

  template       = var.mode_map[var.mode] == 0 ? (var.template_stack == "" ? try(var.template, "default") : null) : null
  template_stack = var.mode_map[var.mode] == 0 ? var.template_stack == "" ? null : var.template_stack : null

  vsys           = try(each.value.vsys, "vsys1")
  name           = each.key
  mode           = try(each.value.mode, null)
  interfaces     = try(each.value.interfaces, [])
  enable_user_id = try(each.value.enable_user_id, false)
  include_acls   = try(each.value.include_acls, [])
  exclude_acls   = try(each.value.exclude_acls, [])
}