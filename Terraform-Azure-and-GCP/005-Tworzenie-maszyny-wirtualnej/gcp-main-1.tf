# Definicja bloku głównego konfiguracji Terraform
terraform {
  required_providers {
    google = {  # Określenie providera dla GCP
      source  = "hashicorp/google"  # Pobranie providera z repozytorium HashiCorp
      version = "~> 4.0"  # Wersja providera, np. 4.x
    }
  }
}

# Konfiguracja providera dla Google Cloud Platform
provider "google" {
  project = "twoj-projekt"  # ID projektu GCP
  region  = "us-central1"   # Domyślny region
  zone    = "us-central1-a"  # Domyślna strefa
}

# Tworzenie sieci VPC
resource "google_compute_network" "main_vpc" {
  name                    = "app-vpc"  # Nazwa sieci VPC
  auto_create_subnetworks = false  # Wyłączenie automatycznego tworzenia podsieci
}

# Tworzenie podsieci w sieci VPC
resource "google_compute_subnetwork" "main_subnet" {
  name          = "app-subnet"  # Nazwa podsieci
  ip_cidr_range = "10.0.0.0/24"  # Zakres adresów IP podsieci
  region        = "us-central1"  # Region podsieci
  network       = google_compute_network.main_vpc.id  # Powiązanie z siecią VPC
}

# Tworzenie reguły zapory sieciowej (firewall) dla RDP
resource "google_compute_firewall" "allow_rdp" {
  name    = "allow-rdp"  # Nazwa reguły zapory
  network = google_compute_network.main_vpc.name  # Powiązanie z siecią VPC

  # Zezwolenie na ruch przychodzący
  allow {
    protocol = "tcp"  # Protokół TCP
    ports    = ["3389"]  # Port RDP
  }

  source_ranges = ["0.0.0.0/0"]  # Źródłowe adresy IP (dowolne)
  direction     = "INGRESS"  # Kierunek: przychodzący
  priority      = 1000  # Priorytet reguły
}

# Tworzenie statycznego publicznego adresu IP
resource "google_compute_address" "app_ip" {
  name   = "app-public-ip"  # Nazwa adresu IP
  region = "us-central1"  # Region adresu IP
}

# Tworzenie instancji maszyny wirtualnej z systemem Windows
resource "google_compute_instance" "app_vm" {
  name         = "app-vm"  # Nazwa instancji
  machine_type = "e2-medium"  # Typ maszyny
  zone         = "us-central1-a"  # Strefa maszyny

  # Konfiguracja sieciowa
  network_interface {
    network       = google_compute_network.main_vpc.id  # Powiązanie z siecią VPC
    subnetwork    = google_compute_subnetwork.main_subnet.id  # Powiązanie z podsiecią
    access_config {  # Publiczny adres IP
      nat_ip = google_compute_address.app_ip.address  # Powiązanie z utworzonym adresem IP
    }
  }

  # Konfiguracja systemu operacyjnego
  boot_disk {
    initialize_params {
      image = "windows-server-2022-dc-v20221108"  # Obraz systemu Windows
    }
  }

  metadata = {
    windows-startup-script-ps1 = <<EOF
      # Skrypt PowerShell uruchamiany po starcie maszyny (opcjonalne)
      Write-Host "Instalacja zakończona"
EOF
  }

  # Użytkownik administracyjny i hasło
  metadata_startup_script = <<EOT
Set-ItemProperty -Path 'HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\System' -Name 'EnableLUA' -Value 0
EOT
}