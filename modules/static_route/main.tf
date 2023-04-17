locals {
  static_routes = { for static_route in flatten([for sk, sv in var.static_routes : [for rk, rv in sv.routes : { virtual_router = sv.virtual_router, route_table = sv.route_table, route_name = rk, route = rv }]]) : "${static_route.virtual_router}_${static_route.route_table}_${static_route.route_name}" => static_route }
}

resource "panos_panorama_static_route_ipv4" "this" {
  for_each = var.mode_map[var.mode] == 0 ? local.static_routes : {}

  template       = var.template_stack == "" ? try(var.template, "default") : null
  template_stack = var.template_stack == "" ? null : var.template_stack

  name           = each.key
  virtual_router = each.value.virtual_router
  route_table    = each.value.route_table
  destination    = each.value.route.destination
  interface      = each.value.route.interface
  type           = each.value.route.type
  next_hop       = each.value.route.next_hop
  admin_distance = each.value.route.admin_distance
  metric         = each.value.route.metric
  bfd_profile    = each.value.route.bfd_profile
}

resource "panos_static_route_ipv4" "this" {
  for_each = var.mode_map[var.mode] == 1 ? local.static_routes : {}

  name           = each.key
  virtual_router = each.value.virtual_router
  route_table    = each.value.route_table
  destination    = each.value.route.destination
  interface      = each.value.route.interface
  type           = each.value.route.type
  next_hop       = each.value.route.next_hop
  admin_distance = each.value.route.admin_distance
  metric         = each.value.route.metric
  bfd_profile    = each.value.route.bfd_profile
}