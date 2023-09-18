Palo Alto Networks PAN-OS Services Module
---
This Terraform module allows users to configure services.

Usage
---

1. Create a **"main.tf"** file with the following content:

```terraform
module "services" {
  source  = "PaloAltoNetworks/terraform-panos-ngfw-modules//modules/services"

  mode = "panorama" # If you want to use this module with a firewall, change this to "ngfw"

  device_group = "test"
  services     = {
    SomeWeb = {
      protocol         = "tcp"
      destination_port = "80,443"
      description      = "Some web services"
    }
    SomeFTP = {
      protocol         = "tcp"
      destination_port = "21"
      description      = "Some FTP services"
    }
    SomeSSH = {
      protocol         = "tcp"
      destination_port = "21"
      description      = "Some SSH services"
    }
    SSH-8022 = {
      protocol         = "tcp"
      destination_port = "8022"
      description      = "SSH not-default port"
    }
    Web-8080 = {
      protocol         = "tcp"
      destination_port = "8080"
      description      = "HTTP not-default port"
    }
    tcp_4450 = {
      protocol         = "tcp"
      destination_port = "4450"
      description      = "Custom ports for PSN Services"
    }
    tcp_4457-4458 = {
      protocol         = "tcp"
      destination_port = "4457-4458"
      description      = "Custom ports for PSN Services"
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
| [panos_panorama_service_group.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/panorama_service_group) | resource |
| [panos_panorama_service_object.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/panorama_service_object) | resource |
| [panos_service_group.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/service_group) | resource |
| [panos_service_object.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/service_object) | resource |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_mode"></a> [mode](#input\_mode) | The mode to use for the modules. Valid values are `panorama` and `ngfw`. | `string` | n/a | yes |
| <a name="input_mode_map"></a> [mode\_map](#input\_mode\_map) | The mode to use for the modules. Valid values are `panorama` and `ngfw`. | <pre>object({<br>    panorama = number<br>    ngfw     = number<br>  })</pre> | <pre>{<br>  "ngfw": 1,<br>  "panorama": 0<br>}</pre> | no |
| <a name="input_device_group"></a> [device\_group](#input\_device\_group) | Used if _mode_ is panorama, this defines the Device Group for the deployment | `string` | `"shared"` | no |
| <a name="input_vsys"></a> [vsys](#input\_vsys) | Used if _mode_ is ngfw, this defines the vsys for the deployment | `string` | `"vsys1"` | no |
| <a name="input_services"></a> [services](#input\_services) | Map of the service objects, where key is the service object's name:<br>- `description`: (optional) The description of the service object.<br>- `protocol`: (required) The service's protocol. Valid values are `tcp`, `udp`, or `sctp` (only for PAN-OS 8.1+).<br>- `source_port`: (optional) The source port. This can be a single port number, range (1-65535), or comma separated (80,8080,443).<br>- `destination_port`: (required) The destination port. This can be a single port number, range (1-65535), or comma separated (80,8080,443).<br>- `tags`: (optional) List of administrative tags.<br>- `override_session_timeout`: (optional) Boolean to override the default application timeouts (default: `false`). Only available for PAN-OS 8.1+.<br>- `override_timeout`: (optional) Integer for the overridden timeout if TCP protocol selected. Only available for PAN-OS 8.1+.<br>- `override_half_closed_timeout`: (optional) Integer for the overridden half closed timeout if TCP protocol selected. Only available for PAN-OS 8.1+.<br>- `override_time_wait_timeout`: (optional) Integer for the overridden wait time if TCP protocol selected. Only available for PAN-OS 8.1+.<br><br>Example:<pre>services = {<br>  WEB-APP = {<br>    protocol         = "tcp"<br>    destination_port = "80,443"<br>    description      = "Some web services"<br>  }<br>  SSH-8022 = {<br>    protocol         = "tcp"<br>    destination_port = "8022"<br>    description      = "SSH not-default port"<br>  }<br>  TCP-4457-4458 = {<br>    protocol         = "tcp"<br>    destination_port = "4457-4458"<br>    description      = "Custom port range"<br>  }<br>}</pre> | <pre>map(object({<br>    description                  = optional(string)<br>    protocol                     = string<br>    source_port                  = optional(string)<br>    destination_port             = string<br>    tags                         = optional(list(string))<br>    override_session_timeout     = optional(bool)<br>    override_timeout             = optional(number)<br>    override_half_closed_timeout = optional(number)<br>    override_time_wait_timeout   = optional(number)<br>  }))</pre> | `{}` | no |
| <a name="input_service_groups"></a> [service\_groups](#input\_service\_groups) | Map of the service groups, where key is the service group's name:<br>- `members`: (required) The service objects to include in this service group.<br>- `tags`: (optional) List of administrative tags.<br><br>Example:<pre>service_groups = {<br>  "Customer Group" = {<br>    members = ["WEB-APP", "TCP-4457-4458"]<br>  }<br>}</pre> | <pre>map(object({<br>    members = list(string)<br>    tags    = optional(list(string))<br>  }))</pre> | `{}` | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_panorama_service_groups"></a> [panorama\_service\_groups](#output\_panorama\_service\_groups) | n/a |
| <a name="output_service_groups"></a> [service\_groups](#output\_service\_groups) | n/a |
| <a name="output_panorama_services"></a> [panorama\_services](#output\_panorama\_services) | n/a |
| <a name="output_services"></a> [services](#output\_services) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->