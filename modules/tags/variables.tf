variable "mode" {
  description = "The mode to use for the modules. Valid values are `panorama` and `ngfw`."
  type        = string
  validation {
    condition     = contains(["panorama", "ngfw"], var.mode)
    error_message = "The mode must be either `panorama` or `ngfw`."
  }
}

variable "device_group" {
  description = "Used if _mode_ is panorama, this defines the Device Group for the deployment"
  default     = "shared"
  type        = string
}

variable "vsys" {
  description = "Used if _mode_ is ngfw, this defines the vsys for the deployment"
  default     = "vsys1"
  type        = string
}

variable "tags" {
  description = <<-EOF
  Map of the tag objects, where key is the tag object's name:
  - `color`: (optional) The tag's color. This should either be an empty string (no color) or a string such as `Red`, `Green` etc. (full list of supported colors is available in [provider documentation](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/administrative_tag)).
  - `comment`: (optional) The description of the administrative tag.

  Example:
  ```
  tags = {
    DNS-SRV = {
      comment = "Tag for DNS servers"
    }
    dns-proxy = {
      color   = "Olive"
      comment = "dns-proxy"
    }
  }
  ```
  EOF
  default     = {}
  type = map(object({
    color   = optional(string)
    comment = optional(string)
  }))
}
