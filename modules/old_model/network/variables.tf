variable "panorama" {
  description = "If modules have target to Panorama, it enable Panorama specific variables."
  default     = false
  type        = bool
}

variable "zones" { default = {} }
variable "zone_entries" { default = {} }
variable "interfaces" { default = {} }
variable "virtual_routers" { default = {} }
variable "virtual_router_entries" { default = {} }
variable "virtual_router_static_routes" { default = {} }
variable "management_profiles" { default = {} }
variable "ike_crypto_profiles" { default = {} }
variable "ipsec_crypto_profiles" { default = {} }
variable "ike_gateways" { default = {} }
variable "ipsec_tunnels" { default = {} }
variable "ipsec_tunnels_proxy" { default = {} }