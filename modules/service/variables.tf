variable "panorama" {
  description = "If modules have target to Panorama, it enable Panorama specific variables."
  default     = false
  type        = bool
}

variable "device_group" {
  description = "Used in variable panorama is true, it gives possibility to choose Device Group for the deployment"
  default     = ["shared"]
  type        = list(string)
}

variable "vsys" {
  description = "Used in variable panorama is false, it gives possibility to choose Virtual System for the deployment"
  default     = ["vsys1"]
  type        = list(string)
}

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
