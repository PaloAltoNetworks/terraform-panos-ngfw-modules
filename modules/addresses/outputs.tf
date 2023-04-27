output "addresses" {
  value = panos_address_object.this
}

output "address_groups" {
  value = panos_panorama_address_group.this
}

output "panorama_address_groups" {
  value = panos_panorama_address_group.this
}
