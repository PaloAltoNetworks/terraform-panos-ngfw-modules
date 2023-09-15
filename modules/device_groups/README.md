Palo Alto Networks PAN-OS Device Groups Module
---
This Terraform module allows users to configure device groups.

Usage
---

1. Create a **"main.tf"** file with the following content:

```terraform
module "device_groups" {
  source  = "PaloAltoNetworks/terraform-panos-ngfw-modules//modules/device_groups"

  mode = "panorama"

  device_groups = {
    "aws-test-dg" = {
        description = "Device group used for AWS cloud"
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
| [panos_device_group.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/device_group) | resource |
| [panos_device_group_entry.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/device_group_entry) | resource |
| [panos_device_group_parent.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/device_group_parent) | resource |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_mode"></a> [mode](#input\_mode) | The mode to use for the modules. Valid values are `panorama` and `ngfw`. | `string` | n/a | yes |
| <a name="input_mode_map"></a> [mode\_map](#input\_mode\_map) | The mode to use for the modules. Valid values are `panorama` and `ngfw`. | <pre>object({<br>    panorama = number<br>    ngfw     = number<br>  })</pre> | <pre>{<br>  "ngfw": 1,<br>  "panorama": 0<br>}</pre> | no |
| <a name="input_device_groups"></a> [device\_groups](#input\_device\_groups) | Map of device group where the key is name of the device group.<br>  - `serial` - (Required) The serial number of the firewall.<br>  - `parent` - (Optional) The parent device group name. Leaving this empty / unspecified means to move this device group under the "shared" device group.<br>  - `vsys_list` - (Optional) A subset of all available vsys on the firewall that should be in this device group. If the firewall is a virtual firewall, then this parameter should just be omitted.<pre>{<br>  "aws-test-dg" = {<br>    description = "Device group used for AWS cloud"<br>    device_group_entries = {<br>    serial = "1111222233334444"<br>    parent = "clouds"<br>  }<br>}</pre> | <pre>map(object({<br>    description = string<br>    parent      = optional(string)<br>    serial      = optional(list(string), [])<br>    vsys_list   = optional(list(string), [])<br>  }))</pre> | `{}` | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_device_groups"></a> [device\_groups](#output\_device\_groups) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
