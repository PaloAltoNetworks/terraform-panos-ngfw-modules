variable "panorama_commit_push_binary" {
  description = "Path to binary file used to commit and push changes from Panorama to devices"
  type        = string
}

variable "pan_creds" {
  description = "Path to file with credentials to Panorama"
  type        = string
}

variable "mode" {
  description = "Type of operation: commit or push"
  type        = string
  default     = "commit"
  validation {
    condition     = contains(["commit", "push"], var.mode)
    error_message = "Only 2 modes are available: commit or push"
  }
}

variable "device_group" {
  description = "Name of the device group"
  type        = string
  default     = null
}

variable "devices" {
  description = "List of devices (serial numbers)"
  type        = list(string)
  default     = null
}

variable "template_stack" {
  description = "Name of the template stack"
  type        = string
  default     = null
}

variable "configured_resource_ids" {
  description = "List of IDs of configured resources (used as trigger)"
  type        = list(string)
}