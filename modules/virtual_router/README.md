<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.4.0, < 2.0.0 |
| <a name="requirement_panos"></a> [panos](#requirement\_panos) | ~> 1.11.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_panos"></a> [panos](#provider\_panos) | ~> 1.11.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [panos_virtual_router.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/virtual_router) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_mode"></a> [mode](#input\_mode) | The mode to use for the modules. Valid values are `panorama` and `ngfw`. | `string` | n/a | yes |
| <a name="input_mode_map"></a> [mode\_map](#input\_mode\_map) | The mode to use for the modules. Valid values are `panorama` and `ngfw`. | <pre>object({<br>    panorama = number<br>    ngfw     = number<br>  })</pre> | <pre>{<br>  "ngfw": 1,<br>  "panorama": 0<br>}</pre> | no |
| <a name="input_template"></a> [template](#input\_template) | The template name. | `string` | `"default"` | no |
| <a name="input_template_stack"></a> [template\_stack](#input\_template\_stack) | The template stack name. | `string` | `""` | no |
| <a name="input_virtual_routers"></a> [virtual\_routers](#input\_virtual\_routers) | Map of the virtual routers, where key is the virtual router's name:<br>- `vsys` - The vsys (default: vsys1)<br>- `static_dist - (int) Admin distance - Static (default: 10).<br>- `static\_ipv6\_dist - (int) Admin distance - Static IPv6 (default: 10).<br>- `ospf_int_dist - (int) Admin distance - OSPF Int (default: 30).<br>- `ospf\_ext\_dist - (int) Admin distance - OSPF Ext (default: 110).<br>- `ospfv3_int_dist - (int) Admin distance - OSPFv3 Int (default: 30).<br>- `ospfv3\_ext\_dist - (int) Admin distance - OSPFv3 Ext (default: 110).<br>- `ibgp_dist - (int) Admin distance - IBGP (default: 200).<br>- `ebgp\_dist - (int) Admin distance - EBGP (default: 20).<br>- `rip_dist - (int) Admin distance - RIP (default: 120).<br>- `enable\_ecmp - (bool) Enable ECMP.<br>- `ecmp_max_path - (int) Maximum number of ECMP paths supported.<br>- `ecmp\_symmetric\_return - (bool) Allows return packets to egress out of the ingress interface of the flow.<br>- `ecmp_strict_source_path - (bool) Force VPN traffic to exit interface that the source-ip belongs to.<br>- `ecmp\_load\_balance\_method - Load balancing algorithm. Valid values are ip-modulo, ip-hash, weighted-round-robin, or balanced-round-robin.<br>- `ecmp_hash_source_only - (bool) For ecmp_load_balance_method = ip-hash: Only use source address for hash.<br>- `ecmp\_hash\_use\_port - (bool) For ecmp\_load\_balance\_method = ip-hash: Use source/destination port for hash.<br>- `ecmp_hash_seed - (int) For ecmp_load_balance_method = ip-hash: User-specified hash seed.<br>- `ecmp\_weighted\_round\_robin\_interfaces - (Map of ints) For ecmp\_load\_balance\_method = weighted-round-robin: Interface weight used in weighted ECMP load balancing.<br><br>Example:<pre>{<br>  "default" = {}<br>}</pre> | <pre>map(object({<br>    vsys                                 = optional(string, "vsys1")<br>    static_dist                          = optional(number, 10)<br>    static_ipv6_dist                     = optional(number, 10)<br>    ospf_int_dist                        = optional(number, 30)<br>    ospf_ext_dist                        = optional(number, 110)<br>    ospfv3_int_dist                      = optional(number, 30)<br>    ospfv3_ext_dist                      = optional(number, 110)<br>    ibgp_dist                            = optional(number, 200)<br>    ebgp_dist                            = optional(number, 20)<br>    rip_dist                             = optional(number, 120)<br>    enable_ecmp                          = optional(bool)<br>    ecmp_max_path                        = optional(number)<br>    ecmp_symmetric_return                = optional(bool)<br>    ecmp_strict_source_path              = optional(bool)<br>    ecmp_load_balance_method             = optional(string)<br>    ecmp_hash_source_only                = optional(bool)<br>    ecmp_hash_use_port                   = optional(bool)<br>    ecmp_hash_seed                       = optional(number)<br>    ecmp_weighted_round_robin_interfaces = optional(map(number))<br>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_panos_virtual_router"></a> [panos\_virtual\_router](#output\_panos\_virtual\_router) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
