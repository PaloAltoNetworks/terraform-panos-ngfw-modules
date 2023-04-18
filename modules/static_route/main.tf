resource "panos_panorama_static_route_ipv4" "this" {
  for_each = var.mode_map[var.mode] == 0 ? var.static_routes : {}

  template       = var.template_stack == "" ? var.template : null
  template_stack = var.template_stack == "" ? null : var.template_stack

  name           = each.key
  virtual_router = each.value.virtual_router
  route_table    = each.value.route_table
  destination    = each.value.destination
  interface      = each.value.interface
  type           = each.value.type
  next_hop       = each.value.next_hop
  admin_distance = each.value.admin_distance
  metric         = each.value.metric
  bfd_profile    = each.value.bfd_profile

  lifecycle {
    create_before_destroy = true
  }
}

resource "panos_static_route_ipv4" "this" {
  for_each = var.mode_map[var.mode] == 1 ? var.static_routes : {}

  name           = each.key
  virtual_router = each.value.virtual_router
  route_table    = each.value.route_table
  destination    = each.value.destination
  interface      = each.value.interface
  type           = each.value.type
  next_hop       = each.value.next_hop
  admin_distance = each.value.admin_distance
  metric         = each.value.metric
  bfd_profile    = each.value.bfd_profile

  lifecycle {
    create_before_destroy = true
  }
}