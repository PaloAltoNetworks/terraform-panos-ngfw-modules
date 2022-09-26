locals {
  tags = [
    for x in csvdecode(file(var.tags_file)) : {
      device_group = x.device_group
      vsys         = x.vsys
      name         = x.name
      color        = length(x.color) != 0 ? x.color : "color8"
      comment      = x.comment
    }
  ]
  services = [
    for x in csvdecode(file(var.services_file)) : {
      device_group     = x.device_group
      vsys             = x.vsys
      name             = x.name
      protocol         = x.protocol
      source_port      = x.source_port
      destination_port = x.destination_port
      tags             = length(x.tags) != 0 ? split(",", x.tags) : []
      description      = x.description
    }
  ]

  service_groups = [
    for x in csvdecode(file(var.service_groups_file)) : {
      device_group = x.device_group
      vsys         = x.vsys
      name         = x.name
      services     = length(x.services) != 0 ? split(",", x.services) : []
      tags         = length(x.tags) != 0 ? split(",", x.tags) : null
    }
  ]

  addr_object = [
    for x in csvdecode(file(var.addresses_file)) : {
      device_group = x.device_group
      name         = x.name
      value        = { x.type == "" ? "ip-netmask" : x.type = x.value }
      tags         = length(x.tags) != 0 ? split(",", x.tags) : []
      type         = x.type == "" ? "ip-netmask" : x.type
      description  = x.description
    }
  ]

  addr_groups = [
    for x in csvdecode(file(var.addr_groups_file)) : {
      device_group     = x.device_group
      vsys             = x.vsys
      name             = x.name
      tags             = length(x.tags) != 0 ? split(",", lookup(x, "tags", "")) : []
      static_addresses = length(x.static_addresses) != 0 ? split(",", x.static_addresses) : []
      dynamic_match    = x.dynamic_match
      description      = x.description
    }
  ]

  sec_rules_dg = toset([for k, v in csvdecode(file(var.policy_file)) : v.device_group])
  sec_rules_rb = toset([for k, v in csvdecode(file(var.policy_file)) : v.rulebase])
  sec_rules = flatten([
    for dg in local.sec_rules_dg : [
      for rb in local.sec_rules_rb : merge(
        { "device_group" : dg },
        { "rulebase" : rb },
        {
          "rules" : [
            for x in csvdecode(file(var.policy_file)) :
            {
              name                               = x.name
              description                        = lookup(x, "description", null)
              applications                       = split(",", lookup(x, "applications", "any"))
              tags                               = length(x.tags) != 0 ? split(",", lookup(x, "tags", "")) : []
              source_zones                       = split(",", lookup(x, "source_zones", "any"))
              source_addresses                   = split(",", lookup(x, "source_addresses", "any"))
              negate_source                      = lookup(x, "negate_source", "false")
              source_users                       = split(",", lookup(x, "source_users", "any"))
              destination_zones                  = split(",", lookup(x, "destination_zones", "any"))
              destination_addresses              = split(",", lookup(x, "destination_addresses", "any"))
              negate_destination                 = lookup(x, "negate_destination", "false")
              applications                       = split(",", lookup(x, "applications", ""))
              services                           = split(",", lookup(x, "services", ""))
              categories                         = split(",", lookup(x, "categories", null))
              action                             = lookup(x, "action", null)
              disable_server_response_inspection = lookup(x, "disable_server_response_inspection", null)
              log_setting                        = lookup(x, "log_setting", null)
              log_start                          = lookup(x, "log_start", false)
              log_end                            = lookup(x, "log_end", true)
              disabled                           = lookup(x, "disabled", false)
              group                              = lookup(x, "group", null)
              virus                              = lookup(x, "virus", null)
              spyware                            = lookup(x, "spyware", null)
              vulnerability                      = lookup(x, "vulnerability", null)
              url_filtering                      = lookup(x, "url_filtering", null)
              file_blocking                      = lookup(x, "file_blocking", null)
              wildfire_analysis                  = lookup(x, "wildfire_analysis", null)
            }
            if x.device_group == dg && x.rulebase == rb
          ]
        }
      )
    ]
    ]
  )

  nat_rules_dg = toset([for k, v in csvdecode(file(var.nat_file)) : v.device_group])
  nat_rules_rb = toset([for k, v in csvdecode(file(var.nat_file)) : v.rulebase])
  nat_rules = flatten([
    for dg in local.nat_rules_dg : [
      for rb in local.nat_rules_rb : merge(
        { "device_group" : dg },
        { "rulebase" : rb },
        {
          "rules" : [
            for x in csvdecode(file(var.nat_file)) : {
              name     = x.name
              tags     = length(x.tags) != 0 ? split(",", lookup(x, "tags", "")) : []
              disabled = tobool(lower(lookup(x, "disabled", "false")))
              original_packet : {
                source_zones          = split(",", lookup(x, "source_zones", "any"))
                destination_zone      = lookup(x, "destination_zone", "any")
                destination_interface = lookup(x, "destination_interface", "any")
                source_addresses      = split(",", lookup(x, "original_source_addresses", "any"))
                destination_addresses = split(",", lookup(x, "original_destination_addresses", "any"))
                service               = lookup(x, "original_service", null)
              }
              translated_packet : {
                ## source
                # dynamic_ip
                source               = x.translated_source_type
                translated_addresses = x.translated_source_type == "dynamic_ip" || (x.translated_source_type == "dynamic_ip_and_port" && x.translated_source_address_type == "translated_address") ? split(",", x.translated_source_address) : []
                # static_ip
                static_ip = x.translated_source_type == "static_ip" ? {
                  translated_address = x.translated_source_address
                  bi_directional     = tobool(lower(lookup(x, "bidirectional", "false")))
                } : {}
                # dynamic_ip_and_port
                interface_address = x.translated_source_type == "dynamic_ip_and_port" && x.translated_source_address_type == "interface_address" ? {
                  interface  = x.translated_source_interface
                  ip_address = x.translated_source_address
                } : {}

                # destination
                destination = x.translated_destination_type
                static_translation = x.translated_destination_type == "static_translation" ? {
                  address = x.translated_destination_address
                  port    = x.translated_destination_port
                } : {}
                dynamic_translation = x.translated_destination_type == "dynamic_translation" ? {
                  address = x.translated_destination_address
                  port    = x.translated_destination_port
                } : {}
              }
            }
          ]
        }
      )
    ]
    ]
  )
  # Network
  zones = [
    for x in csvdecode(file(var.network_zones_file)) : {
      template = x.template != "" ? x.template : "default"

      name           = x.name
      vsys           = x.vsys
      mode           = x.mode
      interfaces     = length(x.interfaces) != 0 ? split(",", x.interfaces) : []
      enable_user_id = x.enable_user_id != "" ? x.enable_user_id : false
      include_acls   = length(x.include_acls) != 0 ? split(",", x.include_acls) : []
      exclude_acls   = length(x.exclude_acls) != 0 ? split(",", x.exclude_acls) : []
  }]

  zone_entres = [
    for x in csvdecode(file(var.network_interfaces_file)) : {

      template  = x.template != "" ? x.template : "default"
      vsys      = x.vsys
      zone      = x.zone
      interface = x.name
    }
  ]

  interfaces = [
    for x in csvdecode(file(var.network_interfaces_file)) : {
      template = x.template != "" ? x.template : "default"

      type                      = x.type
      name                      = x.name
      vsys                      = x.vsys
      mode                      = x.mode
      management_profile        = x.management_profile
      link_state                = x.link_state
      static_ips                = length(x.static_ips) != 0 ? split(",", x.static_ips) : []
      enable_dhcp               = x.enable_dhcp
      create_dhcp_default_route = x.create_dhcp_default_route
      dhcp_default_route_metric = x.dhcp_default_route_metric
      comment                   = x.comment
    } #if x.type == "ethernet"
  ]

  virtual_routers = [
    for x in csvdecode(file(var.network_virtual_routers_file)) : {
      template = x.template != "" ? x.template : "default"
      vsys     = x.vsys
      name     = x.name
      mode     = x.mode
    }
  ]
  # mapping interfaces to virtual_routers
  virtual_router_entries = [
    for x in csvdecode(file(var.network_interfaces_file)) : {
      virtual_router = x.virtual_router
      interface      = x.name
      template       = x.template
    }
  ]
  # static routes
  virtual_router_static_routes_defined = [
    for x in csvdecode(file(var.network_static_routes_file)) : {
      template       = x.template != "" ? x.template : "default"
      virtual_router = x.virtual_router
      route_table    = x.route_table != "" ? x.route_table : "unicast"
      name           = x.name
      destination    = x.destination
      interface      = x.interface != "" ? x.interface : null
      type           = x.type     #!= "" ? x.type : ""
      next_hop       = x.next_hop # != "" ? x.next_hop : null
      admin_distance = x.admin_distance != "" ? x.admin_distance : null
      metric         = x.metric != "" ? x.metric : null
    }
  ]

  management_profiles = [
    for x in csvdecode(file(var.network_management_profiles_file)) : {
      template       = x.template != "" ? x.template : "default"
      name           = x.name
      ping           = x.ping != "" ? x.ping : false
      telnet         = x.telnet != "" ? x.telnet : false
      ssh            = x.ssh != "" ? x.ssh : false
      http           = x.http != "" ? x.http : false
      https          = x.https != "" ? x.https : false
      snmp           = x.snmp != "" ? x.snmp : false
      userid_service = x.userid_service != "" ? x.userid_service : false
      permitted_ips  = length(x.permitted_ips) != 0 ? split(",", x.permitted_ips) : []
    }
  ]

  # IPSec
  ike_crypto_profiles = [
    for x in csvdecode(file(var.network_ike_crypto_profiles_file)) : {
      template                = x.template != "" ? x.template : "default"
      name                    = x.name
      dh_groups               = x.dh_groups != "" ? split(",", x.dh_groups) : []
      authentications         = x.authentications != "" ? split(",", x.authentications) : []
      encryptions             = x.encryptions != "" ? split(",", x.encryptions) : []
      lifetime_value          = x.lifetime_value
      authentication_multiple = x.authentication_multiple
    }
  ]

  ipsec_crypto_profiles = [
    for x in csvdecode(file(var.network_ipsec_crypto_profiles_file)) : {
      template = x.template != "" ? x.template : "default"

      name            = x.name
      protocol        = x.protocol != "" ? x.protocol : "esp"
      dh_group        = x.dh_group != "" ? x.dh_group : null
      authentications = x.authentications != "" ? split(",", x.authentications) : []
      encryptions     = x.encryptions != "" ? split(",", x.encryptions) : []
      lifetime_type   = x.lifetime_type
      lifetime_value  = x.lifetime_value

      lifesize_type  = x.lifesize_type != "" ? x.lifesize_type : null
      lifesize_value = x.lifesize_value != "" ? x.lifesize_value : null
    }
  ]

  ike_gateways = [
    for x in csvdecode(file(var.network_ike_gateways_file)) : {

      template = x.template != "" ? x.template : "default"

      name    = x.name
      version = x.version

      disabled             = x.disabled != "" ? x.disabled : false
      peer_ip_type         = x.peer_ip_type != "" ? x.peer_ip_type : "ipaddr"
      peer_ip_value        = x.peer_ip_value
      interface            = x.interface
      pre_shared_key       = x.pre_shared_key
      local_id_type        = x.local_id_type != "" ? x.local_id_type : "ipaddr"
      local_id_value       = x.local_id_value
      peer_id_type         = x.peer_id_type != "" ? x.peer_id_type : "ipaddr"
      peer_id_value        = x.peer_id_value
      ikev1_crypto_profile = x.ikev1_crypto_profile
    }
  ]

  ipsec_tunnels = [
    for x in csvdecode(file(var.network_ipsec_tunnels_file)) : {

      template = x.template != "" ? x.template : "default"

      name                          = x.name
      tunnel_interface              = x.tunnel_interface
      type                          = x.type
      disabled                      = x.disabled
      ak_ike_gateway                = x.ak_ike_gateway
      ak_ipsec_crypto_profile       = x.ak_ipsec_crypto_profile
      anti_replay                   = x.anti_replay
      copy_flow_label               = x.copy_flow_label
      enable_tunnel_monitor         = x.enable_tunnel_monitor
      tunnel_monitor_destination_ip = x.tunnel_monitor_destination_ip
      tunnel_monitor_source_ip      = x.tunnel_monitor_source_ip
      tunnel_monitor_profile        = x.tunnel_monitor_profile
      tunnel_monitor_proxy_id       = x.tunnel_monitor_proxy_id
    }
  ]

  ipsec_tunnels_proxy = flatten([
    for x in csvdecode(file(var.network_ipsec_tunnels_file)) : [
      for x1 in split(";", x.proxy_subnets) : {

        template     = x.template != "" ? x.template : "default"
        ipsec_tunnel = x.name
        name         = split(",", x1)[0]
        local        = split(",", x1)[1]
        remote       = split(",", x1)[2]
      }
    ] if x.proxy_subnets != ""
  ])

  ipsec_routers = flatten([
    for x in csvdecode(file(var.network_ipsec_tunnels_file)) : [
      for x1 in split(";", x.proxy_subnets) : {

        template     = x.template != "" ? x.template : "default"
        ipsec_tunnel = x.name

        name = join("_", ["IPsec", x.name, split(",", x1)[0]])


        template       = x.template != "" ? x.template : "default"
        virtual_router = x.virtual_router
        route_table    = "unicast"

        destination = split(",", x1)[2]

        interface      = x.tunnel_interface
        type           = ""
        next_hop       = null
        admin_distance = null
        metric         = null

      }
    ] if x.proxy_subnets != ""
  ])

  virtual_router_static_routes = concat(local.virtual_router_static_routes_defined, local.ipsec_routers)

}

