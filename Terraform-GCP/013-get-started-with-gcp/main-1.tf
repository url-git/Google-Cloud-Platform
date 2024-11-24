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
}

resource google_storage_bucket "GCS1"{
  name = "bucket_name" # Utworzenie GCS
}

# Co robi kod?

# 	•	Inicjalizuje Terraform i ustawia go do pracy z providerem Google Cloud.
# 	•	Łączy się z projektem terraform-gcp w regionie i strefie wskazanej w konfiguracji.
# 	•	Tworzy bucket w Google Cloud Storage o nazwie bucket_name.

# gcloud auth application-default login
# gcloud auth list