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
    ngfw = number
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
  type        = any
  description = <<-EOF
  List of the Security policy rule objects.
  - `device_group`: (optional) The device group location (default: `shared`).
  - `rulebase`: (optional) The rulebase for the Security Policy. Valid values are `pre-rulebase` and `post-rulebase` (default: `pre-rulebase`).
  - `position_keyword`: (optional) A positioning keyword for this group. Valid values are `before`, `directly before`, `after`, `directly after`, `top`, `bottom`, or left empty to have no particular placement (default: empty). This parameter works in combination with the `position_reference` parameter.
  - `position_reference`: (optional) Required if `position_keyword` is one of the "above" or "below" variants, this is the name of a non-group rule to use as a reference to place this group.
  - `rules`: (optional) The security rule definition. The security rule ordering will match how they appear in the terraform plan file.
    - `name`: (required) The security rule's name.
    - `description`: (optional) The description of the security rule.
    - `type`: (optional) Rule type. Valid values are `universal`, `interzone`, or `intrazone` (default: `universal`).
    - `tags`: (optional) List of administrative tags.
    - `source_zones`: (optional) List of source zones (default: `any`).
    - `negate_source`: (optional) Boolean designating if the source should be negated (default: `false`).
    - `source_users`: (optional) List of source users (default: `any`).
    - `hip_profiles`: (optional) List of HIP profiles (default: `any`).
    - `destination_zones`: (optional) List of destination zones (default: `any`).
    - `destination_addresses`: (optional) List of destination addresses (default: `any`).
    - `negate_destination`: (optional) Boolean designating if the destination should be negated (default: `false`).
    - `applications`: (optional) List of applications (default: `any`).
    - `services`: (optional) List of services (default: `application-default`).
    - `category`: (optional) List of categories (default: `any`).
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

  Example:
  ```
  [
    {
      rulebase = "pre-rulebase"
      rules = [
        {
          name = "Outbound Block Rule"
          description = "Block outbound sessions with destination address matching one of the Palo Alto Networks external dynamic lists for high risk and known malicious IP addresses."
          source_zones = ["any"]
          source_addresses = ["any"]
          destination_zones = ["any"]
          destination_addresses = [
            "panw-highrisk-ip-list",
            "panw-known-ip-list",
            "panw-bulletproof-ip-list"
          ]
          action = "deny"
        }
      ]
    }
  ]
  ```
  EOF
  default     = "optional"

  validation {
    condition     = var.sec_policy == "optional" || (var.sec_policy != {} && can(var.sec_policy))
    error_message = "Not a valid input to read."
  }
}
