# HUB VPC
resource "google_compute_network" "hub_vpc" {
  name                    = "vpc-hub-${var.env_suffix}"
  auto_create_subnetworks = false
}
resource "google_compute_subnetwork" "hub_frontend" {
  name          = "subnet-hub-frontend-${var.env_suffix}"
  ip_cidr_range = "10.0.1.0/24"
  network       = google_compute_network.hub_vpc.id
}
resource "google_compute_subnetwork" "hub_backend" {
  name          = "subnet-hub-backend-${var.env_suffix}"
  ip_cidr_range = "10.0.2.0/24"
  network       = google_compute_network.hub_vpc.id
}
resource "google_compute_subnetwork" "hub_management" {
  name          = "subnet-hub-management-${var.env_suffix}"
  ip_cidr_range = "10.0.3.0/24"
  network       = google_compute_network.hub_vpc.id
}

# SPOKE 1 VPC
resource "google_compute_network" "spoke1_vpc" {
  name                    = "vpc-spoke1-${var.env_suffix}"
  auto_create_subnetworks = false
}
resource "google_compute_subnetwork" "spoke1_app" {
  name          = "subnet-spoke1-app-${var.env_suffix}"
  ip_cidr_range = "10.1.1.0/24"
  network       = google_compute_network.spoke1_vpc.id
}
resource "google_compute_subnetwork" "spoke1_db" {
  name          = "subnet-spoke1-db-${var.env_suffix}"
  ip_cidr_range = "10.1.2.0/24"
  network       = google_compute_network.spoke1_vpc.id
}

# SPOKE 2 VPC
resource "google_compute_network" "spoke2_vpc" {
  name                    = "vpc-spoke2-${var.env_suffix}"
  auto_create_subnetworks = false
}
resource "google_compute_subnetwork" "spoke2_app" {
  name          = "subnet-spoke2-app-${var.env_suffix}"
  ip_cidr_range = "10.2.1.0/24"
  network       = google_compute_network.spoke2_vpc.id
}
resource "google_compute_subnetwork" "spoke2_db" {
  name          = "subnet-spoke2-db-${var.env_suffix}"
  ip_cidr_range = "10.2.2.0/24"
  network       = google_compute_network.spoke2_vpc.id
}

# FIREWALL RULES
resource "google_compute_firewall" "fw_hub_management" {
  name    = "fw-hub-management-${var.env_suffix}"
  network = google_compute_network.hub_vpc.name
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["35.235.240.0/20"] 
}
resource "google_compute_firewall" "fw_spoke1_allow_hub" {
  name    = "fw-spoke1-allow-hub-${var.env_suffix}"
  network = google_compute_network.spoke1_vpc.name
  allow { protocol = "tcp" }
  allow { protocol = "icmp" }
  source_ranges = ["10.0.0.0/16"] 
}
resource "google_compute_firewall" "fw_spoke2_allow_hub" {
  name    = "fw-spoke2-allow-hub-${var.env_suffix}"
  network = google_compute_network.spoke2_vpc.name
  allow { protocol = "tcp" }
  allow { protocol = "icmp" }
  source_ranges = ["10.0.0.0/16"] 
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
