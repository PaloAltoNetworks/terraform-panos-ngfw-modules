Palo Alto Networks PAN-OS based platforms Modules CSV Example
---
This folder shows an example of Terraform code and CSV files that deploy configurations on the PAN-OS based platforms.

Usage
---

1. Create credential file. Example path ``./creds/credentials.json`` and file structure should look like:
```json
{
  "hostname": "12.345.678.901",
  "logging": [
    "action",
    "query",
    "op",
    "uid",
    "xpath",
    "send",
    "receive"
  ],
  "verify_certificate": false,
  "api_key": "kljhaui4ytq0faiuv9eq8hg=="
}
```


2. Run Terraform

```
terraform init
terraform apply
terraform output -json
```

Cleanup
---

```
terraform destroy
```

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
| <a name="module_policy_as_code_network"></a> [policy\_as\_code\_network](#module\_policy\_as\_code\_network) | ../../../modules/old_model/network | n/a |
| <a name="module_policy_as_code_objects_addresses"></a> [policy\_as\_code\_objects\_addresses](#module\_policy\_as\_code\_objects\_addresses) | ../../../modules/old_model/objects_addresses | n/a |
| <a name="module_policy_as_code_objects_services"></a> [policy\_as\_code\_objects\_services](#module\_policy\_as\_code\_objects\_services) | ../../../modules/old_model/objects_services | n/a |
| <a name="module_policy_as_code_objects_tags"></a> [policy\_as\_code\_objects\_tags](#module\_policy\_as\_code\_objects\_tags) | ../../../modules/old_model/objects_tags | n/a |
| <a name="module_policy_as_code_sec_nat"></a> [policy\_as\_code\_sec\_nat](#module\_policy\_as\_code\_sec\_nat) | ../../../modules/old_model/nat_policies | n/a |
| <a name="module_policy_as_code_sec_policy"></a> [policy\_as\_code\_sec\_policy](#module\_policy\_as\_code\_sec\_policy) | ../../../modules/old_model/security_policies | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_addr_groups_file"></a> [addr\_groups\_file](#input\_addr\_groups\_file) | Path to file with Address Groups config. | `string` | `"csv/addr_groups.csv"` | no |
| <a name="input_addresses_file"></a> [addresses\_file](#input\_addresses\_file) | Path to file with Addresses objects config. | `string` | `"csv/addresses.csv"` | no |
| <a name="input_nat_file"></a> [nat\_file](#input\_nat\_file) | Path to file with config for NAT Policies. | `string` | `"csv/nat.csv"` | no |
| <a name="input_network_ike_crypto_profiles_file"></a> [network\_ike\_crypto\_profiles\_file](#input\_network\_ike\_crypto\_profiles\_file) | Path to file with Network IKE crypto profiles config. | `string` | `"csv/ike_crypto_profiles.csv"` | no |
| <a name="input_network_ike_gateways_file"></a> [network\_ike\_gateways\_file](#input\_network\_ike\_gateways\_file) | Path to file with Network IKE gateways config. | `string` | `"csv/ike_gateways.csv"` | no |
| <a name="input_network_interfaces_file"></a> [network\_interfaces\_file](#input\_network\_interfaces\_file) | Path to file with Network Interfaces config. | `string` | `"csv/interfaces.csv"` | no |
| <a name="input_network_ipsec_crypto_profiles_file"></a> [network\_ipsec\_crypto\_profiles\_file](#input\_network\_ipsec\_crypto\_profiles\_file) | Path to file with Network IPSec crypto profiles config. | `string` | `"csv/ipsec_crypto_profiles.csv"` | no |
| <a name="input_network_ipsec_tunnels_file"></a> [network\_ipsec\_tunnels\_file](#input\_network\_ipsec\_tunnels\_file) | Path to file with Network IPSec tunnels config. | `string` | `"csv/ipsec_tunnels.csv"` | no |
| <a name="input_network_management_profiles_file"></a> [network\_management\_profiles\_file](#input\_network\_management\_profiles\_file) | Path to file with Network Managenet Profile config. | `string` | `"csv/management_profiles.csv"` | no |
| <a name="input_network_static_routes_file"></a> [network\_static\_routes\_file](#input\_network\_static\_routes\_file) | Path to file with Network virtual router static routes ipv4 config. | `string` | `"csv/virtual_routers_routes.csv"` | no |
| <a name="input_network_virtual_routers_file"></a> [network\_virtual\_routers\_file](#input\_network\_virtual\_routers\_file) | Path to file with Network Virtual Routers config. | `string` | `"csv/virtual_routers.csv"` | no |
| <a name="input_network_zones_file"></a> [network\_zones\_file](#input\_network\_zones\_file) | Path to file with Network Zones config. | `string` | `"csv/zones.csv"` | no |
| <a name="input_pan_creds"></a> [pan\_creds](#input\_pan\_creds) | Path to file with credentials to Panorama | `string` | n/a | yes |
| <a name="input_panorama"></a> [panorama](#input\_panorama) | If modules have target to Panorama, it enable Panorama specific variables. | `bool` | `false` | no |
| <a name="input_policy_file"></a> [policy\_file](#input\_policy\_file) | Path to file with config for Security Policies. | `string` | `"csv/policy.csv"` | no |
| <a name="input_service_groups_file"></a> [service\_groups\_file](#input\_service\_groups\_file) | Path to file with Service Groups config. | `string` | `"csv/service_groups.csv"` | no |
| <a name="input_services_file"></a> [services\_file](#input\_services\_file) | Path to file with Services objects config. | `string` | `"csv/services.csv"` | no |
| <a name="input_tags_file"></a> [tags\_file](#input\_tags\_file) | Path to file with Tags objects config. | `string` | `"csv/tags.csv"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_panos_ethernet_interface"></a> [panos\_ethernet\_interface](#output\_panos\_ethernet\_interface) | n/a |
| <a name="output_panos_ike_crypto_profile"></a> [panos\_ike\_crypto\_profile](#output\_panos\_ike\_crypto\_profile) | n/a |
| <a name="output_panos_ike_gateway"></a> [panos\_ike\_gateway](#output\_panos\_ike\_gateway) | n/a |
| <a name="output_panos_ipsec_crypto_profile"></a> [panos\_ipsec\_crypto\_profile](#output\_panos\_ipsec\_crypto\_profile) | n/a |
| <a name="output_panos_ipsec_tunnel"></a> [panos\_ipsec\_tunnel](#output\_panos\_ipsec\_tunnel) | n/a |
| <a name="output_panos_ipsec_tunnel_proxy_id_ipv4"></a> [panos\_ipsec\_tunnel\_proxy\_id\_ipv4](#output\_panos\_ipsec\_tunnel\_proxy\_id\_ipv4) | n/a |
| <a name="output_panos_loopback_interface"></a> [panos\_loopback\_interface](#output\_panos\_loopback\_interface) | n/a |
| <a name="output_panos_management_profile"></a> [panos\_management\_profile](#output\_panos\_management\_profile) | n/a |
| <a name="output_panos_panorama_ethernet_interface"></a> [panos\_panorama\_ethernet\_interface](#output\_panos\_panorama\_ethernet\_interface) | n/a |
| <a name="output_panos_panorama_ike_gateway"></a> [panos\_panorama\_ike\_gateway](#output\_panos\_panorama\_ike\_gateway) | n/a |
| <a name="output_panos_panorama_ipsec_crypto_profile"></a> [panos\_panorama\_ipsec\_crypto\_profile](#output\_panos\_panorama\_ipsec\_crypto\_profile) | n/a |
| <a name="output_panos_panorama_ipsec_tunnel"></a> [panos\_panorama\_ipsec\_tunnel](#output\_panos\_panorama\_ipsec\_tunnel) | n/a |
| <a name="output_panos_panorama_ipsec_tunnel_proxy_id_ipv4"></a> [panos\_panorama\_ipsec\_tunnel\_proxy\_id\_ipv4](#output\_panos\_panorama\_ipsec\_tunnel\_proxy\_id\_ipv4) | n/a |
| <a name="output_panos_panorama_loopback_interface"></a> [panos\_panorama\_loopback\_interface](#output\_panos\_panorama\_loopback\_interface) | n/a |
| <a name="output_panos_panorama_management_profile"></a> [panos\_panorama\_management\_profile](#output\_panos\_panorama\_management\_profile) | n/a |
| <a name="output_panos_panorama_static_route_ipv4"></a> [panos\_panorama\_static\_route\_ipv4](#output\_panos\_panorama\_static\_route\_ipv4) | n/a |
| <a name="output_panos_panorama_tunnel_interface"></a> [panos\_panorama\_tunnel\_interface](#output\_panos\_panorama\_tunnel\_interface) | n/a |
| <a name="output_panos_static_route_ipv4"></a> [panos\_static\_route\_ipv4](#output\_panos\_static\_route\_ipv4) | n/a |
| <a name="output_panos_tunnel_interface"></a> [panos\_tunnel\_interface](#output\_panos\_tunnel\_interface) | n/a |
| <a name="output_panos_virtual_router"></a> [panos\_virtual\_router](#output\_panos\_virtual\_router) | n/a |
| <a name="output_panos_virtual_router_entry"></a> [panos\_virtual\_router\_entry](#output\_panos\_virtual\_router\_entry) | n/a |
| <a name="output_panos_zone_entry"></a> [panos\_zone\_entry](#output\_panos\_zone\_entry) | n/a |
| <a name="output_panos_zones"></a> [panos\_zones](#output\_panos\_zones) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->