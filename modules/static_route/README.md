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
| [panos_panorama_static_route_ipv4.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/panorama_static_route_ipv4) | resource |
| [panos_static_route_ipv4.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/static_route_ipv4) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_mode"></a> [mode](#input\_mode) | The mode to use for the modules. Valid values are `panorama` and `ngfw`. | `string` | n/a | yes |
| <a name="input_mode_map"></a> [mode\_map](#input\_mode\_map) | The mode to use for the modules. Valid values are `panorama` and `ngfw`. | <pre>object({<br>    panorama = number<br>    ngfw     = number<br>  })</pre> | <pre>{<br>  "ngfw": 1,<br>  "panorama": 0<br>}</pre> | no |
| <a name="input_static_routes"></a> [static\_routes](#input\_static\_routes) | Map of the static route, where key is the unique name e.g. build in format "{virtual\_router}\_{route\_table}":<br>- `virtual_router` - (Required) The virtual router to add the static route to.<br>- `route_table` - (Optional) Target routing table to install the route. Valid values are unicast (the default), no install, multicast, or both.<br>- `routes` - (Optional) Map of routes, where every route is an object with attributes:<br>  - `destination` - (Required) Destination IP address / prefix.<br>  - `interface` - (Optional) Interface to use.<br>  - `type` - (Optional) The next hop type. Valid values are ip-address (the default), discard, next-vr, or an empty string for None.<br>  - `next_hop` - (Optional) The value for the type setting.<br>  - `admin_distance` - (Optional) The admin distance.<br>  - `metric` - (Optional, int) Metric value / path cost (default: 10).<br>  - `bfd_profile` - (Optional, PAN-OS 7.1+) BFD configuration.<br><br>Example:<pre>{<br>  "default_unicast" = {<br>    virtual_router = "default"<br>    route_table    = "unicast"<br>    routes = {<br>      "df_route" = {<br>        destination    = "0.0.0.0/0"<br>        interface      = "ethernet1/1"<br>        type           = "ip-address"<br>        next_hop       = "10.1.1.1"<br>        admin_distance = null<br>        metric         = 10<br>      }<br>    }<br>  }<br>}</pre> | <pre>map(object({<br>    virtual_router = string<br>    route_table    = optional(string, "unicast")<br>    routes = map(object({<br>      destination    = string<br>      interface      = optional(string)<br>      type           = optional(string, "ip-address")<br>      next_hop       = optional(string)<br>      admin_distance = optional(number)<br>      metric         = optional(number, 10)<br>      bfd_profile    = optional(string)<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_template"></a> [template](#input\_template) | The template name. | `string` | `"default"` | no |
| <a name="input_template_stack"></a> [template\_stack](#input\_template\_stack) | The template stack name. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_panos_panorama_static_route_ipv4"></a> [panos\_panorama\_static\_route\_ipv4](#output\_panos\_panorama\_static\_route\_ipv4) | n/a |
| <a name="output_panos_static_route_ipv4"></a> [panos\_static\_route\_ipv4](#output\_panos\_static\_route\_ipv4) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
