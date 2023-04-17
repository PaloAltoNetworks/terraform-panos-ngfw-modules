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

variable "template" {
  description = "The template name."
  default     = "default"
  type        = string
}

variable "template_stack" {
  description = "The template stack name."
  default     = ""
  type        = string
}

variable "management_profiles" {
  description = <<-EOF
  Map of the management profiles, where key is the management profile's name:
  - `name` - (Required) The management profile's name.
  - `ping` - (Optional) Allow ping.
  - `telnet` - (Optional) Allow telnet.
  - `ssh` - (Optional) Allow SSH.
  - `http` - (Optional) Allow HTTP.
  - `http_ocsp` - (Optional) Allow HTTP OCSP.
  - `https` - (Optional) Allow HTTPS.
  - `snmp` - (Optional) Allow SNMP.
  - `response_pages` - (Optional) Allow response pages.
  - `userid_service` - (Optional) Allow User ID service.
  - `userid_syslog_listener_ssl` - (Optional) Allow User ID syslog listener for SSL.
  - `userid_syslog_listener_udp` - (Optional) Allow User ID syslog listener for UDP.
  - `permitted_ips` - (Optional) The list of permitted IP addresses or address ranges for this management profile.

  Example:
  ```
  {
    "mgmt_default" = {
      ping           = true
      telnet         = false
      ssh            = true
      http           = false
      https          = true
      snmp           = false
      userid_service = null
      permitted_ips  = ["1.1.1.1/32", "2.2.2.2/32"]
    }
  }
  ```
  EOF
  default     = {}
  type = map(object({
    ping                       = optional(bool)
    telnet                     = optional(bool)
    ssh                        = optional(bool)
    http                       = optional(bool)
    http_ocsp                  = optional(bool)
    https                      = optional(bool)
    snmp                       = optional(bool)
    response_pages             = optional(bool)
    userid_service             = optional(bool)
    userid_syslog_listener_ssl = optional(bool)
    userid_syslog_listener_udp = optional(bool)
    permitted_ips              = list(string)
  }))
}
