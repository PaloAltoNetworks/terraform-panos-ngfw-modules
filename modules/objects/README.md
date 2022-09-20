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
  source  = "sarah-blazic/policy-as-code/panos//modules/policy"
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


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_panos"></a> [panos](#requirement\_panos) | 1.10.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_panos"></a> [panos](#provider\_panos) | 1.10.3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [panos_address_object.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/1.10.3/docs/resources/address_object) | resource |
| [panos_panorama_address_group.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/1.10.3/docs/resources/panorama_address_group) | resource |
| [panos_panorama_administrative_tag.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/1.10.3/docs/resources/panorama_administrative_tag) | resource |
| [panos_panorama_service_group.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/1.10.3/docs/resources/panorama_service_group) | resource |
| [panos_panorama_service_object.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/1.10.3/docs/resources/panorama_service_object) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_addr_group"></a> [addr\_group](#input\_addr\_group) | List of the address group objects.<br>- `name`: (required) The address group's name.<br>- `device_group`: (optional) The device group location (default: `shared`).<br>- `description`: (optional) The description of the address group.<br>- `static_addresses`: (optional) The address objects to include in this statically defined address group.<br>- `dynamic_match`: (optional) The IP tags to include in this DAG. Inputs are structured as follows `'<tag name>' and ...` or `<tag name>` or ...`.<br>- `tags`: (optional) List of administrative tags.<br><br>Example:<br>`<pre>[<br>  {<br>    name = "static ntp grp"<br>    description": "ntp servers"<br>    static_addresses = ["ntp1", "ntp2"]<br>  }<br>  {<br>    name = "trust and internal grp",<br>    description = "dynamic servers",<br>    dynamic_match = "'trust'and'internal'",<br>    tags = ["trust"]<br>  }<br>]</pre> | `list(any)` | `[]` | no |
| <a name="input_addr_obj"></a> [addr\_obj](#input\_addr\_obj) | List of the address objects.<br>- `name`: (required) The address object's name.<br>- `device_group`: (optional) The device group location (default: `shared`).<br>- `description`: (optional) The description of the address object.<br>- `type`: (optional) The type of address object. Valid values are `ip-netmask`, `ip-range`, `fqdn`, or `ip-wildcard` (only available with PAN-OS 9.0+) (default: `ip-netmask).<br>- `value`: (required) The address object's value. This can take various forms depending on what type of address object this is, but can be something like `192.168.80.150` or `192.168.80.0/24`.<br>- `tags`: (optional) List of administrative tags.<br><br>Example:<br>`<pre>[<br>  {<br>    name = "azure_int_lb_priv_ip"<br>    type = "ip-netmask"<br>    value = {<br>      "ip-netmask = "10.100.4.40/32"<br>    }<br>    tags = ["trust"]<br>    device_group = "AZURE"<br>  }<br>  {<br>    name = "pa_updates"<br>    type = "fqdn"<br>    value = {<br>      fqdn = "updates.paloaltonetworks.com"<br>    }<br>    description = "palo alto updates"<br>  }<br>  {<br>    name = "ntp1"<br>    type = "ip-range"<br>    value = {<br>      ip-range = "10.0.0.2-10.0.0.10"<br>    }<br>  }<br>]</pre> | `list(any)` | `[]` | no |
| <a name="input_service_groups"></a> [service\_groups](#input\_service\_groups) | List of the address group objects.<br>- `name`: (required) The address group's name.<br>- `device_group`: (optional) The device group location (default: `shared`).<br>- `services`: (optional) The service objects to include in this service group.<br>- `tags`: (optional) List of administrative tags. | `list(any)` | `[]` | no |
| <a name="input_services"></a> [services](#input\_services) | List of service objects.<br>- `name`: (required) The service object's name.<br>- `device_group`: (optional) The device group location (default: `shared`).<br>- `description`: (optional) The description of the service object.<br>- `protocol`: (required) The service's protocol. Valid values are `tcp`, `udp`, or `sctp` (only for PAN-OS 8.1+).<br>- `source_port`: (optional) The source port. This can be a single port number, range (1-65535), or comma separated (80,8080,443).<br>- `destination_port`: (required) The destination port. This can be a single port number, range (1-65535), or comma separated (80,8080,443).<br>- `tags`: (optional) List of administrative tags.<br>- `override_session_timeout`: (optional) Boolean to override the default application timeouts (default: `false`). Only available for PAN-OS 8.1+.<br>- `override_timeout`: (optional) Integer for the overridden timeout if TCP protocol selected. Only available for PAN-OS 8.1+.<br>- `override_half_closed_timeout`: (optional) Integer for the overridden half closed timeout if TCP protocol selected. Only available for PAN-OS 8.1+.<br>- `override_time_wait_timeout`: (optional) Integer for the overridden wait time if TCP protocol selected. Only available for PAN-OS 8.1+.<br><br>Example:<pre>[<br>  {<br>    name = "service1"<br>    protocol = "tcp"<br>    destination_port = "8080"<br>    source_port = "400"<br>    override_session_timeout = true<br>    override_timeout = 250<br>    override_time_wait_timeout = 590<br>  }<br>  {<br>    name = "service2"<br>    protocol = "udp"<br>    destination_port = "80"<br>  }<br>]</pre> | `list(any)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | List of tag objects.<br>  - `name`: (required) The administrative tag's name.<br>  - `device_group`: (optional) The device group location (default: `shared`).<br>  - `comment`: (optional) The description of the administrative tag.<br>  - `color`: (optional) The tag's color. This should either be an empty string (no color) or a string such as `color1`. Note that the colors go from 1 to 16.<br><br>  Example:<pre>[<br>  {<br>    name = "trust"<br>  }<br>  {<br>    name = "untrust"<br>    comment = "for untrusted zones"<br>    color = "color4"<br>  }<br>  {<br>    name = "AWS"<br>    device_group = "AWS"<br>    color = "color8"<br>  }<br>]</pre> | `list(any)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_created_addr_group"></a> [created\_addr\_group](#output\_created\_addr\_group) | Shows the address groups that were created. |
| <a name="output_created_addr_obj"></a> [created\_addr\_obj](#output\_created\_addr\_obj) | Shows the address objects that were created. |
| <a name="output_created_services"></a> [created\_services](#output\_created\_services) | Shows the services that were created. |
| <a name="output_created_tags"></a> [created\_tags](#output\_created\_tags) | Shows the tags that were created. |
<!-- END_TF_DOCS -->