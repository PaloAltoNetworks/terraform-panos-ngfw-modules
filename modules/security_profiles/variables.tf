variable "mode" {
  description = "The mode to use for the module. Valid values are `panorama` and `ngfw`."
  type        = string
  validation {
    condition     = contains(["panorama", "ngfw"], var.mode)
    error_message = "The mode must be either 'panorama' or 'ngfw'."
  }
}

variable "device_group" {
  description = "Used if `mode` is `panorama`, this defines the Device Group for the deployment."
  default     = "shared"
  type        = string
}

variable "vsys" {
  description = "Used if `mode` is `ngfw`, this defines the vsys for the deployment."
  default     = "vsys1"
  type        = string
}

variable "security_profile_groups" {
  description = <<-EOF
    Map of security profile groups where the key is name of the security profile group.:
    - `antivirus_profile`: (optional) The AV profile name.
    - `anti_spyware_profile`: (optional) Anti Spyware profile name.
    - `vulnerability_profile`: (optional) Vulnerability profile name.
    - `url_filtering_profile`: (optional) URL filtering profile name.
    - `file_blocking_profile`: (optional) File blocking profile name.
    - `data_filtering_profile`: (optional) Data filtering profile name.
    - `wildfire_analysis_profile`: (optional) Wildfire analysis profile name.
    - `gtp_profile`: (optional) GTP profile name.
    - `sctp_profile`: (optional) SCTP profile name.
    Example:
    ```
    {
      "myGroup" = {
        antivirus_profile = "default"
        anti_spyware_profile = "anti-spyware1"
      }
    }
    ```
    EOF
    default = {}
    type = map(object({
    antivirus_profile = optional(string)
    anti_spyware_profile = optional(string)
    vulnerability_profile = optional(string)
    url_filtering_profile = optional(string)
    file_blocking_profile = optional(string)
    data_filtering_profile = optional(string)
    wildfire_analysis_profile = optional(string)
    gtp_profile = optional(string)
    sctp_profile = optional(string)
  }))
}

