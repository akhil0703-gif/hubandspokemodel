output "hub_management_subnet_id" {
  value = google_compute_subnetwork.hub_management.id
}

output "spoke2_db_subnet_id" {
  value = google_compute_subnetwork.spoke2_db.id
}
