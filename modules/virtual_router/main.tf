resource "panos_virtual_router" "this" {
  for_each = var.virtual_routers

  template       = var.mode_map[var.mode] == 0 ? (var.template_stack == "" ? try(var.template, "default") : null) : null
  template_stack = var.mode_map[var.mode] == 0 ? var.template_stack == "" ? null : var.template_stack : null

  vsys = try(each.value.vsys, "vsys1")
  name = each.key
}
