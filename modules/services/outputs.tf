output "panorama_service_groups" {
  value = panos_panorama_service_group.this
}

output "service_groups" {
  value = panos_service_group.this
}

output "panorama_services" {
  value = panos_panorama_service_object.this
}

output "services" {
  value = panos_service_object.this
}
