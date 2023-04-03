<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.4.0, < 2.0.0 |
| <a name="requirement_panos"></a> [panos](#requirement\_panos) | ~> 1.11.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_panos"></a> [panos](#provider\_panos) | ~> 1.11.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [panos_ethernet_interface.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/ethernet_interface) | resource |
| [panos_ike_crypto_profile.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/ike_crypto_profile) | resource |
| [panos_ike_gateway.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/ike_gateway) | resource |
| [panos_ipsec_crypto_profile.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/ipsec_crypto_profile) | resource |
| [panos_ipsec_tunnel.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/ipsec_tunnel) | resource |
| [panos_ipsec_tunnel_proxy_id_ipv4.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/ipsec_tunnel_proxy_id_ipv4) | resource |
| [panos_loopback_interface.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/loopback_interface) | resource |
| [panos_management_profile.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/management_profile) | resource |
| [panos_panorama_ethernet_interface.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/panorama_ethernet_interface) | resource |
| [panos_panorama_ike_gateway.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/panorama_ike_gateway) | resource |
| [panos_panorama_ipsec_crypto_profile.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/panorama_ipsec_crypto_profile) | resource |
| [panos_panorama_ipsec_tunnel.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/panorama_ipsec_tunnel) | resource |
| [panos_panorama_ipsec_tunnel_proxy_id_ipv4.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/panorama_ipsec_tunnel_proxy_id_ipv4) | resource |
| [panos_panorama_loopback_interface.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/panorama_loopback_interface) | resource |
| [panos_panorama_management_profile.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/panorama_management_profile) | resource |
| [panos_panorama_static_route_ipv4.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/panorama_static_route_ipv4) | resource |
| [panos_panorama_tunnel_interface.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/panorama_tunnel_interface) | resource |
| [panos_static_route_ipv4.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/static_route_ipv4) | resource |
| [panos_tunnel_interface.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/tunnel_interface) | resource |
| [panos_virtual_router.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/virtual_router) | resource |
| [panos_virtual_router_entry.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/virtual_router_entry) | resource |
| [panos_zone.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/zone) | resource |
| [panos_zone_entry.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/zone_entry) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ike_crypto_profiles"></a> [ike\_crypto\_profiles](#input\_ike\_crypto\_profiles) | n/a | `map` | `{}` | no |
| <a name="input_ike_gateways"></a> [ike\_gateways](#input\_ike\_gateways) | n/a | `map` | `{}` | no |
| <a name="input_interfaces"></a> [interfaces](#input\_interfaces) | n/a | `map` | `{}` | no |
| <a name="input_ipsec_crypto_profiles"></a> [ipsec\_crypto\_profiles](#input\_ipsec\_crypto\_profiles) | n/a | `map` | `{}` | no |
| <a name="input_ipsec_tunnels"></a> [ipsec\_tunnels](#input\_ipsec\_tunnels) | n/a | `map` | `{}` | no |
| <a name="input_ipsec_tunnels_proxy"></a> [ipsec\_tunnels\_proxy](#input\_ipsec\_tunnels\_proxy) | n/a | `map` | `{}` | no |
| <a name="input_management_profiles"></a> [management\_profiles](#input\_management\_profiles) | n/a | `map` | `{}` | no |
| <a name="input_panorama"></a> [panorama](#input\_panorama) | If modules have target to Panorama, it enable Panorama specific variables. | `bool` | `false` | no |
| <a name="input_virtual_router_entries"></a> [virtual\_router\_entries](#input\_virtual\_router\_entries) | n/a | `map` | `{}` | no |
| <a name="input_virtual_router_static_routes"></a> [virtual\_router\_static\_routes](#input\_virtual\_router\_static\_routes) | n/a | `map` | `{}` | no |
| <a name="input_virtual_routers"></a> [virtual\_routers](#input\_virtual\_routers) | n/a | `map` | `{}` | no |
| <a name="input_zone_entres"></a> [zone\_entres](#input\_zone\_entres) | n/a | `map` | `{}` | no |
| <a name="input_zones"></a> [zones](#input\_zones) | n/a | `map` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_panos_ethernet_interface"></a> [panos\_ethernet\_interface](#output\_panos\_ethernet\_interface) | n/a |
| <a name="output_panos_ike_crypto_profile"></a> [panos\_ike\_crypto\_profile](#output\_panos\_ike\_crypto\_profile) | n/a |
| <a name="output_panos_ike_gateway"></a> [panos\_ike\_gateway](#output\_panos\_ike\_gateway) | n/a |
| <a name="output_panos_ipsec_crypto_profile"></a> [panos\_ipsec\_crypto\_profile](#output\_panos\_ipsec\_crypto\_profile) | n/a |
| <a name="output_panos_ipsec_tunnel"></a> [panos\_ipsec\_tunnel](#output\_panos\_ipsec\_tunnel) | n/a |
| <a name="output_panos_ipsec_tunnel_proxy_id_ipv4"></a> [panos\_ipsec\_tunnel\_proxy\_id\_ipv4](#output\_panos\_ipsec\_tunnel\_proxy\_id\_ipv4) | n/a |
| <a name="output_panos_loopback_interface"></a> [panos\_loopback\_interface](#output\_panos\_loopback\_interface) | n/a |
| <a name="output_panos_management_profile"></a> [panos\_management\_profile](#output\_panos\_management\_profile) | n/a |
| <a name="output_panos_panorama_ethernet_interface"></a> [panos\_panorama\_ethernet\_interface](#output\_panos\_panorama\_ethernet\_interface) | n/a |
| <a name="output_panos_panorama_ike_gateway"></a> [panos\_panorama\_ike\_gateway](#output\_panos\_panorama\_ike\_gateway) | n/a |
| <a name="output_panos_panorama_ipsec_crypto_profile"></a> [panos\_panorama\_ipsec\_crypto\_profile](#output\_panos\_panorama\_ipsec\_crypto\_profile) | n/a |
| <a name="output_panos_panorama_ipsec_tunnel"></a> [panos\_panorama\_ipsec\_tunnel](#output\_panos\_panorama\_ipsec\_tunnel) | n/a |
| <a name="output_panos_panorama_ipsec_tunnel_proxy_id_ipv4"></a> [panos\_panorama\_ipsec\_tunnel\_proxy\_id\_ipv4](#output\_panos\_panorama\_ipsec\_tunnel\_proxy\_id\_ipv4) | n/a |
| <a name="output_panos_panorama_loopback_interface"></a> [panos\_panorama\_loopback\_interface](#output\_panos\_panorama\_loopback\_interface) | n/a |
| <a name="output_panos_panorama_management_profile"></a> [panos\_panorama\_management\_profile](#output\_panos\_panorama\_management\_profile) | n/a |
| <a name="output_panos_panorama_static_route_ipv4"></a> [panos\_panorama\_static\_route\_ipv4](#output\_panos\_panorama\_static\_route\_ipv4) | n/a |
| <a name="output_panos_panorama_tunnel_interface"></a> [panos\_panorama\_tunnel\_interface](#output\_panos\_panorama\_tunnel\_interface) | n/a |
| <a name="output_panos_static_route_ipv4"></a> [panos\_static\_route\_ipv4](#output\_panos\_static\_route\_ipv4) | n/a |
| <a name="output_panos_tunnel_interface"></a> [panos\_tunnel\_interface](#output\_panos\_tunnel\_interface) | n/a |
| <a name="output_panos_virtual_router"></a> [panos\_virtual\_router](#output\_panos\_virtual\_router) | n/a |
| <a name="output_panos_virtual_router_entry"></a> [panos\_virtual\_router\_entry](#output\_panos\_virtual\_router\_entry) | n/a |
| <a name="output_panos_zone_entry"></a> [panos\_zone\_entry](#output\_panos\_zone\_entry) | n/a |
| <a name="output_panos_zones"></a> [panos\_zones](#output\_panos\_zones) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
