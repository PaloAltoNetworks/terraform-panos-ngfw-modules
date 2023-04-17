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
| [panos_panorama_static_route_ipv4.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/panorama_static_route_ipv4) | resource |
| [panos_static_route_ipv4.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/static_route_ipv4) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_mode"></a> [mode](#input\_mode) | The mode to use for the modules. Valid values are `panorama` and `ngfw`. | `string` | `"panorama"` | no |
| <a name="input_static_routes"></a> [static\_routes](#input\_static\_routes) | n/a | `map` | `{}` | no |
| <a name="input_template"></a> [template](#input\_template) | n/a | `string` | n/a | yes |
| <a name="input_template_stack"></a> [template\_stack](#input\_template\_stack) | n/a | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_panos_panorama_static_route_ipv4"></a> [panos\_panorama\_static\_route\_ipv4](#output\_panos\_panorama\_static\_route\_ipv4) | n/a |
| <a name="output_panos_static_route_ipv4"></a> [panos\_static\_route\_ipv4](#output\_panos\_static\_route\_ipv4) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
