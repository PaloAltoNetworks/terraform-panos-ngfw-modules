module "mode_lookup" {
  source = "../mode_lookup"
  mode   = var.mode
}
resource "panos_zone" "this" {
  for_each = length(var.zones) != 0 ? { for zone in var.zones : zone.name => zone } : {}

  template       = module.mode_lookup.mode == 0 ? (each.value.template_stack == "" ? try(each.value.template, "default") : null) : null
  template_stack = module.mode_lookup.mode == 0 ? each.value.template_stack == "" ? null : each.value.template_stack : null

  vsys           = try(each.value.vsys, "vsys1")
  name           = each.key
  mode           = try(each.value.mode, null)
  interfaces     = try(each.value.interfaces, [])
  enable_user_id = try(each.value.enable_user_id, false)
  include_acls   = try(each.value.include_acls, [])
  exclude_acls   = try(each.value.exclude_acls, [])
}

resource "panos_zone_entry" "this" {
  for_each = length(var.zone_entries) != 0 ? { for intf in var.zone_entries : intf.interface => intf } : {}

  template       = module.mode_lookup.mode == 0 ? (each.value.template_stack == "" ? try(each.value.template, "default") : null) : null
  template_stack = module.mode_lookup.mode == 0 ? each.value.template_stack == "" ? null : each.value.template_stack : null

  vsys      = try(each.value.vsys, "vsys1")
  zone      = each.value.zone
  interface = each.value.interface

  depends_on = [
    panos_panorama_ethernet_interface.this,
    panos_panorama_loopback_interface.this,
    panos_panorama_tunnel_interface.this,
    panos_ethernet_interface.this,
    panos_loopback_interface.this,
    panos_tunnel_interface.this,
  ]

}