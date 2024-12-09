# Konfiguracja dostawcy Terraform dla GCP
provider "google" {
  project = var.project_id  # Projekt w GCP
  region  = var.region      # Region dla zasobów
}

# Tworzenie sieci VPC
resource "google_compute_network" "vpc_network" {
  name                    = var.vpc_network  # Nazwa sieci
  auto_create_subnetworks = false            # Wyłącz automatyczne tworzenie podsieci
}

# Tworzenie podsieci
resource "google_compute_subnetwork" "subnet" {
  for_each          = var.subnet_ranges  # Tworzenie podsieci na podstawie mapy `subnet_ranges`
  name              = each.key           # Nazwa podsieci
  ip_cidr_range     = each.value         # Przestrzeń adresowa podsieci
  region            = var.region         # Region podsieci
  network           = google_compute_network.vpc_network.id  # Sieć, do której należy podsieć
}

# Tworzenie maszyny wirtualnej
resource "google_compute_instance" "vm_instance" {
  name         = var.instance_name  # Nazwa instancji
  machine_type = var.machine_type   # Typ maszyny
  zone         = "${var.region}-a"  # Strefa (region + litera)

  # Konfiguracja dysku rozruchowego
  boot_disk {
    initialize_params {
      image = "projects/windows-cloud/global/images/family/windows-2022"  # Obraz systemu operacyjnego (Windows Server 2022)
    }
  }

  # Interfejs sieciowy
  network_interface {
    network    = google_compute_network.vpc_network.id  # Sieć VPC
    subnetwork = google_compute_subnetwork.subnet["dev_subnet"].id  # Podsieć
    access_config {}  # Tworzenie zewnętrznego adresu IP
  }

  # Metadane dla administratora
  metadata = {
    windows-startup-script-ps1 = <<EOT
      net user adminuser ${var.admin_password} /add
      net localgroup administrators adminuser /add
    EOT
  }
}