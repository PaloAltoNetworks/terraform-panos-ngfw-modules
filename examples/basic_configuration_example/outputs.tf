output "device_groups" {
  value = flatten([for k, v in module.device_groups.device_groups :
    { "device_group" : k, "id" : v.id }
  ])
}

output "tags" {
  value = flatten([for k, v in module.tags : concat(
    [for zk, zv in v.panorama_administrative_tags : { "device_group" : k, "tag" : zk, "id" : zv.id }],
    [for zk, zv in v.panos_administrative_tag : { "device_group" : k, "tag" : zk, "id" : zv.id }]
  )])
}

output "addresses" {
  value = flatten([for k, v in module.addresses : concat(
    [for zk, zv in v.addresses : { "device_group" : k, "address" : zk, "id" : zv.id }]
  )])
}

output "address_groups" {
  value = flatten([for k, v in module.address_groups : concat(
    [for zk, zv in v.address_groups : { "device_group" : k, "address_group" : zk, "id" : zv.id }],
    [for zk, zv in v.panorama_address_groups : { "device_group" : k, "address_group" : zk, "id" : zv.id }]
  )])
}

output "services" {
  value = flatten([for k, v in module.services : concat(
    [for zk, zv in v.panorama_services : { "device_group" : k, "service" : zk, "id" : zv.id }],
    [for zk, zv in v.services : { "device_group" : k, "service" : zk, "id" : zv.id }],
  )])
}

output "service_groups" {
  value = flatten([for k, v in module.service_groups : concat(
    [for zk, zv in v.panorama_service_groups : { "device_group" : k, "service_group" : zk, "id" : zv.id }],
    [for zk, zv in v.service_groups : { "device_group" : k, "service_group" : zk, "id" : zv.id }],
  )])
}

output "interfaces" {
  value = flatten([for k, v in module.interfaces : concat(
    [for zk, zv in v.ethernet_interfaces : { "template" : k, "interface" : zk, "id" : zv.id }],
    [for zk, zv in v.loopback_interfaces : { "template" : k, "interface" : zk, "id" : zv.id }],
    [for zk, zv in v.tunnel_interfaces : { "template" : k, "interface" : zk, "id" : zv.id }],
    [for zk, zv in v.panorama_ethernet_interfaces : { "template" : k, "interface" : zk, "id" : zv.id }],
    [for zk, zv in v.panorama_loopback_interfaces : { "template" : k, "interface" : zk, "id" : zv.id }],
    [for zk, zv in v.panorama_tunnel_interfaces : { "template" : k, "interface" : zk, "id" : zv.id }]
  )])
}

output "management_profiles" {
  value = flatten([for k, v in module.management_profiles : concat(
    [for zk, zv in v.panorama_management_profiles : { "template" : k, "management_profile" : zk, "id" : zv.id }],
    [for zk, zv in v.management_profiles : { "template" : k, "management_profile" : zk, "id" : zv.id }]
  )])
}

output "virtual_routers" {
  value = flatten([for k, v in module.virtual_routers : concat(
    [for zk, zv in v.virtual_routers : { "template" : k, "virtual_router" : zk, "id" : zv.id }]
  )])
}

output "static_routes" {
  value = flatten([for k, v in module.static_routes : concat(
    [for zk, zv in v.panorama_static_routes_ipv4 : { "template" : k, "static_route" : zk, "id" : zv.id }],
    [for zk, zv in v.static_routes_ipv4 : { "template" : k, "static_route" : zk, "id" : zv.id }]
  )])
}

output "zones" {
  value = flatten([for k, v in module.zones : concat(
    [for zk, zv in v.zones : { "template" : k, "zone" : zk, "id" : zv.id }]
  )])
}

output "ipsec" {
  value = flatten([for k, v in module.ipsec : concat(
    [for zk, zv in v.panorama_ipsec_tunnels : { "template" : k, "ipsec" : zk, "id" : zv.id }],
    [for zk, zv in v.ipsec_tunnels : { "template" : k, "ipsec" : zk, "id" : zv.id }]
  )])
  sensitive = true
}

output "templates" {
  value = flatten([for k, v in module.templates.panorama_templates :
    { "template" : k, "id" : v.id }
  ])
}

output "template_stacks" {
  value = flatten([for k, v in module.template_stacks.panorama_template_stacks :
    { "template_stack" : k, "id" : v.id }
  ])
}

output "security_policies" {
  value = flatten([for k, v in module.security_policies : concat(
    [for zk, zv in v.security_rule_groups : { "device_group" : k, "security_policy" : zk, "id" : zv.id }]
  )])
}

output "nat_policies" {
  value = flatten([for k, v in module.nat_policies : concat(
    [for zk, zv in v.panos_panorama_nat_rule_group : { "device_group" : k, "nat_policy" : zk, "id" : zv.id }],
    [for zk, zv in v.panos_nat_rule_group : { "device_group" : k, "nat_policy" : zk, "id" : zv.id }]
  )])
}

output "security_profiles" {
  value = flatten([for k, v in module.security_profiles : concat(
    [for zk, zv in v.panos_antivirus_security_profile : { "device_group" : k, "antivirus_security_profile" : zk, "id" : zv.id }],
    [for zk, zv in v.panos_anti_spyware_security_profile : { "device_group" : k, "anti_spyware_security_profile" : zk, "id" : zv.id }],
    [for zk, zv in v.panos_file_blocking_security_profile : { "device_group" : k, "file_blocking_security_profile" : zk, "id" : zv.id }],
    [for zk, zv in v.panos_vulnerability_security_profile : { "device_group" : k, "vulnerability_security_profile" : zk, "id" : zv.id }],
    [for zk, zv in v.panos_wildfire_analysis_security_profile : { "device_group" : k, "wildfire_analysis_security_profile" : zk, "id" : zv.id }]
  )])
}

output "log_forwarding_profiles_shared" {
  value = flatten([concat(
    [for k, v in module.log_forwarding_profiles_shared.panos_log_forwarding_profiles : { "profile" : k, "id" : v.id, "vsys" : v.vsys }],
    [for k, v in module.log_forwarding_profiles_shared.panos_panorama_log_forwarding_profiles : { "profile" : k, "id" : v.id, "device_group" : v.device_group }]
  )])
}
