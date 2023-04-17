module "mode_lookup" {
  source = "../mode_lookup"
  mode   = var.mode
}

resource "panos_panorama_management_profile" "this" {
  for_each = module.mode_lookup.mode == 0 ? var.management_profiles : {}

  template       = var.template_stack == "" ? try(var.template, "default") : null
  template_stack = var.template_stack == "" ? null : var.template_stack
  name           = each.key
  ping           = each.value.ping
  telnet         = each.value.telnet
  ssh            = each.value.ssh
  http           = each.value.http
  https          = each.value.https
  snmp           = each.value.snmp
  userid_service = each.value.userid_service
  permitted_ips  = each.value.permitted_ips
}

resource "panos_management_profile" "this" {
  for_each = module.mode_lookup.mode == 1 ? var.management_profiles : {}

  name           = each.key
  ping           = each.value.ping
  telnet         = each.value.telnet
  ssh            = each.value.ssh
  http           = each.value.http
  https          = each.value.https
  snmp           = each.value.snmp
  userid_service = each.value.userid_service
  permitted_ips  = each.value.permitted_ips
}
