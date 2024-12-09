# Blok terraform definiujący provider
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">=4.0.0"
    }
  }
}

# Konfiguracja providera Google Cloud
provider "google" {
  project = "your-gcp-project-id" # ID projektu GCP
  region  = "europe-west1"        # Region, w którym tworzysz zasoby
}

# Tworzenie zasobnika (bucket) Cloud Storage
resource "google_storage_bucket" "app_data_bucket" {
  name          = "appdata-unique-name-12345"  # Unikalna nazwa bucketu
  location      = "EU"                        # Lokalizacja (np. EU dla multi-regionu)
  storage_class = "STANDARD"                  # Klasa przechowywania (odpowiednik account_tier)

  versioning {
    enabled = true  # Włączenie wersjonowania obiektów
  }
}