Palo Alto Networks PAN-OS Address Module
---
This Terraform module allows users to configure address objects and address groups.

For address objects, there are two options to use this module:
- individual mode - create one `panos_address_obect` resource per object
- bulk mode - create one `panos_address_obects` resource with multiple objects within

Behaviour is controlled using `var.addresses_bulk_mode` - when set to `false` (default), individual mode is used, otherwise - bulk mode.
Please see additional considerations when using the bulk mode - like recommended provider settings, terraform performance or lack of "import" capability in `panos_address_obects` resource [documentation](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/address_objects).

Usage
---

1. Create a **"main.tf"** file with the following content:

```terraform
module "addresses" {
  source  = "PaloAltoNetworks/terraform-panos-ngfw-modules//modules/addresses"

  mode = "panorama" # If you want to use this module with a firewall, change this to "ngfw"

  device_group    = "test"
  address_objects = {
    DNS1 = {
      "value"       = "1.1.1.1/32"
      "type"        = "ip-netmask"
      "description" = "DNS-SRV-Public-1"
    },
    DNS2 = {
      "value"       = "1.0.0.1/32"
      "type"        = "ip-netmask"
      "description" = "DNS-SRV-Public-2"
    },
    DNS3 = {
      "value"       = "8.8.4.4/32"
      "type"        = "ip-netmask"
      "description" = "DNS-GOOGLE-1"
    }
  }
}
```

2. Run Terraform

```
terraform init
terraform apply
terraform output
```

Cleanup
---

```
terraform destroy
```

Compatibility
---
This module is meant for use with **PAN-OS >= 10.2** and **Terraform >= 1.4.0**


Reference
---
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.4.0, < 2.0.0 |
| <a name="requirement_panos"></a> [panos](#requirement\_panos) | ~> 1.11.1 |

### Providers

| Name | Version |
|------|---------|
| <a name="provider_panos"></a> [panos](#provider\_panos) | ~> 1.11.1 |

### Modules

No modules.

### Resources

| Name | Type |
|------|------|
| [panos_address_group.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/address_group) | resource |
| [panos_address_object.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/address_object) | resource |
| [panos_address_objects.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/address_objects) | resource |
| [panos_panorama_address_group.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/panorama_address_group) | resource |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_mode"></a> [mode](#input\_mode) | The mode to use for the modules. Valid values are `panorama` and `ngfw`. | `string` | n/a | yes |
| <a name="input_mode_map"></a> [mode\_map](#input\_mode\_map) | The mode to use for the modules. Valid values are `panorama` and `ngfw`. | <pre>object({<br>    panorama = number<br>    ngfw     = number<br>  })</pre> | <pre>{<br>  "ngfw": 1,<br>  "panorama": 0<br>}</pre> | no |
| <a name="input_device_group"></a> [device\_group](#input\_device\_group) | Used if `var.mode` is `panorama`, defines the device group for the objects. | `string` | `"shared"` | no |
| <a name="input_vsys"></a> [vsys](#input\_vsys) | Used if `var.mode` is `ngfw`, defines the vsys for the objects. | `string` | `"vsys1"` | no |
| <a name="input_addresses_bulk_mode"></a> [addresses\_bulk\_mode](#input\_addresses\_bulk\_mode) | Determines whether each address object is managed as a separate `panos_address_object` resource (when set to `false`) or all within a single `panos_address_objects` resource that is dedicated for bulk operations. | `bool` | `false` | no |
| <a name="input_address_objects"></a> [address\_objects](#input\_address\_objects) | Map of the address objects, where key is the address object's name:<br>- `type`: (optional) The type of address object. This can be ip-netmask (default), ip-range, fqdn, or ip-wildcard (PAN-OS 9.0+).<br>- `value`: (required) The address object's value. This can take various forms depending on what type of address object this is, but can be something like 192.168.80.150 or 192.168.80.0/24.<br>- `description`: (optional) The description of the address object.<br>- `tags`: (optional) List of administrative tags.<br><br>Example:<pre>{<br>  DNS-TAGS-1 = {<br>    value       = "1.1.1.1/32"<br>    type        = "ip-netmask"<br>    description = "DNS Server 1"<br>    tags        = ["DNS-SRV"]<br>  },<br>  PA-UPDATES = {<br>    type        = "fqdn"<br>    value       = "updates.paloaltonetworks.com"<br>    description = "Palo Alto updates"<br>  },<br>  NTP-RANGE-1 = {<br>    name  = "ntp1"<br>    type  = "ip-range"<br>    value = "10.0.0.2-10.0.0.10"<br>  }<br>}</pre> | <pre>map(object({<br>    value       = string<br>    type        = optional(string, "ip-netmask")<br>    description = optional(string)<br>    tags        = optional(list(string))<br>  }))</pre> | `{}` | no |
| <a name="input_address_groups"></a> [address\_groups](#input\_address\_groups) | Map of the address group objects, where key is the address group's name:<br>- `members`: (optional) The address objects to include in this statically defined address group.<br>- `dynamic_match`: (optional) The IP tags to include in this DAG. Inputs are structured as follows `'<tag name>' and ...` or `<tag name>` or ...`.<br>- `description`: (optional) The description of the address group.<br>- `tags`: (optional) List of administrative tags.<br><br>Example:<br>`<pre>{<br>  AddressDeviceGroup = {<br>    members     = ["DNS1", "DNS2"]<br>    description = "DNS servers"<br>  }<br>  grp-dns-proxy = {<br>    dynamic_match = "dns-proxy'"<br>  }<br>}</pre> | <pre>map(object({<br>    members       = optional(list(string))<br>    dynamic_match = optional(string)<br>    description   = optional(string)<br>    tags          = optional(list(string))<br>  }))</pre> | `{}` | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_addresses"></a> [addresses](#output\_addresses) | n/a |
| <a name="output_address_groups"></a> [address\_groups](#output\_address\_groups) | n/a |
| <a name="output_panorama_address_groups"></a> [panorama\_address\_groups](#output\_panorama\_address\_groups) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->