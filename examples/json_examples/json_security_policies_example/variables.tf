variable "pan_creds" {
  description = "Path to file with credentials to PAN-OS based platforms"
  type    = string
}

variable "panorama_mode" {
  description = "Enable if PAN-OS target is Panorama"
  default     = false
  type        = bool
}