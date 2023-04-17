module "mode_lookup" {
  source = "../mode_lookup"
  mode   = var.mode
}

resource "panos_panorama_ethernet_interface" "this" {
  for_each = module.mode_lookup.mode == 0 ? { for name, intf in var.interfaces : name => intf if intf.type == "ethernet" } : {}

  template = try(var.template, "default")

  vsys                      = try(each.value.vsys, "vsys1")
  name                      = each.key
  mode                      = try(each.value.mode, null)
  management_profile        = each.value.management_profile
  link_state                = each.value.link_state
  static_ips                = try(each.value.static_ips, [])
  enable_dhcp               = each.value.enable_dhcp != "" ? each.value.enable_dhcp : false
  create_dhcp_default_route = each.value.create_dhcp_default_route != "" ? each.value.create_dhcp_default_route : false
  dhcp_default_route_metric = each.value.dhcp_default_route_metric != "" ? each.value.dhcp_default_route_metric : null
  comment                   = each.value.comment
}

resource "panos_ethernet_interface" "this" {
  for_each = module.mode_lookup.mode == 1 ? { for name, intf in var.interfaces : name => intf if intf.type == "ethernet" } : {}

  vsys                      = try(each.value.vsys, "vsys1")
  name                      = each.key
  mode                      = try(each.value.mode, null)
  management_profile        = each.value.management_profile
  link_state                = each.value.link_state
  static_ips                = try(each.value.static_ips, [])
  enable_dhcp               = each.value.enable_dhcp != "" ? each.value.enable_dhcp : false
  create_dhcp_default_route = each.value.create_dhcp_default_route != "" ? each.value.create_dhcp_default_route : false
  dhcp_default_route_metric = each.value.dhcp_default_route_metric != "" ? each.value.dhcp_default_route_metric : null
  comment                   = each.value.comment
}

resource "panos_panorama_loopback_interface" "this" {
  for_each = module.mode_lookup.mode == 0 ? { for name, intf in var.interfaces : name => intf if intf.type == "loopback" } : {}

  template = try(var.template, "default")

  vsys               = each.value.vsys != "" ? each.value.vsys : "vsys1"
  name               = each.key
  management_profile = each.value.management_profile
  static_ips         = try(each.value.static_ips, [])
  comment            = each.value.comment
}

resource "panos_loopback_interface" "this" {
  for_each = module.mode_lookup.mode == 1 ? { for name, intf in var.interfaces : name => intf if intf.type == "loopback" } : {}

  vsys               = each.value.vsys != "" ? each.value.vsys : "vsys1"
  name               = each.key
  management_profile = each.value.management_profile
  static_ips         = try(each.value.static_ips, [])
  comment            = each.value.comment
}

resource "panos_panorama_tunnel_interface" "this" {
  for_each = module.mode_lookup.mode == 0 ? { for name, intf in var.interfaces : name => intf if intf.type == "tunnel" } : {}

  template = try(var.template, "default")

  vsys               = each.value.vsys != "" ? each.value.vsys : "vsys1"
  name               = each.key
  management_profile = each.value.management_profile
  static_ips         = try(each.value.static_ips, [])
  comment            = each.value.comment
}

resource "panos_tunnel_interface" "this" {
  for_each = module.mode_lookup.mode == 1 ? { for name, intf in var.interfaces : name => intf if intf.type == "tunnel" } : {}

  vsys               = each.value.vsys != "" ? each.value.vsys : "vsys1"
  name               = each.key
  management_profile = each.value.management_profile
  static_ips         = try(each.value.static_ips, [])
  comment            = each.value.comment
}

resource "panos_virtual_router_entry" "this" {
  for_each = { for k, v in var.interfaces : "${v.virtual_router}_${k}" => { interface = k, virtual_router = v.virtual_router } }

  template       = module.mode_lookup.mode == 0 ? (var.template_stack == "" ? try(var.template, "default") : null) : null
  template_stack = module.mode_lookup.mode == 0 ? var.template_stack == "" ? null : var.template_stack : null

  virtual_router = try(each.value.virtual_router, "vsys1")
  interface      = each.value.interface

  depends_on = [
    panos_panorama_ethernet_interface.this,
    panos_panorama_loopback_interface.this,
    panos_panorama_tunnel_interface.this,
    panos_ethernet_interface.this,
    panos_loopback_interface.this,
    panos_tunnel_interface.this,
  ]
}

resource "panos_zone_entry" "this" {
  for_each = { for k, v in var.interfaces : "${v.zone}_${k}" => { interface = k, zone = v.zone, vsys = v.vsys } }

  template       = module.mode_lookup.mode == 0 ? (var.template_stack == "" ? try(var.template, "default") : null) : null
  template_stack = module.mode_lookup.mode == 0 ? var.template_stack == "" ? null : var.template_stack : null

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