variable "antivirus_profiles" {
  description = <<-EOF
  List with the Antivirus profile objects. Each item supports following parameters:
  - `name`: (required) Profile name.
  - `description`: (optional) Profile description.
  - `packet_capture`: (optional) Boolean that enables packet capture (default: `false`).
  - `threat_exceptions`: (optional) A string list of threat exceptions.
  - `decoders`: (optional) List of objects following the decoder specifications.
    - `name`: (required) Decoder name.
    - `actions`: (optional) Decoder action. Valid values are `default`, `allow`, `alert`, `drop`, `reset-client`, `reset-server`, or `reset-both` (default: `default`).
    - `wildfire_action`: (optional) Wildfire action. Valid values are `default`, `allow`, `alert`, `drop`, `reset-client`, `reset-server`, or `reset-both` (default: `default`).
    - `machine_learning_action`: (optional) Only available with PAN-OS 10.0+, machine learning action. Valid values are `default`, `allow`, `alert`, `drop`, `reset-client`, `reset-server`, or `reset-both` (default: `default`).
  - `application_exceptions`: (optional) List of objects following the application exception specifications.
    - `application`: (required) The application name.
    - `action`: (optional) The action performed when approached with the application exception. Valid values are `default`, `allow`, `alert`, `drop`, `reset-client`, `reset-server`, or `reset-both` (default: `default`).
  - `machine_learning_models`: (optional) List of objects following the machine learning model specifications.
    - `model`: (required) The model.
    - `action`: (required) The action for the machine learning model to perform. Valid values are `default`, `allow`, `alert`, `drop`, `reset-client`, `reset-server`, or `reset-both` (default: `default`).
  - `machine_learning_exceptions`: (optional) List of objects following the machine learning exception specifications.
    - `name`: (required) Partial hash of file included in the machine learning exception.
    - `description`: (optional) The description of the exception.
    - `filename`: (optional) The filename for the exception
  Example:
  ```
  [
    {
      name = "Alert-Only-AV"
      decoders = [
        {
          name = "http"
          action = "alert"
          wildfire_action = "alert"
          machine_learning = "alert"
        }
      ]
      machine_learning_models = [
        {
          model = "Windows Executables"
          action = "enable"
        },
        {
          model = "PowerShell Script 1"
          action = "enable"
        }
      ]
    }
  ]
  ```
  EOF

  default = {}
  type = map(object({
    description       = optional(string)
    packet_capture    = optional(bool)
    threat_exceptions = optional(list(string))
    decoders = optional(list(object({
      name                    = string
      action                  = optional(string, "default")
      wildfire_action         = optional(string, "default")
      machine_learning_action = optional(string, "default")
    })), [])
    application_exceptions = optional(list(object({
      application = string
      action      = optional(string, "default")
    })), [])
    machine_learning_models = optional(list(object({
      model  = string
      action = string
    })), [])
    machine_learning_exceptions = optional(list(object({
      name        = string
      description = optional(string)
      filename    = optional(string)
    })), [])
  }))

  validation {
    condition = alltrue([
      for profile in var.antivirus_profiles : alltrue([
        for decoder in profile.decoders : contains(["default", "allow", "alert", "drop", "reset-client", "reset-server", "reset-both"], decoder.action)
      ])
    ])
    error_message = "Valid actions are: 'default', 'allow', 'alert', 'drop', 'reset-client', 'reset-server', 'reset-both'."
  }
  validation {
    condition = alltrue([
      for profile in var.antivirus_profiles : alltrue([
        for decoder in profile.decoders : contains(["default", "allow", "alert", "drop", "reset-client", "reset-server", "reset-both"], decoder.wildfire_action)
      ])
    ])
    error_message = "Valid actions are: 'default', 'allow', 'alert', 'drop', 'reset-client', 'reset-server', 'reset-both'."
  }
  validation {
    condition = alltrue([
      for profile in var.antivirus_profiles : alltrue([
        for decoder in profile.decoders : contains(["default", "allow", "alert", "drop", "reset-client", "reset-server", "reset-both"], decoder.machine_learning_action)
      ])
    ])
    error_message = "Valid actions are: 'default', 'allow', 'alert', 'drop', 'reset-client', 'reset-server', 'reset-both'."
  }
  validation {
    condition = alltrue([
      for profile in var.antivirus_profiles : alltrue([
        for app_exception in profile.application_exceptions : contains(["default", "allow", "alert", "drop", "reset-client", "reset-server", "reset-both"], app_exception.action)
      ])
    ])
    error_message = "Valid actions are: 'default', 'allow', 'alert', 'drop', 'reset-client', 'reset-server', 'reset-both'."
  }
  validation {
    condition = alltrue([
      for profile in var.antivirus_profiles : alltrue([
        for ml_model in profile.machine_learning_models : contains(["enable", "alert-only", "disable"], ml_model.action)
      ])
    ])
    error_message = "Valid actions are: 'enable', 'alert-only', 'disable'."
  }
}

