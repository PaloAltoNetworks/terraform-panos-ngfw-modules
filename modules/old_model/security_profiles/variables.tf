variable "antivirus" {
  description = <<-EOF
  List of the Antivirus Profile objects.
  - `name`: (required) Identifier of the Antivirus security profile.
  - `device_group`: (optional) The device group location (default: `shared`).
  - `description`: (optional) The description of the Antivirus profile.
  - `packet_capture`: (optional) Boolean that enables packet capture (default: `false`).
  - `threat_exceptions`: (optional) A string list of threat exceptions.
  - `decoder`: (optional) List of objects following the decoder specifications.
    - `name`: (required) Decoder name.
    - `actions`: (optional) Decoder action. Valid values are `default`, `allow`, `alert`, `drop`, `reset-client`, `reset-server`, or `reset-both` (default: `default`).
    - `wildfire_action`: (optional) Wildfire action. Valid values are `default`, `allow`, `alert`, `drop`, `reset-client`, `reset-server`, or `reset-both` (default: `default`).
    - `machine_learning_action`: (optional) Only available with PAN-OS 10.0+, machine learning action. Valid values are `default`, `allow`, `alert`, `drop`, `reset-client`, `reset-server`, or `reset-both` (default: `default`).
  - `application_exception`: (optional) List of objects following the application exception specifications.
    - `application`: (required) The application name.
    - `action`: (optional) The action performed when approached with the application exception. Valid values are `default`, `allow`, `alert`, `drop`, `reset-client`, `reset-server`, or `reset-both` (default: `default`).
  - `machine_learning_model`: (optional) List of objects following the machine learning model specifications.
    - `model`: (required) The model.
    - `action`: (required) The action for the machine learning model to perform. Valid values are `default`, `allow`, `alert`, `drop`, `reset-client`, `reset-server`, or `reset-both` (default: `default`).
  - `machine_learning_exception`: (optional) List of objects following the machine learning exception specifications.
    - `name`: (required) Partial hash of file included in the machine learning exception.
    - `description`: (optional) The description of the exception.
    - `filename`: (optional) The filename for the exception
  Example:
  ```
  [
    {
      name = "Alert-Only-AV"
      decoder: [
        {
          name = "http"
          action = "alert"
          wildfire_action = "alert"
          machine_learning = "alert"
        }
      ]
      machine_learning_model = [
        {
          model = "Windows Executables"
          action = "enable"
        }
        {
          model = "PowerShell Script 1"
          action = "enable"
        }
      ]
    }
  ]
  ```
  EOF

  default = []
  type    = any
}

variable "file_blocking" {
  description = <<-EOF
  List of the File-Blocking Profile objects.
  - `name`: (required) Identifier of the File-blocking security profile.
  - `device_group`: (optional) The device group location (default: `shared`).
  - `description`: (optional) The description of the File-blocking profile.
  - `rule`: (optional) List of objects following the rule specifications.
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
      rule = [
        {
          name = "Alert-All"
          applications = ["any"]
          file_types = ["any"]
          direction = "both"
          action = "alert"
        }
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

  default = []
  type    = any
}

variable "spyware" {
  description = <<-EOF
  List of the Anti-Spyware Profile objects.
  - `name`: (required) Identifier of the Anti-Spyware security profile.
  - `device_group`: (optional) The device group location (default: `shared`).
  - `description`: (optional) The description of the Anti-Spyware profile.
  - `packet_capture`: (optional) Packet capture setting for PAN-OS 8.X only). Valid values are `disable`, single-packet`, or `extended-capture` (default: `disable`).
  - `sinkhole_ipv4_address`: (optional) IPv4 sinkhole address.
  - `sinkhole_ipv6_address`: (optional) IPv6 sinkhole address.
  - `threat_exceptions`: (optional) A string list of threat exceptions.
  - `botnet_list`: (optional) List of objects following the botnet specifications.
    - `name`: (required) Botnet name.
    - `actions`: (optional) Botnet action. Valid values are `allow`, `alert`, `block`, `default`, or `sinkhole` (default: `default`).
    - `packet_capture`: (optional) Packet capture setting for PAN-OS 9.0+. Valid values are `disable`, `single-packet`, or `extended-capture` (default: `disable`).
  - `dns_category`: (optional) List of objects following the DNS category specifications for PAN-OS 10.0+.
    - `name`: (required) DNS category name.
    - `action`: (optional) DNS category action. Valid values are `default`, `allow`, `alert`, `drop`, `block`, or `sinkhole` (default: `default`).
    - `log_level`: (optional) Logging level. Valid values are `default`, `none`, `low`, `informational`, `medium`, `high`, or `critical` (default: `default`).
    - `packet_capture`: (optional) Packet capture setting. Valid values are `disable`, `single-packet`, or `extended-capture` (default: `disable`).
  - `white_list`: (optional) List of objects following the white list specifications.
    - `name`: (required) White list object name.
    - `description`: (optional) Description of the white list.
  - `rule`: (optional) List of objects following the rule specifications.
    - `name`: (required) Rule name.
    - `threat_name`: (optional) Threat name.
    - `category`: (optional) Category for the anti-spyware policy (default: `any`).
    - `severities`: (optional) List of severities to include in policy. Valid values are `any`, `critical`, `high`, `medium`, `low`, or/and `informational` (default: `any`).
    - `packet_capture`: (optional) Packet capture setting. Valid values are `disable`, `single-packet`, or `extended-capture` (default: `disable`).
    - `block_ip_track_by`: (required if `action` = `block-ip`) The track setting. Valid values are `source` or `source-and-destination`.
    - `block_ip_duration`: (required if `action` = `block-ip`) The duration of the block. Valid values are integers.
  - `exception`: (optional) List of objects following the exceptions specifications.
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
      device_group = "shared"
      botnet_list = [
        {
          name = "default-paloalto-dns"
          action = "sinkhole"
          packet_capture = "single-packet"
        }
      ]
      dns_category = [
        {
          name = "pan-dns-sec-benign"
        }
        {
          name = "pan-dns-sec-cc"
          action = "sinkhole"
          packet_capture = "single-packet"
        }
      ]
      sinkhole_ipv4_address = "72.5.65.111"
      sinkhole_ipv6_address = "2600:5200::1"
      rule =
      [
        {
          name = "Block-Critical-High-Medium"
          action = "reset-both"
          severities = ["critical","high","medium"]
          packet_capture = "single-packet"
        }
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

  default = []
  type    = any
}

variable "vulnerability" {
  description = <<-EOF
  List of the Vulnerability Profile objects.
  - `name`: (required) Identifier of the Vulnerability security profile.
  - `device_group`: (optional) The device group location (default: `shared`).
  - `description`: (optional) The description of the vulnerability profile.
  - `rule`: (optional) List of objects following the rule specifications.
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
  - `exception`: (optional) List of objects following the exceptions specifications.
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
      rule = [
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
        }
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

  default = []
  type    = any
}

variable "wildfire" {
  description = <<-EOF
  List of the Wildfire Analysis Profile objects.
  - `name`: (required) Identifier of the Wildfire Analysis security profile.
  - `device_group`: (optional) The device group location (default: `shared`).
  - `description`: (optional) The description of the Wildfire Analysis profile.
  - `rule`: (optional) List of objects following the rule specifications.
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
      rule = [
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

  default = []
  type    = any
}