resource "panos_panorama_ethernet_interface" "this" {
  for_each = var.mode_map[var.mode] == 0 ? { for name, intf in var.interfaces : name => intf if intf.type == "ethernet" } : {}

  template = var.template

  name                            = each.key
  vsys                            = each.value.vsys
  mode                            = each.value.mode
  management_profile              = each.value.management_profile
  link_state                      = each.value.link_state
  static_ips                      = each.value.static_ips
  enable_dhcp                     = each.value.enable_dhcp
  create_dhcp_default_route       = each.value.create_dhcp_default_route
  dhcp_default_route_metric       = each.value.dhcp_default_route_metric
  ipv6_enabled                    = each.value.ipv6_enabled
  mtu                             = each.value.mtu
  adjust_tcp_mss                  = each.value.adjust_tcp_mss
  netflow_profile                 = each.value.netflow_profile
  lldp_enabled                    = each.value.lldp_enabled
  lldp_profile                    = each.value.lldp_profile
  lldp_ha_passive_pre_negotiation = each.value.lldp_ha_passive_pre_negotiation
  lacp_ha_passive_pre_negotiation = each.value.lacp_ha_passive_pre_negotiation
  link_speed                      = each.value.link_speed
  link_duplex                     = each.value.link_duplex
  aggregate_group                 = each.value.aggregate_group
  lacp_port_priority              = each.value.lacp_port_priority
  ipv4_mss_adjust                 = each.value.ipv4_mss_adjust
  ipv6_mss_adjust                 = each.value.ipv6_mss_adjust
  decrypt_forward                 = each.value.decrypt_forward
  rx_policing_rate                = each.value.rx_policing_rate
  tx_policing_rate                = each.value.tx_policing_rate
  dhcp_send_hostname_enable       = each.value.dhcp_send_hostname_enable
  dhcp_send_hostname_value        = each.value.dhcp_send_hostname_value
  comment                         = each.value.comment
}

resource "panos_ethernet_interface" "this" {
  for_each = var.mode_map[var.mode] == 1 ? { for name, intf in var.interfaces : name => intf if intf.type == "ethernet" } : {}

  name                            = each.key
  vsys                            = each.value.vsys
  mode                            = each.value.mode
  management_profile              = each.value.management_profile
  link_state                      = each.value.link_state
  static_ips                      = each.value.static_ips
  enable_dhcp                     = each.value.enable_dhcp
  create_dhcp_default_route       = each.value.create_dhcp_default_route
  dhcp_default_route_metric       = each.value.dhcp_default_route_metric
  ipv6_enabled                    = each.value.ipv6_enabled
  mtu                             = each.value.mtu
  adjust_tcp_mss                  = each.value.adjust_tcp_mss
  netflow_profile                 = each.value.netflow_profile
  lldp_enabled                    = each.value.lldp_enabled
  lldp_profile                    = each.value.lldp_profile
  lldp_ha_passive_pre_negotiation = each.value.lldp_ha_passive_pre_negotiation
  lacp_ha_passive_pre_negotiation = each.value.lacp_ha_passive_pre_negotiation
  link_speed                      = each.value.link_speed
  link_duplex                     = each.value.link_duplex
  aggregate_group                 = each.value.aggregate_group
  lacp_port_priority              = each.value.lacp_port_priority
  ipv4_mss_adjust                 = each.value.ipv4_mss_adjust
  ipv6_mss_adjust                 = each.value.ipv6_mss_adjust
  decrypt_forward                 = each.value.decrypt_forward
  rx_policing_rate                = each.value.rx_policing_rate
  tx_policing_rate                = each.value.tx_policing_rate
  dhcp_send_hostname_enable       = each.value.dhcp_send_hostname_enable
  dhcp_send_hostname_value        = each.value.dhcp_send_hostname_value
  comment                         = each.value.comment
}

resource "panos_panorama_loopback_interface" "this" {
  for_each = var.mode_map[var.mode] == 0 ? { for name, intf in var.interfaces : name => intf if intf.type == "loopback" } : {}

  template = var.template

  name               = each.key
  vsys               = each.value.vsys
  management_profile = each.value.management_profile
  mtu                = each.value.mtu
  netflow_profile    = each.value.netflow_profile
  static_ips         = each.value.static_ips
  adjust_tcp_mss     = each.value.adjust_tcp_mss
  ipv4_mss_adjust    = each.value.ipv4_mss_adjust
  ipv6_mss_adjust    = each.value.ipv6_mss_adjust
  comment            = each.value.comment
}

resource "panos_loopback_interface" "this" {
  for_each = var.mode_map[var.mode] == 1 ? { for name, intf in var.interfaces : name => intf if intf.type == "loopback" } : {}

  name               = each.key
  vsys               = each.value.vsys
  management_profile = each.value.management_profile
  mtu                = each.value.mtu
  netflow_profile    = each.value.netflow_profile
  static_ips         = each.value.static_ips
  adjust_tcp_mss     = each.value.adjust_tcp_mss
  ipv4_mss_adjust    = each.value.ipv4_mss_adjust
  ipv6_mss_adjust    = each.value.ipv6_mss_adjust
  comment            = each.value.comment
}

resource "panos_panorama_tunnel_interface" "this" {
  for_each = var.mode_map[var.mode] == 0 ? { for name, intf in var.interfaces : name => intf if intf.type == "tunnel" } : {}

  template = var.template

  name               = each.key
  vsys               = each.value.vsys
  management_profile = each.value.management_profile
  mtu                = each.value.mtu
  netflow_profile    = each.value.netflow_profile
  static_ips         = each.value.static_ips
  comment            = each.value.comment
}

resource "panos_tunnel_interface" "this" {
  for_each = var.mode_map[var.mode] == 1 ? { for name, intf in var.interfaces : name => intf if intf.type == "tunnel" } : {}

  name               = each.key
  vsys               = each.value.vsys
  management_profile = each.value.management_profile
  mtu                = each.value.mtu
  netflow_profile    = each.value.netflow_profile
  static_ips         = each.value.static_ips
  comment            = each.value.comment
}

resource "panos_virtual_router_entry" "this" {
  for_each = { for k, v in var.interfaces : "${v.virtual_router}_${k}" => { interface = k, virtual_router = v.virtual_router } }

  template       = var.mode_map[var.mode] == 0 ? (var.template_stack == "" ? var.template : null) : null
  template_stack = var.mode_map[var.mode] == 0 ? var.template_stack == "" ? null : var.template_stack : null

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

  template       = var.mode_map[var.mode] == 0 ? (var.template_stack == "" ? var.template : null) : null
  template_stack = var.mode_map[var.mode] == 0 ? var.template_stack == "" ? null : var.template_stack : null

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
