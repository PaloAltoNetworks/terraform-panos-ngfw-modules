terraform {
  required_version = ">= 1.4.0, < 2.0.0"
  required_providers {
    panos = {
      source  = "PaloAltoNetworks/panos"
      version = "~> 1.11.1"
    }
  }
}
