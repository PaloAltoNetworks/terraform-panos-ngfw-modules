Palo Alto Networks Panorama Modules Basic Policy Example
---
This folder shows an example of Terraform code and JSON code that deploy iron skillet configurations on the Panorama.

Usage
---

1. Create a `terraform.tfvars` to setup the panos provider block in the **"main.tf"**.

```terraform
provider "panos" {
  hostname = var.hostname
  username = var.user
  password = var.password
}
```

2. Run Terraform

```
terraform init
terraform apply
terraform output -json
```

Cleanup
---

```
terraform destroy
```

Requirements
---

* Terraform 0.13+

Providers
---

Name | Version
-----|------
panos | 1.8.3

Modules
---

Name | Source | Version
---|---|---
policy | ../../modules/policy | 0.1.0
security-profiles | ../../modules/security-profiles | 0.1.0

Inputs
---

Name | Description | Type | Default | Required
-----|-----|-----|-----|-----
hostname | PAN-OS address. | `string` | n/a | yes
user | Admin username. | `string` | n/a | yes
password | Admin password. | `string` | n/a | yes

Outputs
---

Name | Description
---|---
created_tags | Shows the tags that were created.
created_sec |Shows the security policies that were created.
created_antivirus_prof | Shows the antivirus security profiles that were created.
created_spyware_prof |Shows the anti-spyware security profiles that were created.
created_file_blocking_prof |Shows the file blocking security profiles that were created.
created_vulnerability_prof |Shows the vulnerability security profiles that were created.
created_wildfire_prof |Shows the wildfire analysis security profiles that were created.