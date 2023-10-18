variable "panos_config_file" {
  description = "Path to a JSON configuration file for `panos` provider."
  type        = string
}

variable "panos_timeout" {
  description = "Timeout in seconds for all provider communication with target system, defaults to `10`. Can also be specified within JSON configuration file."
  default     = null
  type        = number
}

variable "mode" {
  description = "Provide information about target."
  default     = ""
  type        = string
}

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

variable "tags" {
  description = "Tags object"
  default     = {}
  type        = any
}

variable "addresses" {
  description = "Address objects to manage using 'addresses' module's individual mode."
  default     = {}
  type        = any
}

variable "addresses_bulk" {
  description = "Address objects to manage using 'addresses' module's bulk mode."
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

variable "security_profiles" {
  description = "Map with security profiles."
  default     = {}
  type        = any
}

variable "log_forwarding_profiles_shared" {
  description = "Map with log forwarding profiles."
  default     = {}
  type        = any
}

variable "security_rule_groups" {
  description = "Security rule groups"
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