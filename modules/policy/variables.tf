#Validation checks:
#1) if the var is on default (aka not being used)
#2) a. if the file exists
#   b. if the file can be decoded by jsondecode or yamldecode (the 2 file input options)


#tags
variable "tags" {
  type        = any
  description = <<-EOF
  List of tag objects.
  - `name`: (required) The administrative tag's name.
  - `device_group`: (optional) The device group location (default: `shared`).
  - `comment`: (optional) The description of the administrataive tag.
  - `color`: (optional) The tag's color. This should either be an empty string (no color) or a string such as `color1`. Note that the colors go from 1 to 16.

  Example:
  ```
[
  {
    name = "trust"
  }
  {
    name = "untrust"
    comment = "for untrusted zones"
    color = "color4"
  }
  {
    name = "AWS"
    device_group = "AWS"
    color = "color8"
  }
]
  ```
  EOF
  default     = "optional"

  validation {
    condition     = var.tags == "optional" || (var.tags != {} && can(var.tags))
    error_message = "Not a input to read."
  }
}


#services
variable "services" {
  type        = any
  description = <<-EOF
  List of service objects.
  - `name`: (required) The service object's name.
  - `device_group`: (optional) The device group location (default: `shared`).
  - `description`: (optional) The description of the service object.
  - `protocol`: (required) The service's protocol. Valid values are `tcp`, `udp`, or `sctp` (only for PAN-OS 8.1+).
  - `source_port`: (optional) The source port. This can be a single port number, range (1-65535), or comma separated (80,8080,443).
  - `destination_port`: (required) The destination port. This can be a single port number, range (1-65535), or comma separated (80,8080,443).
  - `tags`: (optional) List of administrative tags.
  - `override_session_timeout`: (optional) Boolean to override the default application timeouts (default: `false`). Only available for PAN-OS 8.1+.
  - `override_timeout`: (optional) Integer for the overridden timeout if TCP protocol selected. Only available for PAN-OS 8.1+.
  - `override_half_closed_timeout`: (optional) Integer for the overridden half closed timeout if TCP protocol selected. Only available for PAN-OS 8.1+.
  - `override_time_wait_timeout`: (optional) Integer for the overridden wait time if TCP protocol selected. Only available for PAN-OS 8.1+.

  Example:
  ```
  [
    {
      name = "service1"
      protocol = "tcp"
      destination_port = "8080"
      source_port = "400"
      override_session_timeout = true
      override_timeout = 250
      override_time_wait_timeout = 590
    }
    {
      name = "service2"
      protocol = "udp"
      destination_port = "80"
    }
  ]
  ```
  EOF
  default     = "optional"

  validation {
    condition     = var.services == "optional" || (var.services != {} && can(var.services))
    error_message = "Not a input to read."
  }
}

variable "service_groups" {
  type        = any
  description = <<-EOF
  List of the address group objects.
  - `name`: (required) The address group's name.
  - `device_group`: (optional) The device group location (default: `shared`).
  - `services`: (optional) The service objects to include in this service group.
  - `tags`: (optional) List of administrative tags.
  EOF
  default     = "optional"

  validation {
    condition     = var.service_groups == "optional" || (var.service_groups != {} && can(var.service_groups))
    error_message = "Not a input to read."
  }
}

