provider "google" {
  project = "zonedetest"
  credentials = "account.json"
  region  = "us-central1"
  zone    = "us-central1-c"
}

resource "google_compute_instance" "vm_instance" {
  name         = "terraform-instance"
  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = google_compute_network.my-network.self_link
    access_config {
    }
  }
  metadata_startup_script = "apt-get -y update && apt-get -y upgrade && apt-get -y install apache2 && systemctl start apache2"
}

resource "google_compute_network" "my-network" {
  name                    = "terraform-network"
  auto_create_subnetworks = "true"
}

//Need a firewall rule here to allow incoming http (TCP 80)
//to all instances on the terraform-network
