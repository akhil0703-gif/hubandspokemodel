variable "env_suffix" { type = string }

variable "vpcs" {
  type = map(object({
    name = string
    subnets = map(object({ name = string, cidr = string }))
  }))
}

variable "firewall_rules" {
  type = map(object({
    network_name  = string
    source_ranges = list(string)
    target_tags   = list(string)
    allows = list(object({ protocol = string, ports = list(string) }))
  }))
}
