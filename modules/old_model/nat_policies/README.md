Palo Alto Networks PAN-OS based platforms Policy Module for Policy as Code
---
This Terraform module allows users to configure policies (NAT and Security Policies) along with tags, address objects,
address groups, and services with Palo Alto Networks **PAN-OS** based PA-Series devices.

Usage
---

1. Create a JSON/YAML file to config one or more of the following: tags, address objects, address groups, services, nat
   rules, and security policy. Please note that the file(s) must adhere to its respective schema.

Below is an example of a JSON file to create Tags.

```json
[
  {
    "name": "trust"
  },
  {
    "name": "untrust",
    "comment": "for untrusted zones",
    "color": "color4"
  },
  {
    "name": "AWS",
    "device_group": "AWS",
    "color": "color8"
  }
]
```

Below is an example of a YAML file to create Tags.

```yaml
---
- name: trust
- name: untrust
  comment: for untrusted zones
  color: color4
- name: AWS
  device_group: AWS
  color: color8
```

2. Create a **"main.tf"** with the panos provider and policy module blocks.

```terraform
provider "panos" {
  hostname = "<panos_address>"
  username = "<admin_username>"
  password = "<admin_password>"
}

module "policy-as-code_policy" {
  source  = "PaloAltoNetworks/terraform-panos-ngfw-modules//modules/policy"
  version = "0.1.0"

  #for JSON examples: try(jsondecode(file("<*.json>")), {})
  #for YAML examples: try(yamldecode(file("<*.yaml>")), {})
  tags       = try(...decode(file("<tags JSON/YAML>")), {}) # eg. "tags.json"
  services   = try(...decode(file("<services JSON/YAML>")), {})
  addr_group = try(...decode(file("<address groups JSON/YAML>")), {})
  addr_obj   = try(...decode(file("<address objects JSON/YAML>")), {})
  sec        = try(...decode(file("<security policies JSON/YAML>")), {})
  nat        = try(...decode(file("<NAT policies JSON/YAML>")), {})
}
```

4. Run Terraform

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

