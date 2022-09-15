# Terraform Modules for Palo Alto Networks Panorama Config as Code

## Overview

A set of modules for using **Palo Alto Networks Panorama Config as Code** to configure your Palo Alto Networks Next
Generation Firewalls with code instead of interacting with the GUI. It configures aspects such as Tags, Address
Objects/Groups, Security/NAT policies, Security Profiles, and more. You can use multiple config file type like 
YAML/JSON/CSV to configure modules.

* Policy as Code executes Terraform that will create a variety of resources based on the input.
* Terraform is the underlying automation tool, therefore it utilizes the Terraform provider ecosystem to drive relevant
  change to the network infrastructure.
* All Policy as Code is written as a compatible **Terraform module** using resources for the underlying network
  infrastructure provider.

<-- Picture need to be reupload to github.

![PolicyAsCode](https://i.imgur.com/hSWGYuL.png)

## Structure

This repository has the following directory structure:

* [modules](modules): This directory contains several standalone, reusable, production-grade Terraform modules. Each
  module is individually documented.
* [examples](examples): This directory shows examples of different ways to combine the modules contained in the
  `modules` directory.

## Compatibility

This module is meant for use with PAN-OS >= 10.2.0 and Terraform >= 0.13

## Configuration

The code is configured by config files, you can see how to handle that part in examples.

Mechanism needs to authorize calls to Panorama, it can be done in few ways.
It can be configured by JSON file with structure:

```json
{
  "hostname": "12.345.678.901",
  "username": "user",
  "password": "password"
}
```
And Terraform Provider looks like this:
```terraform
provider "panos" {
  json_config_file = var.pan_creds
}
```

Variable ``var.pan_creds`` and contain path to file ie. ``./creds/serviceaccount.json``.

It can be provided directly via variables:

```terraform
provider "panos" {
  
  username = "12.345.678.901"
  password = "user"
  hostname = "password" 
}
```

Or API Key
```terraform
provider "panos" {
  hostname = "12.345.678.901"
  api_key = "6B7fzuxeZlWZQYUgO5J8nhoB9l9U6s2IqEagBRnEI2yAt=="
}
```

## Testing

In order to executed test, prepare folder ``tests/creds/`` with 2 files:
* ``panorama.json``
* ``vmseries.json``

which will contain credentials to access each machine e.g.:

```
{
  "hostname": "12.345.678.901",
  "username": "user",
  "password": "password"
}
```

When credentials files are ready, use below commands to run tests:

```
cd tests
go mod init github.com/PaloAltoNetworks/terraform-panos-modules/tests
go mod tidy
go test -v -timeout 30m -count=1
```

## Versioning

These modules follow the principles of [Semantic Versioning](http://semver.org/). You can find each new release,
along with the changelog, on the GitHub [Releases](../../releases) page.

## Getting Help

If you have found a bug, please report it. The preferred way is to create a new issue on
the [GitHub issue page](../../issues).
