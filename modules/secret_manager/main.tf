resource "google_secret_manager_secret" "hub_secret" {
  secret_id = var.secret_id
  
  replication { 
    auto {} 
  }
}
