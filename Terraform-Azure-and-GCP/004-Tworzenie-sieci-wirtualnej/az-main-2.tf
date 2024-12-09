# Storage Account w Azure to podstawowa jednostka zarządzania danymi w chmurze Microsoft Azure. Jest to zasób umożliwiający przechowywanie różnego rodzaju danych, takich jak pliki, tabele, kolejki, dane blob (obiekty binarne) oraz dyski wirtualnych maszyn.

# Blok terraform definiuje używanego providera oraz wersję
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"  # Określa providera jako Azure Resource Manager
      version = ">=3.0.0"          # Wymaga wersji 3.0.0 lub nowszej
    }
  }
}

# Blok konfiguracji providera Azure
provider "azurerm" {
  features {} # Konieczne dla providera azurerm, aktywuje domyślne funkcjonalności
}

# Definicja grupy zasobów
resource "azurerm_resource_group" "app_data_rg" {
  name     = "App-Data-RG"        # Nazwa grupy zasobów
  location = "West Europe"        # Region, w którym grupa zostanie utworzona
}

# Definicja konta storage w Azure
resource "azurerm_storage_account" "app_data_storage" {
  name                     = "appdatasa92742894"                 # Unikalna nazwa Storage Account (musi być globalnie unikalna w Azure)
  resource_group_name      = azurerm_resource_group.app_data_rg.name # Powiązanie z utworzoną grupą zasobów
  location                 = azurerm_resource_group.app_data_rg.location # Lokalizacja zgodna z grupą zasobów
  account_tier             = "Standard"                         # Ustawia tier jako Standard (optymalny kosztowo)
  account_replication_type = "LRS"                              # Replikacja w obrębie jednego centrum danych (LRS)
}