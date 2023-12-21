Palo Alto Networks PAN-OS Log Forwarding Profile Module
---
This Terraform module allows users to configure log forwarding profiles.

Usage
---

1. Create a **"main.tf"** file with the following content:

```terraform
module "log_forwarding_profiles" {
  source  = "PaloAltoNetworks/terraform-panos-ngfw-modules//modules/log_forwarding_profiles"

  mode = "panorama" # If you want to use this module with a firewall, change this to "ngfw"

  device_group = "test"

  profiles = {
    panorama-shared = {
      match_lists = [
        {
          name             = "threat"
          log_type         = "threat"
          send_to_panorama = true
        },
        {
          name             = "wf"
          log_type         = "wildfire"
          send_to_panorama = true
        },
        {
          name             = "url"
          log_type         = "url"
          send_to_panorama = true
        },
        {
          name             = "auth"
          log_type         = "auth"
          send_to_panorama = true
        },
      ]
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
| [panos_log_forwarding_profile.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/log_forwarding_profile) | resource |
| [panos_panorama_log_forwarding_profile.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/panorama_log_forwarding_profile) | resource |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_mode"></a> [mode](#input\_mode) | The mode to use for the module. Valid values are `panorama` and `ngfw`. | `string` | n/a | yes |
| <a name="input_device_group"></a> [device\_group](#input\_device\_group) | Defines the Device Group for the deployment, used if `var.mode` is `panorama`. | `string` | `"shared"` | no |
| <a name="input_vsys"></a> [vsys](#input\_vsys) | Defines the vsys for the deployment, used if `var.mode` is `ngfw`. | `string` | `"vsys1"` | no |
| <a name="input_profiles"></a> [profiles](#input\_profiles) | Map with log forwarding profile definitions, keys are the object names:<br>- `description`: (optional) The description of the profile.<br>- `enhanced_logging`: (optional) Enable enhanced logging.<br>- `match_lists`: (optional) Match lists definitions:<br>  - `name`: (required) Name.<br>  - `description`: (required) Description.<br>  - `log_type`: (optional) Log type.<br>  - `filter`: (optional) Log filter.<br>  - `send_to_panorama`: (optional) Enable sending to Panorama.<br>  - `snmptrap_server_profiles`: (optional) List of server SNMP profiles.<br>  - `email_server_profiles`: (optional) List of server email profiles.<br>  - `syslog_server_profiles`: (optional) List of server syslog profiles.<br>  - `http_server_profiles`: (optional) List of server HTTP profiles.<br>  - `actions`: (optional) Match list actions specifications:<br>    - `name`: (required) Action name.<br>    - `azure_integration`: (optional) Enable Azure integration (mutually exclusive with `tagging_integration`).<br>    - `tagging_integration`: (optional) Tagging integration specification (mutually exclusive with `azure_integration`):<br>      - `action`: (optional) Action. Valid values are `add-tag` (default) or `remove-tag`.<br>      - `target`: (optional) Target. Valid values are `source-address` (default) or `destination-address`.<br>      - `timeout`: (optional) Amount of time (in minutes) to maintain IP address-to-tag mapping. If unset or 0 the mapping does not timeout.<br>      - `local_registration`: (optional) Local User-ID registration spec (mutually eaxclusive with `panorama_registration` and `remote_registration`):<br>        - `tags`: (required) List of administrative tags.<br>      - `panorama_registration`: (optional) Panorama User-ID registration spec (mutually eaxclusive with `local_registration` and `remote_registration`):<br>        - `tags`: (required) List of administrative tags.<br>      - `remote_registration`: (optional) Remote User-ID registration spec (mutually eaxclusive with `local_registration` and `panorama_registration`):<br>        - `tags`: (required) List of administrative tags.<br>        - `http_profile`: (required) HTTP profile.<br><br>Example:<pre>profiles = {<br>  panorama = {<br>  match_lists = [<br>    {<br>      name = "threat"<br>      log_type = "threat"<br>      send_to_panorama = true<br>    },<br>    {<br>      name = "wf"<br>      log_type = "wildfire"<br>      send_to_panorama = true<br>    },<br>    {<br>      name = "url"<br>      log_type = "url"<br>      send_to_panorama = true<br>    },<br>    {<br>      name = "auth"<br>      log_type = "auth"<br>      send_to_panorama = true<br>    },<br>  ]<br>}<br>}</pre> | <pre>map(object({<br>    description      = optional(string)<br>    enhanced_logging = optional(bool)<br>    match_lists = optional(list(object({<br>      name                     = string<br>      description              = optional(string)<br>      log_type                 = optional(string, "traffic")<br>      filter                   = optional(string, "All logs")<br>      send_to_panorama         = optional(bool)<br>      snmptrap_server_profiles = optional(list(string))<br>      email_server_profiles    = optional(list(string))<br>      syslog_server_profiles   = optional(list(string))<br>      http_server_profiles     = optional(list(string))<br>      actions = optional(list(object({<br>        name              = string<br>        azure_integration = optional(bool)<br>        tagging_integration = optional(object({<br>          action  = optional(string, "add-tag")<br>          target  = optional(string, "source-address")<br>          timeout = optional(number)<br>          local_registration = optional(object({<br>            tags = list(string)<br>          }))<br>          panorama_registration = optional(object({<br>            tags = list(string)<br>          }))<br>          remote_registration = optional(object({<br>            http_profile = string<br>            tags         = list(string)<br>          }))<br>        }))<br>      })), [])<br>    })), [])<br>  }))</pre> | `{}` | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_panos_log_forwarding_profiles"></a> [panos\_log\_forwarding\_profiles](#output\_panos\_log\_forwarding\_profiles) | n/a |
| <a name="output_panos_panorama_log_forwarding_profiles"></a> [panos\_panorama\_log\_forwarding\_profiles](#output\_panos\_panorama\_log\_forwarding\_profiles) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
