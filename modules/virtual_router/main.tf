module "mode_lookup" {
  source = "../mode_lookup"
  mode   = var.mode
}

resource "panos_virtual_router" "this" {
  for_each = length(var.virtual_routers) != 0 ? { for vrouter in var.virtual_routers : vrouter.name => vrouter } : {}

  template       = module.mode_lookup.mode == 0 ? (each.value.template_stack == "" ? try(each.value.template, "default") : null) : null
  template_stack = module.mode_lookup.mode == 0 ? each.value.template_stack == "" ? null : each.value.template_stack : null

  vsys = try(each.value.vsys, "vsys1")
  name = each.key
}

resource "panos_virtual_router_entry" "this" {
  for_each = length(var.virtual_router_entries) != 0 ? { for intf in var.virtual_router_entries : intf.interface => intf } : {}

  template       = module.mode_lookup.mode == 0 ? (each.value.template_stack == "" ? try(each.value.template, "default") : null) : null
  template_stack = module.mode_lookup.mode == 0 ? each.value.template_stack == "" ? null : each.value.template_stack : null

  virtual_router = try(each.value.virtual_router, "vsys1")
  interface      = each.key

  depends_on = [
    panos_virtual_router.this,
    panos_panorama_ethernet_interface.this,
    panos_panorama_loopback_interface.this,
    panos_panorama_tunnel_interface.this,
    panos_ethernet_interface.this,
    panos_loopback_interface.this,
    panos_tunnel_interface.this,
  ]
}

resource "panos_panorama_static_route_ipv4" "this" {
  for_each = module.mode_lookup.mode == 0 && length(var.virtual_router_static_routes) != 0 ? { for route in var.virtual_router_static_routes : "${route.virtual_router}_${route.name}" => route } : {}

  template       = each.value.template_stack == "" ? try(each.value.template, "default") : null
  template_stack = each.value.template_stack == "" ? null : each.value.template_stack

  name           = each.value.name
  virtual_router = each.value.virtual_router
  route_table    = each.value.route_table
  destination    = each.value.destination
  interface      = each.value.interface
  type           = each.value.type
  next_hop       = each.value.next_hop
  admin_distance = each.value.admin_distance
  metric         = each.value.metric

  depends_on = [
    panos_virtual_router_entry.this,
    panos_panorama_ethernet_interface.this,
    panos_panorama_loopback_interface.this,
    panos_panorama_tunnel_interface.this,
    panos_panorama_ipsec_tunnel.this,
  ]
}

resource "panos_static_route_ipv4" "this" {
  for_each = module.mode_lookup.mode == 1 && length(var.virtual_router_static_routes) != 0 ? { for route in var.virtual_router_static_routes : "${route.virtual_router}_${route.name}" => route } : {}

  name           = each.value.name
  virtual_router = each.value.virtual_router
  route_table    = each.value.route_table
  destination    = each.value.destination
  interface      = each.value.interface
  type           = each.value.type
  next_hop       = each.value.next_hop
  admin_distance = each.value.admin_distance
  metric         = each.value.metric

  depends_on = [
    panos_virtual_router_entry.this,
    panos_ethernet_interface.this,
    panos_loopback_interface.this,
    panos_tunnel_interface.this,
    panos_ipsec_tunnel.this,
  ]
}