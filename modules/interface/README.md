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
| [panos_ethernet_interface.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/ethernet_interface) | resource |
| [panos_loopback_interface.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/loopback_interface) | resource |
| [panos_panorama_ethernet_interface.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/panorama_ethernet_interface) | resource |
| [panos_panorama_loopback_interface.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/panorama_loopback_interface) | resource |
| [panos_panorama_tunnel_interface.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/panorama_tunnel_interface) | resource |
| [panos_tunnel_interface.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/tunnel_interface) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_interfaces"></a> [interfaces](#input\_interfaces) | n/a | `map` | `{}` | no |
| <a name="input_mode"></a> [mode](#input\_mode) | The mode to use for the modules. Valid values are `panorama` and `ngfw`. | `string` | `"panorama"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_panos_ethernet_interface"></a> [panos\_ethernet\_interface](#output\_panos\_ethernet\_interface) | n/a |
| <a name="output_panos_loopback_interface"></a> [panos\_loopback\_interface](#output\_panos\_loopback\_interface) | n/a |
| <a name="output_panos_panorama_ethernet_interface"></a> [panos\_panorama\_ethernet\_interface](#output\_panos\_panorama\_ethernet\_interface) | n/a |
| <a name="output_panos_panorama_loopback_interface"></a> [panos\_panorama\_loopback\_interface](#output\_panos\_panorama\_loopback\_interface) | n/a |
| <a name="output_panos_panorama_tunnel_interface"></a> [panos\_panorama\_tunnel\_interface](#output\_panos\_panorama\_tunnel\_interface) | n/a |
| <a name="output_panos_tunnel_interface"></a> [panos\_tunnel\_interface](#output\_panos\_tunnel\_interface) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
