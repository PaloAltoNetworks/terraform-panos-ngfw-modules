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
| [panos_panorama_static_route_ipv4.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/panorama_static_route_ipv4) | resource |
| [panos_static_route_ipv4.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/static_route_ipv4) | resource |
| [panos_virtual_router.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/virtual_router) | resource |
| [panos_virtual_router_entry.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/virtual_router_entry) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_panorama"></a> [panorama](#input\_panorama) | If modules have target to Panorama, it enable Panorama specific variables. | `bool` | `false` | no |
| <a name="input_virtual_router_entries"></a> [virtual\_router\_entries](#input\_virtual\_router\_entries) | n/a | `map` | `{}` | no |
| <a name="input_virtual_router_static_routes"></a> [virtual\_router\_static\_routes](#input\_virtual\_router\_static\_routes) | n/a | `map` | `{}` | no |
| <a name="input_virtual_routers"></a> [virtual\_routers](#input\_virtual\_routers) | n/a | `map` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_panos_panorama_static_route_ipv4"></a> [panos\_panorama\_static\_route\_ipv4](#output\_panos\_panorama\_static\_route\_ipv4) | n/a |
| <a name="output_panos_static_route_ipv4"></a> [panos\_static\_route\_ipv4](#output\_panos\_static\_route\_ipv4) | n/a |
| <a name="output_panos_virtual_router"></a> [panos\_virtual\_router](#output\_panos\_virtual\_router) | n/a |
| <a name="output_panos_virtual_router_entry"></a> [panos\_virtual\_router\_entry](#output\_panos\_virtual\_router\_entry) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
