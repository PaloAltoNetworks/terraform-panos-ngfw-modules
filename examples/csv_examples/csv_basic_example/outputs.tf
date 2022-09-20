output "panos_zones" {
  value = [for zone in module.policy_as_code_network.panos_zones : zone.name]
}

output "panos_zone_entry" {
  value = {
    for name, details in module.policy_as_code_network.panos_zone_entry : name => {
      vsys = details.vsys,
      mode = details.mode
    }
  }
}

output "panos_panorama_ethernet_interface" {
  value = {
    for name, details in module.policy_as_code_network.panos_panorama_ethernet_interface : name => {
      comment                   = details.comment,
      mode                      = details.mode,
      enable_dhcp               = details.enable_dhcp,
      create_dhcp_default_route = details.create_dhcp_default_route,
      vsys                      = details.vsys
    }
  }
}

output "panos_ethernet_interface" {
  value = {
    for name, details in module.policy_as_code_network.panos_ethernet_interface : name => {
      comment                   = details.comment,
      mode                      = details.mode,
      enable_dhcp               = details.enable_dhcp,
      create_dhcp_default_route = details.create_dhcp_default_route,
      vsys                      = details.vsys
    }
  }
}

output "panos_panorama_loopback_interface" {
  value = {
    for name, details in module.policy_as_code_network.panos_panorama_loopback_interface : name => {
      comment = details.comment
    }
  }
}

output "panos_loopback_interface" {
  value = {
    for name, details in module.policy_as_code_network.panos_loopback_interface : name => {
      comment = details.comment
    }
  }
}

output "panos_panorama_tunnel_interface" {
  value = {
    for name, details in module.policy_as_code_network.panos_panorama_tunnel_interface : name => {
      comment = details.comment
    }
  }
}

output "panos_tunnel_interface" {
  value = {
    for name, details in module.policy_as_code_network.panos_tunnel_interface : name => {
      comment = details.comment
    }
  }
}

output "panos_virtual_router" {
  value = {
    for name, details in module.policy_as_code_network.panos_virtual_router : name => {
      interfaces = details.interfaces
    }
  }
}

output "panos_virtual_router_entry" {
  value = {
    for name, details in module.policy_as_code_network.panos_virtual_router_entry : name => {
      virtual_router = details.virtual_router
    }
  }
}

output "panos_panorama_static_route_ipv4" {
  value = {
    for name, details in module.policy_as_code_network.panos_panorama_static_route_ipv4 : name => {
      destination    = details.destination,
      next_hop       = details.next_hop
      id             = details.id
      name           = details.name,
      virtual_router = details.virtual_router
    }
  }
}

output "panos_static_route_ipv4" {
  value = {
    for name, details in module.policy_as_code_network.panos_static_route_ipv4 : name => {
      destination    = details.destination,
      next_hop       = details.next_hop
      id             = details.id
      name           = details.name,
      virtual_router = details.virtual_router
    }
  }
}

output "panos_panorama_management_profile" {
  value = {
    for name, details in module.policy_as_code_network.panos_panorama_management_profile : name => {
      http          = details.http,
      https         = details.http,
      permitted_ips = details.permitted_ips,
      ping          = details.ping,
      snmp          = details.snmp,
      ssh           = details.ssh,
      telnet        = details.telnet
    }
  }
}

output "panos_management_profile" {
  value = {
    for name, details in module.policy_as_code_network.panos_management_profile : name => {
      http          = details.http,
      https         = details.http,
      permitted_ips = details.permitted_ips,
      ping          = details.ping,
      snmp          = details.snmp,
      ssh           = details.ssh,
      telnet        = details.telnet
    }
  }
}


output "panos_ike_crypto_profile" {
  value = {
    for name, details in module.policy_as_code_network.panos_ike_crypto_profile : name => {
      authentications = details.authentications,
      encryptions     = details.encryptions,
      lifetime_type   = details.lifetime_type,
      lifetime_value  = details.lifetime_value
    }
  }
}

output "panos_panorama_ipsec_crypto_profile" {
  value = {
    for name, details in module.policy_as_code_network.panos_panorama_ipsec_crypto_profile : name => {
      authentications = details.authentications,
      encryptions     = details.encryptions,
      lifetime_type   = details.lifetime_type,
      lifetime_value  = details.lifetime_value,
      protocol        = details.protocol
    }
  }
}

output "panos_ipsec_crypto_profile" {
  value = {
    for name, details in module.policy_as_code_network.panos_ipsec_crypto_profile : name => {
      authentications = details.authentications,
      encryptions     = details.encryptions,
      lifetime_type   = details.lifetime_type,
      lifetime_value  = details.lifetime_value,
      protocol        = details.protocol
    }
  }
}

output "panos_panorama_ike_gateway" {
  value = {
    for name, details in module.policy_as_code_network.panos_panorama_ike_gateway : name => {
      peer_ip_type   = details.peer_ip_type,
      local_id_type  = details.local_id_type,
      local_id_value = details.local_id_value,
      peer_id_type   = details.peer_id_type,
      peer_id_value  = details.peer_id_value
    }
  }
}

output "panos_ike_gateway" {
  value = {
    for name, details in module.policy_as_code_network.panos_ike_gateway : name => {
      peer_ip_type   = details.peer_ip_type,
      local_id_type  = details.local_id_type,
      local_id_value = details.local_id_value,
      peer_id_type   = details.peer_id_type,
      peer_id_value  = details.peer_id_value
    }
  }
}

output "panos_panorama_ipsec_tunnel" {
  value = {
    for name, details in module.policy_as_code_network.panos_panorama_ipsec_tunnel : name => {
      tunnel_interface        = details.tunnel_interface,
      ak_ike_gateway          = details.ak_ike_gateway,
      ak_ipsec_crypto_profile = details.ak_ipsec_crypto_profile
    }
  }
}

output "panos_ipsec_tunnel" {
  value = {
    for name, details in module.policy_as_code_network.panos_ipsec_tunnel : name => {
      tunnel_interface        = details.tunnel_interface,
      ak_ike_gateway          = details.ak_ike_gateway,
      ak_ipsec_crypto_profile = details.ak_ipsec_crypto_profile
    }
  }
}

output "panos_panorama_ipsec_tunnel_proxy_id_ipv4" {
  value = {
    for name, details in module.policy_as_code_network.panos_panorama_ipsec_tunnel_proxy_id_ipv4 : name => {
      id           = details.id,
      ipsec_tunnel = details.ipsec_tunnel,
      local        = details.local,
      remote       = details.remote
    }
  }
}

output "panos_ipsec_tunnel_proxy_id_ipv4" {
  value = {
    for name, details in module.policy_as_code_network.panos_ipsec_tunnel_proxy_id_ipv4 : name => {
      id           = details.id,
      ipsec_tunnel = details.ipsec_tunnel,
      local        = details.local,
      remote       = details.remote
    }
  }
}
