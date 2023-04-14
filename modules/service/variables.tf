variable "panorama" {
  description = "If modules have target to Panorama, it enable Panorama specific variables."
  default     = false
  type        = bool
}

#tags
variable "tags" {
  description = <<-EOF
  List of tag objects.
  - `name`: (required) The administrative tag's name.
  - `device_group`: (optional) The device group location (default: `shared`).
  - `comment`: (optional) The description of the administrative tag.
  - `color`: (optional) The tag's color. This should either be an empty string (no color) or a string such as `color1`. Note that the colors go from 1 to 16.

  Example:
  ```
[
  {
    name = "trust"
  }
  {
    name = "untrust"
    comment = "for untrusted zones"
    color = "color4"
  }
  {
    name = "AWS"
    device_group = "AWS"
    color = "color8"
  }
]
  ```
  EOF
  default     = []
  type        = any

}

#services
variable "services" {
  description = <<-EOF
  List of service objects.
  - `name`: (required) The service object's name.
  - `device_group`: (optional) The device group location (default: `shared`).
  - `description`: (optional) The description of the service object.
  - `protocol`: (required) The service's protocol. Valid values are `tcp`, `udp`, or `sctp` (only for PAN-OS 8.1+).
  - `source_port`: (optional) The source port. This can be a single port number, range (1-65535), or comma separated (80,8080,443).
  - `destination_port`: (required) The destination port. This can be a single port number, range (1-65535), or comma separated (80,8080,443).
  - `tags`: (optional) List of administrative tags.
  - `override_session_timeout`: (optional) Boolean to override the default application timeouts (default: `false`). Only available for PAN-OS 8.1+.
  - `override_timeout`: (optional) Integer for the overridden timeout if TCP protocol selected. Only available for PAN-OS 8.1+.
  - `override_half_closed_timeout`: (optional) Integer for the overridden half closed timeout if TCP protocol selected. Only available for PAN-OS 8.1+.
  - `override_time_wait_timeout`: (optional) Integer for the overridden wait time if TCP protocol selected. Only available for PAN-OS 8.1+.

  Example:
  ```
  [
    {
      name = "service1"
      protocol = "tcp"
      destination_port = "8080"
      source_port = "400"
      override_session_timeout = true
      override_timeout = 250
      override_time_wait_timeout = 590
    }
    {
      name = "service2"
      protocol = "udp"
      destination_port = "80"
    }
  ]
  ```
  EOF
  default     = []
  type        = any

}

variable "services_group" {
  description = <<-EOF
  List of the address group objects.
  - `name`: (required) The address group's name.
  - `device_group`: (optional) The device group location (default: `shared`).
  - `services`: (optional) The service objects to include in this service group.
  - `tags`: (optional) List of administrative tags.
  EOF
  default     = []
  type        = any

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

variable "tag_color_map" {
  description = "Map of tag-color match, [provider documentation](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/administrative_tag)"
  default = {
    red            = "color1"
    green          = "color2"
    blue           = "color3"
    yellow         = "color4"
    copper         = "color5"
    orange         = "color6"
    purple         = "color7"
    gray           = "color8"
    light_green    = "color9"
    cyan           = "color10"
    light_gray     = "color11"
    blue_gray      = "color12"
    lime           = "color13"
    black          = "color14"
    gold           = "color15"
    brown          = "color16"
    olive          = "color17"
    maroon         = "color19"
    red_orange     = "color20"
    yellow_orange  = "color21"
    forest_green   = "color22"
    turquoise_blue = "color23"
    azure_blue     = "color24"
    cerulean_blue  = "color25"
    midnight_blue  = "color26"
    medium_blue    = "color27"
    cobalt_blue    = "color28"
    violet_blue    = "color29"
    blue_violet    = "color30"
    medium_violet  = "color31"
    medium_rose    = "color32"
    lavender       = "color33"
    orchid         = "color34"
    thistle        = "color35"
    peach          = "color36"
    salmon         = "color37"
    magenta        = "color38"
    red_violet     = "color39"
    mahogany       = "color40"
    burnt_sienna   = "color41"
    chestnut       = "color42"
  }
  type = any
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