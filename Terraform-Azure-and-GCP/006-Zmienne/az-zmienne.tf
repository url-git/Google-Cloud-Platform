# Definicja zmiennej dla nazwy grupy zasobów
variable "rg_name" {
  type = string  # Typ danych zmiennej to string (tekst).
  description = "Name of main resource group"  # Opis zmiennej.
  default = "App-VM-RG"  # Wartość domyślna zmiennej.
}

# Definicja zmiennej dla lokalizacji zasobów
variable "location" {
  type = string  # Typ danych to string.
  description = "Location of resources"  # Opis zmiennej.
  default = "East US"  # Wartość domyślna: region Azure "East US".
}

# Definicja zmiennej dla przestrzeni adresowej VNET
variable "vnet_addressspace" {
  type = string  # Typ danych to string.
  description = "Address space assigned to VNET"  # Opis przeznaczenia zmiennej.
  default = "10.1.0.0/16"  # Wartość domyślna to przestrzeń adresowa dla wirtualnej sieci.
}

# Definicja zmiennej dla nazwy maszyny wirtualnej
variable "vm_name" {
  type = string  # Typ danych zmiennej.
  description = "Name of virtual machine"  # Opis zmiennej.
  default = "app01vm"  # Wartość domyślna: nazwa maszyny wirtualnej.
}

# Definicja zmiennej dla nazwy administratora
variable "admin_username" {
  type = string  # Typ danych zmiennej.
  description = "Administrator user name"  # Opis zmiennej.
  default = "adminuser"  # Wartość domyślna to "adminuser".
}

# Definicja zmiennej dla hasła administratora
variable "admin_password" {
  type = string  # Typ danych zmiennej.
  description = "Administrator’s password"  # Opis zmiennej.
  default = "TheAnswerIs42."  # Wartość domyślna: hasło administratora.
}
