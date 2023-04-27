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

variable "device_groups" {
  description = <<-EOF
  Map of device group where the key is name of the device group.
  - `serial` - (Required) The serial number of the firewall.
  - `parent` - (Optional) The parent device group name. Leaving this empty / unspecified means to move this device group under the "shared" device group.
  - `vsys_list` - (Optional) A subset of all available vsys on the firewall that should be in this device group. If the firewall is a virtual firewall, then this parameter should just be omitted.

```
{
  "aws-test-dg" = {
    description = "Device group used for AWS cloud"
    device_group_entries = {
    serial = "1111222233334444"
    parent = "clouds"
  }
}
```

EOF

  default = {}
  type = map(object({
    description = string
    parent      = optional(string)
    serial      = optional(list(string), [])
    vsys_list   = optional(list(string), [])
  }))
}