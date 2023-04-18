
resource "panos_panorama_service_object" "this" {
  for_each = var.panorama == true && length(var.services) != 0 ? { for obj in var.services : obj.name => obj } : {}

  destination_port             = each.value.destination_port
  name                         = each.key
  protocol                     = each.value.protocol
  device_group                 = try(each.value.device_group, "shared")
  description                  = try(each.value.description, null)
  source_port                  = try(each.value.source_port, null)
  tags                         = try(each.value.tags, null)
  override_session_timeout     = try(each.value.override_session_timeout, false)
  override_timeout             = try(each.value.override_timeout, null)
  override_half_closed_timeout = try(each.value.override_half_closed_timeout, null)
  override_time_wait_timeout   = try(each.value.override_time_wait_timeout, null)

}

resource "panos_service_object" "this" {
  for_each = var.panorama == false && length(var.services) != 0 ? { for obj in var.services : obj.name => obj } : {}

  vsys = try(each.value.vsys, "vsys1")

  destination_port = each.value.destination_port
  name             = each.key
  protocol         = each.value.protocol

  description                  = try(each.value.description, null)
  source_port                  = try(each.value.source_port, null)
  tags                         = try(each.value.tags, null)
  override_session_timeout     = try(each.value.override_session_timeout, false)
  override_timeout             = try(each.value.override_timeout, null)
  override_half_closed_timeout = try(each.value.override_half_closed_timeout, null)
  override_time_wait_timeout   = try(each.value.override_time_wait_timeout, null)

}

resource "panos_panorama_service_group" "this" {
  for_each = var.panorama == true && length(var.addr_group) != 0 ? { for obj in var.service_groups : obj.name => obj } : tomap({})

  device_group = try(each.value.device_group, "shared")

  name     = each.key
  services = try(each.value.services, [])
  tags     = try(each.value.tags, null)

  depends_on = [
    panos_panorama_service_object.this
  ]
}


resource "panos_service_group" "this" {
  for_each = var.panorama == false && length(var.addr_group) != 0 ? { for obj in var.service_groups : obj.name => obj } : tomap({})

  vsys = try(each.value.vsys, "vsys1")

  name     = each.key
  services = try(each.value.services, [])
  tags     = try(each.value.tags, null)

  depends_on = [
    panos_service_object.this
  ]
}