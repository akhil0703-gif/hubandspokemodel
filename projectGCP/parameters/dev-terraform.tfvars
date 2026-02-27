project_id = "testproject-488314"
region     = "us-central1"
zone       = "us-central1-a"
env_suffix = "us-qa-001"

vpcs = {
  hub = {
    name = "vpc-hub"
    subnets = {
      frontend   = { name = "subnet-hub-frontend", cidr = "10.0.1.0/24" }
      backend    = { name = "subnet-hub-backend", cidr = "10.0.2.0/24" }
      management = { name = "subnet-hub-management", cidr = "10.0.3.0/24" }
    }
  }
  spoke1 = {
    name = "vpc-spoke1"
    subnets = {
      app = { name = "subnet-spoke1-app", cidr = "10.1.1.0/24" }
      db  = { name = "subnet-spoke1-db", cidr = "10.1.2.0/24" }
    }
  }
  spoke2 = {
    name = "vpc-spoke2"
    subnets = {
      app = { name = "subnet-spoke2-app", cidr = "10.2.1.0/24" }
      db  = { name = "subnet-spoke2-db", cidr = "10.2.2.0/24" }
    }
  }
}

firewall_rules = {
  "iap-to-bastion" = {
    network_name  = "vpc-hub"
    source_ranges = ["35.235.240.0/20"] 
    target_tags   = ["bastion-host"]
    allows = [
      { protocol = "tcp", ports = ["22"] }
    ]
  }
  "spoke1-allow-bastion" = {
    network_name  = "vpc-spoke1"
    source_ranges = ["10.0.3.0/24"] 
    target_tags   = []
    allows = [
      { protocol = "tcp", ports = ["22", "3389"] },
      { protocol = "icmp", ports = [] }
    ]
  }
  "spoke2-allow-bastion" = {
    network_name  = "vpc-spoke2"
    source_ranges = ["10.0.3.0/24"] 
    target_tags   = []
    allows = [
      { protocol = "tcp", ports = ["22", "3389"] },
      { protocol = "icmp", ports = [] }
    ]
  }
}
