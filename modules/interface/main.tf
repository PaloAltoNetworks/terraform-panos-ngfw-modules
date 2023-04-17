module "mode_lookup" {
  source = "../mode_lookup"
  mode   = var.mode
}

resource "panos_panorama_ethernet_interface" "this" {
  for_each = module.mode_lookup.mode == 0 && length(var.interfaces) != 0 ? { for intf in var.interfaces : intf.name => intf if intf.type == "ethernet" } : {}

  template = try(each.value.template, "default")

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

  depends_on = [
    panos_panorama_management_profile.this,
    panos_zone.this,
  ]
}

resource "panos_ethernet_interface" "this" {
  for_each = module.mode_lookup.mode == 1 && length(var.interfaces) != 0 ? { for intf in var.interfaces : intf.name => intf if intf.type == "ethernet" } : {}

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

  depends_on = [
    panos_management_profile.this,
    panos_zone.this,
  ]
}

resource "panos_panorama_loopback_interface" "this" {
  for_each = module.mode_lookup.mode == 0 && length(var.interfaces) != 0 ? { for intf in var.interfaces : intf.name => intf if intf.type == "loopback" } : {}

  template = try(each.value.template, "default")

  vsys               = each.value.vsys != "" ? each.value.vsys : "vsys1"
  name               = each.key
  management_profile = each.value.management_profile
  static_ips         = try(each.value.static_ips, [])
  comment            = each.value.comment

  depends_on = [
    panos_panorama_management_profile.this,
    panos_zone.this,
  ]
}

resource "panos_loopback_interface" "this" {
  for_each = module.mode_lookup.mode == 1 && length(var.interfaces) != 0 ? { for intf in var.interfaces : intf.name => intf if intf.type == "loopback" } : {}

  vsys               = each.value.vsys != "" ? each.value.vsys : "vsys1"
  name               = each.key
  management_profile = each.value.management_profile
  static_ips         = try(each.value.static_ips, [])
  comment            = each.value.comment

  depends_on = [
    panos_management_profile.this,
    panos_zone.this,
  ]
}

resource "panos_panorama_tunnel_interface" "this" {
  for_each = module.mode_lookup.mode == 0 && length(var.interfaces) != 0 ? { for intf in var.interfaces : intf.name => intf if intf.type == "tunnel" } : {}

  template = try(each.value.template, "default")

  vsys               = each.value.vsys != "" ? each.value.vsys : "vsys1"
  name               = each.key
  management_profile = each.value.management_profile
  static_ips         = try(each.value.static_ips, [])
  comment            = each.value.comment

  depends_on = [
    panos_panorama_management_profile.this,
    panos_zone.this,
  ]
}

resource "panos_tunnel_interface" "this" {
  for_each = module.mode_lookup.mode == 1 && length(var.interfaces) != 0 ? { for intf in var.interfaces : intf.name => intf if intf.type == "tunnel" } : {}

  vsys               = each.value.vsys != "" ? each.value.vsys : "vsys1"
  name               = each.key
  management_profile = each.value.management_profile
  static_ips         = try(each.value.static_ips, [])
  comment            = each.value.comment

  depends_on = [
    panos_management_profile.this,
    panos_zone.this,
  ]
}
