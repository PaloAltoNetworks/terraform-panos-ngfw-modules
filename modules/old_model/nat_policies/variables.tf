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

variable "panorama" {
  description = "If modules have target to Panorama, it enable Panorama specific variables."
  default     = false
  type        = bool
}