locals {
  mode_map = {
    panorama = 0
    ngfw     = 1
    # cloud_manager = 2 # Not yet supported
  }
}

resource "panos_ike_crypto_profile" "this" {
  for_each = var.ike_crypto_profiles

  template       = local.mode_map[var.mode] == 0 ? (var.template_stack == "" ? var.template : null) : null
  template_stack = local.mode_map[var.mode] == 0 ? var.template_stack == "" ? null : var.template_stack : null

  name                    = each.key
  dh_groups               = each.value.dh_groups
  authentications         = each.value.authentications
  encryptions             = each.value.encryptions
  lifetime_type           = each.value.lifetime_type
  lifetime_value          = each.value.lifetime_value
  authentication_multiple = each.value.authentication_multiple

  lifecycle {
    create_before_destroy = true
  }
}

resource "panos_panorama_ipsec_crypto_profile" "this" {
  for_each = local.mode_map[var.mode] == 0 ? var.ipsec_crypto_profiles : {}

  template       = var.template_stack == "" ? var.template : null
  template_stack = var.template_stack == "" ? null : var.template_stack

  name            = each.key
  protocol        = each.value.protocol
  dh_group        = each.value.dh_group
  authentications = each.value.authentications
  encryptions     = each.value.encryptions
  lifetime_type   = each.value.lifetime_type
  lifetime_value  = each.value.lifetime_value
  lifesize_type   = each.value.lifesize_type
  lifesize_value  = each.value.lifesize_value

  lifecycle {
    create_before_destroy = true
  }
}

resource "panos_ipsec_crypto_profile" "this" {
  for_each = local.mode_map[var.mode] == 1 ? var.ipsec_crypto_profiles : {}

  name            = each.key
  protocol        = each.value.protocol
  dh_group        = each.value.dh_group
  authentications = each.value.authentications
  encryptions     = each.value.encryptions
  lifetime_type   = each.value.lifetime_type
  lifetime_value  = each.value.lifetime_value
  lifesize_type   = each.value.lifesize_type
  lifesize_value  = each.value.lifesize_value

  lifecycle {
    create_before_destroy = true
  }
}

