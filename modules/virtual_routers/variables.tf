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

variable "virtual_routers" {
  description = <<-EOF
  Map of the virtual routers, where key is the virtual router's name:
  - `vsys` - The vsys (default: vsys1)
  - `interfaces` - List of interfaces that should use this VR. Leave this undefined if the association is managed by `interfaces` module (using `panos_virtual_router_entry` resource).
  - `static_dist` - (int) Admin distance - Static (default: 10).
  - `static_ipv6_dist` - (int) Admin distance - Static IPv6 (default: 10).
  - `ospf_int_dist` - (int) Admin distance - OSPF Int (default: 30).
  - `ospf_ext_dist` - (int) Admin distance - OSPF Ext (default: 110).
  - `ospfv3_int_dist` - (int) Admin distance - OSPFv3 Int (default: 30).
  - `ospfv3_ext_dist` - (int) Admin distance - OSPFv3 Ext (default: 110).
  - `ibgp_dist` - (int) Admin distance - IBGP (default: 200).
  - `ebgp_dist` - (int) Admin distance - EBGP (default: 20).
  - `rip_dist` - (int) Admin distance - RIP (default: 120).
  - `enable_ecmp` - (bool) Enable ECMP.
  - `ecmp_max_path` - (int) Maximum number of ECMP paths supported.
  - `ecmp_symmetric_return` - (bool) Allows return packets to egress out of the ingress interface of the flow.
  - `ecmp_strict_source_path` - (bool) Force VPN traffic to exit interface that the source-ip belongs to.
  - `ecmp_load_balance_method` - Load balancing algorithm. Valid values are ip-modulo, ip-hash, weighted-round-robin, or balanced-round-robin.
  - `ecmp_hash_source_only` - (bool) For ecmp_load_balance_method = ip-hash: Only use source address for hash.
  - `ecmp_hash_use_port` - (bool) For ecmp_load_balance_method = ip-hash: Use source/destination port for hash.
  - `ecmp_hash_seed` - (int) For ecmp_load_balance_method = ip-hash: User-specified hash seed.
  - `ecmp_weighted_round_robin_interfaces` - (Map of ints) For ecmp_load_balance_method = weighted-round-robin: Interface weight used in weighted ECMP load balancing.
  - `static_routes` - (map(object)) - Map with static routes to create in the VR. Each route supports following settings:
    - `destination` - (string) Destination IP address / prefix.
    - `interface` - (string) Interface to use.
    - `next_hop` - (sting) The value for the type setting.
    - `route_table` - (string) Target routing table to install the route. Valid values are unicast (the default), no install, multicast, or both.
    - `type` - (string) The next hop type. Valid values are ip-address (the default), discard, next-vr, or an empty string for None.
    - `admin_distance` - (int) The admin distance.
    - `metric` - (int) Metric value / path cost (default: 10).
    - `bfd_profile` - (string) BFD configuration (PAN-OS 7.1+).

  Example:
  ```
  {
    "default" = {}
    "vr-with-route" = {
      static_routes = {
        default = {
          destination = "0.0.0.0/0"
          next_hop    = "10.0.0.1"
          type        = "ip-address"
        }
      }
    }
  }
  ```
  EOF
  default     = {}
  type = map(object({
    vsys                                 = optional(string, "vsys1")
    interfaces                           = optional(list(string))
    static_dist                          = optional(number, 10)
    static_ipv6_dist                     = optional(number, 10)
    ospf_int_dist                        = optional(number, 30)
    ospf_ext_dist                        = optional(number, 110)
    ospfv3_int_dist                      = optional(number, 30)
    ospfv3_ext_dist                      = optional(number, 110)
    ibgp_dist                            = optional(number, 200)
    ebgp_dist                            = optional(number, 20)
    rip_dist                             = optional(number, 120)
    enable_ecmp                          = optional(bool)
    ecmp_max_path                        = optional(number)
    ecmp_symmetric_return                = optional(bool)
    ecmp_strict_source_path              = optional(bool)
    ecmp_load_balance_method             = optional(string)
    ecmp_hash_source_only                = optional(bool)
    ecmp_hash_use_port                   = optional(bool)
    ecmp_hash_seed                       = optional(number)
    ecmp_weighted_round_robin_interfaces = optional(map(number))
    static_routes = optional(map(object({
      destination    = string
      interface      = optional(string)
      next_hop       = optional(string)
      route_table    = optional(string, "unicast")
      type           = optional(string, "ip-address")
      admin_distance = optional(number)
      metric         = optional(number, 10)
      bfd_profile    = optional(string)
    })), {})
  }))

  validation {
    condition     = alltrue([for vr in var.virtual_routers : contains(["ip-modulo", "ip-hash", "weighted-round-robin", "balanced-round-robin"], coalesce(vr.ecmp_load_balance_method, "ip-modulo"))])
    error_message = "Valid types of ECMP load balance method are `ip-modulo`, `ip-hash`, `weighted-round-robin`, or `balanced-round-robin`."
  }
  validation {
    condition = alltrue(flatten([
      for vr in var.virtual_routers : [
        for r in vr.static_routes : contains(["unicast", "no install", "multicast", "both"], r.route_table)
      ]
    ]))
    error_message = "Valid values of route's 'route_table' are `unicast` (the default), `no install`, `multicast`, or `both`."
  }
  validation {
    condition = alltrue(flatten([
      for vr in var.virtual_routers : [
        for r in vr.static_routes : contains(["ip-address", "discard", "next-vr", ""], r.type)
      ]
    ]))
    error_message = "Valid values of route's 'type' are `ip-address` (the default), `discard`, `next-vr`, or an empty string for None."
  }
  validation {
    condition = alltrue(flatten([
      for vr in var.virtual_routers : [
        for r in vr.static_routes : contains(["ip-address", "next-vr"], r.type) ? try(r.next_hop, null) != null : true
      ]
    ]))
    error_message = "Routes of type 'ip-address' and 'next-vr' require 'next_hop' to be set."
  }
}
