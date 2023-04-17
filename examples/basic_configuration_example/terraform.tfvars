# pan_creds = "./creds/credentials_panorama.json"
# mode      = "panorama"

pan_creds = "./creds/credentials_vmseries.json"
mode      = "ngfw"

device_group   = ["AWSTestDG", "AzureTestDG"]
vsys           = ["vsys1"]
template       = "test-template"
template_stack = ""

### Tags

tags = {
  DNS-SRV = {
    color   = "DNS-SRV"
    comment = "Tag for DNS servers"
  }
  DNS-SRV-2 = {
    comment = "Tag for DNS servers-2"
  }
  "Managed by Terraform" = {
    comment = "Managed by Terraform"
  }
  Outbound = {
    color   = "Cyan"
    comment = "Outbound"
  }
  Inbound = {
    color   = "Light Green"
    comment = "Inbound"
  }
  AWS-Route53-Health-Probe = {
    color = "Gold"
  }
  PSN = {
    color   = "Brown"
    comment = "PSN"
  }
  dns-proxy = {
    color   = "Olive"
    comment = "dns-proxy"
  }
}

### Address, Address Groups

addresses = {
  DNS1 = {
    "value"       = "1.1.1.1/32"
    "type"        = "ip-netmask"
    "description" = "DNS-SRV-Public-1"
  },
  DNS2 = {
    "value"       = "1.0.0.1/32"
    "type"        = "ip-netmask"
    "description" = "DNS-SRV-Public-2"
  },
  DNS3 = {
    "value"       = "8.8.4.4/32"
    "type"        = "ip-netmask"
    "description" = "DNS-GOOGLE-1"
  },
  DNS4 = {
    "value"       = "8.8.8.8/32"
    "type"        = "ip-netmask"
    "description" = "DNS-GOOGLE-2"
  },
  Server10 = {
    "value"       = "10.0.0.10/32"
    "type"        = "ip-netmask"
    "description" = "Server10"
  },
  Server11 = {
    "value"       = "10.0.0.11/32"
    "type"        = "ip-netmask"
    "description" = "Server11"
  },
  WebServer1 = {
    "value"       = "10.0.1.10/32"
    "type"        = "ip-netmask"
    "description" = "WebServer1"
  },
  WebServer2 = {
    "value"       = "10.0.1.20/32"
    "type"        = "ip-netmask"
    "description" = "WebServer2"
  },
  "RFC1918_192.168.0.0_16" = {
    "value" = "192.168.0.0/16"
    "type"  = "ip-netmask"
  },
  "RFC1918_172.16.0.0_12" = {
    "value" = "172.16.0.0/12"
    "type"  = "ip-netmask"
  },
  "RFC1918_10.0.0.0_8" = {
    "value" = "10.0.0.0/8"
    "type"  = "ip-netmask"
  },
  NTP1 = {
    "value" = "1.0.0.1/32"
    "type"  = "ip-netmask"
  },
  NTP2 = {
    "value" = "2.0.0.2/32"
    "type"  = "ip-netmask"
  },
  "AWS-15.177.0.0_16" = {
    "value" = "15.177.0.0/16"
    "type"  = "ip-netmask"
  },
  "GlobalProtect Public-A" = {
    "value" = "10.184.0.0/24"
    "type"  = "ip-netmask"
  },
  "GlobalProtect Public-B" = {
    "value" = "10.184.1.0/24"
    "type"  = "ip-netmask"
  },
  "GlobalProtect Public-C" = {
    "value" = "10.184.2.0/24"
    "type"  = "ip-netmask"
  },
}

address_groups = {
  AddressDeviceGroup = {
    members     = ["DNS1", "DNS2"]
    description = "DNS servers"
  }
  DNS-Servers = {
    members = ["DNS1", "DNS2", "DNS3", "DNS4"]
  }
  WebServers = {
    members     = ["WebServer1", "WebServer2"]
    description = "Web Servers"
  }
  SSH-Servers = {
    members     = ["Server10", "Server11"]
    description = "SSH Servers"
  }
  RFC1918_Subnets = {
    members     = ["RFC1918_192.168.0.0_16", "RFC1918_172.16.0.0_12", "RFC1918_10.0.0.0_8"]
    description = "Private ranges"
  }
  panw-known-ip-list = {
    members = ["NTP1", "NTP2"]
  }
  sop-oci = {
    dynamic_match = "sop-oci"
  }
  grp-dns-proxy = {
    dynamic_match = "dns-proxy'"
  }
}

### Service, Service Groups

