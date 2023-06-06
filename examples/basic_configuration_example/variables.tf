variable "device_groups" {
  description = "Used if `var.mode` is panorama, this defines the Device Group for the deployment"
  default     = {}
  type        = any
}

variable "vsys" {
  description = "Used if `var.mode` is ngfw, this defines the vsys for the deployment"
  default     = "vsys1"
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
  description = "Services object"
  default     = {}
  type        = any
}

variable "service_groups" {
  description = "Service groups object"
  default     = {}
  type        = any
}

variable "security_policies" {
  description = "Security policies"
  default     = {}
  type        = any
}

variable "nat_policies" {
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
variable "templates" {}
variable "template_stacks" {}