# Terraform Modules for Palo Alto Networks PAN-OS based platforms Config as Code

## Overview

A set of modules designed to configure your Palo Alto Networks PAN-OS-based platforms using code, eliminating the need for manual GUI interactions. This solution enables you to manage various aspects, including Tags, Address Objects/Groups, Security/NAT policies, Security Profiles, and more. The flexibility extends to multiple config file types like YAML, JSON, and CSV for easy configuration.

* Policy as Code executes Terraform that will create a variety of resources based on the input.
* Terraform is the underlying automation tool, therefore, it utilizes the Terraform provider ecosystem to drive relevant
  change to the network infrastructure.
* All Policy as Code is written as a compatible **Terraform module** using resources for the underlying network
  infrastructure provider.

![ConfigAsCode](https://user-images.githubusercontent.com/2110772/188634641-0f410362-74fe-4414-ac3f-7b9cea9ce9aa.png)

## Structure

This repository has the following directory structure:

* [modules](modules): This directory contains several standalone, reusable, production-grade Terraform modules. Each
  module is individually documented.
* [examples](examples): This directory shows examples of different ways to combine the modules contained in the
  `modules` directory.

## Compatibility

These modules are meant for use with PAN-OS >= 10.2.0 and Terraform >= 0.13

## Setup

The underlying panos provider can be configured using the following methods.

For all the supported arguments, please refer to [provider documentation](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs#argument-reference)

1. Directly in the provider block

```terraform
provider "panos" {
  username = "12.345.678.901"
  password = "user"
  hostname = "password" 
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
  "hostname": "12.345.678.901",
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
  "hostname": "12.345.678.901",
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
