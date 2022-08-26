Palo Alto Networks Panorama Modules CSV Example
---
This folder shows an example of Terraform code and CSV files that deploy configurations on the Panorama.

Usage
---

1. Create credential file. Example path ``./creds/credentials.json`` and file structure should look like:
```json
{
  "hostname": "12.345.678.901",
  "logging": [
    "action",
    "query",
    "op",
    "uid",
    "xpath",
    "send",
    "receive"
  ],
  "verify_certificate": false,
  "api_key": "kljhaui4ytq0faiuv9eq8hg=="
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
| <a name="module_policy-as-code_policy"></a> [policy-as-code\_policy](#module\_policy-as-code\_policy) | ../../../modules/policy | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_addr_groups_file"></a> [addr\_groups\_file](#input\_addr\_groups\_file) | Path to file with Address Groups config. | `string` | `"config/addr_groups.csv"` | no |
| <a name="input_addresses_file"></a> [addresses\_file](#input\_addresses\_file) | Path to file with Addresses objects config. | `string` | `"config/addresses.csv"` | no |
| <a name="input_nat_file"></a> [nat\_file](#input\_nat\_file) | Path to file with config for NAT Policies. | `string` | `"config/nat.csv"` | no |
| <a name="input_pan_creds"></a> [pan\_creds](#input\_pan\_creds) | Path to file with credentials to Panorama | `string` | n/a | yes |
| <a name="input_policy_file"></a> [policy\_file](#input\_policy\_file) | Path to file with config for Security Policies. | `string` | `"config/policy.csv"` | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | n/a | yes |
| <a name="input_service_groups_file"></a> [service\_groups\_file](#input\_service\_groups\_file) | Path to file with Service Groups config. | `string` | `"config/service_groups.csv"` | no |
| <a name="input_services_file"></a> [services\_file](#input\_services\_file) | Path to file with Services objects config. | `string` | `"config/services.csv"` | no |
| <a name="input_tags_file"></a> [tags\_file](#input\_tags\_file) | Path to file with Tags objects config. | `string` | `"config/tags.csv"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->