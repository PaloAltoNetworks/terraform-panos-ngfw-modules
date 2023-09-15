Palo Alto Networks PAN-OS IPSec Module
---
This Terraform module allows users to configure IPSec.

Usage
---

1. Create a **"main.tf"** file with the following content:

```terraform
module "ipsec" {
  source  = "PaloAltoNetworks/terraform-panos-ngfw-modules//modules/ipsec"

  mode = "panorama" # If you want to use this module with a firewall, change this to "ngfw"

  template = "test"

  ike_crypto_profiles   = {
    "AES128_default" = {
        dh_groups               = ["group2", "group5"]
        authentications         = ["md5", "sha1"]
        encryptions             = ["aes-128-cbc", "aes-192-cbc"]
        lifetime_type           = "hours"
        lifetime_value          = 24
        authentication_multiple = 0
    }
    "AES128_DH5" = {
        dh_groups               = ["group5"]
        authentications         = ["sha1"]
        encryptions             = ["aes-128-cbc", "aes-192-cbc"]
        lifetime_type           = "hours"
        lifetime_value          = 8
        authentication_multiple = 3
    }
  }
  ipsec_crypto_profiles = {
    "AES128_default" = {
        protocol        = "esp"
        authentications = ["md5", "sha1"]
        encryptions     = ["aes-128-cbc", "aes-192-cbc"]
        dh_group        = "group5"
        lifetime_type   = "hours"
        lifetime_value  = 24
    }
    "AES128_DH14" = {
        protocol        = "esp"
        authentications = ["sha1"]
        encryptions     = ["aes-128-cbc", "aes-192-cbc"]
        dh_group        = "group14"
        lifetime_type   = "hours"
        lifetime_value  = 24

    }
  }
  ike_gateways          = {
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
  ipsec_tunnels         = {
    "some_tunnel" = {
        virtual_router          = "internal"
        tunnel_interface        = "tunnel.42"
        type                    = "auto-key"
        disabled                = false
        ak_ike_gateway          = "IKE-GW-1"
        ak_ipsec_crypto_profile = "AES128_DH14"
        anti_replay             = false
        copy_flow_label         = false
        enable_tunnel_monitor   = false
        proxy_subnets           = "example1,10.10.10.0/24,10.10.20.0/24;example2,10.10.10.0/24,10.10.30.0/24"
    }
  }
  ipsec_tunnel_proxies  = {}
}
```

2. Run Terraform

```
terraform init
terraform apply
terraform output
```

Cleanup
---

```
terraform destroy
```

Compatibility
---
This module is meant for use with **PAN-OS >= 10.2** and **Terraform >= 1.4.0**


