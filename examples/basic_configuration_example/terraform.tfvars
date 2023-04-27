pan_creds = "./creds/credentials.json"
mode      = "panorama"

### Device group

device_groups = {
  "aws-test-dg" = {
    description = "Device group used for AWS cloud"
    #    serial = ["1111222233334444"]
    parent = "clouds"
  }
}

vsys = "vsys1"

### Templates

templates = {
  "test-template" = {
    description = "My test template"
  }
}

template_stacks = {
  "test-template-stack" = {
    description = "My test template stack with devices"
    templates   = ["test-template"]
    # devices     = ["123456789"]
  }
}

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

service_groups = {
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

### Security policies

security_policies = {
  "allow_rule_group" = {
    rulebase = "pre-rulebase"
    rules = [
      {
        name = "Allow access to DNS Servers"
        tags = [
          "Outbound",
          "Managed by Terraform"
        ]
        source_zones          = ["Trust-L3"]
        source_addresses      = ["RFC1918_Subnets"]
        destination_zones     = ["Untrust-L3"]
        destination_addresses = ["DNS-Servers"]
        applications          = ["dns"]
        services              = ["application-default"]
        action                = "allow"
        log_end               = "true"
        virus                 = "default"
        spyware               = "default"
        vulnerability         = "default"
      },
      {
        name             = "Allow access to RFC1918"
        tags             = ["Managed by Terraform"]
        source_zones     = ["Trust-L3"]
        source_addresses = ["RFC1918_Subnets"]
        destination_zones = [
          "Trust-L3",
          "Untrust-L3"
        ]
        destination_addresses = ["RFC1918_Subnets"]
        services              = ["application-default"]
        action                = "allow"
        log_end               = "true"
        virus                 = "default"
        spyware               = "default"
        vulnerability         = "default"
      },
      {
        name = "Disabled - temporary access to Srv10 and Srv11"
        tags = [
          "Outbound",
          "Managed by Terraform"
        ]
        source_zones = ["Trust-L3"]
        source_addresses = [
          "Server10",
          "Server11"
        ]
        destination_zones     = ["Untrust-L3"]
        destination_addresses = ["123.123.123.123/32"]
        services              = ["SSH-8022"]
        action                = "allow"
        log_end               = "true"
        disabled              = "true"
        virus                 = "default"
        spyware               = "default"
        vulnerability         = "default"
        url_filtering         = "default"
        file_blocking         = "basic file blocking"
        wildfire_analysis     = "default"
      },
      {
        name = "Allow access to SSH Servers"
        tags = [
          "Inbound",
          "Managed by Terraform"
        ]
        source_zones          = ["Untrust-L3"]
        negate_source         = "false"
        destination_zones     = ["Trust-L3"]
        destination_addresses = ["SSH-Servers"]
        negate_destination    = "false"
        applications          = ["ssh"]
        services              = ["application-default"]
        action                = "allow"
        log_end               = "true"
      }
    ]
  }
  "block_rule_group" = {
    position_keyword = "bottom"
    rulebase         = "pre-rulebase"
    rules = [
      {
        name = "Block Some Traffic"
        tags = [
          "Outbound",
          "Managed by Terraform"
        ]
        source_zones     = ["Trust-L3"]
        source_addresses = ["10.0.0.100/32"]
        action           = "deny"
        log_end          = "true"
      }
    ]
  }
}

### Network - interfaces

interfaces = {
  "ethernet1/1" = {
    type                      = "ethernet"
    mode                      = "layer3"
    management_profile        = "mgmt_default"
    link_state                = "up"
    enable_dhcp               = true
    create_dhcp_default_route = false
    comment                   = "mgmt"
    virtual_router            = "vr"
    zone                      = "mgmt"
    vsys                      = "vsys1"
  }
  "ethernet1/2" = {
    type               = "ethernet"
    mode               = "layer3"
    management_profile = "mgmt_default"
    link_state         = "up"
    comment            = "external"
    virtual_router     = "external"
    zone               = "external"
    vsys               = "vsys1"
  }
  "ethernet1/3" = {
    type           = "ethernet"
    mode           = "layer3"
    link_state     = "up"
    comment        = "internal"
    virtual_router = "internal"
    zone           = "internal"
    vsys           = "vsys1"
  }
  "loopback.42" = {
    type           = "loopback"
    mode           = "layer3"
    link_state     = "up"
    comment        = "internal"
    virtual_router = "internal"
    zone           = "vpn"
    vsys           = "vsys1"
  }
  "tunnel.42" = {
    type           = "tunnel"
    mode           = "layer3"
    link_state     = "up"
    comment        = "internal"
    virtual_router = "internal"
    zone           = "vpn"
    vsys           = "vsys1"
  }
}

### Network - management profile

management_profiles = {
  "mgmt_default" = {
    ping          = true
    telnet        = false
    ssh           = true
    http          = false
    https         = true
    snmp          = false
    permitted_ips = ["1.1.1.1/32", "2.2.2.2/32"]
  }
}

### Network - virtual router

virtual_routers = {
  "vr"       = {}
  "external" = {}
  "internal" = {}
}

static_routes = {
  "vr_default_unicast_0.0.0.0" = {
    virtual_router = "vr"
    route_table    = "unicast"
    destination    = "0.0.0.0/0"
    interface      = "ethernet1/1"
    type           = "ip-address"
    next_hop       = "10.1.1.1"
    metric         = 10
  }
  "vr_internal_unicast_10.10.10.0" = {
    virtual_router = "internal"
    route_table    = "unicast"
    destination    = "10.10.10.0/24"
    interface      = "tunnel.42"
    type           = ""
  }
  "vr_external_unicast_0.0.0.0" = {
    virtual_router = "external"
    route_table    = "unicast"
    destination    = "0.0.0.0/0"
    interface      = "ethernet1/2"
    type           = "ip-address"
    next_hop       = "10.1.2.1"
    metric         = 10
  }
}

### Network - zone

zones = {
  "Trust-L3" = {
    mode = "layer3"
  }
  "Untrust-L3" = {
    mode = "layer3"
  }
}

### Network - IPSec

ike_gateways = {
  "IKE-GW-1" = {
    version              = "ikev1"
    disabled             = false
    peer_ip_type         = "ip"
    peer_ip_value        = "5.5.5.5"
    interface            = "ethernet1/1"
    pre_shared_key       = "test12345"
    local_id_type        = "ipaddr"
    local_id_value       = "10.1.1.1"
    peer_id_type         = "ipaddr"
    peer_id_value        = "10.5.1.1"
    ikev1_crypto_profile = "AES128_default"
  }
}

ike_crypto_profiles = {
  "AES128_default" = {
    dh_groups               = ["group2", "group5"]
    authentications         = ["md5", "sha1"]
    encryptions             = ["aes-128-cbc", "aes-192-cbc"]
    lifetime_type           = "hours"
    lifetime_value          = 24
    authentication_multiple = 0
  }
  "AES128_DH5" = {
    dh_groups               = ["group5"]
    authentications         = ["sha1"]
    encryptions             = ["aes-128-cbc", "aes-192-cbc"]
    lifetime_type           = "hours"
    lifetime_value          = 8
    authentication_multiple = 3
  }
}

ipsec_crypto_profiles = {
  "AES128_default" = {
    protocol        = "esp"
    authentications = ["md5", "sha1"]
    encryptions     = ["aes-128-cbc", "aes-192-cbc"]
    dh_group        = "group5"
    lifetime_type   = "hours"
    lifetime_value  = 24
  }
  "AES128_DH14" = {
    protocol        = "esp"
    authentications = ["sha1"]
    encryptions     = ["aes-128-cbc", "aes-192-cbc"]
    dh_group        = "group14"
    lifetime_type   = "hours"
    lifetime_value  = 24

  }
}

ipsec_tunnels = {
  "some_tunnel" = {
    virtual_router          = "internal"
    tunnel_interface        = "tunnel.42"
    type                    = "auto-key"
    disabled                = false
    ak_ike_gateway          = "IKE-GW-1"
    ak_ipsec_crypto_profile = "AES128_DH14"
    anti_replay             = false
    copy_flow_label         = false
    enable_tunnel_monitor   = false
    proxy_subnets           = "example1,10.10.10.0/24,10.10.20.0/24;example2,10.10.10.0/24,10.10.30.0/24"
  }
}
