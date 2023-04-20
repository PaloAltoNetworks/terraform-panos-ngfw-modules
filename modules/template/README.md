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
| [panos_panorama_template.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/panorama_template) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_mode"></a> [mode](#input\_mode) | The mode to use for the modules. Valid values are `panorama` and `ngfw`. | `string` | n/a | yes |
| <a name="input_mode_map"></a> [mode\_map](#input\_mode\_map) | The mode to use for the modules. Valid values are `panorama` and `ngfw`. | <pre>object({<br>    panorama = number<br>    ngfw     = number<br>  })</pre> | <pre>{<br>  "ngfw": 1,<br>  "panorama": 0<br>}</pre> | no |
| <a name="input_templates"></a> [templates](#input\_templates) | Map of the templates, where key is the template's name:<br>- `description` - (Optional) The template's description.<br><br>Example:<pre>{<br>  "test-template" = {<br>    description = "My test template"<br>  }<br>}</pre> | <pre>map(object({<br>    description = optional(string)<br>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_panos_panorama_template"></a> [panos\_panorama\_template](#output\_panos\_panorama\_template) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
