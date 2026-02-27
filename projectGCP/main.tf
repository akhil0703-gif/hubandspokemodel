module "network" {
  source         = "../modules/network"
  env_suffix     = var.env_suffix
  vpcs           = var.vpcs
  firewall_rules = var.firewall_rules
}

module "storage" {
  source      = "../modules/storage"
  bucket_name = "gcs-hub-storage01-${var.env_suffix}"
  location    = "US" # Updated to US to match your new region
}

module "secret_manager" {
  source     = "../modules/secret_manager"
  secret_id  = "secret-hub01-${var.env_suffix}"
}

resource "google_compute_instance" "bastion_host" {
  name         = "vm-bastion-hub-${var.env_suffix}"
  machine_type = "e2-micro"
  zone         = var.zone
  tags         = ["bastion-host"]

  boot_disk {
    initialize_params { 
      image = "ubuntu-minimal-2210-kinetic-amd64-v20230126"
       type  = "pd-standard"
    }
  }

  network_interface {
    subnetwork = module.network.hub_management_subnet_id
  }
}

resource "google_compute_instance" "spoke2_backend_vm" {
  name         = "vm-spoke2-backend-${var.env_suffix}"
  machine_type = "e2-micro"
  zone         = var.zone

  boot_disk {
    initialize_params { 
     image = "ubuntu-minimal-2210-kinetic-amd64-v20230126"
       type  = "pd-standard"
    }
  }

  network_interface {
    subnetwork = module.network.spoke2_db_subnet_id
  }
}
