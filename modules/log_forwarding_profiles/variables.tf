variable "mode" {
  description = "The mode to use for the module. Valid values are `panorama` and `ngfw`."
  type        = string
  validation {
    condition     = contains(["panorama", "ngfw"], var.mode)
    error_message = "The mode must be either `panorama` or `ngfw`."
  }
}

variable "device_group" {
  description = "Defines the Device Group for the deployment, used if `var.mode` is `panorama`."
  default     = "shared"
  type        = string
}

variable "vsys" {
  description = "Defines the vsys for the deployment, used if `var.mode` is `ngfw`."
  default     = "vsys1"
  type        = string
}

variable "profiles" {
  description = <<-EOF
  Map with log forwarding profile definitions, keys are the object names:
  - `description`: (optional) The description of the profile.
  - `enhanced_logging`: (optional) Enable enhanced logging.
  - `match_lists`: (optional) Match lists definitions:
    - `name`: (required) Name.
    - `description`: (required) Description.
    - `log_type`: (optional) Log type.
    - `filter`: (optional) Log filter.
    - `send_to_panorama`: (optional) Enable sending to Panorama.
    - `snmptrap_server_profiles`: (optional) List of server SNMP profiles.
    - `email_server_profiles`: (optional) List of server email profiles.
    - `syslog_server_profiles`: (optional) List of server syslog profiles.
    - `http_server_profiles`: (optional) List of server HTTP profiles.
    - `actions`: (optional) Match list actions specifications:
      - `name`: (required) Action name.
      - `azure_integration`: (optional) Enable Azure integration (mutually exclusive with `tagging_integration`).
      - `tagging_integration`: (optional) Tagging integration specification (mutually exclusive with `azure_integration`):
        - `action`: (optional) Action. Valid values are `add-tag` (default) or `remove-tag`.
        - `target`: (optional) Target. Valid values are `source-address` (default) or `destination-address`.
        - `timeout`: (optional) Amount of time (in minutes) to maintain IP address-to-tag mapping. If unset or 0 the mapping does not timeout.
        - `local_registration`: (optional) Local User-ID registration spec (mutually eaxclusive with `panorama_registration` and `remote_registration`):
          - `tags`: (required) List of administrative tags.
        - `panorama_registration`: (optional) Panorama User-ID registration spec (mutually eaxclusive with `local_registration` and `remote_registration`):
          - `tags`: (required) List of administrative tags.
        - `remote_registration`: (optional) Remote User-ID registration spec (mutually eaxclusive with `local_registration` and `panorama_registration`):
          - `tags`: (required) List of administrative tags.
          - `http_profile`: (required) HTTP profile.

  Example:
  ```
  profiles = {
    panorama = {
    match_lists = [
      {
        name = "threat"
        log_type = "threat"
        send_to_panorama = true
      },
      {
        name = "wf"
        log_type = "wildfire"
        send_to_panorama = true
      },
      {
        name = "url"
        log_type = "url"
        send_to_panorama = true
      },
      {
        name = "auth"
        log_type = "auth"
        send_to_panorama = true
      },
    ]
  }
  }
  ```
  EOF

  default = {}
  type = map(object({
    description      = optional(string)
    enhanced_logging = optional(bool)
    match_lists = optional(list(object({
      name                     = string
      description              = optional(string)
      log_type                 = optional(string, "traffic")
      filter                   = optional(string, "All logs")
      send_to_panorama         = optional(bool)
      snmptrap_server_profiles = optional(list(string))
      email_server_profiles    = optional(list(string))
      syslog_server_profiles   = optional(list(string))
      http_server_profiles     = optional(list(string))
      actions = optional(list(object({
        name              = string
        azure_integration = optional(bool)
        tagging_integration = optional(object({
          action  = optional(string, "add-tag")
          target  = optional(string, "source-address")
          timeout = optional(number)
          local_registration = optional(object({
            tags = list(string)
          }))
          panorama_registration = optional(object({
            tags = list(string)
          }))
          remote_registration = optional(object({
            http_profile = string
            tags         = list(string)
          }))
        }))
      })), [])
    })), [])
  }))

  validation {
    condition = alltrue([
      for p in var.profiles : alltrue([
        for ml in p.match_lists : contains(["traffic", "threat", "wildfire", "url", "data", "gtp", "tunnel", "auth", "sctp", "decryption"], ml.log_type)
      ])
    ])
    error_message = "Valid values of 'log_type' are: 'traffic' (default), 'threat', 'wildfire', 'url', 'data', 'gtp', 'tunnel', 'auth', 'sctp', 'decryption'."
  }
  validation {
    condition = alltrue([
      for p in var.profiles : alltrue([
        for ml in p.match_lists : alltrue([
          for a in ml.actions : try(a.azure_integration, null) != null ? a.azure_integration == true : true
        ])
      ])
    ])
    error_message = "If 'azure_integration' is present, it has to be set to 'true'."
  }
  validation {
    condition = alltrue([
      for p in var.profiles : alltrue([
        for ml in p.match_lists : alltrue([
          for a in ml.actions : length(concat(
            try(a.azure_integration, null) != null ? ["a"] : [],
            try(a.tagging_integration, null) != null ? ["t"] : []
          )) <= 1 ? true : false
        ])
      ])
    ])
    error_message = "'azure_integration' and 'tagging_integration' are mutually exclusive."
  }
  validation {
    condition = alltrue([
      for p in var.profiles : alltrue([
        for ml in p.match_lists : alltrue([
          for a in ml.actions : try(a.tagging_integration, null) != null ? contains(["add-tag", "remove-tag"], coalesce(a.tagging_integration.action, "add-tag")) : true
        ])
      ])
    ])
    error_message = "Valid values of 'action' for 'tagging_integration' are 'add-tag', 'remove-tag'."
  }
  validation {
    condition = alltrue([
      for p in var.profiles : alltrue([
        for ml in p.match_lists : alltrue([
          for a in ml.actions : try(a.tagging_integration, null) != null ? contains(["source-address", "destination-address"], coalesce(a.tagging_integration.target, "source-address")) : true
        ])
      ])
    ])
    error_message = "Valid values of 'target' for 'tagging_integration' are 'source-address', 'destination-address'."
  }
  validation {
    condition = alltrue([
      for p in var.profiles : alltrue([
        for ml in p.match_lists : alltrue([
          for a in ml.actions : length(concat(
            try(a.tagging_integration.local_registration, null) != null ? ["l"] : [],
            try(a.tagging_integration.panorama_registration, null) != null ? ["p"] : [],
            try(a.tagging_integration.remote_registration, null) != null ? ["r"] : []
          )) <= 1 ? true : false
        ])
      ])
    ])
    error_message = "'local_registration', 'panorama_registration', 'remote_registration' are mutually exclusive."
  }
}
