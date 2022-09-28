resource "panos_zone" "this" {
  for_each = length(var.zones) != 0 ? { for zone in var.zones : zone.name => zone } : {}

  template = var.panorama_mode == true ? try(each.value.template, "default") : null
  vsys     = var.panorama_mode == true ? try(each.value.vsys, "vsys1") : null

  name           = each.key
  mode           = try(each.value.mode, null)
  interfaces     = try(each.value.interfaces, [])
  enable_user_id = try(each.value.enable_user_id, false)
  include_acls   = try(each.value.include_acls, [])
  exclude_acls   = try(each.value.exclude_acls, [])
}

resource "panos_zone_entry" "this" {
  for_each = length(var.zone_entres) != 0 ? { for intf in var.zone_entres : intf.interface => intf } : {}

  template = var.panorama_mode == true ? try(each.value.template, "default") : null

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

resource "panos_panorama_ethernet_interface" "this" {
  for_each = var.panorama_mode == true && length(var.interfaces) != 0 ? { for intf in var.interfaces : intf.name => intf if intf.type == "ethernet" } : {}

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
  for_each = var.panorama_mode == false && length(var.interfaces) != 0 ? { for intf in var.interfaces : intf.name => intf if intf.type == "ethernet" } : {}

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
  for_each = var.panorama_mode == true && length(var.interfaces) != 0 ? { for intf in var.interfaces : intf.name => intf if intf.type == "loopback" } : {}

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
  for_each = var.panorama_mode == false && length(var.interfaces) != 0 ? { for intf in var.interfaces : intf.name => intf if intf.type == "loopback" } : {}

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
  for_each = var.panorama_mode == true && length(var.interfaces) != 0 ? { for intf in var.interfaces : intf.name => intf if intf.type == "tunnel" } : {}

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
  for_each = var.panorama_mode == false && length(var.interfaces) != 0 ? { for intf in var.interfaces : intf.name => intf if intf.type == "tunnel" } : {}

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

resource "panos_virtual_router" "this" {
  for_each = length(var.virtual_routers) != 0 ? { for vrouter in var.virtual_routers : vrouter.name => vrouter } : {}

  template = var.panorama_mode == true ? try(each.value.template, "default") : null
  vsys     = try(each.value.vsys, "vsys1")
  name     = each.key
}

resource "panos_virtual_router_entry" "this" {
  for_each = length(var.virtual_router_entries) != 0 ? { for intf in var.virtual_router_entries : intf.interface => intf } : {}

  template       = var.panorama_mode == true ? try(each.value.template, "default") : null
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
  for_each = var.panorama_mode == true && length(var.virtual_router_static_routes) != 0 ? { for route in var.virtual_router_static_routes : "${route.virtual_router}_${route.name}" => route } : {}

  template       = each.value.template
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
  for_each = var.panorama_mode == false && length(var.virtual_router_static_routes) != 0 ? { for route in var.virtual_router_static_routes : "${route.virtual_router}_${route.name}" => route } : {}

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

resource "panos_panorama_management_profile" "this" {
  for_each = var.panorama_mode == true && length(var.management_profiles) != 0 ? { for prof in var.management_profiles : prof.name => prof } : {}

  template       = each.value.template
  name           = each.value.name
  ping           = each.value.ping
  telnet         = each.value.telnet
  ssh            = each.value.ssh
  http           = each.value.http
  https          = each.value.https
  snmp           = each.value.snmp
  userid_service = each.value.userid_service
  permitted_ips  = each.value.permitted_ips
}

resource "panos_management_profile" "this" {
  for_each = var.panorama_mode == false && length(var.management_profiles) != 0 ? { for prof in var.management_profiles : prof.name => prof } : {}

  name           = each.value.name
  ping           = each.value.ping
  telnet         = each.value.telnet
  ssh            = each.value.ssh
  http           = each.value.http
  https          = each.value.https
  snmp           = each.value.snmp
  userid_service = each.value.userid_service
  permitted_ips  = each.value.permitted_ips
}

# IPsec
resource "panos_ike_crypto_profile" "this" {
  for_each = length(var.ike_crypto_profiles) != 0 ? { for profile in var.ike_crypto_profiles : profile.name => profile } : {}

  template        = var.panorama_mode == true ? try(each.value.template, "default") : null
  name            = each.value.name
  dh_groups       = each.value.dh_groups
  authentications = each.value.authentications
  encryptions     = each.value.encryptions
  #lifetime_type           = each.value.lifetime_type
  lifetime_value          = each.value.lifetime_value
  authentication_multiple = each.value.authentication_multiple
}

resource "panos_panorama_ipsec_crypto_profile" "this" {
  for_each = var.panorama_mode == true && length(var.ipsec_crypto_profiles) != 0 ? { for profile in var.ipsec_crypto_profiles : profile.name => profile } : {}

  template        = var.panorama_mode == true ? try(each.value.template, "default") : null
  name            = each.value.name
  protocol        = each.value.protocol
  dh_group        = each.value.dh_group
  authentications = each.value.authentications
  encryptions     = each.value.encryptions
  lifetime_type   = each.value.lifetime_type
  lifetime_value  = each.value.lifetime_value
  lifesize_type   = each.value.lifesize_type
  lifesize_value  = each.value.lifesize_value
}

resource "panos_ipsec_crypto_profile" "this" {
  for_each = var.panorama_mode == false && length(var.ipsec_crypto_profiles) != 0 ? { for profile in var.ipsec_crypto_profiles : profile.name => profile } : {}

  name            = each.value.name
  protocol        = each.value.protocol
  dh_group        = each.value.dh_group
  authentications = each.value.authentications
  encryptions     = each.value.encryptions
  lifetime_type   = each.value.lifetime_type
  lifetime_value  = each.value.lifetime_value
  lifesize_type   = each.value.lifesize_type
  lifesize_value  = each.value.lifesize_value
}

resource "panos_panorama_ike_gateway" "this" {
  for_each = var.panorama_mode == true && length(var.ike_gateways) != 0 ? { for gw in var.ike_gateways : gw.name => gw } : {}

  template = try(each.value.template, "default")

  name                 = each.value.name
  version              = each.value.version
  disabled             = each.value.disabled
  peer_ip_type         = each.value.peer_ip_type
  peer_ip_value        = each.value.peer_ip_value
  interface            = each.value.interface
  pre_shared_key       = each.value.pre_shared_key
  local_id_type        = each.value.local_id_type
  local_id_value       = each.value.local_id_value
  peer_id_type         = each.value.peer_id_type
  peer_id_value        = each.value.peer_id_value
  ikev1_crypto_profile = each.value.ikev1_crypto_profile

  depends_on = [
    panos_ike_crypto_profile.this,
    panos_panorama_loopback_interface.this,
  ]
}

resource "panos_ike_gateway" "this" {
  for_each = var.panorama_mode == false && length(var.ike_gateways) != 0 ? { for gw in var.ike_gateways : gw.name => gw } : {}

  name                 = each.value.name
  version              = each.value.version
  disabled             = each.value.disabled
  peer_ip_type         = each.value.peer_ip_type
  peer_ip_value        = each.value.peer_ip_value
  interface            = each.value.interface
  pre_shared_key       = each.value.pre_shared_key
  local_id_type        = each.value.local_id_type
  local_id_value       = each.value.local_id_value
  peer_id_type         = each.value.peer_id_type
  peer_id_value        = each.value.peer_id_value
  ikev1_crypto_profile = each.value.ikev1_crypto_profile

  depends_on = [
    panos_ike_crypto_profile.this,
    panos_tunnel_interface.this,
    panos_loopback_interface.this,
    panos_ethernet_interface.this,
    panos_panorama_tunnel_interface.this,
    panos_panorama_loopback_interface.this,
    panos_panorama_ethernet_interface.this,
  ]
}

resource "panos_panorama_ipsec_tunnel" "this" {
  for_each = var.panorama_mode == true && length(var.ipsec_tunnels) != 0 ? { for tun in var.ipsec_tunnels : tun.name => tun } : {}

  template = try(each.value.template, "default")

  name                          = each.value.name
  tunnel_interface              = each.value.tunnel_interface
  type                          = each.value.type
  disabled                      = each.value.disabled
  ak_ike_gateway                = each.value.ak_ike_gateway
  ak_ipsec_crypto_profile       = each.value.ak_ipsec_crypto_profile
  anti_replay                   = each.value.anti_replay
  copy_flow_label               = each.value.copy_flow_label
  enable_tunnel_monitor         = each.value.enable_tunnel_monitor
  tunnel_monitor_destination_ip = each.value.tunnel_monitor_destination_ip
  tunnel_monitor_source_ip      = each.value.tunnel_monitor_source_ip
  tunnel_monitor_profile        = each.value.tunnel_monitor_profile
  tunnel_monitor_proxy_id       = each.value.tunnel_monitor_proxy_id

  depends_on = [
    panos_panorama_tunnel_interface.this,
    panos_panorama_ike_gateway.this,
  ]
}

resource "panos_ipsec_tunnel" "this" {
  for_each = var.panorama_mode == false && length(var.ipsec_tunnels) != 0 ? { for tun in var.ipsec_tunnels : tun.name => tun } : {}

  name                          = each.value.name
  tunnel_interface              = each.value.tunnel_interface
  type                          = each.value.type
  disabled                      = each.value.disabled
  ak_ike_gateway                = each.value.ak_ike_gateway
  ak_ipsec_crypto_profile       = each.value.ak_ipsec_crypto_profile
  anti_replay                   = each.value.anti_replay
  copy_flow_label               = each.value.copy_flow_label
  enable_tunnel_monitor         = each.value.enable_tunnel_monitor
  tunnel_monitor_destination_ip = each.value.tunnel_monitor_destination_ip
  tunnel_monitor_source_ip      = each.value.tunnel_monitor_source_ip
  tunnel_monitor_profile        = each.value.tunnel_monitor_profile
  tunnel_monitor_proxy_id       = each.value.tunnel_monitor_proxy_id

  depends_on = [
    panos_tunnel_interface.this,
    panos_ike_gateway.this,
  ]
}

resource "panos_panorama_ipsec_tunnel_proxy_id_ipv4" "this" {
  for_each = var.panorama_mode == true && length(var.ipsec_tunnels_proxy) != 0 ? { for pbvpn in var.ipsec_tunnels_proxy : pbvpn.name => pbvpn } : {}

  template     = try(each.value.template, "default")
  ipsec_tunnel = each.value.ipsec_tunnel
  name         = each.value.name
  local        = each.value.local
  remote       = each.value.remote
  protocol_any = try(each.value.protocol_any, true)
}

resource "panos_ipsec_tunnel_proxy_id_ipv4" "this" {
  for_each = var.panorama_mode == false && length(var.ipsec_tunnels_proxy) != 0 ? { for pbvpn in var.ipsec_tunnels_proxy : pbvpn.name => pbvpn } : {}

  ipsec_tunnel = each.value.ipsec_tunnel
  name         = each.value.name
  local        = each.value.local
  remote       = each.value.remote
  protocol_any = try(each.value.protocol_any, true)
}
