variable "mode" {
  description = "The mode to use for the modules. Valid values are `panorama` and `ngfw`."
  type        = string
  validation {
    condition     = contains(["panorama", "ngfw"], var.mode)
    error_message = "The mode must be either `panorama` or `ngfw`."
  }
}

variable "device_group" {
  description = "Used if `var.mode` is `panorama`, defines the device group for the objects."
  default     = "shared"
  type        = string
}

variable "vsys" {
  description = "Used if `var.mode` is `ngfw`, defines the vsys for the objects."
  default     = "vsys1"
  type        = string
}

variable "addresses_bulk_mode" {
  description = "Determines whether each address object is managed as a separate `panos_address_object` resource (when set to `false`) or all within a single `panos_address_objects` resource that is dedicated for bulk operations."
  default     = false
  type        = bool
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
    value       = string
    type        = optional(string, "ip-netmask")
    description = optional(string)
    tags        = optional(list(string))
  }))
  validation {
    condition     = alltrue([for address_object in var.address_objects : contains(["ip-netmask", "ip-range", "fqdn", "ip-wildcard"], address_object.type)])
    error_message = "Valid values of type are `ip-netmask` (default), `ip-range`, `fqdn`, or `ip-wildcard`"
  }
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
