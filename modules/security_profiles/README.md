Palo Alto Networks PAN-OS Security Profiles Module
---
This Terraform module allows users to configure security profiles.

Usage
---

1. Create a **"main.tf"** file with the following content:

```terraform
module "security_profiles" {
  source  = "PaloAltoNetworks/terraform-panos-ngfw-modules//modules/security_profiles"

  mode = "panorama" # If you want to use this module with a firewall, change this to "ngfw"

  device_group = "test"

  antivirus_profiles = {
    test-av-profile = {
      decoders = [
        {
          name = "http"
        }
      ]
      application_exceptions = [
        { application = "atmail" },
        { application = "alisoft" }
      ]
      machine_learning_models = [
        {
          model  = "Windows Executables"
          action = "disable"
        }
      ]
      machine_learning_exceptions = [
        {
          name = "my-exception"
        },
        {
          name        = "sample-virus"
          filename    = "test-virus-file"
          description = "Test virus file"
        }
      ]
    }
  }
  antispyware_profiles = {
    test-antispyware = {
      rules = [
        {
          name              = "test-policy"
          action            = "block-ip"
          block_ip_duration = 60
        }
      ]
    }
  }
  file_blocking_profiles = {
    outbound-test = {
      rules = [
        {
          name         = "Alert-All"
          applications = ["any"]
          file_types   = ["any"]
          direction    = "both"
          action       = "alert"
        },
        {
          name         = "Block"
          applications = ["any"]
          file_types = [
            "7z",
            "bat",
            "chm",
            "class",
            "cpl",
            "dll",
            "hlp",
            "hta",
            "jar",
            "ocx",
            "pif",
            "scr",
            "torrent",
            "vbe",
            "wsf"
          ]
          direction = "both"
          action    = "block"
        }
      ]
    }
  }
  vulnerability_protection_profiles = {
    outbound-test = {
      rules = [
        {
          name           = "Block-Critical-High-Medium"
          action         = "reset-both"
          vendor_ids     = ["any"]
          severities     = ["critical", "high", "medium"]
          cves           = ["any"]
          threat_name    = "any"
          host           = "any"
          category       = "any"
          packet_capture = "single-packet"
        },
        {
          name           = "Default-Low-Info"
          action         = "default"
          vendor_ids     = ["any"]
          severities     = ["low", "informational"]
          cves           = ["any"]
          threat_name    = "any"
          host           = "any"
          category       = "any"
          packet_capture = "disable"
        }
      ]
    }
  }
  wildfire_analysis_profiles = {
    outbound-test = {
      rules = [
        {
          name         = "Forward-All"
          applications = ["any"]
          file_types   = ["any"]
          direction    = "both"
          analysis     = "public-cloud"
        }
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
| [panos_anti_spyware_security_profile.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/anti_spyware_security_profile) | resource |
| [panos_antivirus_security_profile.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/antivirus_security_profile) | resource |
| [panos_file_blocking_security_profile.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/file_blocking_security_profile) | resource |
| [panos_vulnerability_security_profile.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/vulnerability_security_profile) | resource |
| [panos_wildfire_analysis_security_profile.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/wildfire_analysis_security_profile) | resource |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_mode"></a> [mode](#input\_mode) | The mode to use for the module. Valid values are `panorama` and `ngfw`. | `string` | n/a | yes |
| <a name="input_mode_map"></a> [mode\_map](#input\_mode\_map) | The mode to use for the modules. Valid values are `panorama` and `ngfw`. | <pre>object({<br>    panorama = number<br>    ngfw     = number<br>  })</pre> | <pre>{<br>  "ngfw": 1,<br>  "panorama": 0<br>}</pre> | no |
| <a name="input_device_group"></a> [device\_group](#input\_device\_group) | Used if `mode` is `panorama`, this defines the Device Group for the deployment. | `string` | `"shared"` | no |
| <a name="input_vsys"></a> [vsys](#input\_vsys) | Used if `mode` is `ngfw`, this defines the vsys for the deployment. | `string` | `"vsys1"` | no |
| <a name="input_antivirus_profiles"></a> [antivirus\_profiles](#input\_antivirus\_profiles) | List with the Antivirus profile objects. Each item supports following parameters:<br>- `name`: (required) Profile name.<br>- `description`: (optional) Profile description.<br>- `packet_capture`: (optional) Boolean that enables packet capture (default: `false`).<br>- `threat_exceptions`: (optional) A string list of threat exceptions.<br>- `decoders`: (optional) List of objects following the decoder specifications.<br>  - `name`: (required) Decoder name.<br>  - `actions`: (optional) Decoder action. Valid values are `default`, `allow`, `alert`, `drop`, `reset-client`, `reset-server`, or `reset-both` (default: `default`).<br>  - `wildfire_action`: (optional) Wildfire action. Valid values are `default`, `allow`, `alert`, `drop`, `reset-client`, `reset-server`, or `reset-both` (default: `default`).<br>  - `machine_learning_action`: (optional) Only available with PAN-OS 10.0+, machine learning action. Valid values are `default`, `allow`, `alert`, `drop`, `reset-client`, `reset-server`, or `reset-both` (default: `default`).<br>- `application_exceptions`: (optional) List of objects following the application exception specifications.<br>  - `application`: (required) The application name.<br>  - `action`: (optional) The action performed when approached with the application exception. Valid values are `default`, `allow`, `alert`, `drop`, `reset-client`, `reset-server`, or `reset-both` (default: `default`).<br>- `machine_learning_models`: (optional) List of objects following the machine learning model specifications.<br>  - `model`: (required) The model.<br>  - `action`: (required) The action for the machine learning model to perform. Valid values are `default`, `allow`, `alert`, `drop`, `reset-client`, `reset-server`, or `reset-both` (default: `default`).<br>- `machine_learning_exceptions`: (optional) List of objects following the machine learning exception specifications.<br>  - `name`: (required) Partial hash of file included in the machine learning exception.<br>  - `description`: (optional) The description of the exception.<br>  - `filename`: (optional) The filename for the exception<br>Example:<pre>[<br>  {<br>    name = "Alert-Only-AV"<br>    decoders = [<br>      {<br>        name = "http"<br>        action = "alert"<br>        wildfire_action = "alert"<br>        machine_learning = "alert"<br>      }<br>    ]<br>    machine_learning_models = [<br>      {<br>        model = "Windows Executables"<br>        action = "enable"<br>      },<br>      {<br>        model = "PowerShell Script 1"<br>        action = "enable"<br>      }<br>    ]<br>  }<br>]</pre> | <pre>map(object({<br>    description       = optional(string)<br>    packet_capture    = optional(bool)<br>    threat_exceptions = optional(list(string))<br>    decoders = optional(list(object({<br>      name                    = string<br>      action                  = optional(string, "default")<br>      wildfire_action         = optional(string, "default")<br>      machine_learning_action = optional(string, "default")<br>    })), [])<br>    application_exceptions = optional(list(object({<br>      application = string<br>      action      = optional(string, "default")<br>    })), [])<br>    machine_learning_models = optional(list(object({<br>      model  = string<br>      action = string<br>    })), [])<br>    machine_learning_exceptions = optional(list(object({<br>      name        = string<br>      description = optional(string)<br>      filename    = optional(string)<br>    })), [])<br>  }))</pre> | `{}` | no |
| <a name="input_antispyware_profiles"></a> [antispyware\_profiles](#input\_antispyware\_profiles) | List of the Anti-Spyware profile objects. Each item supports following parameters:<br>- `name`: (required) Identifier of the Anti-Spyware security profile.<br>- `description`: (optional) The description of the Anti-Spyware profile.<br>- `packet_capture`: (optional) Packet capture setting for PAN-OS 8.X only). Valid values are `disable`, `single-packet`, or `extended-capture` (default: `disable`).<br>- `sinkhole_ipv4_address`: (optional) IPv4 sinkhole address.<br>- `sinkhole_ipv6_address`: (optional) IPv6 sinkhole address.<br>- `threat_exceptions`: (optional) A string list of threat exceptions.<br>- `botnet_lists`: (optional) List of objects following the botnet specifications.<br>  - `name`: (required) Botnet name.<br>  - `actions`: (optional) Botnet action. Valid values are `allow`, `alert`, `block`, `default`, or `sinkhole` (default: `default`).<br>  - `packet_capture`: (optional) Packet capture setting for PAN-OS 9.0+. Valid values are `disable`, `single-packet`, or `extended-capture` (default: `disable`).<br>- `dns_categories`: (optional) List of objects following the DNS category specifications for PAN-OS 10.0+.<br>  - `name`: (required) DNS category name.<br>  - `action`: (optional) DNS category action. Valid values are `default`, `allow`, `alert`, `drop`, `block`, or `sinkhole` (default: `default`).<br>  - `log_level`: (optional) Logging level. Valid values are `default`, `none`, `low`, `informational`, `medium`, `high`, or `critical` (default: `default`).<br>  - `packet_capture`: (optional) Packet capture setting. Valid values are `disable`, `single-packet`, or `extended-capture` (default: `disable`).<br>- `white_lists`: (optional) List of objects following the white list specifications.<br>  - `name`: (required) White list object name.<br>  - `description`: (optional) Description of the white list.<br>- `rules`: (optional) List of objects following the rule specifications.<br>  - `name`: (required) Rule name.<br>  - `threat_name`: (optional) Threat name.<br>  - `category`: (optional) Category for the anti-spyware policy (default: `any`).<br>  - `severities`: (optional) List of severities to include in policy. Valid values are `any`, `critical`, `high`, `medium`, `low`, or/and `informational` (default: `any`).<br>  - `packet_capture`: (optional) Packet capture setting. Valid values are `disable`, `single-packet`, or `extended-capture` (default: `disable`).<br>  - `block_ip_track_by`: (required if `action` = `block-ip`) The track setting. Valid values are `source` or `source-and-destination`.<br>  - `block_ip_duration`: (required if `action` = `block-ip`) The duration of the block. Valid values are integers.<br>- `exceptions`: (optional) List of objects following the exceptions specifications.<br>  - `name`: (required) Threat name for the exception. You can use the `panos_predefined_threat` data source to discover the various names available to use.<br>  - `packet_capture`: (optional) Packet capture setting. Valid values are `disable`, `single-packet`, or `extended-capture` (default: `disable`).<br>  - `action`: (optional) Exception action. Valid values are `default`, `allow`, `alert`, `drop`, `reset-client`, `reset-server`, `reset-both`, or `block-ip` (default: `default`).<br>  - `block_ip_track_by`: (required if `action` = `block-ip`) The track setting. Valid values are `source` or `source-and-destination`.<br>  - `block_ip_duration`: (required if `action` = `block-ip`) The duration of the block. Valid values are integers.<br>  - `exempt_ips`: (optional) List of exempt IPs.<br><br>Example:<pre>[<br>  {<br><br>    name = "Outbound-AS"<br>    botnet_lists = [<br>      {<br>        name = "default-paloalto-dns"<br>        action = "sinkhole"<br>        packet_capture = "single-packet"<br>      }<br>    ]<br>    dns_categories = [<br>      {<br>        name = "pan-dns-sec-benign"<br>      },<br>      {<br>        name = "pan-dns-sec-cc"<br>        action = "sinkhole"<br>        packet_capture = "single-packet"<br>      }<br>    ]<br>    sinkhole_ipv4_address = "72.5.65.111"<br>    sinkhole_ipv6_address = "2600:5200::1"<br>    rules =<br>    [<br>      {<br>        name = "Block-Critical-High-Medium"<br>        action = "reset-both"<br>        severities = ["critical","high","medium"]<br>        packet_capture = "single-packet"<br>      },<br>      {<br>        name = "Default-Low-Info"<br>        severities = ["low","informational"]<br>        packet_capture = "disable"<br>      }<br>    ]<br>  }<br>]</pre> | <pre>map(object({<br>    description           = optional(string)<br>    packet_capture        = optional(string, "disable")<br>    sinkhole_ipv4_address = optional(string)<br>    sinkhole_ipv6_address = optional(string)<br>    threat_exceptions     = optional(list(string))<br>    botnet_lists = optional(list(object({<br>      name           = string<br>      action         = optional(string, "default")<br>      packet_capture = optional(string, "disable")<br>    })), [])<br>    dns_categories = optional(list(object({<br>      name           = string<br>      action         = optional(string, "default")<br>      log_level      = optional(string, "default")<br>      packet_capture = optional(string, "disable")<br>    })), [])<br>    white_lists = optional(list(object({<br>      name        = string<br>      description = optional(string)<br>    })), [])<br>    rules = optional(list(object({<br>      name              = string<br>      threat_name       = optional(string, "any")<br>      category          = optional(string, "any")<br>      severities        = optional(list(string), ["any"])<br>      packet_capture    = optional(string, "disable")<br>      action            = optional(string, "default")<br>      block_ip_track_by = optional(string, "source")<br>      block_ip_duration = optional(number)<br>    })), [])<br>    exceptions = optional(list(object({<br>      name              = string<br>      packet_capture    = optional(string, "disable")<br>      action            = optional(string, "default")<br>      block_ip_track_by = optional(string, "source")<br>      block_ip_duration = optional(number)<br>      exempt_ips        = optional(list(string))<br>    })), [])<br>  }))</pre> | `{}` | no |
| <a name="input_file_blocking_profiles"></a> [file\_blocking\_profiles](#input\_file\_blocking\_profiles) | List of the File Blocking profile objects. Each item supports following parameters:<br>- `name`: (required) Identifier of the File-blocking security profile.<br>- `description`: (optional) The description of the File-blocking profile.<br>- `rules`: (optional) List of objects following the rule specifications.<br>  - `name`: (required) Rule name.<br>  - `applications`: (optional) List of applications (default: `any`).<br>  - `file_types`: (optional) File types included in the file-blocking rule.<br>  - `direction`: (optional) Direction for the file-blocking rule to flow. Valid values are `both`, `upload`, or `download` (default: `both`).<br>  - `action`: (optional) Action for the policy to take. Valid values are `alert`, `block`, or `continue` (default: `alert`).<br><br>Example:<pre>[<br>  {<br>    name = "Outbound-FB"<br>    rules = [<br>      {<br>        name = "Alert-All"<br>        applications = ["any"]<br>        file_types = ["any"]<br>        direction = "both"<br>        action = "alert"<br>      },<br>      {<br>        name = "Block"<br>        applications = ["any"]<br>        file_types = [<br>          "7z",<br>          "bat",<br>          "chm",<br>          "class",<br>          "cpl",<br>          "dll",<br>          "hlp",<br>          "hta",<br>          "jar",<br>          "ocx",<br>          "pif",<br>          "scr",<br>          "torrent",<br>          "vbe",<br>          "wsf"<br>        ]<br>        direction = "both"<br>        action = "block"<br>      }<br>    ]<br>  }<br>]</pre> | <pre>map(object({<br>    description = optional(string)<br>    rules = optional(list(object({<br>      name         = string<br>      applications = optional(list(string), ["any"])<br>      file_types   = optional(list(string), ["any"])<br>      direction    = optional(string, "both")<br>      action       = optional(string, "alert")<br>    })), [])<br>  }))</pre> | `{}` | no |
| <a name="input_vulnerability_protection_profiles"></a> [vulnerability\_protection\_profiles](#input\_vulnerability\_protection\_profiles) | List of the Vulnerability Protection profile objects. Each item supports following parameters:<br>- `name`: (required) Identifier of the Vulnerability security profile.<br>- `description`: (optional) The description of the vulnerability profile.<br>- `rules`: (optional) List of objects following the rule specifications.<br>  - `name`: (required) Rule name.<br>  - `threat_name`: (optional) Threat name.<br>  - `cves`: (optional) List of CVEs (default: `any`).<br>  - `host`: (optional) The host. Valid values are `any`, `client`, or `server` (default: `any`).<br>  - `vendor_ids`: (optional) List of vendor IDs (default: `any`).<br>  - `category`: (optional) Category for the file-blocking policy (default: `any`).<br>  - `severities`: (optional) List of severities to include in policy. Valid values are `any`, `critical`, `high`, `medium`, `low`, or/and `informational` (default: `any`).<br>  - `packet_capture`: (optional) Packet capture setting. Valid values are `disable`, `single-packet`, or `extended-capture` (default: `disable`).<br>  - `action`: (optional) Exception action. Valid values are `default`, `allow`, `alert`, `drop`, `reset-client`, `reset-server`, `reset-both`, or `block-ip` (default: `default`).<br>  - `block_ip_track_by`: (required if `action` = `block-ip`) The track setting. Valid values are `source` or `source-and-destination`.<br>  - `block_ip_duration`: (required if `action` = `block-ip`) The duration of the block. Valid values are integers.<br>- `exceptions`: (optional) List of objects following the exceptions specifications.<br>  - `name`: (required) Threat name for the exception. You can use the `panos_predefined_threat` data source to discover the various names available to use.<br>  - `packet_capture`: (optional) Packet capture setting. Valid values are `disable`, `single-packet`, or `extended-capture` (default: `disable`).<br>  - `action`: (optional) Exception action. Valid values are `default`, `allow`, `alert`, `drop`, `reset-client`, `reset-server`, `reset-both`, or `block-ip` (default: `default`).<br>  - `block_ip_track_by`: (required if `action` = `block-ip`) The track setting. Valid values are `source` or `source-and-destination`.<br>  - `block_ip_duration`: (required if `action` = `block-ip`) The duration of the block. Valid values are integers.<br>  - `exempt_ips`: (optional) List of exempt IPs.<br>  - `time_interval`: (optional) Time interval integer.<br>  - `time_threshold`: (optional) Time threshold integer.<br>  - `time_track_by`: (optional) Time track by setting. Valid values are `source`, `destination`, or `source-and-destination`.<br><br>Example:<pre>[<br>  {<br>    name = "Outbound-VP"<br>    rules = [<br>      {<br>        name = "Block-Critical-High-Medium"<br>        action = "reset-both"<br>        vendor_ids = ["any"]<br>        severities = ["critical","high","medium"]<br>        cves = ["any"]<br>        threat_name = "any"<br>        host = "any"<br>        category = "any"<br>        packet_capture = "single-packet"<br>      },<br>      {<br>        name = "Default-Low-Info"<br>        action = "default"<br>        vendor_ids = ["any"]<br>        severities = ["low","informational"]<br>        cves = ["any"]<br>        threat_name = "any"<br>        host = "any"<br>        category = "any"<br>        packet_capture = "disable"<br>      }<br>    ]<br>  }<br>]</pre> | <pre>map(object({<br>    description = optional(string)<br>    rules = optional(list(object({<br>      name              = string<br>      threat_name       = optional(string, "any")<br>      cves              = optional(set(string), ["any"])<br>      host              = optional(string, "any")<br>      vendor_ids        = optional(set(string), ["any"])<br>      severities        = optional(list(string), ["any"])<br>      category          = optional(string, "any")<br>      action            = optional(string, "default")<br>      block_ip_track_by = optional(string, "source")<br>      block_ip_duration = optional(number)<br>      packet_capture    = optional(string, "disable")<br>    })), [])<br>    exceptions = optional(list(object({<br>      name              = string<br>      packet_capture    = optional(string, "disable")<br>      action            = optional(string, "default")<br>      block_ip_track_by = optional(string, "source")<br>      block_ip_duration = optional(number)<br>      time_interval     = optional(number)<br>      time_threshold    = optional(number)<br>      time_track_by     = optional(string)<br>      exempt_ips        = optional(list(string))<br>    })), [])<br>  }))</pre> | `{}` | no |
| <a name="input_wildfire_analysis_profiles"></a> [wildfire\_analysis\_profiles](#input\_wildfire\_analysis\_profiles) | List of the Wildfire Analysis profile objects. Each item supports following parameters:<br>- `name`: (required) Identifier of the Wildfire Analysis security profile.<br>- `device_group`: (optional) The device group location (default: `shared`).<br>- `description`: (optional) The description of the Wildfire Analysis profile.<br>- `rules`: (optional) List of objects following the rule specifications.<br>  - `name`: (required) Rule name.<br>  - `applications`: (optional) List of applications (default: `any`).<br>  - `file_types`: (optional) List of file types (default: `any`).<br>  - `direction`: (optional) Direction for the wildfire analysis policy. Valid values are `both`, `upload`, or `download` (default: `both`).<br>  - `analysis`: (optional) Analysis setting. Valid values are `public-cloud` or `private-cloud` (default: `public-cloud`).<br><br>Example:<pre>[<br>  {<br>    name = "Outbound-WF"<br>    rules = [<br>      {<br>        name = "Forward-All"<br>        applications = ["any"]<br>        file_types = ["any"]<br>        direction = "both"<br>        analysis = "public-cloud"<br>      }<br>    ]<br>  }<br>]</pre> | <pre>map(object({<br>    description = optional(string)<br>    rules = optional(list(object({<br>      name         = string<br>      applications = optional(list(string), ["any"])<br>      file_types   = optional(list(string), ["any"])<br>      direction    = optional(string, "both")<br>      analysis     = optional(string, "public-cloud")<br>    })), [])<br>  }))</pre> | `{}` | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_panos_antivirus_security_profile"></a> [panos\_antivirus\_security\_profile](#output\_panos\_antivirus\_security\_profile) | n/a |
| <a name="output_panos_anti_spyware_security_profile"></a> [panos\_anti\_spyware\_security\_profile](#output\_panos\_anti\_spyware\_security\_profile) | n/a |
| <a name="output_panos_file_blocking_security_profile"></a> [panos\_file\_blocking\_security\_profile](#output\_panos\_file\_blocking\_security\_profile) | n/a |
| <a name="output_panos_vulnerability_security_profile"></a> [panos\_vulnerability\_security\_profile](#output\_panos\_vulnerability\_security\_profile) | n/a |
| <a name="output_panos_wildfire_analysis_security_profile"></a> [panos\_wildfire\_analysis\_security\_profile](#output\_panos\_wildfire\_analysis\_security\_profile) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->