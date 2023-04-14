variable "panorama" {
  description = "If modules have target to Panorama, it enable Panorama specific variables."
  default     = false
  type        = bool
}

#address
variable "addr_obj" {
  description = <<-EOF
  List of the address objects.
  - `name`: (required) The address object's name.
  - `device_group`: (optional) The device group location (default: `shared`).
  - `description`: (optional) The description of the address object.
  - `type`: (optional) The type of address object. Valid values are `ip-netmask`, `ip-range`, `fqdn`, or `ip-wildcard` (only available with PAN-OS 9.0+) (default: `ip-netmask).
  - `value`: (required) The address object's value. This can take various forms depending on what type of address object this is, but can be something like `192.168.80.150` or `192.168.80.0/24`.
  - `tags`: (optional) List of administrative tags.

  Example:
  ```
  [
    {
      name = "azure_int_lb_priv_ip"
      type = "ip-netmask"
      value = {
        "ip-netmask = "10.100.4.40/32"
      }
      tags = ["trust"]
      device_group = "AZURE"
    }
    {
      name = "pa_updates"
      type = "fqdn"
      value = {
        fqdn = "updates.paloaltonetworks.com"
      }
      description = "palo alto updates"
    }
    {
      name = "ntp1"
      type = "ip-range"
      value = {
        ip-range = "10.0.0.2-10.0.0.10"
      }
    }
  ]
  ```
  EOF
  default     = []
  type        = any

}

variable "addr_group" {
  description = <<-EOF
  List of the address group objects.
  - `name`: (required) The address group's name.
  - `device_group`: (optional) The device group location (default: `shared`).
  - `description`: (optional) The description of the address group.
  - `static_addresses`: (optional) The address objects to include in this statically defined address group.
  - `dynamic_match`: (optional) The IP tags to include in this DAG. Inputs are structured as follows `'<tag name>' and ...` or `<tag name>` or ...`.
  - `tags`: (optional) List of administrative tags.

  Example:
  ```
  [
    {
      name = "static ntp grp"
      description": "ntp servers"
      static_addresses = ["ntp1", "ntp2"]
    }
    {
      name = "trust and internal grp",
      description = "dynamic servers",
      dynamic_match = "'trust'and'internal'",
      tags = ["trust"]
    }
  ]
  ```
  EOF

  default = []
  type    = any

}

variable "device_group" {
  description = "Used in variable panorama is true, it gives possibility to choose Device Group for the deployment"
  default     = ["shared"]
  type        = list(string)
}

variable "vsys" {
  description = "Used in variable panorama is true, it gives possibility to choose Device Group for the deployment"
  default     = ["vsys1"]
  type        = list(string)
}