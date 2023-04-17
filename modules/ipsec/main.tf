module "mode_lookup" {
  source = "../mode_lookup"
  mode   = var.mode
}

resource "panos_ike_crypto_profile" "this" {
  for_each = var.ike_crypto_profiles

  template       = module.mode_lookup.mode == 0 ? (var.template_stack == "" ? try(var.template, "default") : null) : null
  template_stack = module.mode_lookup.mode == 0 ? var.template_stack == "" ? null : var.template_stack : null

  name                    = each.key
  dh_groups               = each.value.dh_groups
  authentications         = each.value.authentications
  encryptions             = each.value.encryptions
  lifetime_value          = each.value.lifetime_value
  authentication_multiple = each.value.authentication_multiple
}

resource "panos_panorama_ipsec_crypto_profile" "this" {
  for_each = module.mode_lookup.mode == 0 ? var.ipsec_crypto_profiles : {}

  template       = module.mode_lookup.mode == 0 ? (var.template_stack == "" ? try(var.template, "default") : null) : null
  template_stack = module.mode_lookup.mode == 0 ? var.template_stack == "" ? null : var.template_stack : null

  name            = each.key
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
  for_each = module.mode_lookup.mode == 1 ? var.ipsec_crypto_profiles : {}

  name            = each.key
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
  for_each = module.mode_lookup.mode == 0 ? var.ike_gateways : {}

  template       = var.template_stack == "" ? try(var.template, "default") : null
  template_stack = var.template_stack == "" ? null : var.template_stack

  name                 = each.key
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
  ]
}

resource "panos_ike_gateway" "this" {
  for_each = module.mode_lookup.mode == 1 ? var.ike_gateways : {}

  name                 = each.key
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
    panos_ike_crypto_profile.this
  ]
}

resource "panos_panorama_ipsec_tunnel" "this" {
  for_each = module.mode_lookup.mode == 0 ? var.ipsec_tunnels : {}

  template = try(var.template, "default")

  name                          = each.key
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
    panos_panorama_ike_gateway.this,
  ]
}

resource "panos_ipsec_tunnel" "this" {
  for_each = module.mode_lookup.mode == 1 ? var.ipsec_tunnels : {}

  name                          = each.key
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
    panos_ike_gateway.this,
  ]
}

resource "panos_panorama_ipsec_tunnel_proxy_id_ipv4" "this" {
  for_each = module.mode_lookup.mode == 0 ? var.ipsec_tunnels_proxy : {}

  template     = try(var.template, "default")
  ipsec_tunnel = each.value.ipsec_tunnel
  name         = each.key
  local        = each.value.local
  remote       = each.value.remote
  protocol_any = try(each.value.protocol_any, true)
}

resource "panos_ipsec_tunnel_proxy_id_ipv4" "this" {
  for_each = module.mode_lookup.mode == 1 ? var.ipsec_tunnels_proxy : {}

  ipsec_tunnel = each.value.ipsec_tunnel
  name         = each.key
  local        = each.value.local
  remote       = each.value.remote
  protocol_any = try(each.value.protocol_any, true)
}
