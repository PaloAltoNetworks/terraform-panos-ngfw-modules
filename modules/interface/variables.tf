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

variable "interfaces" {
  description = <<-EOF
  Map of the interfaces objects, where key is the interface's name:
  - `type` - (Required) Type of interface. Valid values are `ethernet`,`loopback`,`tunnel`.
  - `mode` - (Required) The interface mode. This can be any of the following values: layer3, layer2, virtual-wire, tap, ha, decrypt-mirror, or aggregate-group.
  - `zone` - (Required) The zone's name
  - `virtual_router` - (Required) The virtual router's name
  - `vsys` - (Optional) The vsys that will use this interface (default: vsys1). This should be something like vsys1 or vsys3.
  - `static_ips` - (Optional) List of static IPv4 addresses to set for this data interface.
  - `enable_dhcp` - (Optional) Set to true to enable DHCP on this interface.
  - `create_dhcp_default_route` - (Optional) Set to true to create a DHCP default route.
  - `dhcp_default_route_metric` - (Optional) The metric for the DHCP default route.
  - `ipv6_enabled` - (Optional) Set to true to enable IPv6.
  - `management_profile` - (Optional) The management profile.
  - `mtu` - (Optional) The MTU.
  - `adjust_tcp_mss` - (Optional) Adjust TCP MSS (default: false).
  - `netflow_profile - (Optional) The netflow profile.
  - `lldp_enabled` - (Optional) Enable LLDP (default: false).
  - `lldp_profile` - (Optional) LLDP profile.
  - `lldp_ha_passive_pre_negotiation` - (bool) LLDP HA passive pre-negotiation.
  - `lacp_ha_passive_pre_negotiation` - (bool) LACP HA passive pre-negotiation.
  - `link_speed` - (Optional) Link speed. This can be any of the following: 10, 100, 1000, or auto.
  - `link_duplex` - (Optional) Link duplex setting. This can be full, half, or auto.
  - `link_state` - (Optional) The link state. This can be up, down, or auto.
  - `aggregate_group` - (Optional) The aggregate group (applicable for physical firewalls only).
  - `comment` - (Optional) The interface comment.
  - `lacp_port_priority` - (int) LACP port priority.
  - `ipv4_mss_adjust` - (Optional, PAN-OS 7.1+) The IPv4 MSS adjust value.
  - `ipv6_mss_adjust` - (Optional, PAN-OS 7.1+) The IPv6 MSS adjust value.
  - `decrypt_forward` - (Optional, PAN-OS 8.1+) Enable decrypt forwarding.
  - `rx_policing_rate` - (Optional, PAN-OS 8.1+) Receive policing rate in Mbps.
  - `tx_policing_rate` - (Optional, PAN-OS 8.1+) Transmit policing rate in Mbps.
  - `dhcp_send_hostname_enable` - (Optional, PAN-OS 9.0+) For DHCP layer3 interfaces: enable sending the firewall or a custom hostname to DHCP server
  - `dhcp_send_hostname_value` - (Optional, PAN-OS 9.0+) For DHCP layer3 interfaces: the interface hostname. Leaving this unspecified with dhcp_send_hostname_enable set means to send the system hostname.

  Example:
  ```
  {
    "ethernet1/1" = {
      type                      = "ethernet"
      mode                      = "layer3"
      management_profile        = "mgmt_default"
      link_state                = "up"
      enable_dhcp               = true
      create_dhcp_default_route = false
      comment                   = "mgmt"
      virtual_router            = "default"
      zone                      = "mgmt"
      vsys                      = "vsys1"
    }
  }
  ```
  EOF  
  default     = {}
  type = map(object({
    type                            = string
    mode                            = string
    zone                            = string
    virtual_router                  = string
    vsys                            = optional(string, "vsys1")
    static_ips                      = optional(list(string), [])
    enable_dhcp                     = optional(bool, false)
    create_dhcp_default_route       = optional(bool, false)
    dhcp_default_route_metric       = optional(number)
    ipv6_enabled                    = optional(bool)
    management_profile              = optional(string)
    mtu                             = optional(number)
    adjust_tcp_mss                  = optional(bool, false)
    netflow_profile                 = optional(string)
    lldp_enabled                    = optional(bool, false)
    lldp_profile                    = optional(string)
    lldp_ha_passive_pre_negotiation = optional(bool)
    lacp_ha_passive_pre_negotiation = optional(bool)
    link_speed                      = optional(string)
    link_duplex                     = optional(string)
    link_state                      = optional(string)
    aggregate_group                 = optional(string)
    comment                         = optional(string)
    lacp_port_priority              = optional(number)
    ipv4_mss_adjust                 = optional(string)
    ipv6_mss_adjust                 = optional(string)
    decrypt_forward                 = optional(bool)
    rx_policing_rate                = optional(string)
    tx_policing_rate                = optional(string)
    dhcp_send_hostname_enable       = optional(bool)
    dhcp_send_hostname_value        = optional(string)
  }))
  validation {
    condition     = (length(var.interfaces) > 0 && alltrue([for interface in var.interfaces : contains(["ethernet", "loopback", "tunnel"], interface.type)]))
    error_message = "Valid types of interfaces are `ethernet`,`loopback`,`tunnel`"
  }
  validation {
    condition     = (length(var.interfaces) > 0 && alltrue([for interface in var.interfaces : contains(["up", "down", "auto"], interface.link_state)]))
    error_message = "Valid types of link state are `up`, `down`, `auto`"
  }
}
