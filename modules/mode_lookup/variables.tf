variable "mode" {
  description = "The mode to use for the modules. Valid values are `panorama` and `ngfw`."
  default     = "panorama"
  type        = string

  validation {
    condition     = contains(["panorama", "ngfw"], var.mode)
    error_message = "The mode must be either `panorama` or `ngfw`."
  }
}
