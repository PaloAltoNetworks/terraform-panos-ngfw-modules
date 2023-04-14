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

| Name | Source | Version |
|------|--------|---------|
| <a name="module_mode_lookup"></a> [mode\_lookup](#module\_mode\_lookup) | ../mode_lookup | n/a |

## Resources

| Name | Type |
|------|------|
| [panos_address_group.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/address_group) | resource |
| [panos_address_object.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/address_object) | resource |
| [panos_panorama_address_group.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/panorama_address_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_address_groups"></a> [address\_groups](#input\_address\_groups) | Map of the address group objects, where key is the address group's name:<br>- `members`: (optional) The address objects to include in this statically defined address group.<br>- `dynamic_match`: (optional) The IP tags to include in this DAG. Inputs are structured as follows `'<tag name>' and ...` or `<tag name>` or ...`.<br>- `description`: (optional) The description of the address group.<br>- `tags`: (optional) List of administrative tags.<br><br>Example:<br>`<pre>addr_group = {<br>  AddressDeviceGroup = {<br>    members     = ["DNS1", "DNS2"]<br>    description = "DNS servers"<br>  }<br>  grp-dns-proxy = {<br>    dynamic_match = "dns-proxy'"<br>  }<br>}</pre> | <pre>map(object({<br>    members       = optional(list(string))<br>    dynamic_match = optional(string)<br>    description   = optional(string)<br>    tags          = optional(list(string))<br>  }))</pre> | `{}` | no |
| <a name="input_address_objects"></a> [address\_objects](#input\_address\_objects) | Map of the address objects, where key is the address object's name:<br>- `type`: (optional) The type of address object. This can be ip-netmask (default), ip-range, fqdn, or ip-wildcard (PAN-OS 9.0+).<br>- `value`: (required) The address object's value. This can take various forms depending on what type of address object this is, but can be something like 192.168.80.150 or 192.168.80.0/24.<br>- `description`: (optional) The description of the address object.<br>- `tags`: (optional) List of administrative tags.<br><br>Example:<pre>addr_obj = {<br>  DNS-TAGS-1 = {<br>    value       = "1.1.1.1/32"<br>    type        = "ip-netmask"<br>    description = "DNS Server 1"<br>    tags        = ["DNS-SRV"]<br>  },<br>  PA-UPDATES = {<br>    type        = "fqdn"<br>    value       = "updates.paloaltonetworks.com"<br>    description = "Palo Alto updates"<br>  },<br>  NTP-RANGE-1 = {<br>    name  = "ntp1"<br>    type  = "ip-range"<br>    value = "10.0.0.2-10.0.0.10"<br>  }<br>}</pre> | <pre>map(object({<br>    type        = optional(string, "ip-netmask")<br>    value       = string<br>    description = optional(string)<br>    tags        = optional(list(string))<br>  }))</pre> | `{}` | no |
| <a name="input_device_group"></a> [device\_group](#input\_device\_group) | Used if _mode_ is panorama, this defines the Device Group for the deployment | `string` | `"shared"` | no |
| <a name="input_mode"></a> [mode](#input\_mode) | If modules have target to Panorama, it enable Panorama specific variables. | `string` | `false` | no |
| <a name="input_vsys"></a> [vsys](#input\_vsys) | Used if _mode_ is ngfw, this defines the vsys for the deployment | `string` | `"vsys1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_panos_address_object"></a> [panos\_address\_object](#output\_panos\_address\_object) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->