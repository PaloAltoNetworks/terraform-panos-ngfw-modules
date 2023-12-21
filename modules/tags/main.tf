locals {
  mode_map = {
    panorama = 0
    ngfw     = 1
    # cloud_manager = 2 # Not yet supported
  }
  tag_color_map = {
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
}

resource "panos_panorama_administrative_tag" "this" {
  for_each = local.mode_map[var.mode] == 0 ? var.tags : {}

  name         = each.key
  color        = try(local.tag_color_map[lower(replace(each.value.color, " ", "_"))], null)
  comment      = try(each.value.comment, null)
  device_group = var.device_group

  lifecycle {
    create_before_destroy = true
  }
}

resource "panos_administrative_tag" "this" {
  for_each = local.mode_map[var.mode] == 1 ? var.tags : {}

  name    = each.key
  color   = try(local.tag_color_map[lower(replace(each.value.color, " ", "_"))], null)
  comment = try(each.value.comment, null)
  vsys    = var.vsys

  lifecycle {
    create_before_destroy = true
  }
}
