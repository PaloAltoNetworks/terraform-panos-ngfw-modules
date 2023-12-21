Palo Alto Networks PAN-OS Tags Module
---
This Terraform module allows users to configure tags.

Usage
---

1. Create a **"main.tf"** file with the following content:

```terraform
module "tags" {
  source  = "PaloAltoNetworks/terraform-panos-ngfw-modules//modules/tags"

  mode = "panorama" # If you want to use this module with a firewall, change this to "ngfw"

  device_group = "test"
  tags         = {
    DNS-SRV = {
      comment = "Tag for DNS servers"
    }
    DNS-SRV-2 = {
      comment = "Tag for DNS servers-2"
    }
    "Managed by Terraform" = {
      comment = "Managed by Terraform"
    }
    Outbound = {
      color   = "Cyan"
      comment = "Outbound"
    }
    Inbound = {
      color   = "Light Green"
      comment = "Inbound"
    }
    AWS-Route53-Health-Probe = {
      color = "Gold"
    }
    PSN = {
      color   = "Brown"
      comment = "PSN"
    }
    dns-proxy = {
      color   = "Olive"
      comment = "dns-proxy"
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
| [panos_administrative_tag.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/administrative_tag) | resource |
| [panos_panorama_administrative_tag.this](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/panorama_administrative_tag) | resource |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_mode"></a> [mode](#input\_mode) | The mode to use for the modules. Valid values are `panorama` and `ngfw`. | `string` | n/a | yes |
| <a name="input_device_group"></a> [device\_group](#input\_device\_group) | Used if _mode_ is panorama, this defines the Device Group for the deployment | `string` | `"shared"` | no |
| <a name="input_vsys"></a> [vsys](#input\_vsys) | Used if _mode_ is ngfw, this defines the vsys for the deployment | `string` | `"vsys1"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of the tag objects, where key is the tag object's name:<br>- `color`: (optional) The tag's color. This should either be an empty string (no color) or a string such as `Red`, `Green` etc. (full list of supported colors is available in [provider documentation](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/administrative_tag)).<br>- `comment`: (optional) The description of the administrative tag.<br><br>Example:<pre>tags = {<br>  DNS-SRV = {<br>    comment = "Tag for DNS servers"<br>  }<br>  dns-proxy = {<br>    color   = "Olive"<br>    comment = "dns-proxy"<br>  }<br>}</pre> | <pre>map(object({<br>    color   = optional(string)<br>    comment = optional(string)<br>  }))</pre> | `{}` | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_panorama_administrative_tags"></a> [panorama\_administrative\_tags](#output\_panorama\_administrative\_tags) | n/a |
| <a name="output_panos_administrative_tag"></a> [panos\_administrative\_tag](#output\_panos\_administrative\_tag) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->