module "policy_as_code_objects" {
  source = "../../../modules/objects"

  panorama_mode = var.panorama_mode

  tags           = try(local.tags, {})
  services       = try(local.services, {})
  service_groups = try(local.service_groups, {})
  addr_obj       = try(local.addr_object, {})
  addr_group     = try(local.addr_groups, {})
}

module "policy_as_code_policy" {
  source = "../../../modules/policy"

  panorama_mode = var.panorama_mode

  sec_policy = try(local.sec_rules, {})
  nat_policy = try(local.nat_rules, {})

  depends_on = [
    module.policy_as_code_objects,
    module.policy_as_code_network,
  ]
}

module "policy_as_code_network" {
  source = "../../../modules/network"

  panorama_mode = var.panorama_mode

  interfaces                   = try(local.interfaces, {})
  zones                        = try(local.zones, {})
  zone_entres                  = try(local.zone_entres, {})
  virtual_routers              = try(local.virtual_routers, {})
  virtual_router_entries       = try(local.virtual_router_entries, {})
  virtual_router_static_routes = try(local.virtual_router_static_routes, {})
  management_profiles          = try(local.management_profiles, {})

  ike_crypto_profiles   = try(local.ike_crypto_profiles, {})
  ipsec_crypto_profiles = try(local.ipsec_crypto_profiles, {})
  ike_gateways          = try(local.ike_gateways, {})
  ipsec_tunnels         = try(local.ipsec_tunnels, {})
  ipsec_tunnels_proxy   = try(local.ipsec_tunnels_proxy, {})
}
