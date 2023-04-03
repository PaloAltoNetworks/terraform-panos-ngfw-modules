Palo Alto Networks PAN-OS based platforms Policy Module for Policy as Code
---
This Terraform module allows users to configure policies (NAT and Security Policies) along with tags, address objects,
address groups, and services with Palo Alto Networks **PAN-OS** based PA-Series devices.

Usage
---

1. Create a JSON/YAML/CSV file to config one or more of the following: tags, address objects, address groups, services and service groups. Please note that the file(s) must adhere to its respective schema.

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

Below is an example of a CSV file to create Tags.
```csv
device_group,name,color,comment
AWS,untrust,color4,for untrusted zones
AWS,AWS,color8,
```

2. Create a **"main.tf"** with the panos provider and policy module blocks.

```terraform
module "policy-as-code_policy" {
  source  = "PaloAltoNetworks/terraform-panos-ngfw-modules//modules/policy"
  version = "0.1.0"

  #for JSON examples: try(jsondecode(file("<*.json>")), {})
  #for YAML examples: try(yamldecode(file("<*.yaml>")), {})
  #for CSV you need to parse file to proper schema first, for detailed view see examples. 
  
  tags       = try(...decode(file("<tags JSON/YAML>")), {}) # eg. "tags.json"
  services   = try(...decode(file("<services JSON/YAML>")), {})
  addr_group = try(...decode(file("<address groups JSON/YAML>")), {})
  addr_obj   = try(...decode(file("<address objects JSON/YAML>")), {})
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

Compatibility
---
This module is meant for use with **PAN-OS >= 10.2** and **Terraform >= 0.13**

Permissions
---

* In order for the module to work as expected, the hostname, username, and password to the **panos** Terraform provider.

Caveats
---

* Tags, address objects, address groups, and services can be associated to one or more polices on a PAN-OS device. Once
  any tags, address objects, address groups, or/and services are associated to a policy, it can only be deleted if there
  are no policies associated with any of those resources. If the users tries to delete any of those resources that are
  associated with any policy, they will encounter an error. This is a behavior on a PAN-OS device. This module creates,
  updates and deletes polices with Terraform. If a security profile, tag, address object, address group, and/or service
  associated to a security policy is deleted from the panorama, the module will throw an error when trying to create the
  profile. This is the correct and expected behavior as the resource is being used in a policy.


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
| [panos_administrative_tag.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/administrative_tag) | resource |
| [panos_panorama_administrative_tag.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/panorama_administrative_tag) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_panorama"></a> [panorama](#input\_panorama) | If modules have target to Panorama, it enable Panorama specific variables. | `bool` | `false` | no |
| <a name="input_tag_color_map"></a> [tag\_color\_map](#input\_tag\_color\_map) | Map of tag-color match, [provider documentation](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/administrative_tag) | `any` | <pre>{<br>  "azure_blue": "color24",<br>  "black": "color14",<br>  "blue": "color3",<br>  "blue_gray": "color12",<br>  "blue_violet": "color30",<br>  "brown": "color16",<br>  "burnt_sienna": "color41",<br>  "cerulean_blue": "color25",<br>  "chestnut": "color42",<br>  "cobalt_blue": "color28",<br>  "copper": "color5",<br>  "cyan": "color10",<br>  "forest_green": "color22",<br>  "gold": "color15",<br>  "gray": "color8",<br>  "green": "color2",<br>  "lavender": "color33",<br>  "light_gray": "color11",<br>  "light_green": "color9",<br>  "lime": "color13",<br>  "magenta": "color38",<br>  "mahogany": "color40",<br>  "maroon": "color19",<br>  "medium_blue": "color27",<br>  "medium_rose": "color32",<br>  "medium_violet": "color31",<br>  "midnight_blue": "color26",<br>  "olive": "color17",<br>  "orange": "color6",<br>  "orchid": "color34",<br>  "peach": "color36",<br>  "purple": "color7",<br>  "red": "color1",<br>  "red_orange": "color20",<br>  "red_violet": "color39",<br>  "salmon": "color37",<br>  "thistle": "color35",<br>  "turquoise_blue": "color23",<br>  "violet_blue": "color29",<br>  "yellow": "color4",<br>  "yellow_orange": "color21"<br>}</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | List of tag objects.<br>  - `name`: (required) The administrative tag's name.<br>  - `device_group`: (optional) The device group location (default: `shared`).<br>  - `comment`: (optional) The description of the administrative tag.<br>  - `color`: (optional) The tag's color. This should either be an empty string (no color) or a string such as `color1`. Note that the colors go from 1 to 16.<br><br>  Example:<pre>[<br>  {<br>    name = "trust"<br>  }<br>  {<br>    name = "untrust"<br>    comment = "for untrusted zones"<br>    color = "color4"<br>  }<br>  {<br>    name = "AWS"<br>    device_group = "AWS"<br>    color = "color8"<br>  }<br>]</pre> | `any` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_panos_panorama_administrative_tag"></a> [panos\_panorama\_administrative\_tag](#output\_panos\_panorama\_administrative\_tag) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->