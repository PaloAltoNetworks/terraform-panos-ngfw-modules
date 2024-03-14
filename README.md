![GitHub release (latest by date)](https://img.shields.io/github/v/release/PaloAltoNetworks/terraform-panos-ngfw-modules?style=flat-square)
![GitHub](https://img.shields.io/github/license/PaloAltoNetworks/terraform-modules-swfw-ci-workflows?style=flat-square)
![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/PaloAltoNetworks/terraform-panos-ngfw-modules/release_ci.yml?style=flat-square)
![GitHub issues](https://img.shields.io/github/issues/PaloAltoNetworks/terraform-panos-ngfw-modules?style=flat-square)
![GitHub pull requests](https://img.shields.io/github/issues-pr/PaloAltoNetworks/terraform-panos-ngfw-modules?style=flat-square)
![Terraform registry downloads total](https://img.shields.io/badge/dynamic/json?color=green&label=downloads%20total&query=data.attributes.total&url=https%3A%2F%2Fregistry.terraform.io%2Fv2%2Fmodules%2FPaloAltoNetworks%2Fngfw-modules%2Fpanos%2Fdownloads%2Fsummary&style=flat-square)
![Terraform registry download month](https://img.shields.io/badge/dynamic/json?color=green&label=downloads%20this%20month&query=data.attributes.month&url=https%3A%2F%2Fregistry.terraform.io%2Fv2%2Fmodules%2FPaloAltoNetworks%2Fngfw-modules%2Fpanos%2Fdownloads%2Fsummary&style=flat-square)


# Terraform Modules for Palo Alto Networks PAN-OS Based Platforms 

## Overview

A set of Terraform modules that can be leveraged to configure and manage Palo Alto Networks PAN-OS-based platforms (Firewalls and Panorama) using code. 

This solution enables you to manage various configuration aspects, including Tags, Address Objects/Groups, Security/NAT policies, Security Profiles, and more. 

## Structure

This repository has the following directory structure:

* [modules](modules): This directory contains several standalone, reusable, production-grade Terraform modules. Each
  module is individually documented.
* [examples](examples): This directory shows examples of different ways to combine the modules contained in the
  `modules` directory.

## Compatibility

These modules are meant for use with PAN-OS >= 10.x.x and Terraform >= 1.4

## Setup

> [!IMPORTANT]
> ### Modes
> 
> The modules are designed to seamlessly integrate with either a PAN-OS firewall or a Panorama instance, providing flexibility in their usage. The user is required to implicitly pass the `mode` variable to these modules, which dictates the operational context of the modules. This variable is mandatory, with accepted values being `panorama` or `ngfw`. 

The underlying panos provider can be configured using the following methods.

For all the supported arguments, please refer to [provider documentation](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs#argument-reference)

1. Directly in the provider block

```terraform
provider "panos" {
  hostname = "1.1.1.1"
  username = "username"
  password= "password" 
}
```

2. Environment variable setting (where applicable)

```sh
export PANOS_HOSTNAME=
export PANOS_USERNAME=
export PANOS_API_KEY=
```

3. From a JSON config file

```sh
> cat ./panos-config.json
{
  "hostname": "1.1.1.1",
  "username": "user",
  "password": "password"
}
```

```terraform
provider "panos" {
  json_config_file = "panos-config.json"
}
```

## Testing

To execute tests, create the folder ``tests/creds/`` with below two files:
* ``panorama.json``
* ``firewall.json``

which will contain credentials to access Panorama and firewall instances, e.g.:

```
{
  "hostname": "1.1.1.1",
  "username": "user",
  "password": "password"
}
```

When credentials files are ready, use the below commands to run tests:

```
cd tests
go mod init github.com/PaloAltoNetworks/terraform-panos-modules/tests
go mod tidy
go test -v -timeout 30m -count=1
```

## Versioning

These modules follow the principles of [Semantic Versioning](http://semver.org/). You can find each new release,
along with the changelog on the GitHub [Releases](../../releases) page.

## Getting Help

If you have found a bug, please report it. The preferred way is to create a new issue on
the [GitHub issue page](../../issues).
