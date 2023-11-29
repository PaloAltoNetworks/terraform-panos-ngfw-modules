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

variable "ike_crypto_profiles" {
  description = <<-EOF
  Map of the IKE crypto profiles, where key is the IKE crypto profile's name:
  - `dh_groups` - (Required, list) List of DH Group entries. Values should have a prefix if group.
  - `authentications` - (Required, list) List of authentication types. This c
  - `encryptions` - (Required, list) List of encryption types. Valid values are des, 3des, aes-128-cbc, aes-192-cbc, aes-256-cbc, aes-128-gcm (PAN-OS 10.0), and aes-256-gcm (PAN-OS 10.0).
  - `lifetime_type` - The lifetime type. Valid values are seconds, minutes, hours (the default), and days.
  - `lifetime_value` - (int) The lifetime value.
  - `authentication_multiple` - (PAN-OS 7.0+, int) IKEv2 SA reauthentication interval equals authetication-multiple * rekey-lifetime; 0 means reauthentication is disabled

  Example:
  ```
  {
     "AES128_default" = {
      dh_groups               = ["group2", "group5"]
      authentications         = ["md5", "sha1"]
      encryptions             = ["aes-128-cbc", "aes-192-cbc"]
      lifetime_type           = "hours"
      lifetime_value          = 24
      authentication_multiple = 0
    }
  }
  ```
  EOF
  default     = {}
  type = map(object({
    dh_groups               = list(string)
    authentications         = list(string)
    encryptions             = list(string)
    lifetime_type           = optional(string)
    lifetime_value          = optional(number)
    authentication_multiple = optional(number)
  }))
  validation {
    condition     = alltrue([for ike_crypto_profile in var.ike_crypto_profiles : contains(["seconds", "minutes", "hours", "days"], ike_crypto_profile.lifetime_type)])
    error_message = "Valid values for the lifetime type are `seconds`, `minutes`, `hours` (the default), and `days`"
  }
  validation {
    condition     = alltrue([for ike_crypto_profile in var.ike_crypto_profiles : length(setsubtract(ike_crypto_profile.encryptions, ["des", "3des", "aes-128-cbc", "aes-192-cbc", "aes-256-cbc", "aes-128-gcm", "aes-256-gcm"])) == 0])
    error_message = "Valid values for the encryptions are `des`, `3des`, `aes-128-cbc`, `aes-192-cbc`, `aes-256-cbc`, `aes-128-gcm` (PAN-OS 10.0), and `aes-256-gcm`"
  }
}
variable "ipsec_crypto_profiles" {
  description = <<-EOF
  Map of the IPSec crypto profiles, where key is the IPSec crypto profile's name:
  - `protocol` - (Optional) The protocol. Valid values are esp (the default) or ah
  - `authentications` - (Required, list) - List of authentication types.
  - `encryptions` - (Required, list) - List of encryption types. Valid values are des, 3des, aes-128-cbc, aes-192-cbc, aes-256-cbc, aes-128-gcm, aes-256-gcm, and null. Note that the "gcm" values are only available in PAN-OS 7.0+.
  - `dh_group` - (Optional) The DH group value. Valid values should start with the string group.
  - `lifetime_type` - (Optional) The lifetime type. Valid values are seconds, minutes, hours (the default), or days.
  - `lifetime_value` - (Optional, int) The lifetime value.
  - `lifesize_type` - (Optional) The lifesize type. Valid values are kb, mb, gb, or tb.
  - `lifesize_value` - (Optional, int) the lifesize value.

  Example:
  ```
  {
    "AES128_default" = {
      protocol        = "esp"
      authentications = ["md5", "sha1"]
      encryptions     = ["aes-128-cbc", "aes-192-cbc"]
      dh_group        = "group5"
      lifetime_type   = "hours"
      lifetime_value  = 24
      lifesize_type   = null
      lifesize_value  = null
    }
  }
  ```
  EOF
  default     = {}
  type = map(object({
    protocol        = optional(string, "esp")
    authentications = list(string)
    encryptions     = list(string)
    dh_group        = optional(string)
    lifetime_type   = optional(string)
    lifetime_value  = optional(number)
    lifesize_type   = optional(string)
    lifesize_value  = optional(number)
  }))
  validation {
    condition     = alltrue([for ipsec_crypto_profile in var.ipsec_crypto_profiles : contains(["esp", "ah"], ipsec_crypto_profile.protocol)])
    error_message = "Valid values for the protocol are `esp` and `ah`"
  }
  validation {
    condition     = alltrue([for ipsec_crypto_profile in var.ipsec_crypto_profiles : contains(["seconds", "minutes", "hours", "days"], ipsec_crypto_profile.lifetime_type)])
    error_message = "Valid values for the lifetime type are `seconds`, `minutes`, `hours` (the default), and `days`"
  }
  validation {
    condition     = alltrue([for ipsec_crypto_profile in var.ipsec_crypto_profiles : contains(["kb", "mb", "gb", "tb"], coalesce(ipsec_crypto_profile.lifesize_type, "kb"))])
    error_message = "Valid values for the lifesize type are `kb`, `mb`, `gb`, or `tb`"
  }
  validation {
    condition     = alltrue([for ipsec_crypto_profile in var.ipsec_crypto_profiles : length(setsubtract(ipsec_crypto_profile.encryptions, ["des", "3des", "aes-128-cbc", "aes-192-cbc", "aes-256-cbc", "aes-128-gcm", "aes-256-gcm"])) == 0])
    error_message = "Valid values for the encryptions are `des`, `3des`, `aes-128-cbc`, `aes-192-cbc`, `aes-256-cbc`, `aes-128-gcm` and `aes-256-gcm`"
  }
}
variable "ike_gateways" {
  description = <<-EOF
  Map of the IKE gateways, where key is the IKE gateway's name:
  - `version` - (Optional, PAN-OS 7.0+) The IKE gateway version. Valid values are ikev1, (the default), ikev2, or ikev2-preferred. For PAN-OS 6.1, only ikev1 is acceptable.
  - `enable_ipv6` - (Optional, PAN-OS 7.0+, bool) Enable IPv6 or not.
  - `disabled` - (Optional, PAN-OS 7.0+, bool) Set to true to disable.
  - `peer_ip_type` - (Optional) The peer IP type. Valid values are ip, dynamic, and fqdn (PANOS 8.1+).
  - `peer_ip_value` - (Optional) The peer IP value.
  - `interface` - (Required) The interface.
  - `local_ip_address_type` - (Optional) The local IP address type. Valid values for this are ip, floating-ip, or an empty string (the default) which is None.
  - `local_ip_address_value` - (Optional) The IP address if local_ip_address_type is set to ip.
  - `auth_type` - (Optional) The auth type. Valid values are pre-shared-key (the default), or certificate.
  - `pre_shared_key` - (Optional) The pre-shared key value.
  - `local_id_type` - (Optional) The local ID type. Valid values are ipaddr, fqdn, ufqdn, keyid, or dn.
  - `local_id_value` - (Optional) The local ID value.
  - `peer_id_type` - (Optional) The peer ID type. Valid values are ipaddr, fqdn, ufqdn, keyid, or dn.
  - `peer_id_value` - (Optional) The peer ID value.
  - `peer_id_check` - (Optional) Enable peer ID wildcard match for certificate authentication. Valid values are exact or wildcard.
  - `local_cert` - (Optional) The local certificate name.
  - `cert_enable_hash_and_url` - (Optional, PAN-OS 7.0+, bool) Set to true to use hash-and-url for local certificate.
  - `cert_base_url` - (Optional) The host and directory part of URL for local certificates.
  - `cert_use_management_as_source` - (Optional, PAN-OS 7.0+, bool) Set to true to use management interface IP as source to retrieve http certificates
  - `cert_permit_payload_mismatch` - (Optional, bool) Set to true to permit peer identification and certificate payload identification mismatch.
  - `cert_profile` - (Optional) Profile for certificate valdiation during IKE negotiation.
  - `cert_enable_strict_validation` - (Optional, bool) Set to true to enable strict validation of peer's extended key use.
  - `enable_passive_mode` - (Optional, bool) Set to true to enable passive mode (responder only).
  - `enable_nat_traversal` - (Optional, bool) Set to true to enable NAT traversal.
  - `nat_traversal_keep_alive` - (Optional, int) Sending interval for NAT keep-alive packets (in seconds). For versions 6.1 - 8.1, this param, if specified, should be a multiple of 10 between 10 and 3600 to be valid.
  - `nat_traversal_enable_udp_checksum` - (Optional, bool) Set to true to enable NAT traversal UDP checksum.
  - `enable_fragmentation` - (Optional, bool) Set to true to enable fragmentation.
  - `ikev1_exchange_mode` - (Optional) The IKEv1 exchange mode.
  - `ikev1_crypto_profile` - (Optional) IKEv1 crypto profile.
  - `enable_dead_peer_detection` - (Optional, bool) Set to true to enable dead peer detection.
  - `dead_peer_detection_interval` - (Optional, int) The dead peer detection interval.
  - `dead_peer_detection_retry` - (Optional, int) Number of retries before disconnection.
  - `ikev2_crypto_profile` - (Optional, PAN-OS 7.0+) IKEv2 crypto profile.
  - `ikev2_cookie_validation` - (Optional, PAN-OS 7.0+) Set to true to require cookie.
  - `enable_liveness_check` - (Optional, , PAN-OS 7.0+bool) Set to true to enable sending empty information liveness check message.
  - `liveness_check_interval` - (Optional, , PAN-OS 7.0+int) Delay interval before sending probing packets (in seconds).

  Example:
  ```
  {
    "IKE-GW-1" = {
      version              = "ikev1"
      disabled             = false
      peer_ip_type         = "ip"
      peer_ip_value        = "5.5.5.5"
      interface            = "ethernet1/1"
      pre_shared_key       = "test12345"
      local_id_type        = "ipaddr"
      local_id_value       = "10.1.1.1"
      peer_id_type         = "ipaddr"
      peer_id_value        = "10.5.1.1"
      ikev1_crypto_profile = "AES128_default"
    }
  }
  ```
  EOF
  default     = {}
  type = map(object({
    version                           = optional(string)
    enable_ipv6                       = optional(bool)
    disabled                          = optional(bool)
    peer_ip_type                      = optional(string)
    peer_ip_value                     = optional(string)
    interface                         = string
    local_ip_address_type             = optional(string)
    local_ip_address_value            = optional(string)
    auth_type                         = optional(string, "pre-shared-key")
    pre_shared_key                    = optional(string)
    local_id_type                     = optional(string)
    local_id_value                    = optional(string)
    peer_id_type                      = optional(string)
    peer_id_value                     = optional(string)
    peer_id_check                     = optional(string)
    local_cert                        = optional(string)
    cert_enable_hash_and_url          = optional(bool)
    cert_base_url                     = optional(string)
    cert_use_management_as_source     = optional(bool)
    cert_permit_payload_mismatch      = optional(bool)
    cert_profile                      = optional(string)
    cert_enable_strict_validation     = optional(bool)
    enable_passive_mode               = optional(bool)
    enable_nat_traversal              = optional(bool)
    nat_traversal_keep_alive          = optional(number)
    nat_traversal_enable_udp_checksum = optional(bool)
    enable_fragmentation              = optional(bool)
    ikev1_exchange_mode               = optional(string)
    ikev1_crypto_profile              = optional(string)
    enable_dead_peer_detection        = optional(bool)
    dead_peer_detection_interval      = optional(number)
    dead_peer_detection_retry         = optional(number)
    ikev2_crypto_profile              = optional(string)
    ikev2_cookie_validation           = optional(bool)
    enable_liveness_check             = optional(bool)
    liveness_check_interval           = optional(number)
  }))
  validation {
    condition     = alltrue([for ike_gateway in var.ike_gateways : contains(["ikev1", "ikev2", "ikev2-preferred"], ike_gateway.version)])
    error_message = "Valid values for IKE gateway version are `ikev1`, `ikev2`, `ikev2-preferred`"
  }
  validation {
    condition     = alltrue([for ike_gateway in var.ike_gateways : contains(["ipaddr", "fqdn", "ufqdn", "keyid", "dn"], coalesce(ike_gateway.peer_id_type, "ipaddr"))])
    error_message = "If set, valid values for peer ID type are `ipaddr`, `fqdn`, `ufqdn`, `keyid`, or `dn`."
  }
  validation {
    condition     = alltrue([for ike_gateway in var.ike_gateways : contains(["ipaddr", "fqdn", "ufqdn", "keyid", "dn"], coalesce(ike_gateway.local_id_type, "ipaddr"))])
    error_message = "If set, valid values for local ID type are `ipaddr`, `fqdn`, `ufqdn`, `keyid`, or `dn`"
  }
  validation {
    condition     = alltrue([for ike_gateway in var.ike_gateways : contains(["pre-shared-key", "certificate"], ike_gateway.auth_type)])
    error_message = "Valid values for auth type are `pre-shared-key` (the default), or `certificate`"
  }
}
variable "ipsec_tunnels" {
  description = <<-EOF
  Map of the IPSec tunnels, where key is the IPSec tunnel's name:
  - `tunnel_interface` - (Required) The tunnel interface.
  - `anti_replay` - (Optional, bool) Set to true to enable Anti-Replay check on this tunnel.
  - `enable_ipv6` - (Optional, PAN-OS 7.0+, bool) Set to true to enable IPv6.
  - `copy_tos` - (Optional, bool) Set to true to copy IP TOS bits from inner packet to IPSec packet (not recommended).
  - `copy_flow_label` - (Optional, PAN-OS 7.0+, bool) Set to true to copy IPv6 flow label for 6in6 tunnel from inner packet to IPSec packet (not recommended).
  - `disabled` - (Optional, PAN-OS 7.0+, bool) Set to true to disable this IPSec tunnel.
  - `type` - (Optional) The type. Valid values are auto-key (the default), manual-key, or global-protect-satellite.
  - `ak_ike_gateway` - (Optional) IKE gateway name.
  - `ak_ipsec_crypto_profile` - (Optional) IPSec crypto profile name.
  - `mk_local_spi` - (Optional) Outbound SPI, hex format.
  - `mk_remote_spi` - (Optional) Inbound SPI, hex format.
  - `mk_local_address_ip` - (Optional) Specify exact IP address if interface has multiple addresses.
  - `mk_local_address_floating_ip` - (Optional) Floating IP address in HA Active-Active configuration.
  - `mk_protocol` - (Optional) Manual key protocol. Valid valies are esp or ah.
  - `mk_auth_type` - (Optional) Authentication algorithm. Valid values are md5, sha1, sha256, sha384, sha512, or none.
  - `mk_auth_key` - (Optional) The auth key for the given auth type.
  - `mk_esp_encryption_type` - (Optional) The encryption algorithm. Valid values are des, 3des, aes-128-cbc, aes-192-cbc, aes-256-cbc, or null.
  - `mk_esp_encryption_key` - (Optional) The encryption key.
  - `gps_interface` - (Optional) Interface to communicate with portal.
  - `gps_portal_address` - (Optional) GlobalProtect portal address.
  - `gps_prefer_ipv6` - (Optional, PAN-OS 8.0+, bool) Prefer to register the portal in IPv6. Only applicable to FQDN portal-address.
  - `gps_interface_ip_ipv4` - (Optional) specify exact IP address if interface has multiple addresses (IPv4).
  - `gps_interface_ip_ipv6` - (Optional, PAN-OS 8.0+) specify exact IP address if interface has multiple addresses (IPv6).
  - `gps_interface_floating_ip_ipv4` - (Optional, PAN-OS 7.0+) Floating IPv4 address in HA Active-Active configuration.
  - `gps_interface_floating_ip_ipv6` - (Optional, PAN-OS 8.0+) Floating IPv6 address in HA Active-Active configuration.
  - `gps_publish_connected_routes` - (Optional, bool) Set to true to to publish connected and static routes.
  - `gps_publish_routes` - (Optional, list) Specify list of routes to publish to Global Protect Gateway.
  - `gps_local_certificate` - (Optional) GlobalProtect satellite certificate file name.
  - `gps_certificate_profile` - (Optional) Profile for authenticating GlobalProtect gateway certificates.
  - `enable_tunnel_monitor` - (Optional, bool) Enable tunnel monitoring on this tunnel.
  - `tunnel_monitor_destination_ip` - (Optional) Destination IP to send ICMP probe.
  - `tunnel_monitor_source_ip` - (Optional) Source IP to send ICMP probe
  - `tunnel_monitor_profile` - (Optional) Tunnel monitor profile.
  - `tunnel_monitor_proxy_id` - (Optional, PAN-OS 7.0+) Which proxy-id (or proxy-id-v6) the monitoring traffic will use.

  Example:
  ```
  {
    "some_tunnel" = {
      virtual_router                = "internal"
      tunnel_interface              = "tunnel.42"
      type                          = "auto-key"
      disabled                      = false
      ak_ike_gateway                = "IKE-GW-1"
      ak_ipsec_crypto_profile       = "AES128_DH14"
      anti_replay                   = false
      copy_flow_label               = false
      enable_tunnel_monitor         = false
      tunnel_monitor_destination_ip = null
      tunnel_monitor_source_ip      = null
      tunnel_monitor_profile        = null
      tunnel_monitor_proxy_id       = null
      proxy_subnets                 = "example1,10.10.10.0/24,10.10.20.0/24;example2,10.10.10.0/24,10.10.30.0/24"
    }
  }
  ```
  EOF
  default     = {}
  type = map(object({
    tunnel_interface               = string
    anti_replay                    = optional(bool)
    enable_ipv6                    = optional(bool)
    copy_tos                       = optional(bool)
    copy_flow_label                = optional(bool)
    disabled                       = optional(bool)
    type                           = optional(string, "auto-key")
    ak_ike_gateway                 = optional(string)
    ak_ipsec_crypto_profile        = optional(string)
    mk_local_spi                   = optional(string)
    mk_remote_spi                  = optional(string)
    mk_local_address_ip            = optional(string)
    mk_local_address_floating_ip   = optional(string)
    mk_protocol                    = optional(string)
    mk_auth_type                   = optional(string)
    mk_auth_key                    = optional(string)
    mk_esp_encryption_type         = optional(string)
    mk_esp_encryption_key          = optional(string)
    gps_interface                  = optional(string)
    gps_portal_address             = optional(string)
    gps_prefer_ipv6                = optional(bool)
    gps_interface_ip_ipv4          = optional(string)
    gps_interface_ip_ipv6          = optional(string)
    gps_interface_floating_ip_ipv4 = optional(string)
    gps_interface_floating_ip_ipv6 = optional(string)
    gps_publish_connected_routes   = optional(bool)
    gps_publish_routes             = optional(list(string))
    gps_local_certificate          = optional(string)
    gps_certificate_profile        = optional(string)
    enable_tunnel_monitor          = optional(bool)
    tunnel_monitor_destination_ip  = optional(string)
    tunnel_monitor_source_ip       = optional(string)
    tunnel_monitor_profile         = optional(string)
    tunnel_monitor_proxy_id        = optional(string)
  }))
  validation {
    condition     = alltrue([for ipsec_tunnel in var.ipsec_tunnels : contains(["auto-key", "manual-key", "global-protect-satellite"], ipsec_tunnel.type)])
    error_message = "Valid values for type are `auto-key` (the default), `manual-key`, or `global-protect-satellite`"
  }
  validation {
    condition     = alltrue([for ipsec_tunnel in var.ipsec_tunnels : contains(["md5", "sha1", "sha256", "sha384", "sha512", "none"], coalesce(ipsec_tunnel.mk_auth_type, "md5"))])
    error_message = "Valid values for auth type are `md5`, `sha1`, `sha256`, `sha384`, `sha512`, or `none`"
  }
  validation {
    condition     = alltrue([for ipsec_tunnel in var.ipsec_tunnels : contains(["esp", "ah"], coalesce(ipsec_tunnel.mk_protocol, "esp"))])
    error_message = "Valid values for the protocol are `esp` and `ah`"
  }
  validation {
    condition     = alltrue([for ipsec_tunnel in var.ipsec_tunnels : contains(["des", "3des", "aes-128-cbc", "aes-192-cbc", "aes-256-cbc"], coalesce(ipsec_tunnel.mk_esp_encryption_type, "des"))])
    error_message = "Valid values for the encryptions are `des`, `3des`, `aes-ipsec_tunnel-cbc`, `aes-192-cbc`, `aes-256-cbc`"
  }
}
variable "ipsec_tunnel_proxies" {
  description = <<-EOF
  Map of the IPSec tunnel proxy, where key is the IPSec tunnel proxy's name:
  - `ipsec_tunnel` - (Required) The auto key IPSec tunnel to attach this proxy ID to.
  - `local` - (Optional) IP subnet or IP address represents local network.
  - `remote` - (Optional) IP subnet or IP address represents remote network.
  - `protocol_any` - (Optional, bool) Set to true for any IP protocol.
  - `protocol_number` - (Optional, int) IP protocol number.
  - `protocol_tcp_local` - (Optional, int) Local TCP port number.
  - `protocol_tcp_remote` - (Optional, int) Remote TCP port number.
  - `protocol_udp_local` - (Optional, int) Local UDP port number.
  - `protocol_udp_remote` - (Optional, int) Remote UDP port number.

  Example:
  ```
  {
    ipsec_tunnel = "some_tunnel"
  }
  ```
  EOF
  default     = {}
  type = map(object({
    ipsec_tunnel        = string
    local               = optional(string)
    remote              = optional(string)
    protocol_any        = optional(bool, true)
    protocol_number     = optional(number)
    protocol_tcp_local  = optional(number)
    protocol_tcp_remote = optional(number)
    protocol_udp_local  = optional(number)
    protocol_udp_remote = optional(number)
  }))
}