variable "antispyware_profiles" {
  description = <<-EOF
  List of the Anti-Spyware profile objects. Each item supports following parameters:
  - `name`: (required) Identifier of the Anti-Spyware security profile.
  - `description`: (optional) The description of the Anti-Spyware profile.
  - `packet_capture`: (optional) Packet capture setting for PAN-OS 8.X only). Valid values are `disable`, `single-packet`, or `extended-capture` (default: `disable`).
  - `sinkhole_ipv4_address`: (optional) IPv4 sinkhole address.
  - `sinkhole_ipv6_address`: (optional) IPv6 sinkhole address.
  - `threat_exceptions`: (optional) A string list of threat exceptions.
  - `botnet_lists`: (optional) List of objects following the botnet specifications.
    - `name`: (required) Botnet name.
    - `actions`: (optional) Botnet action. Valid values are `allow`, `alert`, `block`, `default`, or `sinkhole` (default: `default`).
    - `packet_capture`: (optional) Packet capture setting for PAN-OS 9.0+. Valid values are `disable`, `single-packet`, or `extended-capture` (default: `disable`).
  - `dns_categories`: (optional) List of objects following the DNS category specifications for PAN-OS 10.0+.
    - `name`: (required) DNS category name.
    - `action`: (optional) DNS category action. Valid values are `default`, `allow`, `alert`, `drop`, `block`, or `sinkhole` (default: `default`).
    - `log_level`: (optional) Logging level. Valid values are `default`, `none`, `low`, `informational`, `medium`, `high`, or `critical` (default: `default`).
    - `packet_capture`: (optional) Packet capture setting. Valid values are `disable`, `single-packet`, or `extended-capture` (default: `disable`).
  - `white_lists`: (optional) List of objects following the white list specifications.
    - `name`: (required) White list object name.
    - `description`: (optional) Description of the white list.
  - `rules`: (optional) List of objects following the rule specifications.
    - `name`: (required) Rule name.
    - `threat_name`: (optional) Threat name.
    - `category`: (optional) Category for the anti-spyware policy (default: `any`).
    - `severities`: (optional) List of severities to include in policy. Valid values are `any`, `critical`, `high`, `medium`, `low`, or/and `informational` (default: `any`).
    - `packet_capture`: (optional) Packet capture setting. Valid values are `disable`, `single-packet`, or `extended-capture` (default: `disable`).
    - `block_ip_track_by`: (required if `action` = `block-ip`) The track setting. Valid values are `source` or `source-and-destination`.
    - `block_ip_duration`: (required if `action` = `block-ip`) The duration of the block. Valid values are integers.
  - `exceptions`: (optional) List of objects following the exceptions specifications.
    - `name`: (required) Threat name for the exception. You can use the `panos_predefined_threat` data source to discover the various names available to use.
    - `packet_capture`: (optional) Packet capture setting. Valid values are `disable`, `single-packet`, or `extended-capture` (default: `disable`).
    - `action`: (optional) Exception action. Valid values are `default`, `allow`, `alert`, `drop`, `reset-client`, `reset-server`, `reset-both`, or `block-ip` (default: `default`).
    - `block_ip_track_by`: (required if `action` = `block-ip`) The track setting. Valid values are `source` or `source-and-destination`.
    - `block_ip_duration`: (required if `action` = `block-ip`) The duration of the block. Valid values are integers.
    - `exempt_ips`: (optional) List of exempt IPs.

  Example:
  ```
  [
    {

      name = "Outbound-AS"
      botnet_lists = [
        {
          name = "default-paloalto-dns"
          action = "sinkhole"
          packet_capture = "single-packet"
        }
      ]
      dns_categories = [
        {
          name = "pan-dns-sec-benign"
        },
        {
          name = "pan-dns-sec-cc"
          action = "sinkhole"
          packet_capture = "single-packet"
        }
      ]
      sinkhole_ipv4_address = "sinkhole.paloaltonetworks.com"
      sinkhole_ipv6_address = "2600:5200::1"
      rules =
      [
        {
          name = "Block-Critical-High-Medium"
          action = "reset-both"
          severities = ["critical","high","medium"]
          packet_capture = "single-packet"
        },
        {
          name = "Default-Low-Info"
          severities = ["low","informational"]
          packet_capture = "disable"
        }
      ]
    }
  ]
  ```
  EOF

  default = {}
  type = map(object({
    description           = optional(string)
    packet_capture        = optional(string, "disable")
    sinkhole_ipv4_address = optional(string)
    sinkhole_ipv6_address = optional(string)
    threat_exceptions     = optional(list(string))
    botnet_lists = optional(list(object({
      name           = string
      action         = optional(string, "default")
      packet_capture = optional(string, "disable")
    })), [])
    dns_categories = optional(list(object({
      name           = string
      action         = optional(string, "default")
      log_level      = optional(string, "default")
      packet_capture = optional(string, "disable")
    })), [])
    white_lists = optional(list(object({
      name        = string
      description = optional(string)
    })), [])
    rules = optional(list(object({
      name              = string
      threat_name       = optional(string, "any")
      category          = optional(string, "any")
      severities        = optional(list(string), ["any"])
      packet_capture    = optional(string, "disable")
      action            = optional(string, "default")
      block_ip_track_by = optional(string, "source")
      block_ip_duration = optional(number)
    })), [])
    exceptions = optional(list(object({
      name              = string
      packet_capture    = optional(string, "disable")
      action            = optional(string, "default")
      block_ip_track_by = optional(string, "source")
      block_ip_duration = optional(number)
      exempt_ips        = optional(list(string))
    })), [])
  }))

  validation {
    condition = alltrue([
      for profile in var.antispyware_profiles : contains(["", "disable", "single-packet", "extended-capture"], profile.packet_capture)
    ])
    error_message = "Valid 'packet_capture' values are: 'disable', 'single-packet', 'extended-capture'."
  }
  validation {
    condition = alltrue([
      for profile in var.antispyware_profiles : alltrue([
        for botnet_list in profile.botnet_lists : contains(["default", "allow", "alert", "block", "sinkhole"], botnet_list.action)
      ])
    ])
    error_message = "Valid actions are: 'default', 'allow', 'alert', 'block', 'sinkhole'."
  }
  validation {
    condition = alltrue([
      for profile in var.antispyware_profiles : alltrue([
        for botnet_list in profile.botnet_lists : contains(["disable", "single-packet", "extended-capture"], botnet_list.packet_capture)
      ])
    ])
    error_message = "Valid 'packet_capture' values are: 'disable', 'single-packet', 'extended-capture'."
  }
  validation {
    condition = alltrue([
      for profile in var.antispyware_profiles : alltrue([
        for dns_category in profile.dns_categories : contains(["default", "allow", "alert", "block", "sinkhole"], dns_category.action)
      ])
    ])
    error_message = "Valid actions are: 'default', 'allow', 'alert', 'block', 'sinkhole'."
  }
  validation {
    condition = alltrue([
      for profile in var.antispyware_profiles : alltrue([
        for dns_category in profile.dns_categories : contains(["default", "none", "low", "informational", "medium", "high", "critical"], dns_category.log_level)
      ])
    ])
    error_message = "Valid log levels are: 'default', 'none', 'low', 'informational', 'medium', 'high', 'critical'."
  }
  validation {
    condition = alltrue([
      for profile in var.antispyware_profiles : alltrue([
        for dns_category in profile.dns_categories : contains(["disable", "single-packet", "extended-capture"], dns_category.packet_capture)
      ])
    ])
    error_message = "Valid 'packet_capture' values are: 'disable', 'single-packet', 'extended-capture'."
  }
  validation {
    condition = alltrue([
      for profile in var.antispyware_profiles : alltrue([
        for rule in profile.rules : contains(["disable", "single-packet", "extended-capture"], rule.packet_capture)
      ])
    ])
    error_message = "Valid 'packet_capture' values are: 'disable', 'single-packet', 'extended-capture'."
  }
  validation {
    condition = alltrue([
      for profile in var.antispyware_profiles : alltrue([
        for rule in profile.rules : contains(["default", "allow", "alert", "drop", "reset-client", "reset-server", "reset-both", "block-ip"], rule.action)
      ])
    ])
    error_message = "Valid actions are: 'default', 'allow', 'alert', 'drop', 'reset-client', 'reset-server', 'reset-both', 'block-ip'."
  }
  validation {
    condition = alltrue([
      for profile in var.antispyware_profiles : alltrue([
        for rule in profile.rules : contains(["source", "source-and-destination"], rule.block_ip_track_by)
      ])
    ])
    error_message = "Valid 'block_ip_track_by' values are: 'source', 'source-and-destination'."
  }
  validation {
    condition = alltrue([
      for profile in var.antispyware_profiles : alltrue([
        for exception in profile.exceptions : contains(["disable", "single-packet", "extended-capture"], exception.packet_capture)
      ])
    ])
    error_message = "Valid 'packet_capture' values are: 'disable', 'single-packet', 'extended-capture'."
  }
  validation {
    condition = alltrue([
      for profile in var.antispyware_profiles : alltrue([
        for exception in profile.exceptions : contains(["default", "allow", "alert", "drop", "reset-client", "reset-server", "reset-both", "block-ip"], exception.action)
      ])
    ])
    error_message = "Valid actions are: 'default', 'allow', 'alert', 'drop', 'reset-client', 'reset-server', 'reset-both', 'block-ip'."
  }
  validation {
    condition = alltrue([
      for profile in var.antispyware_profiles : alltrue([
        for exception in profile.exceptions : contains(["source", "source-and-destination"], exception.block_ip_track_by)
      ])
    ])
    error_message = "Valid 'block_ip_track_by' values are: 'source', 'source-and-destination'."
  }
}