| Name | Version |
|------|---------|
| <a name="provider_panos"></a> [panos](#provider\_panos) | ~> 1.11.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [panos_nat_rule_group.fw_mode](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/nat_rule_group) | resource |
| [panos_panorama_nat_rule_group.panorama](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/panorama_nat_rule_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_nat_policy"></a> [nat\_policy](#input\_nat\_policy) | List of the NAT policy rule objects.<br>- `device_group`: (optional) The device group location (default: `shared`).<br>- `rulebase`: (optional) The rulebase for the NAT Policy. Valid values are `pre-rulebase` and `post-rulebase` (default: `pre-rulebase`).<br>- `position_keyword`: (optional) A positioning keyword for this group. Valid values are `before`, `directly before`, `after`, `directly after`, `top`, `bottom`, or left empty to have no particular placement (default: empty). This parameter works in combination with the `position_reference` parameter.<br>- `position_reference`: (optional) Required if `position_keyword` is one of the "above" or "below" variants, this is the name of a non-group rule to use as a reference to place this group.<br>- `rules`: (optional) The NAT rule definition. The NAT rule ordering will match how they appear in the terraform plan file.<br>  - `name`: (required) The NAT rule's name.<br>  - `description`: (optional) The description of the NAT rule.<br>  - `type`: (optional) NAT type. Valid values are `ipv4`, `nat64`, or `nptv6` (default: `ipv4`).<br>  - `tags`: (optional) List of administrative tags.<br>  - `disabled`: (optional) Boolean designating if the security policy rule is disabled (default: `false`).<br>  - `original_packet`: (required) The original packet specification.<br>    - `source_zones`: (optional) List of source zones (default: `any`).<br>    - `destination_zone`: (optional) The destination zone (default: `any`).<br>    - `destination_interface`: (optional) Egress interface from the lookup (default: `any`).<br>    - `service`: (optional) Service for the original packet (default: `any`).<br>    - `source_addresses`: (optional) List of source addresses (default: `any`).<br>    - `destination_addresses`: (optional) List of destination addresses (default: `any`).<br>  - `translated_packet`: (required) The translated packet specifications.<br>    - `source`: (optional) The source specification. Valid values are `none`, `dynamic_ip_port`, `dynamic_ip`, or `static_ip` (default: `none`).<br>      - `dynamic_ip_and_port`: (optional) Dynamic IP and port source translation specification.<br>        - `translated_addresses`: (optional) Not functional if `interface_address` is configured. List of translated addresses.<br>        - `interface_address`: (optional) Not functional if `translated_addresses` is configured. Interface address source translation type specifications.<br>          - `interface`: (required) The interface.<br>          - `ip_address`: (optional) The IP address.<br>      - `dynamic_ip`: (optional) Dynamic IP source translation specification.<br>        - `translated_addresses`: (optional) The list of translated addresses.<br>        - `fallback`: (optional) The fallback specifications (default: `none`).<br>          - `translated_addresses`: (optional) Not functional if `interface_address` is configured. List of translated addresses.<br>          - `interface_address`: (optional) Not functional if `translated address` is configured. The interface address fallback specifications.<br>            - `interface`: (required) Source address translated fallback interface.<br>            - `type`: (optional) Type of interface fallback. Valid values are `ip` or `floating` (default: `ip`).<br>            - `ip_address`: (optional) IP address of the fallback interface.<br>      - `static_ip`: (optional) Static IP source translation specifications.<br>        - `translated_address`: (required) The statically translated source address.<br>        - `bi_directional`: (optional) Boolean enabling bi-directional source address translation (default: `false`).<br>    - `destination`: (optional) The destination specification. Valid values are `none`, `static_translation`, or `dynamic_translation` (default: `none`).<br>      - `static_translation`: (optional) Specifies a static destination NAT.<br>        - `address`: (required) Destination address translation address.<br>        - `port`: (optional) Integer destination address translation port number.<br>      - `dynamic_translation`: (optional) Specify a dynamic destination NAT. Only available for PAN-OS 8.1+.<br>        - `address`: (required) Destination address translation address.<br>        - `port`: (optional) Integer destination address translation port number.<br>        - `distribution`: (optional) Distribution algorithm for destination address pool. Valid values are `round-robin`, `source-ip-hash`, `ip-modulo`, `ip-hash`, or `least-sessions` (default: `round-robin`). Only available for PAN-OS 8.1+.<br><br>Example:<pre>[<br>  {<br>    device_group = "AWS"<br>    rules = [<br>      {<br>        name = "rule1"<br>        original_packet = {<br>          source_zones = ["trust"]<br>          destination_zone = "untrust"<br>          destination_interface = "any"<br>          source_addresses = ["google_dns1"]<br>          destination_addresses = ["any"]<br>        }<br>        translated_packet = {<br>          source = "dynamic_ip"<br>          translated_addresses = ["google_dns1", "google_dns2"]<br>          destination = "static_translation"<br>          static_translation = {<br>            address = "10.2.3.1"<br>            port = 5678<br>          }<br>        }<br>      }<br>      {<br>        name = "rule2"<br>        original_packet = {<br>          source_zones = ["untrust"]<br>          destination_zone = "trust"<br>          destination_interface = "any"<br>          source_addresses = ["any"]<br>          destination_addresses = ["any"]<br>        }<br>        translated_packet = {<br>          source = "static_ip"<br>          static_ip = {<br>            translated_address = "192.168.1.5"<br>            bi_directional = true<br>          }<br>          destination = "none"<br>        }<br>        {<br>          name = "rule3"<br>          original_packet = {<br>            source_zones = ["dmz"]<br>            destination_zone = "dmz"<br>            destination_interface = "any"<br>            source_addresses = ["any"]<br>            destination_addresses = ["any"]<br>          }<br>          translated_packet = {<br>            source = "dynamic_ip_and_port"<br>            interface_address = {<br>              interface = "ethernet1/5"<br>            }<br>            destination = "none"<br>          }<br>        }<br>      }<br>      {<br>        name = "rule4"<br>        original_packet = {<br>          source_zones = ["dmz"]<br>          destination_zone = "dmz"<br>          destination_interface = "any"<br>          source_addresses = ["any"]<br>          destination_addresses = ["trust and internal grp"]<br>        }<br>        translated_packet = {<br>          source = "dynamic_ip"<br>          translated_addresses = ["localnet"]<br>          fallback = {<br>            translated_addresses = ["ntp1"]<br>          }<br>          destination = "dynamic_translation"<br>          dynamic_translation = {<br>            address = "localnet"<br>            port = 1234<br>          }<br>        }<br>      }<br>    ]<br>  }<br>]</pre> | `any` | `"optional"` | no |
| <a name="input_panorama"></a> [panorama](#input\_panorama) | If modules have target to Panorama, it enable Panorama specific variables. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_panos_panorama_nat_rule_group"></a> [panos\_panorama\_nat\_rule\_group](#output\_panos\_panorama\_nat\_rule\_group) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->