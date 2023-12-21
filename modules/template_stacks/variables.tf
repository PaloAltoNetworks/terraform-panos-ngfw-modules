variable "mode" {
  description = "The mode to use for the modules. Valid values are `panorama` and `ngfw`."
  type        = string
  validation {
    condition     = contains(["panorama", "ngfw"], var.mode)
    error_message = "The mode must be either `panorama` or `ngfw`."
  }
}

variable "template_stacks" {
  description = <<-EOF
  Map of the template stacks, where key is the template stack's name:
  - `description` - (Optional) The template's description.
  - `default_vsys` - (Optional) The default virtual system template configuration pushed to firewalls with a single virtual system. Note - you can only set this if there is at least one template in this stack.
  - `templates` - (Optional) List of templates in this stack.
  - `devices` - (Optional) List of serial numbers to include in this stack.

  Example:
  ```
  {
    "test-template-stack" = {
      description = "My test template stack with devices"
      templates   = ["test-template"]
      devices     = ["123456789"]
    }
  }
  ```
  EOF
  default     = {}
  type = map(object({
    description  = optional(string)
    default_vsys = optional(string)
    templates    = optional(list(string))
    devices      = optional(list(string), [])
  }))
}
