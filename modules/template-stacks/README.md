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
| [panos_panorama_template_stack.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/panorama_template_stack) | resource |
| [panos_panorama_template_stack_entry.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/panorama_template_stack_entry) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_mode"></a> [mode](#input\_mode) | The mode to use for the modules. Valid values are `panorama` and `ngfw`. | `string` | n/a | yes |
| <a name="input_mode_map"></a> [mode\_map](#input\_mode\_map) | The mode to use for the modules. Valid values are `panorama` and `ngfw`. | <pre>object({<br>    panorama = number<br>    ngfw     = number<br>  })</pre> | <pre>{<br>  "ngfw": 1,<br>  "panorama": 0<br>}</pre> | no |
| <a name="input_template_stacks"></a> [template\_stacks](#input\_template\_stacks) | Map of the template stacks, where key is the template stack's name:<br>- `description` - (Optional) The template's description.<br>- `default_vsys` - (Optional) The default virtual system template configuration pushed to firewalls with a single virtual system. Note - you can only set this if there is at least one template in this stack.<br>- `templates` - (Optional) List of templates in this stack.<br>- `devices` - (Optional) List of serial numbers to include in this stack.<br><br>Example:<pre>{<br>  "test-template-stack" = {<br>    description = "My test template stack with devices"<br>    templates   = ["test-template"]<br>    devices     = ["123456789"]<br>  }<br>}</pre> | <pre>map(object({<br>    description  = optional(string)<br>    default_vsys = optional(string)<br>    templates    = optional(list(string))<br>    devices      = optional(list(string), [])<br>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_panorama_template_stacks"></a> [panorama\_template\_stacks](#output\_panorama\_template\_stacks) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
