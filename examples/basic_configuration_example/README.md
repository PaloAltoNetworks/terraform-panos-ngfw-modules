# Palo Alto Networks PAN-OS based platforms - Config as Code - HCL Example

This folder shows an example of Terraform code and HCL files that deploy configurations on the PAN-OS based platforms.

## Usage

1. Create credential file. In `terraform.tfvars` the path with credentials is ``./creds/credentials.json`` and file structure should look like:
```json
{
    "hostname": "IP_ADDRESS",
    "username": "ACCOUNT_NAME",
    "password": "PASSWORD"
}
```

or using API keys:

```json
{
    "hostname": "IP_ADDRESS",
    "api_key": "API_KEY"
}
```

where `API_KEY` was generated from as [described in PAN-OS API Guide](https://docs.paloaltonetworks.com/pan-os/10-2/pan-os-panorama-api/get-started-with-the-pan-os-xml-api/get-your-api-key):

```
curl 'https://IP_ADDRESS/api/?type=keygen&user=ACCOUNT_NAME&password=PASSWORD'
```


2. Initialize Terraform and apply changes:

```
terraform init
terraform apply
```

## Cleanup

In order to remove whole configuration provisioned using code, use command:

```
terraform destroy
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.4.0, < 2.0.0 |
| <a name="requirement_panos"></a> [panos](#requirement\_panos) | ~> 1.11.1 |

### Providers

No providers.

### Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_device_groups"></a> [device\_groups](#module\_device\_groups) | ../../modules/device_groups | n/a |
| <a name="module_tags"></a> [tags](#module\_tags) | ../../modules/tags | n/a |
| <a name="module_addresses"></a> [addresses](#module\_addresses) | ../../modules/addresses | n/a |
| <a name="module_address_groups"></a> [address\_groups](#module\_address\_groups) | ../../modules/addresses | n/a |
| <a name="module_services"></a> [services](#module\_services) | ../../modules/services | n/a |
| <a name="module_service_groups"></a> [service\_groups](#module\_service\_groups) | ../../modules/services | n/a |
| <a name="module_interfaces"></a> [interfaces](#module\_interfaces) | ../../modules/interfaces | n/a |
| <a name="module_management_profiles"></a> [management\_profiles](#module\_management\_profiles) | ../../modules/management_profiles | n/a |
| <a name="module_virtual_routers"></a> [virtual\_routers](#module\_virtual\_routers) | ../../modules/virtual_routers | n/a |
| <a name="module_static_routes"></a> [static\_routes](#module\_static\_routes) | ../../modules/static_routes | n/a |
| <a name="module_zones"></a> [zones](#module\_zones) | ../../modules/zones | n/a |
| <a name="module_ipsec"></a> [ipsec](#module\_ipsec) | ../../modules/ipsec | n/a |
| <a name="module_templates"></a> [templates](#module\_templates) | ../../modules/templates | n/a |
| <a name="module_template_stacks"></a> [template\_stacks](#module\_template\_stacks) | ../../modules/template_stacks | n/a |
| <a name="module_security_policies_post_rules"></a> [security\_policies\_post\_rules](#module\_security\_policies\_post\_rules) | ../../modules/security_policy | n/a |
| <a name="module_security_rule_groups"></a> [security\_rule\_groups](#module\_security\_rule\_groups) | ../../modules/security_rule_groups | n/a |
| <a name="module_nat_policies"></a> [nat\_policies](#module\_nat\_policies) | ../../modules/nat_policies | n/a |
| <a name="module_security_profiles"></a> [security\_profiles](#module\_security\_profiles) | ../../modules/security_profiles | n/a |
| <a name="module_log_forwarding_profiles_shared"></a> [log\_forwarding\_profiles\_shared](#module\_log\_forwarding\_profiles\_shared) | ../../modules/log_forwarding_profiles | n/a |

### Resources

No resources.

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_device_groups"></a> [device\_groups](#input\_device\_groups) | Used if `var.mode` is panorama, this defines the Device Group for the deployment | `any` | `{}` | no |
| <a name="input_vsys"></a> [vsys](#input\_vsys) | Used if `var.mode` is ngfw, this defines the vsys for the deployment | `string` | `"vsys1"` | no |
| <a name="input_pan_creds"></a> [pan\_creds](#input\_pan\_creds) | Path to file with credentials to Panorama | `string` | n/a | yes |
| <a name="input_mode"></a> [mode](#input\_mode) | Provide information about target. | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags object | `any` | `{}` | no |
| <a name="input_addresses"></a> [addresses](#input\_addresses) | Address object | `any` | `{}` | no |
| <a name="input_address_groups"></a> [address\_groups](#input\_address\_groups) | Address groups object | `any` | `{}` | no |
| <a name="input_services"></a> [services](#input\_services) | Services object | `any` | `{}` | no |
| <a name="input_service_groups"></a> [service\_groups](#input\_service\_groups) | Service groups object | `any` | `{}` | no |
| <a name="input_security_profiles"></a> [security\_profiles](#input\_security\_profiles) | Map with security profiles. | `any` | `{}` | no |
| <a name="input_log_forwarding_profiles_shared"></a> [log\_forwarding\_profiles\_shared](#input\_log\_forwarding\_profiles\_shared) | Map with log forwarding profiles. | `any` | `{}` | no |
| <a name="input_security_post_rules"></a> [security\_post\_rules](#input\_security\_post\_rules) | List with security post rules. | `any` | `[]` | no |
| <a name="input_security_rule_groups"></a> [security\_rule\_groups](#input\_security\_rule\_groups) | Security rule groups | `any` | `{}` | no |
| <a name="input_nat_policies"></a> [nat\_policies](#input\_nat\_policies) | Security policies | `any` | `{}` | no |
| <a name="input_interfaces"></a> [interfaces](#input\_interfaces) | n/a | `any` | n/a | yes |
| <a name="input_management_profiles"></a> [management\_profiles](#input\_management\_profiles) | n/a | `any` | n/a | yes |
| <a name="input_virtual_routers"></a> [virtual\_routers](#input\_virtual\_routers) | n/a | `any` | n/a | yes |
| <a name="input_static_routes"></a> [static\_routes](#input\_static\_routes) | n/a | `any` | n/a | yes |
| <a name="input_zones"></a> [zones](#input\_zones) | n/a | `any` | n/a | yes |
| <a name="input_ike_gateways"></a> [ike\_gateways](#input\_ike\_gateways) | n/a | `any` | n/a | yes |
| <a name="input_ike_crypto_profiles"></a> [ike\_crypto\_profiles](#input\_ike\_crypto\_profiles) | n/a | `any` | n/a | yes |
| <a name="input_ipsec_crypto_profiles"></a> [ipsec\_crypto\_profiles](#input\_ipsec\_crypto\_profiles) | n/a | `any` | n/a | yes |
| <a name="input_ipsec_tunnels"></a> [ipsec\_tunnels](#input\_ipsec\_tunnels) | n/a | `any` | n/a | yes |
| <a name="input_templates"></a> [templates](#input\_templates) | n/a | `any` | n/a | yes |
| <a name="input_template_stacks"></a> [template\_stacks](#input\_template\_stacks) | n/a | `any` | n/a | yes |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_device_groups"></a> [device\_groups](#output\_device\_groups) | n/a |
| <a name="output_tags"></a> [tags](#output\_tags) | n/a |
| <a name="output_addresses"></a> [addresses](#output\_addresses) | n/a |
| <a name="output_address_groups"></a> [address\_groups](#output\_address\_groups) | n/a |
| <a name="output_services"></a> [services](#output\_services) | n/a |
| <a name="output_service_groups"></a> [service\_groups](#output\_service\_groups) | n/a |
| <a name="output_interfaces"></a> [interfaces](#output\_interfaces) | n/a |
| <a name="output_management_profiles"></a> [management\_profiles](#output\_management\_profiles) | n/a |
| <a name="output_virtual_routers"></a> [virtual\_routers](#output\_virtual\_routers) | n/a |
| <a name="output_static_routes"></a> [static\_routes](#output\_static\_routes) | n/a |
| <a name="output_zones"></a> [zones](#output\_zones) | n/a |
| <a name="output_ipsec"></a> [ipsec](#output\_ipsec) | n/a |
| <a name="output_templates"></a> [templates](#output\_templates) | n/a |
| <a name="output_template_stacks"></a> [template\_stacks](#output\_template\_stacks) | n/a |
| <a name="output_security_rule_groups"></a> [security\_rule\_groups](#output\_security\_rule\_groups) | n/a |
| <a name="output_nat_policies"></a> [nat\_policies](#output\_nat\_policies) | n/a |
| <a name="output_security_profiles"></a> [security\_profiles](#output\_security\_profiles) | n/a |
| <a name="output_log_forwarding_profiles_shared"></a> [log\_forwarding\_profiles\_shared](#output\_log\_forwarding\_profiles\_shared) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->