variable "panorama" {
  description = "If modules have target to Panorama, it enable Panorama specific variables."
  default     = false
  type        = bool
}

#tags
variable "tags" {
  description = <<-EOF
  List of tag objects.
  - `name`: (required) The administrative tag's name.
  - `device_group`: (optional) The device group location (default: `shared`).
  - `comment`: (optional) The description of the administrative tag.
  - `color`: (optional) The tag's color. This should either be an empty string (no color) or a string such as `color1`. Note that the colors go from 1 to 16.

  Example:
  ```
[
  {
    name = "trust"
  }
  {
    name = "untrust"
    comment = "for untrusted zones"
    color = "color4"
  }
  {
    name = "AWS"
    device_group = "AWS"
    color = "color8"
  }
]
  ```
  EOF
  default     = []
  type        = any

}

variable "tag_color_map" {
  description = "Map of tag-color match, [provider documentation](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/resources/administrative_tag)"
  default = {
    red            = "color1"
    green          = "color2"
    blue           = "color3"
    yellow         = "color4"
    copper         = "color5"
    orange         = "color6"
    purple         = "color7"
    gray           = "color8"
    light_green    = "color9"
    cyan           = "color10"
    light_gray     = "color11"
    blue_gray      = "color12"
    lime           = "color13"
    black          = "color14"
    gold           = "color15"
    brown          = "color16"
    olive          = "color17"
    maroon         = "color19"
    red_orange     = "color20"
    yellow_orange  = "color21"
    forest_green   = "color22"
    turquoise_blue = "color23"
    azure_blue     = "color24"
    cerulean_blue  = "color25"
    midnight_blue  = "color26"
    medium_blue    = "color27"
    cobalt_blue    = "color28"
    violet_blue    = "color29"
    blue_violet    = "color30"
    medium_violet  = "color31"
    medium_rose    = "color32"
    lavender       = "color33"
    orchid         = "color34"
    thistle        = "color35"
    peach          = "color36"
    salmon         = "color37"
    magenta        = "color38"
    red_violet     = "color39"
    mahogany       = "color40"
    burnt_sienna   = "color41"
    chestnut       = "color42"
  }
  type = any
}