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

variable "template" {
  description = "Template name"
  default     = "default"
  type        = string
}

variable "template_stack" {
  description = "Template stack name"
  default     = ""
  type        = string
}

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

variable "security_policies_group" {
  description = "Security policies"
  default     = {}
  type        = any
}

variable "interfaces" {}
variable "management_profiles" {}
variable "virtual_routers" {}
variable "static_routes" {}
variable "zones" {}
variable "ike_gateways" {}
variable "ike_crypto_profiles" {}
variable "ipsec_crypto_profiles" {}
variable "ipsec_tunnels" {}
