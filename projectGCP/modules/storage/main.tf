variable "bucket_name" { type = string }
variable "location" { type = string }

resource "google_storage_bucket" "hub_storage" {
  name                        = var.bucket_name
  location                    = var.location
  force_destroy               = true
  uniform_bucket_level_access = true
}

output "bucket_url" {
  value = google_storage_bucket.hub_storage.url
}
