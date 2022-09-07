variable "pan_creds" {
  description = "Path to file with credentials to PAN-OS based platforms"
  type    = string
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

variable "panorama_mode" {
  description = "Enable if PAN-OS target is Panorama"
  default     = false
  type        = bool
}