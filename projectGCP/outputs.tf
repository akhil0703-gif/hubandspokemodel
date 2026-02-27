output "bastion_internal_ip" {
  description = "Internal IP of the Bastion Host"
  value       = google_compute_instance.bastion_host.network_interface[0].network_ip
}

output "spoke2_vm_internal_ip" {
  description = "Internal IP of the Spoke 2 Backend VM"
  value       = google_compute_instance.spoke2_backend_vm.network_interface[0].network_ip
}

output "storage_bucket_url" {
  description = "GCS Bucket URL"
  value       = module.storage.bucket_url
}
