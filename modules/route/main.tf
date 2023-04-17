module "mode_lookup" {
  source = "../mode_lookup"
  mode   = var.mode
}

locals {
  static_routes = flatten([for k, v in var.virtual_routers : [for rk, rv in v.route_tables : [for sk, sv in rv.routes : { virtual_router = k, route_table = rk, route_name = sk, route = sv }]]])
}

resource "panos_panorama_static_route_ipv4" "this" {
  for_each = module.mode_lookup.mode == 0 ? { for static_route in local.static_routes : "${static_route.virtual_router}_${static_route.route_table}_${static_route.route_name}" => static_route } : {}

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
}

resource "panos_static_route_ipv4" "this" {
  for_each = module.mode_lookup.mode == 1 ? { for static_route in local.static_routes : "${static_route.virtual_router}_${static_route.route_table}_${static_route.route_name}" => static_route } : {}

  name           = each.key
  virtual_router = each.value.virtual_router
  route_table    = each.value.route_table
  destination    = each.value.route.destination
  interface      = each.value.route.interface
  type           = each.value.route.type
  next_hop       = each.value.route.next_hop
  admin_distance = each.value.route.admin_distance
  metric         = each.value.route.metric
}