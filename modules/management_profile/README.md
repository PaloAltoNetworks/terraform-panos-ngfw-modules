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
| [panos_management_profile.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/management_profile) | resource |
| [panos_panorama_management_profile.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/panorama_management_profile) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_management_profiles"></a> [management\_profiles](#input\_management\_profiles) | n/a | `map` | `{}` | no |
| <a name="input_mode"></a> [mode](#input\_mode) | The mode to use for the modules. Valid values are `panorama` and `ngfw`. | `string` | n/a | yes |
| <a name="input_mode_map"></a> [mode\_map](#input\_mode\_map) | The mode to use for the modules. Valid values are `panorama` and `ngfw`. | <pre>object({<br>    panorama = number<br>    ngfw     = number<br>  })</pre> | <pre>{<br>  "ngfw": 1,<br>  "panorama": 0<br>}</pre> | no |
| <a name="input_template"></a> [template](#input\_template) | The template name. | `string` | `"default"` | no |
| <a name="input_template_stack"></a> [template\_stack](#input\_template\_stack) | The template stack name. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_panos_management_profile"></a> [panos\_management\_profile](#output\_panos\_management\_profile) | n/a |
| <a name="output_panos_panorama_management_profile"></a> [panos\_panorama\_management\_profile](#output\_panos\_panorama\_management\_profile) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->