variable "file_blocking_profiles" {
  description = <<-EOF
  List of the File Blocking profile objects. Each item supports following parameters:
  - `name`: (required) Identifier of the File-blocking security profile.
  - `description`: (optional) The description of the File-blocking profile.
  - `rules`: (optional) List of objects following the rule specifications.
    - `name`: (required) Rule name.
    - `applications`: (optional) List of applications (default: `any`).
    - `file_types`: (optional) File types included in the file-blocking rule.
    - `direction`: (optional) Direction for the file-blocking rule to flow. Valid values are `both`, `upload`, or `download` (default: `both`).
    - `action`: (optional) Action for the policy to take. Valid values are `alert`, `block`, or `continue` (default: `alert`).

  Example:
  ```
  [
    {
      name = "Outbound-FB"
      rules = [
        {
          name = "Alert-All"
          applications = ["any"]
          file_types = ["any"]
          direction = "both"
          action = "alert"
        },
        {
          name = "Block"
          applications = ["any"]
          file_types = [
            "7z",
            "bat",
            "chm",
            "class",
            "cpl",
            "dll",
            "hlp",
            "hta",
            "jar",
            "ocx",
            "pif",
            "scr",
            "torrent",
            "vbe",
            "wsf"
          ]
          direction = "both"
          action = "block"
        }
      ]
    }
  ]
  ```
  EOF

  default = {}
  type = map(object({
    description = optional(string)
    rules = optional(list(object({
      name         = string
      applications = optional(list(string), ["any"])
      file_types   = optional(list(string), ["any"])
      direction    = optional(string, "both")
      action       = optional(string, "alert")
    })), [])
  }))

  validation {
    condition = alltrue([
      for profile in var.file_blocking_profiles : alltrue([
        for rule in profile.rules : contains(["both", "upload", "download"], rule.direction)
      ])
    ])
    error_message = "Valid 'direction' values are: 'both', 'upload', 'download'."
  }
  validation {
    condition = alltrue([
      for profile in var.file_blocking_profiles : alltrue([
        for rule in profile.rules : contains(["alert", "block", "continue"], rule.action)
      ])
    ])
    error_message = "Valid actions are: 'alert', 'block', 'continue'."
  }
}

