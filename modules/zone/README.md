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
| [panos_zone.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/zone) | resource |
| [panos_zone_entry.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/zone_entry) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_panorama"></a> [panorama](#input\_panorama) | If modules have target to Panorama, it enable Panorama specific variables. | `bool` | `false` | no |
| <a name="input_zone_entries"></a> [zone\_entries](#input\_zone\_entries) | n/a | `map` | `{}` | no |
| <a name="input_zones"></a> [zones](#input\_zones) | n/a | `map` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_panos_zone_entry"></a> [panos\_zone\_entry](#output\_panos\_zone\_entry) | n/a |
| <a name="output_panos_zones"></a> [panos\_zones](#output\_panos\_zones) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
