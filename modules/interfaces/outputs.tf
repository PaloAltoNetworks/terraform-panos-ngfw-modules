output "panorama_ethernet_interfaces" {
  value = panos_panorama_ethernet_interface.this
}

output "ethernet_interfaces" {
  value = panos_ethernet_interface.this
}

output "panorama_loopback_interfaces" {
  value = panos_panorama_loopback_interface.this
}

output "loopback_interfaces" {
  value = panos_loopback_interface.this
}

output "panorama_tunnel_interfaces" {
  value = panos_panorama_tunnel_interface.this
}

output "tunnel_interfaces" {
  value = panos_tunnel_interface.this
}

output "virtual_router_entries" {
  value = panos_virtual_router_entry.this
}

output "zone_entries" {
  value = panos_zone_entry.this
}