variable "vulnerability_protection_profiles" {
  description = <<-EOF
  List of the Vulnerability Protection profile objects. Each item supports following parameters:
  - `name`: (required) Identifier of the Vulnerability security profile.
  - `description`: (optional) The description of the vulnerability profile.
  - `rules`: (optional) List of objects following the rule specifications.
    - `name`: (required) Rule name.
    - `threat_name`: (optional) Threat name.
    - `cves`: (optional) List of CVEs (default: `any`).
    - `host`: (optional) The host. Valid values are `any`, `client`, or `server` (default: `any`).
    - `vendor_ids`: (optional) List of vendor IDs (default: `any`).
    - `category`: (optional) Category for the file-blocking policy (default: `any`).
    - `severities`: (optional) List of severities to include in policy. Valid values are `any`, `critical`, `high`, `medium`, `low`, or/and `informational` (default: `any`).
    - `packet_capture`: (optional) Packet capture setting. Valid values are `disable`, `single-packet`, or `extended-capture` (default: `disable`).
    - `action`: (optional) Exception action. Valid values are `default`, `allow`, `alert`, `drop`, `reset-client`, `reset-server`, `reset-both`, or `block-ip` (default: `default`).
    - `block_ip_track_by`: (required if `action` = `block-ip`) The track setting. Valid values are `source` or `source-and-destination`.
    - `block_ip_duration`: (required if `action` = `block-ip`) The duration of the block. Valid values are integers.
  - `exceptions`: (optional) List of objects following the exceptions specifications.
    - `name`: (required) Threat name for the exception. You can use the `panos_predefined_threat` data source to discover the various names available to use.
    - `packet_capture`: (optional) Packet capture setting. Valid values are `disable`, `single-packet`, or `extended-capture` (default: `disable`).
    - `action`: (optional) Exception action. Valid values are `default`, `allow`, `alert`, `drop`, `reset-client`, `reset-server`, `reset-both`, or `block-ip` (default: `default`).
    - `block_ip_track_by`: (required if `action` = `block-ip`) The track setting. Valid values are `source` or `source-and-destination`.
    - `block_ip_duration`: (required if `action` = `block-ip`) The duration of the block. Valid values are integers.
    - `exempt_ips`: (optional) List of exempt IPs.
    - `time_interval`: (optional) Time interval integer.
    - `time_threshold`: (optional) Time threshold integer.
    - `time_track_by`: (optional) Time track by setting. Valid values are `source`, `destination`, or `source-and-destination`.

  Example:
  ```
  [
    {
      name = "Outbound-VP"
      rules = [
        {
          name = "Block-Critical-High-Medium"
          action = "reset-both"
          vendor_ids = ["any"]
          severities = ["critical","high","medium"]
          cves = ["any"]
          threat_name = "any"
          host = "any"
          category = "any"
          packet_capture = "single-packet"
        },
        {
          name = "Default-Low-Info"
          action = "default"
          vendor_ids = ["any"]
          severities = ["low","informational"]
          cves = ["any"]
          threat_name = "any"
          host = "any"
          category = "any"
          packet_capture = "disable"
        }
      ]
    }
  ]
  ```
  EOF

  default = {}
  type = map(object({
    description = optional(string)
    rules = optional(list(object({
      name              = string
      threat_name       = optional(string, "any")
      cves              = optional(set(string), ["any"])
      host              = optional(string, "any")
      vendor_ids        = optional(set(string), ["any"])
      severities        = optional(list(string), ["any"])
      category          = optional(string, "any")
      action            = optional(string, "default")
      block_ip_track_by = optional(string, "source")
      block_ip_duration = optional(number)
      packet_capture    = optional(string, "disable")
    })), [])
    exceptions = optional(list(object({
      name              = string
      packet_capture    = optional(string, "disable")
      action            = optional(string, "default")
      block_ip_track_by = optional(string, "source")
      block_ip_duration = optional(number)
      time_interval     = optional(number)
      time_threshold    = optional(number)
      time_track_by     = optional(string)
      exempt_ips        = optional(list(string))
    })), [])
  }))

  validation {
    condition = alltrue([
      for profile in var.vulnerability_protection_profiles : alltrue([
        for rule in profile.rules : contains(["any", "client", "server"], rule.host)
      ])
    ])
    error_message = "Valid 'host' values are: 'any', 'client', 'server'."
  }
  validation {
    condition = alltrue([
      for profile in var.vulnerability_protection_profiles : alltrue([
        for rule in profile.rules : contains(["default", "allow", "alert", "drop", "reset-client", "reset-server", "reset-both", "block-ip"], rule.action)
      ])
    ])
    error_message = "Valid actions are: 'default', 'allow', 'alert', 'drop', 'reset-client', 'reset-server', 'reset-both', 'block-ip'."
  }
  validation {
    condition = alltrue([
      for profile in var.vulnerability_protection_profiles : alltrue([
        for rule in profile.rules : contains(["source", "source-and-destination"], rule.block_ip_track_by)
      ])
    ])
    error_message = "Valid 'block_ip_track_by' values are: 'source', 'source-and-destination'."
  }
  validation {
    condition = alltrue([
      for profile in var.vulnerability_protection_profiles : alltrue([
        for rule in profile.rules : contains(["disable", "single-packet", "extended-capture"], rule.packet_capture)
      ])
    ])
    error_message = "Valid 'packet_capture' values are: 'disable', 'single-packet', 'extended-capture'."
  }
  validation {
    condition = alltrue([
      for profile in var.vulnerability_protection_profiles : alltrue([
        for exception in profile.exceptions : contains(["disable", "single-packet", "extended-capture"], exception.packet_capture)
      ])
    ])
    error_message = "Valid 'packet_capture' values are: 'disable', 'single-packet', 'extended-capture'."
  }
  validation {
    condition = alltrue([
      for profile in var.vulnerability_protection_profiles : alltrue([
        for exception in profile.exceptions : contains(["default", "allow", "alert", "drop", "reset-client", "reset-server", "reset-both", "block-ip"], exception.action)
      ])
    ])
    error_message = "Valid actions are: 'default', 'allow', 'alert', 'drop', 'reset-client', 'reset-server', 'reset-both', 'block-ip'."
  }
  validation {
    condition = alltrue([
      for profile in var.vulnerability_protection_profiles : alltrue([
        for exception in profile.exceptions : contains(["source", "source-and-destination"], exception.block_ip_track_by)
      ])
    ])
    error_message = "Valid 'block_ip_track_by' values are: 'source', 'source-and-destination'."
  }
  validation {
    condition = alltrue([
      for profile in var.vulnerability_protection_profiles : alltrue([
        for exception in profile.exceptions : contains(["source", "destination", "source-and-destination"], coalesce(exception.time_track_by, "source"))
      ])
    ])
    error_message = "Valid 'time_track_by' values are: 'source', 'destination', 'source-and-destination'."
  }
}

