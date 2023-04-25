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
| <a name="module_device_group"></a> [device\_group](#module\_device\_group) | ../../modules/device_group | n/a |
| <a name="module_policy_as_code_address"></a> [policy\_as\_code\_address](#module\_policy\_as\_code\_address) | ../../modules/address | n/a |
| <a name="module_policy_as_code_address_groups"></a> [policy\_as\_code\_address\_groups](#module\_policy\_as\_code\_address\_groups) | ../../modules/address | n/a |
| <a name="module_policy_as_code_interfaces"></a> [policy\_as\_code\_interfaces](#module\_policy\_as\_code\_interfaces) | ../../modules/interface | n/a |
| <a name="module_policy_as_code_ipsec"></a> [policy\_as\_code\_ipsec](#module\_policy\_as\_code\_ipsec) | ../../modules/ipsec | n/a |
| <a name="module_policy_as_code_management_profiles"></a> [policy\_as\_code\_management\_profiles](#module\_policy\_as\_code\_management\_profiles) | ../../modules/management_profile | n/a |
| <a name="module_policy_as_code_security_policies"></a> [policy\_as\_code\_security\_policies](#module\_policy\_as\_code\_security\_policies) | ../../modules/security_policies | n/a |
| <a name="module_policy_as_code_service"></a> [policy\_as\_code\_service](#module\_policy\_as\_code\_service) | ../../modules/service | n/a |
| <a name="module_policy_as_code_service_groups"></a> [policy\_as\_code\_service\_groups](#module\_policy\_as\_code\_service\_groups) | ../../modules/service | n/a |
| <a name="module_policy_as_code_static_routes"></a> [policy\_as\_code\_static\_routes](#module\_policy\_as\_code\_static\_routes) | ../../modules/static_route | n/a |
| <a name="module_policy_as_code_tag"></a> [policy\_as\_code\_tag](#module\_policy\_as\_code\_tag) | ../../modules/tag | n/a |
| <a name="module_policy_as_code_template"></a> [policy\_as\_code\_template](#module\_policy\_as\_code\_template) | ../../modules/template | n/a |
| <a name="module_policy_as_code_template_stack"></a> [policy\_as\_code\_template\_stack](#module\_policy\_as\_code\_template\_stack) | ../../modules/template_stack | n/a |
| <a name="module_policy_as_code_virtual_routers"></a> [policy\_as\_code\_virtual\_routers](#module\_policy\_as\_code\_virtual\_routers) | ../../modules/virtual_router | n/a |
| <a name="module_policy_as_code_zones"></a> [policy\_as\_code\_zones](#module\_policy\_as\_code\_zones) | ../../modules/zone | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_address_groups"></a> [address\_groups](#input\_address\_groups) | Address groups object | `any` | `{}` | no |
| <a name="input_addresses"></a> [addresses](#input\_addresses) | Address object | `any` | `{}` | no |
| <a name="input_device_group"></a> [device\_group](#input\_device\_group) | Used if _mode_ is panorama, this defines the Device Group for the deployment | `any` | `{}` | no |
| <a name="input_ike_crypto_profiles"></a> [ike\_crypto\_profiles](#input\_ike\_crypto\_profiles) | n/a | `any` | n/a | yes |
| <a name="input_ike_gateways"></a> [ike\_gateways](#input\_ike\_gateways) | n/a | `any` | n/a | yes |
| <a name="input_interfaces"></a> [interfaces](#input\_interfaces) | n/a | `any` | n/a | yes |
| <a name="input_ipsec_crypto_profiles"></a> [ipsec\_crypto\_profiles](#input\_ipsec\_crypto\_profiles) | n/a | `any` | n/a | yes |
| <a name="input_ipsec_tunnels"></a> [ipsec\_tunnels](#input\_ipsec\_tunnels) | n/a | `any` | n/a | yes |
| <a name="input_management_profiles"></a> [management\_profiles](#input\_management\_profiles) | n/a | `any` | n/a | yes |
| <a name="input_mode"></a> [mode](#input\_mode) | Provide information about target. | `string` | `""` | no |
| <a name="input_pan_creds"></a> [pan\_creds](#input\_pan\_creds) | Path to file with credentials to Panorama | `string` | n/a | yes |
| <a name="input_security_policies_group"></a> [security\_policies\_group](#input\_security\_policies\_group) | Security policies | `any` | `{}` | no |
| <a name="input_services"></a> [services](#input\_services) | Service object | `any` | `{}` | no |
| <a name="input_services_group"></a> [services\_group](#input\_services\_group) | Service group object | `any` | `{}` | no |
| <a name="input_static_routes"></a> [static\_routes](#input\_static\_routes) | n/a | `any` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags object | `any` | `{}` | no |
| <a name="input_template_stacks"></a> [template\_stacks](#input\_template\_stacks) | n/a | `any` | n/a | yes |
| <a name="input_templates"></a> [templates](#input\_templates) | n/a | `any` | n/a | yes |
| <a name="input_virtual_routers"></a> [virtual\_routers](#input\_virtual\_routers) | n/a | `any` | n/a | yes |
| <a name="input_vsys"></a> [vsys](#input\_vsys) | Used if _mode_ is ngfw, this defines the vsys for the deployment | `string` | `"vsys1"` | no |
| <a name="input_zones"></a> [zones](#input\_zones) | n/a | `any` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->