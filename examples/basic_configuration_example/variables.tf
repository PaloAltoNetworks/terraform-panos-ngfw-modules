variable "pan_creds" {
  description = "Path to file with credentials to Panorama"
  type        = string
}

variable "mode" {
  description = "If modules have target to Panorama, it enable Panorama specific variables."
  default     = "ngfw"
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
  description = "Used in variable panorama is true, it gives possibility to choose Device Group for the deployment"
  default     = []
  type        = list(string)
}

variable "vsys" {
  description = "Used in variable panorama is true, it gives possibility to choose Device Group for the deployment"
  default     = []
  type        = list(string)
}

variable "template" {
  type = string
}

variable "template_stack" {
  type = string
}

variable "interfaces" {
}

variable "management_profiles" {
}

variable "virtual_routers" {
}

variable "zones" {
}

variable "ike_gateways" {
}

variable "ike_crypto_profiles" {
}

variable "ipsec_crypto_profiles" {
}

variable "ipsec_tunnels" {
}