variable "panorama" {
  description = "If modules have target to Panorama, it enable Panorama specific variables."
  default     = false
  type        = bool
}

variable "ike_crypto_profiles" { default = {} }
variable "ipsec_crypto_profiles" { default = {} }
variable "ike_gateways" { default = {} }
variable "ipsec_tunnels" { default = {} }
variable "ipsec_tunnels_proxy" { default = {} }
