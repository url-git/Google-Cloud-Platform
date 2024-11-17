terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "3.85.0"
    }
  }
}

provider "google" {
  # Configuration options
  project = "terraform-gcp"
  region = "europe-central2"
  zone = "europe-central2-a"
  credentials = "keys.json"
}