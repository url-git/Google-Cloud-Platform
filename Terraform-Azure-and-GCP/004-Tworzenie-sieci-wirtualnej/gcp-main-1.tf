# Tworzenie zasobów dla GCP

# Provider dla Google Cloud
provider "google" {
  project = "your-gcp-project-id"  # ID projektu w GCP
  region  = "us-east1"             # Domyślny region
}

# Tworzenie sieci VPC
resource "google_compute_network" "main_vpc" {
  name                    = "terraform-vpc"  # Nazwa sieci VPC
  auto_create_subnetworks = false            # Wyłączenie automatycznego tworzenia podsieci
}

# Tworzenie pierwszej podsieci (dev_subnet)
resource "google_compute_subnetwork" "dev_subnet" {
  name          = "dev-subnet"                         # Nazwa podsieci
  ip_cidr_range = "10.1.1.0/24"                        # Przestrzeń adresowa podsieci
  region        = "us-east1"                           # Region dla podsieci
  network       = google_compute_network.main_vpc.id   # Powiązanie podsieci z siecią VPC
}

# Tworzenie drugiej podsieci (tst_subnet)
resource "google_compute_subnetwork" "tst_subnet" {
  name          = "tst-subnet"                         # Nazwa podsieci
  ip_cidr_range = "10.1.2.0/24"                        # Przestrzeń adresowa podsieci
  region        = "us-east1"                           # Region dla podsieci
  network       = google_compute_network.main_vpc.id   # Powiązanie podsieci z siecią VPC
}