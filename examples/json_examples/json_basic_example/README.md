Palo Alto Networks PAN-OS based platforms Modules JSON Example
---
This folder shows an example of Terraform code and JSON files that deploy configurations on the Panorama.

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

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_panos"></a> [panos](#requirement\_panos) | 1.10.3 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_policy_as_code_objects"></a> [policy\_as\_code\_objects](#module\_policy\_as\_code\_objects) | ../../../modules/objects | n/a |
| <a name="module_policy_as_code_policy"></a> [policy\_as\_code\_policy](#module\_policy\_as\_code\_policy) | ../../../modules/policy | n/a |
| <a name="module_policy_as_code_security_profiles"></a> [policy\_as\_code\_security\_profiles](#module\_policy\_as\_code\_security\_profiles) | ../../../modules/security-profiles | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_pan_creds"></a> [pan\_creds](#input\_pan\_creds) | Path to file with credentials to PAN-OS based platforms | `string` | n/a | yes |
| <a name="input_panorama_mode"></a> [panorama\_mode](#input\_panorama\_mode) | Enable if PAN-OS target is Panorama | `bool` | `false` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->