resource "panos_virtual_router" "this" {
  for_each = var.virtual_routers

  template       = var.mode_map[var.mode] == 0 ? (var.template_stack == "" ? var.template : null) : null
  template_stack = var.mode_map[var.mode] == 0 ? var.template_stack == "" ? null : var.template_stack : null

  name                                 = each.key
  vsys                                 = each.value.vsys
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
