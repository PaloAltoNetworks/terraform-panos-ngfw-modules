resource "panos_panorama_management_profile" "this" {
  for_each = var.mode_map[var.mode] == 0 ? var.management_profiles : {}

  template       = var.template_stack == "" ? var.template : null
  template_stack = var.template_stack == "" ? null : var.template_stack

  name                       = each.key
  ping                       = each.value.ping
  telnet                     = each.value.telnet
  ssh                        = each.value.ssh
  http                       = each.value.http
  https                      = each.value.https
  snmp                       = each.value.snmp
  response_pages             = each.value.response_pages
  userid_service             = each.value.userid_service
  userid_syslog_listener_ssl = each.value.userid_syslog_listener_ssl
  userid_syslog_listener_udp = each.value.userid_syslog_listener_udp
  permitted_ips              = each.value.permitted_ips

  lifecycle {
    create_before_destroy = true
  }
}

resource "panos_management_profile" "this" {
  for_each = var.mode_map[var.mode] == 1 ? var.management_profiles : {}

  name                       = each.key
  ping                       = each.value.ping
  telnet                     = each.value.telnet
  ssh                        = each.value.ssh
  http                       = each.value.http
  https                      = each.value.https
  snmp                       = each.value.snmp
  response_pages             = each.value.response_pages
  userid_service             = each.value.userid_service
  userid_syslog_listener_ssl = each.value.userid_syslog_listener_ssl
  userid_syslog_listener_udp = each.value.userid_syslog_listener_udp
  permitted_ips              = each.value.permitted_ips

  lifecycle {
    create_before_destroy = true
  }
}
