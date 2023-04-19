variable "mode" {
  description = "The mode to use for the modules. Valid values are `panorama` and `ngfw`."
  type        = string
  validation {
    condition     = contains(["panorama", "ngfw"], var.mode)
    error_message = "The mode must be either `panorama` or `ngfw`."
  }
}

variable "mode_map" {
  description = "The mode to use for the modules. Valid values are `panorama` and `ngfw`."
  default = {
    panorama = 0
    ngfw     = 1
    # cloud_manager = 2 # Not yet supported
  }
  type = object({
    panorama = number
    ngfw     = number
  })
}

variable "templates" {
  description = <<-EOF
  Map of the templates, where key is the template's name:
  - `description` - (Optional) The template's description.

  Example:
  ```
  {

  }
  ```
  EOF
  default     = {}
  type = map(object({
    description = optional(string)
  }))
}
