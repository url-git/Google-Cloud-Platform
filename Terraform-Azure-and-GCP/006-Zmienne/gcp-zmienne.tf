# Definicja zmiennej dla nazwy projektu GCP
variable "project_id" {
  type        = string
  description = "GCP Project ID"
  default     = "my-gcp-project"
}

# Lokalizacja zasobów (region)
variable "region" {
  type        = string
  description = "Region for the resources"
  default     = "us-central1"
}

# Przestrzeń adresowa VPC
variable "vpc_network" {
  type        = string
  description = "Name of the VPC network"
  default     = "app-vpc"
}

# Przestrzeń adresowa dla podsieci
variable "subnet_ranges" {
  type        = map(string)
  description = "Map of subnet names and their IP ranges"
  default = {
    dev_subnet = "10.1.1.0/24"
    tst_subnet = "10.1.2.0/24"
  }
}

# Nazwa maszyny wirtualnej
variable "instance_name" {
  type        = string
  description = "Name of the Compute Engine instance"
  default     = "app01-vm"
}

# Typ maszyny
variable "machine_type" {
  type        = string
  description = "Machine type for the Compute Engine instance"
  default     = "e2-medium"
}

# Hasło administratora
variable "admin_password" {
  type        = string
  description = "Administrator password for the VM"
  default     = "TheAnswerIs42."
}
