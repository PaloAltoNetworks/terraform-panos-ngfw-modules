variable "pan_creds" {
  description = "Path to file with credentials to Panorama"
  type        = string
}

variable "mode" {
  description = "Provide information about target."
  default     = ""
  type        = string
}

variable "tags" {
  description = "Tags object"
  default     = {}
  type        = any
}

variable "addresses" {
  description = "Address object"
  default     = {}
  type        = any
}

variable "address_groups" {
  description = "Address groups object"
  default     = {}
  type        = any
}

variable "services" {
  description = "Service object"
  default     = {}
  type        = any
}

variable "services_group" {
  description = "Service group object"
  default     = {}
  type        = any
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

variable "mode_map" {
  description = "The mode to use for the modules. Valid values are `panorama` and `ngfw`."
  default = {
    panorama = 0
    ngfw     = 1
    # cloud_manager = 2 # Not yet supported
  }
  type = object({
    panorama = number
    ngfw = number
  })
}

variable "security_policies" {
  description = "Security policies"
  default = {}
  type = any
}
