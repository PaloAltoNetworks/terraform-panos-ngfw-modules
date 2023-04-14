variable "panorama" {
  description = "If modules have target to Panorama, it enable Panorama specific variables."
  default     = false
  type        = bool
}

variable "zones" { default = {} }
variable "zone_entries" { default = {} }
