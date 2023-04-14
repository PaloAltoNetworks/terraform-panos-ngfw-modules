variable "panorama" {
  description = "If modules have target to Panorama, it enable Panorama specific variables."
  default     = false
  type        = bool
}

variable "virtual_routers" { default = {} }
variable "virtual_router_entries" { default = {} }
variable "virtual_router_static_routes" { default = {} }
