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
| [panos_management_profile.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/management_profile) | resource |
| [panos_panorama_management_profile.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/panorama_management_profile) | resource |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_mode"></a> [mode](#input\_mode) | The mode to use for the modules. Valid values are `panorama` and `ngfw`. | `string` | n/a | yes |
| <a name="input_mode_map"></a> [mode\_map](#input\_mode\_map) | The mode to use for the modules. Valid values are `panorama` and `ngfw`. | <pre>object({<br>    panorama = number<br>    ngfw     = number<br>  })</pre> | <pre>{<br>  "ngfw": 1,<br>  "panorama": 0<br>}</pre> | no |
| <a name="input_template"></a> [template](#input\_template) | The template name. | `string` | `"default"` | no |
| <a name="input_template_stack"></a> [template\_stack](#input\_template\_stack) | The template stack name. | `string` | `""` | no |
| <a name="input_management_profiles"></a> [management\_profiles](#input\_management\_profiles) | Map of the management profiles, where key is the management profile's name:<br>- `ping` - (Optional) Allow ping.<br>- `telnet` - (Optional) Allow telnet.<br>- `ssh` - (Optional) Allow SSH.<br>- `http` - (Optional) Allow HTTP.<br>- `http_ocsp` - (Optional) Allow HTTP OCSP.<br>- `https` - (Optional) Allow HTTPS.<br>- `snmp` - (Optional) Allow SNMP.<br>- `response_pages` - (Optional) Allow response pages.<br>- `userid_service` - (Optional) Allow User ID service.<br>- `userid_syslog_listener_ssl` - (Optional) Allow User ID syslog listener for SSL.<br>- `userid_syslog_listener_udp` - (Optional) Allow User ID syslog listener for UDP.<br>- `permitted_ips` - (Optional) The list of permitted IP addresses or address ranges for this management profile.<br><br>Example:<pre>{<br>  "mgmt_default" = {<br>    ping           = true<br>    telnet         = false<br>    ssh            = true<br>    http           = false<br>    https          = true<br>    snmp           = false<br>    userid_service = null<br>    permitted_ips  = ["1.1.1.1/32", "2.2.2.2/32"]<br>  }<br>}</pre> | <pre>map(object({<br>    ping                       = optional(bool)<br>    telnet                     = optional(bool)<br>    ssh                        = optional(bool)<br>    http                       = optional(bool)<br>    http_ocsp                  = optional(bool)<br>    https                      = optional(bool)<br>    snmp                       = optional(bool)<br>    response_pages             = optional(bool)<br>    userid_service             = optional(bool)<br>    userid_syslog_listener_ssl = optional(bool)<br>    userid_syslog_listener_udp = optional(bool)<br>    permitted_ips              = list(string)<br>  }))</pre> | `{}` | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_panorama_management_profiles"></a> [panorama\_management\_profiles](#output\_panorama\_management\_profiles) | n/a |
| <a name="output_management_profiles"></a> [management\_profiles](#output\_management\_profiles) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
