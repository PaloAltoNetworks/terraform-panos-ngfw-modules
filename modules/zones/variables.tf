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

variable "template" {
  description = "The template name."
  default     = "default"
  type        = string
}

variable "template_stack" {
  description = "The template stack name."
  default     = ""
  type        = string
}

variable "zones" {
  description = <<-EOF
  Map of the zones, where key is the zone's name:
  - `vsys` - The vsys (default: vsys1)
  - `mode` - (Required) The zone's mode. This can be layer3, layer2, virtual-wire, tap, or tunnel.
  - `zone_profile` - The zone protection profile.
  - `log_setting` - Log setting.
  - `enable_user_id` - Boolean to enable user identification.
  - `interfaces` - List of interfaces to associated with this zone. Leave this undefined if you want to use panos_zone_entry resources.
  - `include_acls` - Users from these addresses/subnets will be identified. This can be an address object, an address group, a single IP address, or an IP address subnet.
  - `exclude_acls` - Users from these addresses/subnets will not be identified. This can be an address object, an address group, a single IP address, or an IP address subnet.

  Example:
  ```
  {
    "default" = {}
  }
  ```
  EOF
  default     = {}
  type = map(object({
    vsys           = optional(string, "vsys1")
    mode           = optional(string)
    zone_profile   = optional(string)
    log_setting    = optional(string)
    enable_user_id = optional(bool)
    interfaces     = optional(list(string))
    include_acls   = optional(list(string))
    exclude_acls   = optional(list(string))
  }))
  validation {
    condition     = alltrue([for zone in var.zones : contains(["layer3", "layer2", "virtual-wire", "tap", "tunnel"], zone.mode)])
    error_message = "Valid types of zone's mode are `layer3`, `layer2`, `virtual-wire`, `tap`, or `tunnel``"
  }
}
