variable "pan_creds" {
  description = "Path to file with credentials to Panorama"
  type        = string
}

variable "panorama" {
  description = "If modules have target to Panorama, it enable Panorama specific variables."
  default     = false
  type        = bool
}

variable "policy_file" {
  description = "Path to file with config for Security Policies."
  default     = "csv/policy.csv"
  type        = string
}

variable "nat_file" {
  description = "Path to file with config for NAT Policies."
  default     = "csv/nat.csv"
  type        = string
}

variable "addresses_file" {
  description = "Path to file with Addresses objects config."
  default     = "csv/addresses.csv"
  type        = string
}
variable "addr_groups_file" {
  description = "Path to file with Address Groups config."
  default     = "csv/addr_groups.csv"
  type        = string
}

variable "tags_file" {
  description = "Path to file with Tags objects config."
  default     = "csv/tags.csv"
  type        = string
}

variable "services_file" {
  description = "Path to file with Services objects config."
  default     = "csv/services.csv"
  type        = string
}

variable "service_groups_file" {
  description = "Path to file with Service Groups config."
  default     = "csv/service_groups.csv"
  type        = string
}

variable "network_zones_file" {
  description = "Path to file with Network Zones config."
  default     = "csv/zones.csv"
  type        = string
}

variable "network_interfaces_file" {
  description = "Path to file with Network Interfaces config."
  default     = "csv/interfaces.csv"
  type        = string
}

variable "network_virtual_routers_file" {
  description = "Path to file with Network Virtual Routers config."
  default     = "csv/virtual_routers.csv"
  type        = string
}

variable "network_management_profiles_file" {
  description = "Path to file with Network Managenet Profile config."
  default     = "csv/management_profiles.csv"
  type        = string
}

variable "network_static_routes_file" {
  description = "Path to file with Network virtual router static routes ipv4 config."
  default     = "csv/virtual_routers_routes.csv"
  type        = string
}

variable "network_ike_gateways_file" {
  description = "Path to file with Network IKE gateways config."
  default     = "csv/ike_gateways.csv"
  type        = string
}

variable "network_ike_crypto_profiles_file" {
  description = "Path to file with Network IKE crypto profiles config."
  default     = "csv/ike_crypto_profiles.csv"
  type        = string
}

variable "network_ipsec_crypto_profiles_file" {
  description = "Path to file with Network IPSec crypto profiles config."
  default     = "csv/ipsec_crypto_profiles.csv"
  type        = string
}

variable "network_ipsec_tunnels_file" {
  description = "Path to file with Network IPSec tunnels config."
  default     = "csv/ipsec_tunnels.csv"
  type        = string
}