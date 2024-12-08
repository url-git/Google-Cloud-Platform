# Ten plik Terraform utworzy instancję maszyny wirtualnej w Google Cloud Platform w regionie us-central1 i strefie us-central1-a.


# Blok terraform
terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "=4.0.0"
    }
  }
}

# Blok provider
provider "google" {
  project = "your-project-id"   # ID projektu GCP
  region  = "us-central1"       # Region GCP
  zone    = "us-central1-a"     # Strefa GCP
}

# Blok resource - Instancja wirtualna
resource "google_compute_instance" "hello_world" {
  name         = "hello-terraform-instance"   # Nazwa instancji
  machine_type = "e2-medium"                  # Typ maszyny
  zone         = "us-central1-a"              # Strefa

  # Konfiguracja dysku startowego
  boot_disk {
    initialize_params {
      image = "debian-10-buster-v20210316"    # Obraz systemu operacyjnego
    }
  }

  # Konfiguracja interfejsu sieciowego
  network_interface {
    network = "default"
    access_config {}
  }
}