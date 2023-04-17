variable "mode" {
  description = "The mode to use for the modules. Valid values are `panorama` and `ngfw`."
  default     = "panorama"
  type        = string
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

variable "ike_crypto_profiles" { default = {} }
variable "ipsec_crypto_profiles" { default = {} }
variable "ike_gateways" { default = {} }
variable "ipsec_tunnels" { default = {} }
variable "ipsec_tunnels_proxy" { default = {} }
