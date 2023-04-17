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

| Name | Source | Version |
|------|--------|---------|
| <a name="module_mode_lookup"></a> [mode\_lookup](#module\_mode\_lookup) | ../mode_lookup | n/a |

## Resources

| Name | Type |
|------|------|
| [panos_ike_crypto_profile.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/ike_crypto_profile) | resource |
| [panos_ike_gateway.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/ike_gateway) | resource |
| [panos_ipsec_crypto_profile.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/ipsec_crypto_profile) | resource |
| [panos_ipsec_tunnel.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/ipsec_tunnel) | resource |
| [panos_ipsec_tunnel_proxy_id_ipv4.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/ipsec_tunnel_proxy_id_ipv4) | resource |
| [panos_panorama_ike_gateway.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/panorama_ike_gateway) | resource |
| [panos_panorama_ipsec_crypto_profile.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/panorama_ipsec_crypto_profile) | resource |
| [panos_panorama_ipsec_tunnel.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/panorama_ipsec_tunnel) | resource |
| [panos_panorama_ipsec_tunnel_proxy_id_ipv4.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/panorama_ipsec_tunnel_proxy_id_ipv4) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ike_crypto_profiles"></a> [ike\_crypto\_profiles](#input\_ike\_crypto\_profiles) | n/a | `map` | `{}` | no |
| <a name="input_ike_gateways"></a> [ike\_gateways](#input\_ike\_gateways) | n/a | `map` | `{}` | no |
| <a name="input_ipsec_crypto_profiles"></a> [ipsec\_crypto\_profiles](#input\_ipsec\_crypto\_profiles) | n/a | `map` | `{}` | no |
| <a name="input_ipsec_tunnels"></a> [ipsec\_tunnels](#input\_ipsec\_tunnels) | n/a | `map` | `{}` | no |
| <a name="input_ipsec_tunnels_proxy"></a> [ipsec\_tunnels\_proxy](#input\_ipsec\_tunnels\_proxy) | n/a | `map` | `{}` | no |
| <a name="input_mode"></a> [mode](#input\_mode) | The mode to use for the modules. Valid values are `panorama` and `ngfw`. | `string` | `"panorama"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_panos_ike_crypto_profile"></a> [panos\_ike\_crypto\_profile](#output\_panos\_ike\_crypto\_profile) | n/a |
| <a name="output_panos_ike_gateway"></a> [panos\_ike\_gateway](#output\_panos\_ike\_gateway) | n/a |
| <a name="output_panos_ipsec_crypto_profile"></a> [panos\_ipsec\_crypto\_profile](#output\_panos\_ipsec\_crypto\_profile) | n/a |
| <a name="output_panos_ipsec_tunnel"></a> [panos\_ipsec\_tunnel](#output\_panos\_ipsec\_tunnel) | n/a |
| <a name="output_panos_ipsec_tunnel_proxy_id_ipv4"></a> [panos\_ipsec\_tunnel\_proxy\_id\_ipv4](#output\_panos\_ipsec\_tunnel\_proxy\_id\_ipv4) | n/a |
| <a name="output_panos_panorama_ike_gateway"></a> [panos\_panorama\_ike\_gateway](#output\_panos\_panorama\_ike\_gateway) | n/a |
| <a name="output_panos_panorama_ipsec_crypto_profile"></a> [panos\_panorama\_ipsec\_crypto\_profile](#output\_panos\_panorama\_ipsec\_crypto\_profile) | n/a |
| <a name="output_panos_panorama_ipsec_tunnel"></a> [panos\_panorama\_ipsec\_tunnel](#output\_panos\_panorama\_ipsec\_tunnel) | n/a |
| <a name="output_panos_panorama_ipsec_tunnel_proxy_id_ipv4"></a> [panos\_panorama\_ipsec\_tunnel\_proxy\_id\_ipv4](#output\_panos\_panorama\_ipsec\_tunnel\_proxy\_id\_ipv4) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