#address
variable "addr_obj" {
  type        = any
  description = <<-EOF
  List of the address objects.
  - `name`: (required) The address object's name.
  - `device_group`: (optional) The device group location (default: `shared`).
  - `description`: (optional) The description of the address object.
  - `type`: (optional) The type of address object. Valid values are `ip-netmask`, `ip-range`, `fqdn`, or `ip-wildcard` (only available with PAN-OS 9.0+) (default: `ip-netmask).
  - `value`: (required) The address object's value. This can take various forms depending on what type of address object this is, but can be something like `192.168.80.150` or `192.168.80.0/24`.
  - `tags`: (optional) List of administrative tags.

  Example:
  ```
  [
    {
      name = "azure_int_lb_priv_ip"
      type = "ip-netmask"
      value = {
        "ip-netmask = "10.100.4.40/32"
      }
      tags = ["trust"]
      device_group = "AZURE"
    }
    {
      name = "pa_updates"
      type = "fqdn"
      value = {
        fqdn = "updates.paloaltonetworks.com"
      }
      description = "palo alto updates"
    }
    {
      name = "ntp1"
      type = "ip-range"
      value = {
        ip-range = "10.0.0.2-10.0.0.10"
      }
    }
  ]
  ```
  EOF
  default     = "optional"

  validation {
    condition     = var.addr_obj == "optional" || (var.addr_obj != {} && can(var.addr_obj))
    error_message = "Not a valid input to read."
  }
}

variable "addr_group" {
  type        = any
  description = <<-EOF
  List of the address group objects.
  - `name`: (required) The address group's name.
  - `device_group`: (optional) The device group location (default: `shared`).
  - `description`: (optional) The description of the address group.
  - `static_addresses`: (optional) The address objects to include in this statically defined address group.
  - `dynamic_match`: (optional) The IP tags to include in this DAG. Inputs are structured as follows `'<tag name>' and ...` or `<tag name>` or ...`.
  - `tags`: (optional) List of administrative tags.

  Example:
  ```
  [
    {
      name = "static ntp grp"
      description": "ntp servers"
      static_addresses = ["ntp1", "ntp2"]
    }
    {
      name = "trust and internal grp",
      description = "dynamic servers",
      dynamic_match = "'trust'and'internal'",
      tags = ["trust"]
    }
  ]
  ```
  EOF
  default     = "optional"

  validation {
    condition     = var.addr_group == "optional" || (var.addr_group != {} && can(var.addr_group))
    error_message = "Not a input to read."
  }
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

variable "nat_policy" {
  type        = any
  description = <<-EOF
  List of the NAT policy rule objects.
  - `device_group`: (optional) The device group location (default: `shared`).
  - `rulebase`: (optional) The rulebase for the NAT Policy. Valid values are `pre-rulebase` and `post-rulebase` (default: `pre-rulebase`).
  - `position_keyword`: (optional) A positioning keyword for this group. Valid values are `before`, `directly before`, `after`, `directly after`, `top`, `bottom`, or left empty to have no particular placement (default: empty). This parameter works in combination with the `position_reference` parameter.
  - `position_reference`: (optional) Required if `position_keyword` is one of the "above" or "below" variants, this is the name of a non-group rule to use as a reference to place this group.
  - `rules`: (optional) The NAT rule definition. The NAT rule ordering will match how they appear in the terraform plan file.
    - `name`: (required) The NAT rule's name.
    - `description`: (optional) The description of the NAT rule.
    - `type`: (optional) NAT type. Valid values are `ipv4`, `nat64`, or `nptv6` (default: `ipv4`).
    - `tags`: (optional) List of administrative tags.
    - `disabled`: (optional) Boolean designating if the security policy rule is disabled (default: `false`).
    - `original_packet`: (required) The original packet specification.
      - `source_zones`: (optional) List of source zones (default: `any`).
      - `destination_zone`: (optional) The destination zone (default: `any`).
      - `destination_interface`: (optional) Egress interface from the lookup (default: `any`).
      - `service`: (optional) Service for the original packet (default: `any`).
      - `source_addresses`: (optional) List of source addresses (default: `any`).
      - `destination_addresses`: (optional) List of destination addresses (default: `any`).
    - `translated_packet`: (required) The translated packet specifications.
      - `source`: (optional) The source specification. Valid values are `none`, `dynamic_ip_port`, `dynamic_ip`, or `static_ip` (default: `none`).
        - `dynamic_ip_and_port`: (optional) Dynamic IP and port source translation specification.
          - `translated_addresses`: (optional) Not functional if `interface_address` is configured. List of translated addresses.
          - `interface_address`: (optional) Not functional if `translated_addresses` is configured. Interface address source translation type specifications.
            - `interface`: (required) The interface.
            - `ip_address`: (optional) The IP address.
        - `dynamic_ip`: (optional) Dynamic IP source translation specification.
          - `translated_addresses`: (optional) The list of translated addresses.
          - `fallback`: (optional) The fallback specifications (default: `none`).
            - `translated_addresses`: (optional) Not functional if `interface_address` is configured. List of translated addresses.
            - `interface_address`: (optional) Not functional if `translated address` is configured. The interface address fallback specifications.
              - `interface`: (required) Source address translated fallback interface.
              - `type`: (optional) Type of interface fallback. Valid values are `ip` or `floating` (default: `ip`).
              - `ip_address`: (optional) IP address of the fallback interface.
        - `static_ip`: (optional) Static IP source translation specifications.
          - `translated_address`: (required) The statically translated source address.
          - `bi_directional`: (optional) Boolean enabling bi-directional source address translation (default: `false`).
      - `destination`: (optional) The destination specification. Valid values are `none`, `static_translation`, or `dynamic_translation` (default: `none`).
        - `static_translation`: (optional) Specifies a static destination NAT.
          - `address`: (required) Destination address translation address.
          - `port`: (optional) Integer destination address translation port number.
        - `dynamic_translation`: (optional) Specify a dynamic destination NAT. Only available for PAN-OS 8.1+.
          - `address`: (required) Destination address translation address.
          - `port`: (optional) Integer destination address translation port number.
          - `distribution`: (optional) Distribution algorithm for destination address pool. Valid values are `round-robin`, `source-ip-hash`, `ip-modulo`, `ip-hash`, or `least-sessions` (default: `round-robin`). Only available for PAN-OS 8.1+.

  Example:
  ```
  [
    {
      device_group = "AWS"
      rules = [
        {
          name = "rule1"
          original_packet = {
            source_zones = ["trust"]
            destination_zone = "untrust"
            destination_interface = "any"
            source_addresses = ["google_dns1"]
            destination_addresses = ["any"]
          }
          translated_packet = {
            source = "dynamic_ip"
            translated_addresses = ["google_dns1", "google_dns2"]
            destination = "static_translation"
            static_translation = {
              address = "10.2.3.1"
              port = 5678
            }
          }
        }
        {
          name = "rule2"
          original_packet = {
            source_zones = ["untrust"]
            destination_zone = "trust"
            destination_interface = "any"
            source_addresses = ["any"]
            destination_addresses = ["any"]
          }
          translated_packet = {
            source = "static_ip"
            static_ip = {
              translated_address = "192.168.1.5"
              bi_directional = true
            }
            destination = "none"
          }
          {
            name = "rule3"
            original_packet = {
              source_zones = ["dmz"]
              destination_zone = "dmz"
              destination_interface = "any"
              source_addresses = ["any"]
              destination_addresses = ["any"]
            }
            translated_packet = {
              source = "dynamic_ip_and_port"
              interface_address = {
                interface = "ethernet1/5"
              }
              destination = "none"
            }
          }
        }
        {
          name = "rule4"
          original_packet = {
            source_zones = ["dmz"]
            destination_zone = "dmz"
            destination_interface = "any"
            source_addresses = ["any"]
            destination_addresses = ["trust and internal grp"]
          }
          translated_packet = {
            source = "dynamic_ip"
            translated_addresses = ["localnet"]
            fallback = {
              translated_addresses = ["ntp1"]
            }
            destination = "dynamic_translation"
            dynamic_translation = {
              address = "localnet"
              port = 1234
            }
          }
        }
      ]
    }
  ]
  ```

  EOF
  default     = "optional"

  validation {
    condition     = var.nat_policy == "optional" || (var.nat_policy != {} && can(var.nat_policy))
    error_message = "Not a valid input to read."
  }
}