services = {
  SomeWeb = {
    protocol         = "tcp"
    destination_port = "80,443"
    description      = "Some web services"
  }
  SomeFTP = {
    protocol         = "tcp"
    destination_port = "21"
    description      = "Some FTP services"
  }
  SomeSSH = {
    protocol         = "tcp"
    destination_port = "21"
    description      = "Some SSH services"
  }
  SSH-8022 = {
    protocol         = "tcp"
    destination_port = "8022"
    description      = "SSH not-default port"
  }
  Web-8080 = {
    protocol         = "tcp"
    destination_port = "8080"
    description      = "HTTP not-default port"
  }
  tcp_4450 = {
    protocol         = "tcp"
    destination_port = "4450"
    description      = "Custom ports for PSN Services"
  }
  tcp_4457-4458 = {
    protocol         = "tcp"
    destination_port = "4457-4458"
    description      = "Custom ports for PSN Services"
  }
}

services_group = {
  "Customer Group" = {
    members = ["SomeWeb", "SomeSSH", "SomeFTP"]
  }
  HTTP-ports = {
    members = ["SomeWeb", "Web-8080"]
  }
  "PSN Custom Ports" = {
    members = ["tcp_4450", "tcp_4457-4458"]
  }
}

### Network - interfaces

interfaces = {
  "ethernet1/1" = {
    type                      = "ethernet"
    mode                      = "layer3"
    management_profile        = "mgmt_default"
    link_state                = "up"
    static_ips                = null
    enable_dhcp               = true
    create_dhcp_default_route = false
    dhcp_default_route_metric = null
    comment                   = "mgmt"
    virtual_router            = "default"
    zone                      = "mgmt"
    vsys                      = "vsys1"
  }
  "ethernet1/2" = {
    type                      = "ethernet"
    mode                      = "layer3"
    management_profile        = "mgmt_default"
    link_state                = "up"
    static_ips                = null
    enable_dhcp               = null
    create_dhcp_default_route = null
    dhcp_default_route_metric = null
    comment                   = "external"
    virtual_router            = "external"
    zone                      = "external"
    vsys                      = "vsys1"
  }
  "ethernet1/3" = {
    type                      = "ethernet"
    mode                      = "layer3"
    management_profile        = null
    link_state                = "up"
    static_ips                = null
    enable_dhcp               = null
    create_dhcp_default_route = null
    dhcp_default_route_metric = null
    comment                   = "internal"
    virtual_router            = "internal"
    zone                      = "internal"
    vsys                      = "vsys1"
  }
  "loopback.42" = {
    type                      = "loopback"
    mode                      = "layer3"
    management_profile        = null
    link_state                = "up"
    static_ips                = null
    enable_dhcp               = null
    create_dhcp_default_route = null
    dhcp_default_route_metric = null
    comment                   = "internal"
    virtual_router            = "internal"
    zone                      = "vpn"
    vsys                      = "vsys1"
  }
  "tunnel.42" = {
    type                      = "tunnel"
    mode                      = "layer3"
    management_profile        = null
    link_state                = "up"
    static_ips                = null
    enable_dhcp               = null
    create_dhcp_default_route = null
    dhcp_default_route_metric = null
    comment                   = "internal"
    virtual_router            = "internal"
    zone                      = "vpn"
    vsys                      = "vsys1"
  }
}

### Network - management profile

management_profiles = {
  "mgmt_default" = {
    ping           = true
    telnet         = false
    ssh            = true
    http           = false
    https          = true
    snmp           = false
    userid_service = null
    permitted_ips  = ["1.1.1.1/32", "2.2.2.2/32"]
  }
}

### Network - virtual router

virtual_routers = {
  "default" = {
    mode = "layer3"
    route_tables = {
      "unicast" = {
        routes = {
          "df_route" = {
            destination    = "0.0.0.0/0"
            interface      = "ethernet1/1"
            type           = "ip-address"
            next_hop       = "10.1.1.1"
            admin_distance = null
            metric         = 10
          }
        }
      }
    }
  }
  "external" = {
    mode = "layer3"
    route_tables = {
      "unicast" = {
        routes = {
          "df_route" = {
            destination    = "0.0.0.0/0"
            interface      = "ethernet1/2"
            type           = "ip-address"
            next_hop       = "10.1.2.1"
            admin_distance = null
            metric         = 10
          }
        }
      }
    }
  }
  "internal" = {
    mode = "layer3"
    route_tables = {
      "unicast" = {
        routes = {
          "IPSec_route" = {
            destination    = "10.10.10.0/24"
            interface      = "tunnel.42"
            type           = ""
            next_hop       = null
            admin_distance = null
            metric         = null
          }
        }
      }
    }
  }
}

### Network - zone

zones = {
  "internal" = {
    mode           = "layer3"
    zone_profile   = null
    log_setting    = null
    enable_user_id = null
    interfaces     = null
    include_acls   = null
    exclude_acls   = null
  }
}

### Network - IPSec

ike_gateways          = {}
ike_crypto_profiles   = {}
ipsec_crypto_profiles = {}
ipsec_tunnels         = {}