resource "panos_panorama_ike_gateway" "this" {
  for_each = local.mode_map[var.mode] == 0 ? var.ike_gateways : {}

  template       = var.template_stack == "" ? var.template : null
  template_stack = var.template_stack == "" ? null : var.template_stack

  name                              = each.key
  version                           = each.value.version
  enable_ipv6                       = each.value.enable_ipv6
  disabled                          = each.value.disabled
  peer_ip_type                      = each.value.peer_ip_type
  peer_ip_value                     = each.value.peer_ip_value
  interface                         = each.value.interface
  local_ip_address_type             = each.value.local_ip_address_type
  local_ip_address_value            = each.value.local_ip_address_value
  auth_type                         = each.value.auth_type
  pre_shared_key                    = each.value.pre_shared_key
  local_id_type                     = each.value.local_id_type
  local_id_value                    = each.value.local_id_value
  peer_id_type                      = each.value.peer_id_type
  peer_id_value                     = each.value.peer_id_value
  peer_id_check                     = each.value.peer_id_check
  local_cert                        = each.value.local_cert
  cert_enable_hash_and_url          = each.value.cert_enable_hash_and_url
  cert_base_url                     = each.value.cert_base_url
  cert_use_management_as_source     = each.value.cert_use_management_as_source
  cert_permit_payload_mismatch      = each.value.cert_permit_payload_mismatch
  cert_profile                      = each.value.cert_profile
  cert_enable_strict_validation     = each.value.cert_enable_strict_validation
  enable_passive_mode               = each.value.enable_passive_mode
  enable_nat_traversal              = each.value.enable_nat_traversal
  nat_traversal_keep_alive          = each.value.nat_traversal_keep_alive
  nat_traversal_enable_udp_checksum = each.value.nat_traversal_enable_udp_checksum
  enable_fragmentation              = each.value.enable_fragmentation
  ikev1_exchange_mode               = each.value.ikev1_exchange_mode
  ikev1_crypto_profile              = each.value.ikev1_crypto_profile
  enable_dead_peer_detection        = each.value.enable_dead_peer_detection
  dead_peer_detection_interval      = each.value.dead_peer_detection_interval
  dead_peer_detection_retry         = each.value.dead_peer_detection_retry
  ikev2_crypto_profile              = each.value.ikev2_crypto_profile
  ikev2_cookie_validation           = each.value.ikev2_cookie_validation
  enable_liveness_check             = each.value.enable_liveness_check
  liveness_check_interval           = each.value.liveness_check_interval

  depends_on = [
    panos_ike_crypto_profile.this,
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "panos_ike_gateway" "this" {
  for_each = local.mode_map[var.mode] == 1 ? var.ike_gateways : {}

  name                              = each.key
  version                           = each.value.version
  enable_ipv6                       = each.value.enable_ipv6
  disabled                          = each.value.disabled
  peer_ip_type                      = each.value.peer_ip_type
  peer_ip_value                     = each.value.peer_ip_value
  interface                         = each.value.interface
  local_ip_address_type             = each.value.local_ip_address_type
  local_ip_address_value            = each.value.local_ip_address_value
  auth_type                         = each.value.auth_type
  pre_shared_key                    = each.value.pre_shared_key
  local_id_type                     = each.value.local_id_type
  local_id_value                    = each.value.local_id_value
  peer_id_type                      = each.value.peer_id_type
  peer_id_value                     = each.value.peer_id_value
  peer_id_check                     = each.value.peer_id_check
  local_cert                        = each.value.local_cert
  cert_enable_hash_and_url          = each.value.cert_enable_hash_and_url
  cert_base_url                     = each.value.cert_base_url
  cert_use_management_as_source     = each.value.cert_use_management_as_source
  cert_permit_payload_mismatch      = each.value.cert_permit_payload_mismatch
  cert_profile                      = each.value.cert_profile
  cert_enable_strict_validation     = each.value.cert_enable_strict_validation
  enable_passive_mode               = each.value.enable_passive_mode
  enable_nat_traversal              = each.value.enable_nat_traversal
  nat_traversal_keep_alive          = each.value.nat_traversal_keep_alive
  nat_traversal_enable_udp_checksum = each.value.nat_traversal_enable_udp_checksum
  enable_fragmentation              = each.value.enable_fragmentation
  ikev1_exchange_mode               = each.value.ikev1_exchange_mode
  ikev1_crypto_profile              = each.value.ikev1_crypto_profile
  enable_dead_peer_detection        = each.value.enable_dead_peer_detection
  dead_peer_detection_interval      = each.value.dead_peer_detection_interval
  dead_peer_detection_retry         = each.value.dead_peer_detection_retry
  ikev2_crypto_profile              = each.value.ikev2_crypto_profile
  ikev2_cookie_validation           = each.value.ikev2_cookie_validation
  enable_liveness_check             = each.value.enable_liveness_check
  liveness_check_interval           = each.value.liveness_check_interval

  depends_on = [
    panos_ike_crypto_profile.this
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "panos_panorama_ipsec_tunnel" "this" {
  for_each = local.mode_map[var.mode] == 0 ? var.ipsec_tunnels : {}

  template = var.template
  ### an argument named "template_stack" is not expected here

  name                           = each.key
  tunnel_interface               = each.value.tunnel_interface
  anti_replay                    = each.value.anti_replay
  enable_ipv6                    = each.value.enable_ipv6
  copy_tos                       = each.value.copy_tos
  copy_flow_label                = each.value.copy_flow_label
  disabled                       = each.value.disabled
  type                           = each.value.type
  ak_ike_gateway                 = each.value.ak_ike_gateway
  ak_ipsec_crypto_profile        = each.value.ak_ipsec_crypto_profile
  mk_local_spi                   = each.value.mk_local_spi
  mk_remote_spi                  = each.value.mk_remote_spi
  mk_local_address_ip            = each.value.mk_local_address_ip
  mk_local_address_floating_ip   = each.value.mk_local_address_floating_ip
  mk_protocol                    = each.value.mk_protocol
  mk_auth_type                   = each.value.mk_auth_type
  mk_auth_key                    = each.value.mk_auth_key
  mk_esp_encryption_type         = each.value.mk_esp_encryption_type
  mk_esp_encryption_key          = each.value.mk_esp_encryption_key
  gps_interface                  = each.value.gps_interface
  gps_portal_address             = each.value.gps_portal_address
  gps_prefer_ipv6                = each.value.gps_prefer_ipv6
  gps_interface_ip_ipv4          = each.value.gps_interface_ip_ipv4
  gps_interface_ip_ipv6          = each.value.gps_interface_ip_ipv6
  gps_interface_floating_ip_ipv4 = each.value.gps_interface_floating_ip_ipv4
  gps_interface_floating_ip_ipv6 = each.value.gps_interface_floating_ip_ipv6
  gps_publish_connected_routes   = each.value.gps_publish_connected_routes
  gps_publish_routes             = each.value.gps_publish_routes
  gps_local_certificate          = each.value.gps_local_certificate
  gps_certificate_profile        = each.value.gps_certificate_profile
  enable_tunnel_monitor          = each.value.enable_tunnel_monitor
  tunnel_monitor_destination_ip  = each.value.tunnel_monitor_destination_ip
  tunnel_monitor_source_ip       = each.value.tunnel_monitor_source_ip
  tunnel_monitor_profile         = each.value.tunnel_monitor_profile
  tunnel_monitor_proxy_id        = each.value.tunnel_monitor_proxy_id

  depends_on = [
    panos_panorama_ike_gateway.this,
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "panos_ipsec_tunnel" "this" {
  for_each = local.mode_map[var.mode] == 1 ? var.ipsec_tunnels : {}

  name                           = each.key
  tunnel_interface               = each.value.tunnel_interface
  anti_replay                    = each.value.anti_replay
  enable_ipv6                    = each.value.enable_ipv6
  copy_tos                       = each.value.copy_tos
  copy_flow_label                = each.value.copy_flow_label
  disabled                       = each.value.disabled
  type                           = each.value.type
  ak_ike_gateway                 = each.value.ak_ike_gateway
  ak_ipsec_crypto_profile        = each.value.ak_ipsec_crypto_profile
  mk_local_spi                   = each.value.mk_local_spi
  mk_remote_spi                  = each.value.mk_remote_spi
  mk_local_address_ip            = each.value.mk_local_address_ip
  mk_local_address_floating_ip   = each.value.mk_local_address_floating_ip
  mk_protocol                    = each.value.mk_protocol
  mk_auth_type                   = each.value.mk_auth_type
  mk_auth_key                    = each.value.mk_auth_key
  mk_esp_encryption_type         = each.value.mk_esp_encryption_type
  mk_esp_encryption_key          = each.value.mk_esp_encryption_key
  gps_interface                  = each.value.gps_interface
  gps_portal_address             = each.value.gps_portal_address
  gps_prefer_ipv6                = each.value.gps_prefer_ipv6
  gps_interface_ip_ipv4          = each.value.gps_interface_ip_ipv4
  gps_interface_ip_ipv6          = each.value.gps_interface_ip_ipv6
  gps_interface_floating_ip_ipv4 = each.value.gps_interface_floating_ip_ipv4
  gps_interface_floating_ip_ipv6 = each.value.gps_interface_floating_ip_ipv6
  gps_publish_connected_routes   = each.value.gps_publish_connected_routes
  gps_publish_routes             = each.value.gps_publish_routes
  gps_local_certificate          = each.value.gps_local_certificate
  gps_certificate_profile        = each.value.gps_certificate_profile
  enable_tunnel_monitor          = each.value.enable_tunnel_monitor
  tunnel_monitor_destination_ip  = each.value.tunnel_monitor_destination_ip
  tunnel_monitor_source_ip       = each.value.tunnel_monitor_source_ip
  tunnel_monitor_profile         = each.value.tunnel_monitor_profile
  tunnel_monitor_proxy_id        = each.value.tunnel_monitor_proxy_id

  depends_on = [
    panos_ike_gateway.this,
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "panos_panorama_ipsec_tunnel_proxy_id_ipv4" "this" {
  for_each = local.mode_map[var.mode] == 0 ? var.ipsec_tunnel_proxies : {}

  template = var.template
  ### an argument named "template_stack" is not expected here

  name                = each.key
  ipsec_tunnel        = each.value.ipsec_tunnel
  local               = each.value.local
  remote              = each.value.remote
  protocol_any        = each.value.protocol_any
  protocol_number     = each.value.protocol_number
  protocol_tcp_local  = each.value.protocol_tcp_local
  protocol_tcp_remote = each.value.protocol_tcp_remote
  protocol_udp_local  = each.value.protocol_udp_local
  protocol_udp_remote = each.value.protocol_udp_remote

  lifecycle {
    create_before_destroy = true
  }
}

resource "panos_ipsec_tunnel_proxy_id_ipv4" "this" {
  for_each = local.mode_map[var.mode] == 1 ? var.ipsec_tunnel_proxies : {}

  name                = each.key
  ipsec_tunnel        = each.value.ipsec_tunnel
  local               = each.value.local
  remote              = each.value.remote
  protocol_any        = each.value.protocol_any
  protocol_number     = each.value.protocol_number
  protocol_tcp_local  = each.value.protocol_tcp_local
  protocol_tcp_remote = each.value.protocol_tcp_remote
  protocol_udp_local  = each.value.protocol_udp_local
  protocol_udp_remote = each.value.protocol_udp_remote

  lifecycle {
    create_before_destroy = true
  }
}
