Palo Alto Networks PAN-OS Static Routes Module
---
This Terraform module allows users to configure static routes.

Usage
---

1. Create a **"main.tf"** file with the following content:

```terraform
module "static_routes" {
  source  = "PaloAltoNetworks/terraform-panos-ngfw-modules//modules/static_routes"

  mode = "panorama" # If you want to use this module with a firewall, change this to "ngfw"

  template = "test"

  static_routes = {
    "vr_default_unicast_0.0.0.0" = {
      virtual_router = "vr"
      route_table    = "unicast"
      destination    = "0.0.0.0/0"
      interface      = "ethernet1/1"
      type           = "ip-address"
      next_hop       = "10.1.1.1"
      metric         = 10
    }
    "vr_internal_unicast_10.10.10.0" = {
      virtual_router = "internal"
      route_table    = "unicast"
      destination    = "10.10.10.0/24"
      interface      = "tunnel.42"
      type           = ""
    }
    "vr_external_unicast_0.0.0.0" = {
      virtual_router = "external"
      route_table    = "unicast"
      destination    = "0.0.0.0/0"
      interface      = "ethernet1/2"
      type           = "ip-address"
      next_hop       = "10.1.2.1"
      metric         = 10
    }
  }
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
| [panos_panorama_static_route_ipv4.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/panorama_static_route_ipv4) | resource |
| [panos_static_route_ipv4.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/static_route_ipv4) | resource |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_mode"></a> [mode](#input\_mode) | The mode to use for the modules. Valid values are `panorama` and `ngfw`. | `string` | n/a | yes |
| <a name="input_mode_map"></a> [mode\_map](#input\_mode\_map) | The mode to use for the modules. Valid values are `panorama` and `ngfw`. | <pre>object({<br>    panorama = number<br>    ngfw     = number<br>  })</pre> | <pre>{<br>  "ngfw": 1,<br>  "panorama": 0<br>}</pre> | no |
| <a name="input_template"></a> [template](#input\_template) | The template name. | `string` | `"default"` | no |
| <a name="input_template_stack"></a> [template\_stack](#input\_template\_stack) | The template stack name. | `string` | `""` | no |
| <a name="input_static_routes"></a> [static\_routes](#input\_static\_routes) | Map of the static routes, where key is the unique name e.g. build in format "{virtual\_router}\_{route\_table}":<br>- `virtual_router` - (Required) The virtual router to add the static route to.<br>- `route_table` - (Optional) Target routing table to install the route. Valid values are unicast (the default), no install, multicast, or both.<br>- `destination` - (Required) Destination IP address / prefix.<br>- `interface` - (Optional) Interface to use.<br>- `type` - (Optional) The next hop type. Valid values are ip-address (the default), discard, next-vr, or an empty string for None.<br>- `next_hop` - (Optional) The value for the type setting.<br>- `admin_distance` - (Optional) The admin distance.<br>- `metric` - (Optional, int) Metric value / path cost (default: 10).<br>- `bfd_profile` - (Optional, PAN-OS 7.1+) BFD configuration.<br><br>Example:<pre>{<br>  "vr_default_unicast_0.0.0.0" = {<br>    virtual_router = "default"<br>    route_table    = "unicast"<br>    destination    = "0.0.0.0/0"<br>    interface      = "ethernet1/1"<br>    type           = "ip-address"<br>    next_hop       = "10.1.1.1"<br>    admin_distance = null<br>    metric         = 10<br>  }<br>}</pre> | <pre>map(object({<br>    virtual_router = string<br>    route_table    = optional(string, "unicast")<br>    destination    = string<br>    interface      = optional(string)<br>    type           = optional(string, "ip-address")<br>    next_hop       = optional(string)<br>    admin_distance = optional(number)<br>    metric         = optional(number, 10)<br>    bfd_profile    = optional(string)<br>  }))</pre> | `{}` | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_panorama_static_routes_ipv4"></a> [panorama\_static\_routes\_ipv4](#output\_panorama\_static\_routes\_ipv4) | n/a |
| <a name="output_static_routes_ipv4"></a> [static\_routes\_ipv4](#output\_static\_routes\_ipv4) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
