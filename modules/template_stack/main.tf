resource "panos_panorama_template_stack" "this" {
  for_each = var.mode_map[var.mode] == 0 ? var.template_stacks : {}

  name        = each.key
  description = each.value.description
  templates   = each.value.templates

  lifecycle {
    create_before_destroy = true
  }
}

locals {
  templates_devices = flatten([for tk, tv in var.template_stacks : [for dv in tv.devices : { template_stack = "${tk}", device = "${dv}" }]])
}

resource "panos_panorama_template_stack_entry" "this" {
  for_each = var.mode_map[var.mode] == 0 ? { for td in local.templates_devices : "${td.template_stack}_${td.device}" => td } : {}

  template_stack = each.value.template_stack

  device = each.value.device

  lifecycle {
    create_before_destroy = true
  }
}
