variable "mode" {
  description = "The mode to use for the modules. Valid values are `panorama` and `ngfw`."
  type        = string
  validation {
    condition     = contains(["panorama", "ngfw"], var.mode)
    error_message = "The mode must be either `panorama` or `ngfw`."
  }
}

variable "mode_map" {
  description = "The mode to use for the modules. Valid values are `panorama` and `ngfw`."
  default = {
    panorama = 0
    ngfw     = 1
    # cloud_manager = 2 # Not yet supported
  }
  type = object({
    panorama = number
    ngfw     = number
  })
}

variable "device_group" {
  description = "Used if _mode_ is panorama, this defines the Device Group for the deployment"
  default     = "shared"
  type        = string
}

variable "vsys" {
  description = "Used if _mode_ is ngfw, this defines the vsys for the deployment"
  default     = "vsys1"
  type        = string
}

#policy
variable "sec_policy" {
  description = <<-EOF
  List of the Security policy rule objects.
  - `rulebase`: (optional) The rulebase for the Security Policy. Valid values are `pre-rulebase` and `post-rulebase` (default: `pre-rulebase`).
  - `position_keyword`: (optional) A positioning keyword for this group. Valid values are `before`, `directly before`, `after`, `directly after`, `top`, `bottom`, or left empty to have no particular placement (default: empty). This parameter works in combination with the `position_reference` parameter.
  - `position_reference`: (optional) Required if `position_keyword` is one of the "above" or "below" variants, this is the name of a non-group rule to use as a reference to place this group.
  - `rules`: (optional) The security rule definition. The security rule ordering will match how they appear in the terraform plan file.
    - `name`: (required) The security rule's name.
    - `description`: (optional) The description of the security rule.
    - `type`: (optional) Rule type. Valid values are `universal`, `interzone`, or `intrazone` (default: `universal`).
    - `tags`: (optional) List of administrative tags.
    - `source_addresses`: (optional) List of source addresses (default: `any`).
    - `source_zones`: (optional) List of source zones (default: `any`).
    - `negate_source`: (optional) Boolean designating if the source should be negated (default: `false`).
    - `source_users`: (optional) List of source users (default: `any`).
    - `hip_profiles`: (optional) List of HIP profiles (default: `any`).
    - `destination_zones`: (optional) List of destination zones (default: `any`).
    - `destination_addresses`: (optional) List of destination addresses (default: `any`).
    - `negate_destination`: (optional) Boolean designating if the destination should be negated (default: `false`).
    - `applications`: (optional) List of applications (default: `any`).
    - `services`: (optional) List of services (default: `application-default`).
    - `categories`: (optional) List of categories (default: `any`).
    - `action`: (optional) Action for the matched traffic. Valid values are `allow`, `drop`, `reset-client`, `reset-server`, or `reset-both` (default: `allow`).
    - `log_setting`: (optional) Log forwarding profile.
    - `log_start`: (optional) Boolean designating if log the start of the traffic flow (default: `false`).
    - `log_end`: (optional) Boolean designating if log the end of the traffic flow (default: `true`).
    - `disabled`: (optional) Boolean designating if the security policy rule is disabled (default: `false`).
    - `schedule`: (optional) The security rule schedule.
    - `icmp_unreachable`: (optional) Boolean enabling ICMP unreachable (default: `false`).
    - `disable_server_response_inspection`: (optional) Boolean disabling server response inspection (default: `false`).
    - `group`: (optional) Profile setting: `Group` - The group profile name.
    - `virus`: (optional) Profile setting: `Profiles` - Input the desired antivirus profile name.
    - `spyware`: (optional) Profile setting: `Profiles` - Input the desired anti-spyware profile name.
    - `vulnerability`: (optional) Profile setting: `Profiles` - Input the desired vulnerability profile name.
    - `url_filtering`: (optional) Profile setting: `Profiles` - Input the desired URL filtering profile name.
    - `file_blocking`: (optional) Profile setting: `Profiles` - Input the desired File-Blocking profile name.
    - `wildfire_analysis`: (optional) Profile setting: `Profiles` - Input the desired Wildfire Analysis profile name.
    - `data_filtering`: (optional) Profile setting: `Profiles` - Input the desired Data Filtering profile name.
    - `negate_target`: (optional, Panorama only) Instead of applying the rule for the given serial numbers, apply it to everything except them.
    - `target`: (optional, Panorama only) A target definition,if there are no target sections, then the rule will apply to every vsys of every device in the device group.

  Example:
  ```
  {
    "allow_rule_group" = {
      rulebase = "pre-rulebase"
      policies_rules = [
        {
          name = "Allow access to DNS Servers"
          tags = [
            "Outbound",
            "Managed by Terraform"
          ]
          source_zones                       = ["Trust-L3"]
          source_addresses                   = ["RFC1918_Subnets"]
          destination_zones                  = ["Untrust-L3"]
          destination_addresses              = ["DNS-Servers"]
          applications                       = ["dns"]
          services                           = ["application-default"]
          action                             = "allow"
          log_end                            = "true"
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
          destination_addresses              = ["RFC1918_Subnets"]
          services                           = ["application-default"]
          action                             = "allow"
          log_end                            = "true"
          virus                              = "default"
          spyware                            = "default"
          vulnerability                      = "default"
        }
      ]
    }
    "block_rule_group" = {
      position_keyword = "bottom"
      rulebase         = "pre-rulebase"
      policies_rules = [
        {
          name = "Block Some Traffic"
          tags = [
            "Outbound",
            "Managed by Terraform"
          ]
          source_zones                       = ["Trust-L3"]
          source_addresses                   = ["10.0.0.100/32"]
          action                             = "deny"
          log_end                            = "true"
        }
      ]
    }
  }
  ```
  EOF
  default     = {}
  type = map(object({
    rulebase           = optional(string, "pre-rulebase")
    position_keyword   = optional(string)
    position_reference = optional(string)
    policies_rules = list(object({
      name                               = string
      type                               = optional(string, "universal")
      description                        = optional(string)
      tags                               = optional(list(string))
      source_zones                       = optional(list(string), ["any"])
      source_addresses                   = optional(list(string), ["any"])
      negate_source                      = optional(string, false)
      source_users                       = optional(list(string), ["any"])
      hip_profiles                       = optional(list(string), ["any"])
      destination_zones                  = optional(list(string), ["any"])
      destination_addresses              = optional(list(string), ["any"])
      negate_destination                 = optional(string, false)
      applications                       = optional(list(string), ["any"])
      services                           = optional(list(string), ["application-default"])
      categories                         = optional(list(string), ["any"])
      action                             = optional(string, "allow")
      log_setting                        = optional(string)
      log_start                          = optional(string, false)
      log_end                            = optional(string, true)
      disabled                           = optional(string, false)
      schedule                           = optional(string)
      icmp_unreachable                   = optional(string)
      disable_server_response_inspection = optional(bool, false)
      group                              = optional(string)
      virus                              = optional(string)
      spyware                            = optional(string)
      vulnerability                      = optional(string)
      url_filtering                      = optional(string)
      file_blocking                      = optional(string)
      wildfire_analysis                  = optional(string)
      data_filtering                     = optional(string)
      group_tag                          = optional(list(string))
      negate_target                      = optional(bool, false)
      audit_comment                      = optional(string)
      target = optional(list(object({
        serial    = string
        vsys_list = optional(list(string))
      })), null)
    }))
  }))
  validation {
    condition = alltrue([
      for rule_group in var.sec_policy : alltrue([
        for rule in rule_group.policies_rules :
        contains(["universal", "interzone", "intrazone"], coalesce(rule.type, "universal"))
      ])
    ])
    error_message = "Valid types of type are `universal`, `interzone`, `intrazone`"
  }
  validation {
    condition = alltrue([
      for rule_group in var.sec_policy : alltrue([
        for rule in rule_group.policies_rules :
        contains([
          "allow", "deny", "drop", "reset-client", "reset-server", "reset-both"
        ], coalesce(rule.action, "allow"))
      ])
    ])
    error_message = "Valid types of action are `allow`, `deny`, `drop`, `reset-client`, `reset-server`, `reset-both`"
  }
}
