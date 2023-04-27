output "ike_crypto_profiles" {
  value = panos_ike_crypto_profile.this
}

output "panorama_ipsec_crypto_profiles" {
  value = panos_panorama_ipsec_crypto_profile.this
}

output "ipsec_crypto_profiles" {
  value = panos_ipsec_crypto_profile.this
}

output "panorama_ike_gateways" {
  value = panos_panorama_ike_gateway.this
}

output "ike_gateways" {
  value = panos_ike_gateway.this
}

output "panorama_ipsec_tunnels" {
  value = panos_panorama_ipsec_tunnel.this
}

output "ipsec_tunnels" {
  value = panos_ipsec_tunnel.this
}

output "panorama_ipsec_tunnel_proxy_ids_ipv4" {
  value = panos_panorama_ipsec_tunnel_proxy_id_ipv4.this
}

output "ipsec_tunnel_proxy_ids_ipv4" {
  value = panos_ipsec_tunnel_proxy_id_ipv4.this
}
