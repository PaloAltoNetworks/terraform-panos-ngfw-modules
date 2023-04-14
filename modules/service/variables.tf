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
  Map of the service objects, where key is the service object's name:
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
  services = {
    WEB-APP = {
      protocol         = "tcp"
      destination_port = "80,443"
      description      = "Some web services"
    }
    SSH-8022 = {
      protocol         = "tcp"
      destination_port = "8022"
      description      = "SSH not-default port"
    }
    TCP-4457-4458 = {
      protocol         = "tcp"
      destination_port = "4457-4458"
      description      = "Custom port range"
    }    
  }
  ```
  EOF
  default     = {}
  type = map(object({
    description                  = optional(string)
    protocol                     = string
    source_port                  = optional(string)
    destination_port             = string
    tags                         = optional(list(string))
    override_session_timeout     = optional(bool)
    override_timeout             = optional(number)
    override_half_closed_timeout = optional(number)
    override_time_wait_timeout   = optional(number)
  }))
}

variable "services_group" {
  description = <<-EOF
  Map of the service groups, where key is the service group's name:
  - `members`: (required) The service objects to include in this service group.
  - `tags`: (optional) List of administrative tags.

  Example:
  ```
  services_group = {
    "Customer Group" = {
      members = ["WEB-APP", "TCP-4457-4458"]
    }
  }  
  ```  
  EOF
  default     = {}
  type = map(object({
    members = list(string)
    tags    = optional(list(string))
  }))
}
