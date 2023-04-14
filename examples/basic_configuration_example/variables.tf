variable "pan_creds" {
  description = "Path to file with credentials to Panorama"
  type        = string
}

variable "panorama" {
  description = "Give information if Panorama is a target."
  default     = false
  type        = bool
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
  description = "Used in variable panorama is true, it gives possibility to choose Device Group for the deployment"
  default     = []
  type        = list(string)
}

variable "vsys" {
  description = "Used in variable panorama is true, it gives possibility to choose Device Group for the deployment"
  default     = []
  type        = list(string)
}