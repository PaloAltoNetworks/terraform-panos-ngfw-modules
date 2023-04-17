variable "mode" {
  description = "The mode to use for the modules. Valid values are `panorama` and `ngfw`."
  default     = "panorama"
  type        = string
}

variable "zones" { default = {} }
variable "zone_entries" { default = {} }