variable "wildfire_analysis_profiles" {
  description = <<-EOF
  List of the Wildfire Analysis profile objects. Each item supports following parameters:
  - `name`: (required) Identifier of the Wildfire Analysis security profile.
  - `device_group`: (optional) The device group location (default: `shared`).
  - `description`: (optional) The description of the Wildfire Analysis profile.
  - `rules`: (optional) List of objects following the rule specifications.
    - `name`: (required) Rule name.
    - `applications`: (optional) List of applications (default: `any`).
    - `file_types`: (optional) List of file types (default: `any`).
    - `direction`: (optional) Direction for the wildfire analysis policy. Valid values are `both`, `upload`, or `download` (default: `both`).
    - `analysis`: (optional) Analysis setting. Valid values are `public-cloud` or `private-cloud` (default: `public-cloud`).

  Example:
  ```
  [
    {
      name = "Outbound-WF"
      rules = [
        {
          name = "Forward-All"
          applications = ["any"]
          file_types = ["any"]
          direction = "both"
          analysis = "public-cloud"
        }
      ]
    }
  ]
  ```
  EOF

  default = {}
  type = map(object({
    description = optional(string)
    rules = optional(list(object({
      name         = string
      applications = optional(list(string), ["any"])
      file_types   = optional(list(string), ["any"])
      direction    = optional(string, "both")
      analysis     = optional(string, "public-cloud")
    })), [])
  }))

  validation {
    condition = alltrue([
      for profile in var.wildfire_analysis_profiles : alltrue([
        for rule in profile.rules : contains(["both", "upload", "download"], rule.direction)
      ])
    ])
    error_message = "Valid 'direction' values are: 'both', 'upload', 'download'."
  }
  validation {
    condition = alltrue([
      for profile in var.wildfire_analysis_profiles : alltrue([
        for rule in profile.rules : contains(["public-cloud", "private-cloud"], rule.analysis)
      ])
    ])
    error_message = "Valid 'analysis' values are: 'public-cloud', 'private-cloud'."
  }
}

