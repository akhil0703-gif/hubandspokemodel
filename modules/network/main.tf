# HUB VPC & SUBNETS
resource "google_compute_network" "hub_vpc" {
  name                    = "${var.vpcs["hub"].name}-${var.env_suffix}"
  auto_create_subnetworks = false
}
resource "google_compute_subnetwork" "hub_frontend" {
  name          = "${var.vpcs["hub"].subnets["frontend"].name}-${var.env_suffix}"
  ip_cidr_range = var.vpcs["hub"].subnets["frontend"].cidr
  network       = google_compute_network.hub_vpc.id
}
resource "google_compute_subnetwork" "hub_backend" {
  name          = "${var.vpcs["hub"].subnets["backend"].name}-${var.env_suffix}"
  ip_cidr_range = var.vpcs["hub"].subnets["backend"].cidr
  network       = google_compute_network.hub_vpc.id
}
resource "google_compute_subnetwork" "hub_management" {
  name          = "${var.vpcs["hub"].subnets["management"].name}-${var.env_suffix}"
  ip_cidr_range = var.vpcs["hub"].subnets["management"].cidr
  network       = google_compute_network.hub_vpc.id
}


# SPOKE 1 VPC & SUBNETS
resource "google_compute_network" "spoke1_vpc" {
  name                    = "${var.vpcs["spoke1"].name}-${var.env_suffix}"
  auto_create_subnetworks = false
}
resource "google_compute_subnetwork" "spoke1_app" {
  name          = "${var.vpcs["spoke1"].subnets["app"].name}-${var.env_suffix}"
  ip_cidr_range = var.vpcs["spoke1"].subnets["app"].cidr
  network       = google_compute_network.spoke1_vpc.id
}
resource "google_compute_subnetwork" "spoke1_db" {
  name          = "${var.vpcs["spoke1"].subnets["db"].name}-${var.env_suffix}"
  ip_cidr_range = var.vpcs["spoke1"].subnets["db"].cidr
  network       = google_compute_network.spoke1_vpc.id
}

# SPOKE 2 VPC & SUBNETS
resource "google_compute_network" "spoke2_vpc" {
  name                    = "${var.vpcs["spoke2"].name}-${var.env_suffix}"
  auto_create_subnetworks = false
}
resource "google_compute_subnetwork" "spoke2_app" {
  name          = "${var.vpcs["spoke2"].subnets["app"].name}-${var.env_suffix}"
  ip_cidr_range = var.vpcs["spoke2"].subnets["app"].cidr
  network       = google_compute_network.spoke2_vpc.id
}
resource "google_compute_subnetwork" "spoke2_db" {
  name          = "${var.vpcs["spoke2"].subnets["db"].name}-${var.env_suffix}"
  ip_cidr_range = var.vpcs["spoke2"].subnets["db"].cidr
  network       = google_compute_network.spoke2_vpc.id
}

# DYNAMIC FIREWALL RULES
resource "google_compute_firewall" "dynamic_rules" {
  for_each = var.firewall_rules

  name          = "fw-${each.key}-${var.env_suffix}"
  network       = "${each.value.network_name}-${var.env_suffix}"
  depends_on = [
    google_compute_network.hub_vpc
  ]
  source_ranges = each.value.source_ranges
  target_tags   = each.value.target_tags

  dynamic "allow" {
    for_each = each.value.allows
    content {
      protocol = allow.value.protocol
      ports    = allow.value.ports
    }
  }
}

# PEERING
resource "google_compute_network_peering" "hub_to_spoke1" {
  name         = "peer-hub-to-spoke1"
  network      = google_compute_network.hub_vpc.id
  peer_network = google_compute_network.spoke1_vpc.id
}
resource "google_compute_network_peering" "spoke1_to_hub" {
  name         = "peer-spoke1-to-hub"
  network      = google_compute_network.spoke1_vpc.id
  peer_network = google_compute_network.hub_vpc.id
}
resource "google_compute_network_peering" "hub_to_spoke2" {
  name         = "peer-hub-to-spoke2"
  network      = google_compute_network.hub_vpc.id
  peer_network = google_compute_network.spoke2_vpc.id
}
resource "google_compute_network_peering" "spoke2_to_hub" {
  name         = "peer-spoke2-to-hub"
  network      = google_compute_network.spoke2_vpc.id
  peer_network = google_compute_network.hub_vpc.id
}
