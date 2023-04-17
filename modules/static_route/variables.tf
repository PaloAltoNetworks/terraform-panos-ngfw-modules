variable "mode" {
  description = "The mode to use for the modules. Valid values are `panorama` and `ngfw`."
  default     = "panorama"
  type        = string
}

variable "template" {
  type = string
}

variable "template_stack" {
  type = string
}

variable "static_routes" { default = {} }
