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
| [panos_virtual_router.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/virtual_router) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_mode"></a> [mode](#input\_mode) | The mode to use for the modules. Valid values are `panorama` and `ngfw`. | `string` | `"panorama"` | no |
| <a name="input_template"></a> [template](#input\_template) | n/a | `string` | n/a | yes |
| <a name="input_template_stack"></a> [template\_stack](#input\_template\_stack) | n/a | `string` | n/a | yes |
| <a name="input_virtual_routers"></a> [virtual\_routers](#input\_virtual\_routers) | n/a | `map` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_panos_virtual_router"></a> [panos\_virtual\_router](#output\_panos\_virtual\_router) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
