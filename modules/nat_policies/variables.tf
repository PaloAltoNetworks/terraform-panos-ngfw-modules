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
  default     = {
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

variable "nat_policies" {
  description = <<-EOF
  Map with NAT policy rule objects.
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
          - `fallback`: (optional) The fallback specifications.
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
  "required_nat" = {
    rulebase = "pre-rulebase"
    rules    = [
      {
        name = "DNS config rule"
        tags = [
          "dns-proxy",
          "Managed by Terraform"
        ]
        original_packet = {
          destination_addresses = ["any"]
          destination_zone      = "Trust-L3"
          source_addresses      = ["any"]
          source_zones          = ["Untrust-L3"]
          service               = "any"
        }
        translated_packet = {
          source = {
            dynamic_ip = {
              translated_addresses = ["DNS-Servers"]
              fallback = {
                interface_address = {
                  interface = "ethernet1/1"
                }
              }
            }
          }
          destination = {
            static_translation = {
              address = "2.2.2.2"
              port    = "80"
            }
          }
        }
      }
    ]
  }
  ```

  EOF
  default     = {}

  type = map(object({
    rulebase           = optional(string, "pre-rulebase")
    position_keyword   = optional(string)
    position_reference = optional(string)
    rules              = list(object({
      name            = string
      description     = optional(string)
      tags            = optional(list(string))
      type            = optional(string, "ipv4")
      disabled        = optional(bool, false)
      original_packet = object({
        destination_addresses = optional(list(string),["any"])
        destination_zone      = string
        destination_interface = optional(string, "any")
        source_addresses      = optional(list(string), ["any"])
        source_zones          = list(string)
        service               = optional(string, "any")
      })
      translated_packet = optional(object({
        destination = optional(object({
          static_translation = optional(object({
            address = optional(string)
            port    = optional(string)
          }))
          dynamic_translation = optional(object({
            address      = optional(string)
            port         = optional(string)
            distribution = optional(string)
          }))
        }))
        source = optional(object({
          dynamic_ip_and_port = optional(object({
            translated_address = optional(object({
              translated_addresses = optional(list(string))
            }))
            interface_address = optional(object({
              interface  = string
              ip_address = optional(string)
            }))
          }))
          dynamic_ip = optional(object({
            translated_addresses = list(string)
            fallback             = optional(object({
              translated_address = optional(object({
                translated_addresses = list(string)
              }))
              interface_address = optional(object({
                interface  = string
                type       = optional(string)
                ip_address = optional(string, "ip")
              }))
            }))
          }))
          static_ip = optional(object({
            translated_address = optional(string)
            bi_directional     = optional(bool)
          }))
        }))
      }))
      negate_target = optional(bool, false)
      target        = optional(list(object({
        serial    = string
        vsys_list = optional(list(string))
      })), null)
    }))
  }))
  validation {
    condition = alltrue([
      for rule_group in var.nat_policies : alltrue([
        for rule in rule_group.rules :
        contains(["ipv4", "nat64", "natv6"], coalesce(rule.type, "ipv4"))
      ])
    ])
    error_message = "Valid types of type are `ipv4`, `nat64`, `natv6`"
  }
  # validation {
  #   condition = alltrue([
  #     for rule_group in var.nat_policies : contains(["", "before", "after", "directly before", "directly after", "top", "bottom"], try(rule_group.position_keyword, ""))
  #   ])
  #   error_message = "Valid types of type are `before`, `directly before`, `after`, `directly after`, `top`, `bottom`, or left empty"
  # }
}