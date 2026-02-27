output "bucket_url" {
  description = "The URL of the created storage bucket"
  value       = google_storage_bucket.hub_storage.url
}
