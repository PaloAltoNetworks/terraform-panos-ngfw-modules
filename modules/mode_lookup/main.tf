# This is a utility module to convert the mode variable to a number for use in the other modules

locals {
  lookup_map = {
    panorama = 0
    ngfw     = 1
    # cloud_manager = 2 # Not yet supported
  }
}


