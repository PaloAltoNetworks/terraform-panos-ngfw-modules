terraform {
  required_version = ">= 0.13"

  required_providers {
    panos = {
      source  = "PaloAltoNetworks/panos"
      version = "1.10.3"
    }
  }
}

provider "panos" {
  json_config_file = var.pan_creds
}