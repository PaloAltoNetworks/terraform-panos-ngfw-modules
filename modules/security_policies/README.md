Palo Alto Networks PAN-OS Security Policies Module
---
This Terraform module allows users to configure security policies.

Usage
---

1. Create a **"main.tf"** file with the following content:

```terraform
module "security_policies" {
  source  = "PaloAltoNetworks/terraform-panos-ngfw-modules//modules/security_policies"

  mode = "panorama" # If you want to use this module with a firewall, change this to "ngfw"

  device_group      = "test"
  security_policies = {
    "allow_rule_group" = {
      rulebase = "pre-rulebase"
      rules = [
        {
          name = "Allow access to DNS Servers"
          tags = [
            "Outbound",
            "Managed by Terraform"
          ]
          source_zones          = ["Trust-L3"]
          source_addresses      = ["RFC1918_Subnets"]
          destination_zones     = ["Untrust-L3"]
          destination_addresses = ["DNS-Servers"]
          applications          = ["dns"]
          services              = ["application-default"]
          action                = "allow"
          log_end               = "true"
          virus                 = "default"
          spyware               = "default"
          vulnerability         = "default"
        },
        {
          name             = "Allow access to RFC1918"
          tags             = ["Managed by Terraform"]
          source_zones     = ["Trust-L3"]
          source_addresses = ["RFC1918_Subnets"]
          destination_zones = [
            "Trust-L3",
            "Untrust-L3"
          ]
          destination_addresses = ["RFC1918_Subnets"]
          services              = ["application-default"]
          action                = "allow"
          log_end               = "true"
          virus                 = "default"
          spyware               = "default"
          vulnerability         = "default"
        },
        {
          name = "Disabled - temporary access to Srv10 and Srv11"
          tags = [
            "Outbound",
            "Managed by Terraform"
          ]
          source_zones = ["Trust-L3"]
          source_addresses = [
            "Server10",
            "Server11"
          ]
          destination_zones     = ["Untrust-L3"]
          destination_addresses = ["123.123.123.123/32"]
          services              = ["SSH-8022"]
          action                = "allow"
          log_end               = "true"
          disabled              = "true"
          virus                 = "default"
          spyware               = "default"
          vulnerability         = "default"
          url_filtering         = "default"
          file_blocking         = "basic file blocking"
          wildfire_analysis     = "default"
        },
        {
          name = "Allow access to SSH Servers"
          tags = [
            "Inbound",
            "Managed by Terraform"
          ]
          source_zones          = ["Untrust-L3"]
          negate_source         = "false"
          destination_zones     = ["Trust-L3"]
          destination_addresses = ["SSH-Servers"]
          negate_destination    = "false"
          applications          = ["ssh"]
          services              = ["application-default"]
          action                = "allow"
          log_end               = "true"
        }
      ]
    }
    "block_rule_group" = {
      position_keyword = "bottom"
      rulebase         = "pre-rulebase"
      rules = [
        {
          name = "Block Some Traffic"
          tags = [
            "Outbound",
            "Managed by Terraform"
          ]
          source_zones     = ["Trust-L3"]
          source_addresses = ["10.0.0.100/32"]
          action           = "deny"
          log_end          = "true"
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
| [panos_security_rule_group.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/security_rule_group) | resource |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_mode"></a> [mode](#input\_mode) | The mode to use for the modules. Valid values are `panorama` and `ngfw`. | `string` | n/a | yes |
| <a name="input_mode_map"></a> [mode\_map](#input\_mode\_map) | The mode to use for the modules. Valid values are `panorama` and `ngfw`. | <pre>object({<br>    panorama = number<br>    ngfw     = number<br>  })</pre> | <pre>{<br>  "ngfw": 1,<br>  "panorama": 0<br>}</pre> | no |
| <a name="input_device_group"></a> [device\_group](#input\_device\_group) | Used if `mode` is panorama, this defines the Device Group for the deployment | `string` | `"shared"` | no |
| <a name="input_vsys"></a> [vsys](#input\_vsys) | Used if `mode` is ngfw, this defines the vsys for the deployment | `string` | `"vsys1"` | no |
| <a name="input_security_policies"></a> [security\_policies](#input\_security\_policies) | Map with groups of security policies to apply. Each item supports following parameters:<br>- `rulebase`: (optional) The rulebase for the Security Policy. Valid values are `pre-rulebase` and `post-rulebase` (default: `pre-rulebase`).<br>- `position_keyword`: (optional) A positioning keyword for this group. Valid values are `before`, `directly before`, `after`, `directly after`, `top`, `bottom`, or left empty to have no particular placement (default: empty). This parameter works in combination with the `position_reference` parameter.<br>- `position_reference`: (optional) Required if `position_keyword` is one of the "above" or "below" variants, this is the name of a non-group rule to use as a reference to place this group.<br>- `rules`: (optional) List of security rule definitions. The order of the rules will match how they appear in the terraform plan file.<br>  - `name`: (required) The security rule's name.<br>  - `description`: (optional) The description of the security rule.<br>  - `type`: (optional) Rule type. Valid values are `universal`, `interzone`, or `intrazone` (default: `universal`).<br>  - `tags`: (optional) List of administrative tags.<br>  - `source_addresses`: (optional) List of source addresses (default: `any`).<br>  - `source_zones`: (optional) List of source zones (default: `any`).<br>  - `negate_source`: (optional) Boolean designating if the source should be negated (default: `false`).<br>  - `source_users`: (optional) List of source users (default: `any`).<br>  - `hip_profiles`: (optional) List of HIP profiles (default: `any`).<br>  - `destination_zones`: (optional) List of destination zones (default: `any`).<br>  - `destination_addresses`: (optional) List of destination addresses (default: `any`).<br>  - `negate_destination`: (optional) Boolean designating if the destination should be negated (default: `false`).<br>  - `applications`: (optional) List of applications (default: `any`).<br>  - `services`: (optional) List of services (default: `application-default`).<br>  - `categories`: (optional) List of categories (default: `any`).<br>  - `action`: (optional) Action for the matched traffic. Valid values are `allow`, `drop`, `reset-client`, `reset-server`, or `reset-both` (default: `allow`).<br>  - `log_setting`: (optional) Log forwarding profile.<br>  - `log_start`: (optional) Boolean designating if log the start of the traffic flow (default: `false`).<br>  - `log_end`: (optional) Boolean designating if log the end of the traffic flow (default: `true`).<br>  - `disabled`: (optional) Boolean designating if the security policy rule is disabled (default: `false`).<br>  - `schedule`: (optional) The security rule schedule.<br>  - `icmp_unreachable`: (optional) Boolean enabling ICMP unreachable (default: `false`).<br>  - `disable_server_response_inspection`: (optional) Boolean disabling server response inspection (default: `false`).<br>  - `group`: (optional) Profile setting: `Group` - The group profile name.<br>  - `virus`: (optional) Profile setting: `Profiles` - Input the desired antivirus profile name.<br>  - `spyware`: (optional) Profile setting: `Profiles` - Input the desired anti-spyware profile name.<br>  - `vulnerability`: (optional) Profile setting: `Profiles` - Input the desired vulnerability profile name.<br>  - `url_filtering`: (optional) Profile setting: `Profiles` - Input the desired URL filtering profile name.<br>  - `file_blocking`: (optional) Profile setting: `Profiles` - Input the desired File-Blocking profile name.<br>  - `wildfire_analysis`: (optional) Profile setting: `Profiles` - Input the desired Wildfire Analysis profile name.<br>  - `data_filtering`: (optional) Profile setting: `Profiles` - Input the desired Data Filtering profile name.<br>  - `negate_target`: (optional, Panorama only) Instead of applying the rule for the given serial numbers, apply it to everything except them.<br>  - `target`: (optional, Panorama only) A target definition,if there are no target sections, then the rule will apply to every vsys of every device in the device group.<br><br>Example:<pre>{<br>  "allow_rule_group" = {<br>    rulebase = "pre-rulebase"<br>    rules = [<br>      {<br>        name = "Allow access to DNS Servers"<br>        tags = [<br>          "Outbound",<br>          "Managed by Terraform"<br>        ]<br>        source_zones                       = ["Trust-L3"]<br>        source_addresses                   = ["RFC1918_Subnets"]<br>        destination_zones                  = ["Untrust-L3"]<br>        destination_addresses              = ["DNS-Servers"]<br>        applications                       = ["dns"]<br>        services                           = ["application-default"]<br>        action                             = "allow"<br>        log_end                            = "true"<br>      },<br>      {<br>        name             = "Allow access to RFC1918"<br>        tags             = ["Managed by Terraform"]<br>        source_zones     = ["Trust-L3"]<br>        source_addresses = ["RFC1918_Subnets"]<br>        destination_zones = [<br>          "Trust-L3",<br>          "Untrust-L3"<br>        ]<br>        destination_addresses              = ["RFC1918_Subnets"]<br>        services                           = ["application-default"]<br>        action                             = "allow"<br>        log_end                            = "true"<br>        virus                              = "default"<br>        spyware                            = "default"<br>        vulnerability                      = "default"<br>      }<br>    ]<br>  }<br>  "block_rule_group" = {<br>    position_keyword = "bottom"<br>    rulebase         = "pre-rulebase"<br>    rules = [<br>      {<br>        name = "Block Some Traffic"<br>        tags = [<br>          "Outbound",<br>          "Managed by Terraform"<br>        ]<br>        source_zones                       = ["Trust-L3"]<br>        source_addresses                   = ["10.0.0.100/32"]<br>        action                             = "deny"<br>        log_end                            = "true"<br>      }<br>    ]<br>  }<br>}</pre> | <pre>map(object({<br>    rulebase           = optional(string, "pre-rulebase")<br>    position_keyword   = optional(string)<br>    position_reference = optional(string)<br>    rules = list(object({<br>      name                               = string<br>      type                               = optional(string, "universal")<br>      description                        = optional(string)<br>      tags                               = optional(list(string))<br>      source_zones                       = optional(list(string), ["any"])<br>      source_addresses                   = optional(list(string), ["any"])<br>      negate_source                      = optional(string, false)<br>      source_users                       = optional(list(string), ["any"])<br>      hip_profiles                       = optional(list(string), ["any"])<br>      destination_zones                  = optional(list(string), ["any"])<br>      destination_addresses              = optional(list(string), ["any"])<br>      negate_destination                 = optional(string, false)<br>      applications                       = optional(list(string), ["any"])<br>      services                           = optional(list(string), ["application-default"])<br>      categories                         = optional(list(string), ["any"])<br>      action                             = optional(string, "allow")<br>      log_setting                        = optional(string)<br>      log_start                          = optional(string, false)<br>      log_end                            = optional(string, true)<br>      disabled                           = optional(string, false)<br>      schedule                           = optional(string)<br>      icmp_unreachable                   = optional(string)<br>      disable_server_response_inspection = optional(bool, false)<br>      group                              = optional(string)<br>      virus                              = optional(string)<br>      spyware                            = optional(string)<br>      vulnerability                      = optional(string)<br>      url_filtering                      = optional(string)<br>      file_blocking                      = optional(string)<br>      wildfire_analysis                  = optional(string)<br>      data_filtering                     = optional(string)<br>      group_tag                          = optional(list(string))<br>      negate_target                      = optional(bool, false)<br>      audit_comment                      = optional(string)<br>      target = optional(list(object({<br>        serial    = string<br>        vsys_list = optional(list(string))<br>      })), null)<br>    }))<br>  }))</pre> | `{}` | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_security_rule_groups"></a> [security\_rule\_groups](#output\_security\_rule\_groups) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->