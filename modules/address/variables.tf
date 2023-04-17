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

variable "address_objects" {
  description = <<-EOF
  Map of the address objects, where key is the address object's name:
  - `type`: (optional) The type of address object. This can be ip-netmask (default), ip-range, fqdn, or ip-wildcard (PAN-OS 9.0+).
  - `value`: (required) The address object's value. This can take various forms depending on what type of address object this is, but can be something like 192.168.80.150 or 192.168.80.0/24.
  - `description`: (optional) The description of the address object.
  - `tags`: (optional) List of administrative tags.

  Example:
  ```
  {
    DNS-TAGS-1 = {
      value       = "1.1.1.1/32"
      type        = "ip-netmask"
      description = "DNS Server 1"
      tags        = ["DNS-SRV"]
    },
    PA-UPDATES = {
      type        = "fqdn"
      value       = "updates.paloaltonetworks.com"
      description = "Palo Alto updates"
    },
    NTP-RANGE-1 = {
      name  = "ntp1"
      type  = "ip-range"
      value = "10.0.0.2-10.0.0.10"
    }
  }
  ```
  EOF
  default     = {}
  type = map(object({
    type        = optional(string, "ip-netmask")
    value       = string
    description = optional(string)
    tags        = optional(list(string))
  }))
}

variable "address_groups" {
  description = <<-EOF
  Map of the address group objects, where key is the address group's name:
  - `members`: (optional) The address objects to include in this statically defined address group.
  - `dynamic_match`: (optional) The IP tags to include in this DAG. Inputs are structured as follows `'<tag name>' and ...` or `<tag name>` or ...`.
  - `description`: (optional) The description of the address group.
  - `tags`: (optional) List of administrative tags.

  Example:
  ```
  {
    AddressDeviceGroup = {
      members     = ["DNS1", "DNS2"]
      description = "DNS servers"
    }
    grp-dns-proxy = {
      dynamic_match = "dns-proxy'"
    }
  }
  ```
  EOF

  default = {}
  type = map(object({
    members       = optional(list(string))
    dynamic_match = optional(string)
    description   = optional(string)
    tags          = optional(list(string))
  }))
}
