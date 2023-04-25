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
| [panos_device_group.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/device_group) | resource |
| [panos_device_group_entry.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/device_group_entry) | resource |
| [panos_device_group_parent.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/device_group_parent) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_device_group"></a> [device\_group](#input\_device\_group) | Map of device group where the key is name of the device group.<br>  - `device_group` - (Required) The device group's name.<br>  - `serial` - (Required) The serial number of the firewall.<br>  - `is_parent_of` - (Optional) The parent device group name. Leaving this empty / unspecified means to move this device group under the "shared" device group.<br>  - `vsys_list` - (Optional) A subset of all available vsys on the firewall that should be in this device group. If the firewall is a virtual firewall, then this parameter should just be omitted.<pre>{<br>  "aws-test-dg" = {<br>    description = "Device group used for AWS cloud"<br>    device_group_entries = {<br>    serial = "1111222233334444"<br>    is_parent_of = "clouds"<br>  }<br>}</pre> | <pre>map(object({<br>    description  = string<br>    is_parent_of = optional(string)<br>    serial       = optional(list(string), [])<br>    vsys_list    = optional(list(string), [])<br>  }))</pre> | `{}` | no |
| <a name="input_mode"></a> [mode](#input\_mode) | The mode to use for the modules. Valid values are `panorama` and `ngfw`. | `string` | n/a | yes |
| <a name="input_mode_map"></a> [mode\_map](#input\_mode\_map) | The mode to use for the modules. Valid values are `panorama` and `ngfw`. | <pre>object({<br>    panorama = number<br>    ngfw     = number<br>  })</pre> | <pre>{<br>  "ngfw": 1,<br>  "panorama": 0<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_panos_device_group"></a> [panos\_device\_group](#output\_panos\_device\_group) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
