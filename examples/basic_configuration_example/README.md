<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.4.0, < 2.0.0 |
| <a name="requirement_panos"></a> [panos](#requirement\_panos) | ~> 1.11.1 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_policy_as_code_address"></a> [policy\_as\_code\_address](#module\_policy\_as\_code\_address) | ../../modules/address | n/a |
| <a name="module_policy_as_code_address_groups"></a> [policy\_as\_code\_address\_groups](#module\_policy\_as\_code\_address\_groups) | ../../modules/address | n/a |
| <a name="module_policy_as_code_service"></a> [policy\_as\_code\_service](#module\_policy\_as\_code\_service) | ../../modules/service | n/a |
| <a name="module_policy_as_code_service_groups"></a> [policy\_as\_code\_service\_groups](#module\_policy\_as\_code\_service\_groups) | ../../modules/service | n/a |
| <a name="module_policy_as_code_tag"></a> [policy\_as\_code\_tag](#module\_policy\_as\_code\_tag) | ../../modules/tag | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_address_groups"></a> [address\_groups](#input\_address\_groups) | Address groups object | `any` | `{}` | no |
| <a name="input_addresses"></a> [addresses](#input\_addresses) | Address object | `any` | `{}` | no |
| <a name="input_device_group"></a> [device\_group](#input\_device\_group) | Used in variable panorama is true, it gives possibility to choose Device Group for the deployment | `list(string)` | `[]` | no |
| <a name="input_pan_creds"></a> [pan\_creds](#input\_pan\_creds) | Path to file with credentials to Panorama | `string` | n/a | yes |
| <a name="input_panorama"></a> [panorama](#input\_panorama) | Give information if Panorama is a target. | `bool` | `false` | no |
| <a name="input_services"></a> [services](#input\_services) | Service object | `any` | `{}` | no |
| <a name="input_services_group"></a> [services\_group](#input\_services\_group) | Service group object | `any` | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags object | `any` | `{}` | no |
| <a name="input_vsys"></a> [vsys](#input\_vsys) | Used in variable panorama is true, it gives possibility to choose Device Group for the deployment | `list(string)` | `[]` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->