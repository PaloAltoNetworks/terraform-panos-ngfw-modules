resource "panos_panorama_management_profile" "this" {
  for_each = var.panorama == true && length(var.management_profiles) != 0 ? { for prof in var.management_profiles : prof.name => prof } : {}

  template       = each.value.template_stack == "" ? try(each.value.template, "default") : null
  template_stack = each.value.template_stack == "" ? null : each.value.template_stack
  name           = each.value.name
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
  for_each = var.panorama == false && length(var.management_profiles) != 0 ? { for prof in var.management_profiles : prof.name => prof } : {}

  name           = each.value.name
  ping           = each.value.ping
  telnet         = each.value.telnet
  ssh            = each.value.ssh
  http           = each.value.http
  https          = each.value.https
  snmp           = each.value.snmp
  userid_service = each.value.userid_service
  permitted_ips  = each.value.permitted_ips
}
