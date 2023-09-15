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
| [panos_panorama_static_route_ipv4.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/panorama_static_route_ipv4) | resource |
| [panos_static_route_ipv4.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/static_route_ipv4) | resource |
| [panos_virtual_router.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/virtual_router) | resource |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_mode"></a> [mode](#input\_mode) | The mode to use for the modules. Valid values are `panorama` and `ngfw`. | `string` | n/a | yes |
| <a name="input_mode_map"></a> [mode\_map](#input\_mode\_map) | The mode to use for the modules. Valid values are `panorama` and `ngfw`. | <pre>object({<br>    panorama = number<br>    ngfw     = number<br>  })</pre> | <pre>{<br>  "ngfw": 1,<br>  "panorama": 0<br>}</pre> | no |
| <a name="input_template"></a> [template](#input\_template) | The template name. | `string` | `"default"` | no |
| <a name="input_template_stack"></a> [template\_stack](#input\_template\_stack) | The template stack name. | `string` | `""` | no |
| <a name="input_virtual_routers"></a> [virtual\_routers](#input\_virtual\_routers) | Map of the virtual routers, where key is the virtual router's name:<br>- `vsys` - The vsys (default: vsys1)<br>- `interfaces` - List of interfaces that should use this VR. Leave this undefined if the association is managed by `interfaces` module (using `panos_virtual_router_entry` resource).<br>- `static_dist` - (int) Admin distance - Static (default: 10).<br>- `static_ipv6_dist` - (int) Admin distance - Static IPv6 (default: 10).<br>- `ospf_int_dist` - (int) Admin distance - OSPF Int (default: 30).<br>- `ospf_ext_dist` - (int) Admin distance - OSPF Ext (default: 110).<br>- `ospfv3_int_dist` - (int) Admin distance - OSPFv3 Int (default: 30).<br>- `ospfv3_ext_dist` - (int) Admin distance - OSPFv3 Ext (default: 110).<br>- `ibgp_dist` - (int) Admin distance - IBGP (default: 200).<br>- `ebgp_dist` - (int) Admin distance - EBGP (default: 20).<br>- `rip_dist` - (int) Admin distance - RIP (default: 120).<br>- `enable_ecmp` - (bool) Enable ECMP.<br>- `ecmp_max_path` - (int) Maximum number of ECMP paths supported.<br>- `ecmp_symmetric_return` - (bool) Allows return packets to egress out of the ingress interface of the flow.<br>- `ecmp_strict_source_path` - (bool) Force VPN traffic to exit interface that the source-ip belongs to.<br>- `ecmp_load_balance_method` - Load balancing algorithm. Valid values are ip-modulo, ip-hash, weighted-round-robin, or balanced-round-robin.<br>- `ecmp_hash_source_only` - (bool) For ecmp\_load\_balance\_method = ip-hash: Only use source address for hash.<br>- `ecmp_hash_use_port` - (bool) For ecmp\_load\_balance\_method = ip-hash: Use source/destination port for hash.<br>- `ecmp_hash_seed` - (int) For ecmp\_load\_balance\_method = ip-hash: User-specified hash seed.<br>- `ecmp_weighted_round_robin_interfaces` - (Map of ints) For ecmp\_load\_balance\_method = weighted-round-robin: Interface weight used in weighted ECMP load balancing.<br>- `static_routes` - (map(object)) - Map with static routes to create in the VR. Each route supports following settings:<br>  - `destination` - (string) Destination IP address / prefix.<br>  - `interface` - (string) Interface to use.<br>  - `next_hop` - (sting) The value for the type setting.<br>  - `route_table` - (string) Target routing table to install the route. Valid values are unicast (the default), no install, multicast, or both.<br>  - `type` - (string) The next hop type. Valid values are ip-address (the default), discard, next-vr, or an empty string for None.<br>  - `admin_distance` - (int) The admin distance.<br>  - `metric` - (int) Metric value / path cost (default: 10).<br>  - `bfd_profile` - (string) BFD configuration (PAN-OS 7.1+).<br><br>Example:<pre>{<br>  "default" = {}<br>  "vr-with-route" = {<br>    static_routes = {<br>      default = {<br>        destination = "0.0.0.0/0"<br>        next_hop    = "10.0.0.1"<br>        type        = "ip-address"<br>      }<br>    }<br>  }<br>}</pre> | <pre>map(object({<br>    vsys                                 = optional(string, "vsys1")<br>    interfaces                           = optional(list(string))<br>    static_dist                          = optional(number, 10)<br>    static_ipv6_dist                     = optional(number, 10)<br>    ospf_int_dist                        = optional(number, 30)<br>    ospf_ext_dist                        = optional(number, 110)<br>    ospfv3_int_dist                      = optional(number, 30)<br>    ospfv3_ext_dist                      = optional(number, 110)<br>    ibgp_dist                            = optional(number, 200)<br>    ebgp_dist                            = optional(number, 20)<br>    rip_dist                             = optional(number, 120)<br>    enable_ecmp                          = optional(bool)<br>    ecmp_max_path                        = optional(number)<br>    ecmp_symmetric_return                = optional(bool)<br>    ecmp_strict_source_path              = optional(bool)<br>    ecmp_load_balance_method             = optional(string)<br>    ecmp_hash_source_only                = optional(bool)<br>    ecmp_hash_use_port                   = optional(bool)<br>    ecmp_hash_seed                       = optional(number)<br>    ecmp_weighted_round_robin_interfaces = optional(map(number))<br>    static_routes = optional(map(object({<br>      destination    = string<br>      interface      = optional(string)<br>      next_hop       = optional(string)<br>      route_table    = optional(string, "unicast")<br>      type           = optional(string, "ip-address")<br>      admin_distance = optional(number)<br>      metric         = optional(number, 10)<br>      bfd_profile    = optional(string)<br>    })), {})<br>  }))</pre> | `{}` | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_virtual_routers"></a> [virtual\_routers](#output\_virtual\_routers) | n/a |
| <a name="output_panorama_static_routes_ipv4"></a> [panorama\_static\_routes\_ipv4](#output\_panorama\_static\_routes\_ipv4) | n/a |
| <a name="output_static_routes_ipv4"></a> [static\_routes\_ipv4](#output\_static\_routes\_ipv4) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
