terraform {
  required_version = ">= 0.13"

  backend "s3" {
    bucket = "hcf-terraform-tf-state"
    key    = "csv-vmseries-terraform.tfstate"
    region = "us-east-1"
  }

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