variable "url_filtering_profiles" {
  description = <<-EOF
  List of the Url Filtering security profile objects. Each item supports following parameters:
  - `name`: (required) Identifier of the Url Filtering security profile.
  - `description`: (optional) The description of the Url Filtering profile.
  
  Example:
  ```
  
  ```
  EOF

  default = {}
  type = map(object({
    description = optional(string)
    allow_categories = optional(list(string))
    alert_categories = optional(list(string))
    block_categories = optional(list(string))
    continue_categories = optional(list(string))
    override_categories = optional(list(string))
    track_container_page = optional(bool)
    log_container_page_only = optional(bool)
    safe_search_enforcement = optional(bool)
    log_http_header_xff = optional(bool)
    log_http_header_user_agent = optional(bool)
    log_http_header_referer = optional(bool)
    # ucd stuff no idea what this is...  Skipping for now.
    ucd_mode = optional(string, "disabled")
    ucd_mode_group_mapping = optional(string)
    ucd_log_severity = optional(string)
    ucd_allow_categories = optional(list(string))
    ucd_alert_categories = optional(list(string))
    ucd_block_categories = optional(list(string))
    ucd_continue_categories = optional(list(string))
    http_header_insertion = optional(list(object({
      name              = string
      type              = optional(string) # this is a specific list but do not want to bother validation now
      domains           = optional(list(string))
      http_header       = optional(list(object( {
        name = string
        header = string
        value = string
        log = optional(bool, false)
      })), [])
    })), [])
    machine_learning_model = optional(list(object({
      model              = string
      action              = optional(string, "any")
    })), [])
    machine_learning_exceptions = optional(list(string))
  }))

}

