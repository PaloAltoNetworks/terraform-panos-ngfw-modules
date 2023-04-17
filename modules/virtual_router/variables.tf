variable "mode" {
  description = "The mode to use for the modules. Valid values are `panorama` and `ngfw`."
  default     = "panorama"
  type        = string
}

variable "virtual_routers" { default = {} }
variable "virtual_router_entries" { default = {} }
variable "virtual_router_static_routes" { default = {} }