Reference
---
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.4.0, < 2.0.0 |
| <a name="requirement_panos"></a> [panos](#requirement\_panos) | ~> 1.11.1 |

### Providers

| Name | Version |
|------|---------|
| <a name="provider_panos"></a> [panos](#provider\_panos) | ~> 1.11.1 |

### Modules

No modules.

### Resources

| Name | Type |
|------|------|
| [panos_ike_crypto_profile.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/ike_crypto_profile) | resource |
| [panos_ike_gateway.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/ike_gateway) | resource |
| [panos_ipsec_crypto_profile.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/ipsec_crypto_profile) | resource |
| [panos_ipsec_tunnel.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/ipsec_tunnel) | resource |
| [panos_ipsec_tunnel_proxy_id_ipv4.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/ipsec_tunnel_proxy_id_ipv4) | resource |
| [panos_panorama_ike_gateway.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/panorama_ike_gateway) | resource |
| [panos_panorama_ipsec_crypto_profile.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/panorama_ipsec_crypto_profile) | resource |
| [panos_panorama_ipsec_tunnel.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/panorama_ipsec_tunnel) | resource |
| [panos_panorama_ipsec_tunnel_proxy_id_ipv4.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/panorama_ipsec_tunnel_proxy_id_ipv4) | resource |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_mode"></a> [mode](#input\_mode) | The mode to use for the modules. Valid values are `panorama` and `ngfw`. | `string` | n/a | yes |
| <a name="input_mode_map"></a> [mode\_map](#input\_mode\_map) | The mode to use for the modules. Valid values are `panorama` and `ngfw`. | <pre>object({<br>    panorama = number<br>    ngfw     = number<br>  })</pre> | <pre>{<br>  "ngfw": 1,<br>  "panorama": 0<br>}</pre> | no |
| <a name="input_template"></a> [template](#input\_template) | The template name. | `string` | `"default"` | no |
| <a name="input_template_stack"></a> [template\_stack](#input\_template\_stack) | The template stack name. | `string` | `""` | no |
| <a name="input_ike_crypto_profiles"></a> [ike\_crypto\_profiles](#input\_ike\_crypto\_profiles) | Map of the IKE crypto profiles, where key is the IKE crypto profile's name:<br>- `dh_groups` - (Required, list) List of DH Group entries. Values should have a prefix if group.<br>- `authentications` - (Required, list) List of authentication types. This c<br>- `encryptions` - (Required, list) List of encryption types. Valid values are des, 3des, aes-128-cbc, aes-192-cbc, aes-256-cbc, aes-128-gcm (PAN-OS 10.0), and aes-256-gcm (PAN-OS 10.0).<br>- `lifetime_type` - The lifetime type. Valid values are seconds, minutes, hours (the default), and days.<br>- `lifetime_value` - (int) The lifetime value.<br>- `authentication_multiple` - (PAN-OS 7.0+, int) IKEv2 SA reauthentication interval equals authetication-multiple * rekey-lifetime; 0 means reauthentication is disabled<br><br>Example:<pre>{<br>   "AES128_default" = {<br>    dh_groups               = ["group2", "group5"]<br>    authentications         = ["md5", "sha1"]<br>    encryptions             = ["aes-128-cbc", "aes-192-cbc"]<br>    lifetime_type           = "hours"<br>    lifetime_value          = 24<br>    authentication_multiple = 0<br>  }<br>}</pre> | <pre>map(object({<br>    dh_groups               = list(string)<br>    authentications         = list(string)<br>    encryptions             = list(string)<br>    lifetime_type           = optional(string)<br>    lifetime_value          = optional(number)<br>    authentication_multiple = optional(number)<br>  }))</pre> | `{}` | no |
| <a name="input_ipsec_crypto_profiles"></a> [ipsec\_crypto\_profiles](#input\_ipsec\_crypto\_profiles) | Map of the IPSec crypto profiles, where key is the IPSec crypto profile's name:<br>- `protocol` - (Optional) The protocol. Valid values are esp (the default) or ah<br>- `authentications` - (Required, list) - List of authentication types.<br>- `encryptions` - (Required, list) - List of encryption types. Valid values are des, 3des, aes-128-cbc, aes-192-cbc, aes-256-cbc, aes-128-gcm, aes-256-gcm, and null. Note that the "gcm" values are only available in PAN-OS 7.0+.<br>- `dh_group` - (Optional) The DH group value. Valid values should start with the string group.<br>- `lifetime_type` - (Optional) The lifetime type. Valid values are seconds, minutes, hours (the default), or days.<br>- `lifetime_value` - (Optional, int) The lifetime value.<br>- `lifesize_type` - (Optional) The lifesize type. Valid values are kb, mb, gb, or tb.<br>- `lifesize_value` - (Optional, int) the lifesize value.<br><br>Example:<pre>{<br>  "AES128_default" = {<br>    protocol        = "esp"<br>    authentications = ["md5", "sha1"]<br>    encryptions     = ["aes-128-cbc", "aes-192-cbc"]<br>    dh_group        = "group5"<br>    lifetime_type   = "hours"<br>    lifetime_value  = 24<br>    lifesize_type   = null<br>    lifesize_value  = null<br>  }<br>}</pre> | <pre>map(object({<br>    protocol        = optional(string, "esp")<br>    authentications = list(string)<br>    encryptions     = list(string)<br>    dh_group        = optional(string)<br>    lifetime_type   = optional(string)<br>    lifetime_value  = optional(number)<br>    lifesize_type   = optional(string)<br>    lifesize_value  = optional(number)<br>  }))</pre> | `{}` | no |
| <a name="input_ike_gateways"></a> [ike\_gateways](#input\_ike\_gateways) | Map of the IKE gateways, where key is the IKE gateway's name:<br>- `version` - (Optional, PAN-OS 7.0+) The IKE gateway version. Valid values are ikev1, (the default), ikev2, or ikev2-preferred. For PAN-OS 6.1, only ikev1 is acceptable.<br>- `enable_ipv6` - (Optional, PAN-OS 7.0+, bool) Enable IPv6 or not.<br>- `disabled` - (Optional, PAN-OS 7.0+, bool) Set to true to disable.<br>- `peer_ip_type` - (Optional) The peer IP type. Valid values are ip, dynamic, and fqdn (PANOS 8.1+).<br>- `peer_ip_value` - (Optional) The peer IP value.<br>- `interface` - (Required) The interface.<br>- `local_ip_address_type` - (Optional) The local IP address type. Valid values for this are ip, floating-ip, or an empty string (the default) which is None.<br>- `local_ip_address_value` - (Optional) The IP address if local\_ip\_address\_type is set to ip.<br>- `auth_type` - (Optional) The auth type. Valid values are pre-shared-key (the default), or certificate.<br>- `pre_shared_key` - (Optional) The pre-shared key value.<br>- `local_id_type` - (Optional) The local ID type. Valid values are ipaddr, fqdn, ufqdn, keyid, or dn.<br>- `local_id_value` - (Optional) The local ID value.<br>- `peer_id_type` - (Optional) The peer ID type. Valid values are ipaddr, fqdn, ufqdn, keyid, or dn.<br>- `peer_id_value` - (Optional) The peer ID value.<br>- `peer_id_check` - (Optional) Enable peer ID wildcard match for certificate authentication. Valid values are exact or wildcard.<br>- `local_cert` - (Optional) The local certificate name.<br>- `cert_enable_hash_and_url` - (Optional, PAN-OS 7.0+, bool) Set to true to use hash-and-url for local certificate.<br>- `cert_base_url` - (Optional) The host and directory part of URL for local certificates.<br>- `cert_use_management_as_source` - (Optional, PAN-OS 7.0+, bool) Set to true to use management interface IP as source to retrieve http certificates<br>- `cert_permit_payload_mismatch` - (Optional, bool) Set to true to permit peer identification and certificate payload identification mismatch.<br>- `cert_profile` - (Optional) Profile for certificate valdiation during IKE negotiation.<br>- `cert_enable_strict_validation` - (Optional, bool) Set to true to enable strict validation of peer's extended key use.<br>- `enable_passive_mode` - (Optional, bool) Set to true to enable passive mode (responder only).<br>- `enable_nat_traversal` - (Optional, bool) Set to true to enable NAT traversal.<br>- `nat_traversal_keep_alive` - (Optional, int) Sending interval for NAT keep-alive packets (in seconds). For versions 6.1 - 8.1, this param, if specified, should be a multiple of 10 between 10 and 3600 to be valid.<br>- `nat_traversal_enable_udp_checksum` - (Optional, bool) Set to true to enable NAT traversal UDP checksum.<br>- `enable_fragmentation` - (Optional, bool) Set to true to enable fragmentation.<br>- `ikev1_exchange_mode` - (Optional) The IKEv1 exchange mode.<br>- `ikev1_crypto_profile` - (Optional) IKEv1 crypto profile.<br>- `enable_dead_peer_detection` - (Optional, bool) Set to true to enable dead peer detection.<br>- `dead_peer_detection_interval` - (Optional, int) The dead peer detection interval.<br>- `dead_peer_detection_retry` - (Optional, int) Number of retries before disconnection.<br>- `ikev2_crypto_profile` - (Optional, PAN-OS 7.0+) IKEv2 crypto profile.<br>- `ikev2_cookie_validation` - (Optional, PAN-OS 7.0+) Set to true to require cookie.<br>- `enable_liveness_check` - (Optional, , PAN-OS 7.0+bool) Set to true to enable sending empty information liveness check message.<br>- `liveness_check_interval` - (Optional, , PAN-OS 7.0+int) Delay interval before sending probing packets (in seconds).<br><br>Example:<pre>{<br>  "IKE-GW-1" = {<br>    version              = "ikev1"<br>    disabled             = false<br>    peer_ip_type         = "ip"<br>    peer_ip_value        = "5.5.5.5"<br>    interface            = "ethernet1/1"<br>    pre_shared_key       = "test12345"<br>    local_id_type        = "ipaddr"<br>    local_id_value       = "10.1.1.1"<br>    peer_id_type         = "ipaddr"<br>    peer_id_value        = "10.5.1.1"<br>    ikev1_crypto_profile = "AES128_default"<br>  }<br>}</pre> | <pre>map(object({<br>    version                           = optional(string)<br>    enable_ipv6                       = optional(bool)<br>    disabled                          = optional(bool)<br>    peer_ip_type                      = optional(string)<br>    peer_ip_value                     = optional(string)<br>    interface                         = string<br>    local_ip_address_type             = optional(string)<br>    local_ip_address_value            = optional(string)<br>    auth_type                         = optional(string, "pre-shared-key")<br>    pre_shared_key                    = optional(string)<br>    local_id_type                     = optional(string)<br>    local_id_value                    = optional(string)<br>    peer_id_type                      = optional(string)<br>    peer_id_value                     = optional(string)<br>    peer_id_check                     = optional(string)<br>    local_cert                        = optional(string)<br>    cert_enable_hash_and_url          = optional(bool)<br>    cert_base_url                     = optional(string)<br>    cert_use_management_as_source     = optional(bool)<br>    cert_permit_payload_mismatch      = optional(bool)<br>    cert_profile                      = optional(string)<br>    cert_enable_strict_validation     = optional(bool)<br>    enable_passive_mode               = optional(bool)<br>    enable_nat_traversal              = optional(bool)<br>    nat_traversal_keep_alive          = optional(number)<br>    nat_traversal_enable_udp_checksum = optional(bool)<br>    enable_fragmentation              = optional(bool)<br>    ikev1_exchange_mode               = optional(string)<br>    ikev1_crypto_profile              = optional(string)<br>    enable_dead_peer_detection        = optional(bool)<br>    dead_peer_detection_interval      = optional(number)<br>    dead_peer_detection_retry         = optional(number)<br>    ikev2_crypto_profile              = optional(string)<br>    ikev2_cookie_validation           = optional(bool)<br>    enable_liveness_check             = optional(bool)<br>    liveness_check_interval           = optional(number)<br>  }))</pre> | `{}` | no |
| <a name="input_ipsec_tunnels"></a> [ipsec\_tunnels](#input\_ipsec\_tunnels) | Map of the IPSec tunnels, where key is the IPSec tunnel's name:<br>- `tunnel_interface` - (Required) The tunnel interface.<br>- `anti_replay` - (Optional, bool) Set to true to enable Anti-Replay check on this tunnel.<br>- `enable_ipv6` - (Optional, PAN-OS 7.0+, bool) Set to true to enable IPv6.<br>- `copy_tos` - (Optional, bool) Set to true to copy IP TOS bits from inner packet to IPSec packet (not recommended).<br>- `copy_flow_label` - (Optional, PAN-OS 7.0+, bool) Set to true to copy IPv6 flow label for 6in6 tunnel from inner packet to IPSec packet (not recommended).<br>- `disabled` - (Optional, PAN-OS 7.0+, bool) Set to true to disable this IPSec tunnel.<br>- `type` - (Optional) The type. Valid values are auto-key (the default), manual-key, or global-protect-satellite.<br>- `ak_ike_gateway` - (Optional) IKE gateway name.<br>- `ak_ipsec_crypto_profile` - (Optional) IPSec crypto profile name.<br>- `mk_local_spi` - (Optional) Outbound SPI, hex format.<br>- `mk_remote_spi` - (Optional) Inbound SPI, hex format.<br>- `mk_local_address_ip` - (Optional) Specify exact IP address if interface has multiple addresses.<br>- `mk_local_address_floating_ip` - (Optional) Floating IP address in HA Active-Active configuration.<br>- `mk_protocol` - (Optional) Manual key protocol. Valid valies are esp or ah.<br>- `mk_auth_type` - (Optional) Authentication algorithm. Valid values are md5, sha1, sha256, sha384, sha512, or none.<br>- `mk_auth_key` - (Optional) The auth key for the given auth type.<br>- `mk_esp_encryption_type` - (Optional) The encryption algorithm. Valid values are des, 3des, aes-128-cbc, aes-192-cbc, aes-256-cbc, or null.<br>- `mk_esp_encryption_key` - (Optional) The encryption key.<br>- `gps_interface` - (Optional) Interface to communicate with portal.<br>- `gps_portal_address` - (Optional) GlobalProtect portal address.<br>- `gps_prefer_ipv6` - (Optional, PAN-OS 8.0+, bool) Prefer to register the portal in IPv6. Only applicable to FQDN portal-address.<br>- `gps_interface_ip_ipv4` - (Optional) specify exact IP address if interface has multiple addresses (IPv4).<br>- `gps_interface_ip_ipv6` - (Optional, PAN-OS 8.0+) specify exact IP address if interface has multiple addresses (IPv6).<br>- `gps_interface_floating_ip_ipv4` - (Optional, PAN-OS 7.0+) Floating IPv4 address in HA Active-Active configuration.<br>- `gps_interface_floating_ip_ipv6` - (Optional, PAN-OS 8.0+) Floating IPv6 address in HA Active-Active configuration.<br>- `gps_publish_connected_routes` - (Optional, bool) Set to true to to publish connected and static routes.<br>- `gps_publish_routes` - (Optional, list) Specify list of routes to publish to Global Protect Gateway.<br>- `gps_local_certificate` - (Optional) GlobalProtect satellite certificate file name.<br>- `gps_certificate_profile` - (Optional) Profile for authenticating GlobalProtect gateway certificates.<br>- `enable_tunnel_monitor` - (Optional, bool) Enable tunnel monitoring on this tunnel.<br>- `tunnel_monitor_destination_ip` - (Optional) Destination IP to send ICMP probe.<br>- `tunnel_monitor_source_ip` - (Optional) Source IP to send ICMP probe<br>- `tunnel_monitor_profile` - (Optional) Tunnel monitor profile.<br>- `tunnel_monitor_proxy_id` - (Optional, PAN-OS 7.0+) Which proxy-id (or proxy-id-v6) the monitoring traffic will use.<br><br>Example:<pre>{<br>  "some_tunnel" = {<br>    virtual_router                = "internal"<br>    tunnel_interface              = "tunnel.42"<br>    type                          = "auto-key"<br>    disabled                      = false<br>    ak_ike_gateway                = "IKE-GW-1"<br>    ak_ipsec_crypto_profile       = "AES128_DH14"<br>    anti_replay                   = false<br>    copy_flow_label               = false<br>    enable_tunnel_monitor         = false<br>    tunnel_monitor_destination_ip = null<br>    tunnel_monitor_source_ip      = null<br>    tunnel_monitor_profile        = null<br>    tunnel_monitor_proxy_id       = null<br>    proxy_subnets                 = "example1,10.10.10.0/24,10.10.20.0/24;example2,10.10.10.0/24,10.10.30.0/24"<br>  }<br>}</pre> | <pre>map(object({<br>    tunnel_interface               = string<br>    anti_replay                    = optional(bool)<br>    enable_ipv6                    = optional(bool)<br>    copy_tos                       = optional(bool)<br>    copy_flow_label                = optional(bool)<br>    disabled                       = optional(bool)<br>    type                           = optional(string, "auto-key")<br>    ak_ike_gateway                 = optional(string)<br>    ak_ipsec_crypto_profile        = optional(string)<br>    mk_local_spi                   = optional(string)<br>    mk_remote_spi                  = optional(string)<br>    mk_local_address_ip            = optional(string)<br>    mk_local_address_floating_ip   = optional(string)<br>    mk_protocol                    = optional(string)<br>    mk_auth_type                   = optional(string)<br>    mk_auth_key                    = optional(string)<br>    mk_esp_encryption_type         = optional(string)<br>    mk_esp_encryption_key          = optional(string)<br>    gps_interface                  = optional(string)<br>    gps_portal_address             = optional(string)<br>    gps_prefer_ipv6                = optional(bool)<br>    gps_interface_ip_ipv4          = optional(string)<br>    gps_interface_ip_ipv6          = optional(string)<br>    gps_interface_floating_ip_ipv4 = optional(string)<br>    gps_interface_floating_ip_ipv6 = optional(string)<br>    gps_publish_connected_routes   = optional(bool)<br>    gps_publish_routes             = optional(list(string))<br>    gps_local_certificate          = optional(string)<br>    gps_certificate_profile        = optional(string)<br>    enable_tunnel_monitor          = optional(bool)<br>    tunnel_monitor_destination_ip  = optional(string)<br>    tunnel_monitor_source_ip       = optional(string)<br>    tunnel_monitor_profile         = optional(string)<br>    tunnel_monitor_proxy_id        = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_ipsec_tunnel_proxies"></a> [ipsec\_tunnel\_proxies](#input\_ipsec\_tunnel\_proxies) | Map of the IPSec tunnel proxy, where key is the IPSec tunnel proxy's name:<br>- `ipsec_tunnel` - (Required) The auto key IPSec tunnel to attach this proxy ID to.<br>- `local` - (Optional) IP subnet or IP address represents local network.<br>- `remote` - (Optional) IP subnet or IP address represents remote network.<br>- `protocol_any` - (Optional, bool) Set to true for any IP protocol.<br>- `protocol_number` - (Optional, int) IP protocol number.<br>- `protocol_tcp_local` - (Optional, int) Local TCP port number.<br>- `protocol_tcp_remote` - (Optional, int) Remote TCP port number.<br>- `protocol_udp_local` - (Optional, int) Local UDP port number.<br>- `protocol_udp_remote` - (Optional, int) Remote UDP port number.<br><br>Example:<pre>{<br>  ipsec_tunnel = "some_tunnel"<br>}</pre> | <pre>map(object({<br>    ipsec_tunnel        = string<br>    local               = optional(string)<br>    remote              = optional(string)<br>    protocol_any        = optional(bool, true)<br>    protocol_number     = optional(number)<br>    protocol_tcp_local  = optional(number)<br>    protocol_tcp_remote = optional(number)<br>    protocol_udp_local  = optional(number)<br>    protocol_udp_remote = optional(number)<br>  }))</pre> | `{}` | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_ike_crypto_profiles"></a> [ike\_crypto\_profiles](#output\_ike\_crypto\_profiles) | n/a |
| <a name="output_panorama_ipsec_crypto_profiles"></a> [panorama\_ipsec\_crypto\_profiles](#output\_panorama\_ipsec\_crypto\_profiles) | n/a |
| <a name="output_ipsec_crypto_profiles"></a> [ipsec\_crypto\_profiles](#output\_ipsec\_crypto\_profiles) | n/a |
| <a name="output_panorama_ike_gateways"></a> [panorama\_ike\_gateways](#output\_panorama\_ike\_gateways) | n/a |
| <a name="output_ike_gateways"></a> [ike\_gateways](#output\_ike\_gateways) | n/a |
| <a name="output_panorama_ipsec_tunnels"></a> [panorama\_ipsec\_tunnels](#output\_panorama\_ipsec\_tunnels) | n/a |
| <a name="output_ipsec_tunnels"></a> [ipsec\_tunnels](#output\_ipsec\_tunnels) | n/a |
| <a name="output_panorama_ipsec_tunnel_proxy_ids_ipv4"></a> [panorama\_ipsec\_tunnel\_proxy\_ids\_ipv4](#output\_panorama\_ipsec\_tunnel\_proxy\_ids\_ipv4) | n/a |
| <a name="output_ipsec_tunnel_proxy_ids_ipv4"></a> [ipsec\_tunnel\_proxy\_ids\_ipv4](#output\_ipsec\_tunnel\_proxy\_ids\_ipv4) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
