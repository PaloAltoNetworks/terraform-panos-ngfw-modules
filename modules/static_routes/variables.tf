variable "mode" {
  description = "The mode to use for the modules. Valid values are `panorama` and `ngfw`."
  type        = string
  validation {
    condition     = contains(["panorama", "ngfw"], var.mode)
    error_message = "The mode must be either `panorama` or `ngfw`."
  }
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

variable "static_routes" {
  description = <<-EOF
  Map of the static routes, where key is the unique name e.g. build in format "{virtual_router}_{route_table}":
  - `virtual_router` - (Required) The virtual router to add the static route to.
  - `route_table` - (Optional) Target routing table to install the route. Valid values are unicast (the default), no install, multicast, or both.
  - `destination` - (Required) Destination IP address / prefix.
  - `interface` - (Optional) Interface to use.
  - `type` - (Optional) The next hop type. Valid values are ip-address (the default), discard, next-vr, or an empty string for None.
  - `next_hop` - (Optional) The value for the type setting.
  - `admin_distance` - (Optional) The admin distance.
  - `metric` - (Optional, int) Metric value / path cost (default: 10).
  - `bfd_profile` - (Optional, PAN-OS 7.1+) BFD configuration.

  Example:
  ```
  {
    "vr_default_unicast_0.0.0.0" = {
      virtual_router = "default"
      route_table    = "unicast"
      destination    = "0.0.0.0/0"
      interface      = "ethernet1/1"
      type           = "ip-address"
      next_hop       = "10.1.1.1"
      admin_distance = null
      metric         = 10
    }
  }
  ```
  EOF
  default     = {}
  type = map(object({
    virtual_router = string
    route_table    = optional(string, "unicast")
    destination    = string
    interface      = optional(string)
    type           = optional(string, "ip-address")
    next_hop       = optional(string)
    admin_distance = optional(number)
    metric         = optional(number, 10)
    bfd_profile    = optional(string)
  }))
  validation {
    condition     = alltrue(flatten([for static_route in var.static_routes : contains(["unicast", "no install", "multicast", "both"], static_route.route_table)]))
    error_message = "Valid values of route tables are `unicast` (the default), `no install`, `multicast`, or `both`"
  }
  validation {
    condition     = alltrue(flatten([for static_route in var.static_routes : contains(["ip-address", "discard", "next-vr", ""], static_route.type)]))
    error_message = "Valid values type in route are `ip-address` (the default), `discard`, `next-vr`, or an empty string for None"
  }
}
