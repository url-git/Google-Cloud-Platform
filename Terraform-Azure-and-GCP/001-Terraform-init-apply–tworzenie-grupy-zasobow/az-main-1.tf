# Blok terraform
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Blok provider
provider "azurerm" {
  features {}
}

# Blok resource
resource "azurerm_resource_group" "hello_word" {
  name     = "Hello_Terraform_RG"
  location = "East US"
}

# Azure Resource Manager (ARM):
# Jest to usługa w Azure, która umożliwia zarządzanie zasobami w sposób deklaratywny. ARM pozwala na tworzenie, modyfikowanie i usuwanie zasobów za pomocą API, portalu Azure, CLI czy narzędzi takich jak Terraform.
# W skrócie: azurerm = Azure Resource Manager

# terraform init
# terraform apply
# Stwórz odpowiednik kodu Terraform Azure dla providera GCP w postaci jednego pliku