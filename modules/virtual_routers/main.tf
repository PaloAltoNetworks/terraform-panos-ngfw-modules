locals {
  routes = flatten([
    for vrk, vrv in var.virtual_routers : [
      for rk, rv in vrv.static_routes : {
        vr_key    = vrk
        route_key = rk
        route_val = rv
      }
    ] if can(vrv.static_routes)
  ])
}

resource "panos_virtual_router" "this" {
  for_each = var.virtual_routers

  template       = var.mode_map[var.mode] == 0 ? (var.template_stack == "" ? var.template : null) : null
  template_stack = var.mode_map[var.mode] == 0 ? var.template_stack == "" ? null : var.template_stack : null

  name                                 = each.key
  vsys                                 = each.value.vsys
  interfaces                           = each.value.interfaces
  static_dist                          = each.value.static_dist
  static_ipv6_dist                     = each.value.static_ipv6_dist
  ospf_int_dist                        = each.value.ospf_int_dist
  ospf_ext_dist                        = each.value.ospf_ext_dist
  ospfv3_int_dist                      = each.value.ospfv3_int_dist
  ospfv3_ext_dist                      = each.value.ospfv3_ext_dist
  ibgp_dist                            = each.value.ibgp_dist
  ebgp_dist                            = each.value.ebgp_dist
  rip_dist                             = each.value.rip_dist
  enable_ecmp                          = each.value.enable_ecmp
  ecmp_max_path                        = each.value.ecmp_max_path
  ecmp_symmetric_return                = each.value.ecmp_symmetric_return
  ecmp_strict_source_path              = each.value.ecmp_strict_source_path
  ecmp_load_balance_method             = each.value.ecmp_load_balance_method
  ecmp_hash_source_only                = each.value.ecmp_hash_source_only
  ecmp_hash_use_port                   = each.value.ecmp_hash_use_port
  ecmp_hash_seed                       = each.value.ecmp_hash_seed
  ecmp_weighted_round_robin_interfaces = each.value.ecmp_weighted_round_robin_interfaces

  lifecycle {
    create_before_destroy = true
  }
}

resource "panos_panorama_static_route_ipv4" "this" {
  for_each = var.mode_map[var.mode] == 0 ? { for v in local.routes : "${v.vr_key}-${v.route_key}" => v } : {}

  template       = var.template_stack == "" ? var.template : null
  template_stack = var.template_stack == "" ? null : var.template_stack

  name           = each.value.route_key
  virtual_router = panos_virtual_router.this[each.value.vr_key].name

  destination    = each.value.route_val.destination
  interface      = each.value.route_val.interface
  next_hop       = each.value.route_val.next_hop
  route_table    = each.value.route_val.route_table
  type           = each.value.route_val.type
  admin_distance = each.value.route_val.admin_distance
  metric         = each.value.route_val.metric
  bfd_profile    = each.value.route_val.bfd_profile

  lifecycle {
    create_before_destroy = true
  }
}

resource "panos_static_route_ipv4" "this" {
  for_each = var.mode_map[var.mode] == 1 ? { for v in local.routes : "${v.vr_key}-${v.route_key}" => v } : {}

  name           = each.value.route_key
  virtual_router = panos_virtual_router.this[each.value.vr_key].name

  destination    = each.value.route_val.destination
  interface      = each.value.route_val.interface
  next_hop       = each.value.route_val.next_hop
  route_table    = each.value.route_val.route_table
  type           = each.value.route_val.type
  admin_distance = each.value.route_val.admin_distance
  metric         = each.value.route_val.metric
  bfd_profile    = each.value.route_val.bfd_profile

  lifecycle {
    create_before_destroy = true
  }
}
