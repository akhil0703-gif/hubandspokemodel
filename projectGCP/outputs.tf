output "bastion_internal_ip" {
  value = google_compute_instance.bastion_host.network_interface[0].network_ip
}

output "spoke2_vm_internal_ip" {
  value = google_compute_instance.spoke2_backend_vm.network_interface[0].network_ip
}