variable "data_filtering_profiles" {
  description = <<-EOF
  List of the Data Filtering security profile objects. Each item supports following parameters:
  - `name`: (required) Identifier of the Data Filtering security profile.
  - `description`: (optional) The description of the Data Filtering profile.
  
  Example:
  ```
  
  ```
  EOF

  default = {}
  type = map(object({
    description = optional(string)
    data_capture = optional(bool)
    rule = optional(list(object({
      data_pattern      = string
      applications      = optional(list(string), ["any"])
      file_types        = optional(list(string), ["any"])
      direction         = optional(string, "both")
      alert_threshold   = optional(number, 0)
      block_threshold   = optional(number, 0)
      log_severity      = optional(string, "informational")
    })), [])
  }))

}

variable "data_pattern_objects" {
  description = <<-EOF
  List of the Data Pattern objects. Each item supports following parameters:
  - `name`: (required) Identifier of the Data Pattern object.
  - `description`: (optional) The description of the Data Pattern object.
  
  Example:
  ```
  
  ```
  EOF

  default = {}
  type = map(object({
    description = optional(string)
    type = optional(string, "file-properties")
    predefined_pattern = optional(list(object({
      name              = string
      file_types       = optional(list(string))
    })), [])
    regex = optional(list(object({
      name              = string
      file_types       = list(string)
      regex            = string
    })), [])
    file_property = optional(list(object({
      name              = string
      file_type       = string
      file_property     = string
      property_value        = string
    })), [])
  }))

}