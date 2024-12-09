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

# MAIN.TF – zmienione fragmenty

# Tworzenie grupy zasobów w Azure
resource "azurerm_resource_group" "main_rg" {
  name     = var.rg_name  # Użycie zmiennej `rg_name` do nazwania grupy zasobów.
  location = var.location  # Użycie zmiennej `location` do określenia regionu.
}

# Tworzenie wirtualnej sieci w Azure
resource "azurerm_virtual_network" "main_vnet" {
  name                = "App_VNET"  # Nazwa wirtualnej sieci.
  location            = azurerm_resource_group.main_rg.location  # Lokalizacja z grupy zasobów.
  resource_group_name = azurerm_resource_group.main_rg.name  # Nazwa grupy zasobów.
  address_space       = [var.vnet_addressspace]  # Przestrzeń adresowa sieci, pobrana ze zmiennej.

  # Tworzenie pierwszej podsieci
  subnet {
    name           = "dev_subnet"  # Nazwa podsieci.
    address_prefix = "10.1.1.0/24"  # Prefiks adresów dla podsieci.
  }

  # Tworzenie drugiej podsieci
  subnet {
    name           = "tst_subnet"  # Nazwa podsieci.
    address_prefix = "10.1.2.0/24"  # Prefiks adresów dla podsieci.
  }
}

# Tworzenie maszyny wirtualnej z systemem Windows
resource "azurerm_windows_virtual_machine" "app01vm" {
  name                = var.vm_name  # Użycie zmiennej `vm_name` jako nazwy maszyny.
  resource_group_name = azurerm_resource_group.main_rg.name  # Grupa zasobów.
  location            = azurerm_resource_group.main_rg.location  # Lokalizacja.
  size                = "Standard_B2s"  # Rozmiar maszyny wirtualnej (rodzaj SKU).

  # Przypisanie interfejsu sieciowego do maszyny
  network_interface_ids = [azurerm_network_interface.app01vm_nic.id]

  admin_username = var.admin_username  # Nazwa użytkownika pobrana ze zmiennej.
  admin_password = var.admin_password  # Hasło administratora pobrane ze zmiennej.

  os_disk {  # Definicja dysku systemowego.
    caching              = "ReadWrite"  # Ustawienie pamięci podręcznej jako odczyt/zapis.
    storage_account_type = "Standard_LRS"  # Typ magazynu dysku (lokalnie redundowany).
  }

  source_image_reference {  # Odwołanie do obrazu systemu operacyjnego.
    publisher = "microsoftwindowsdesktop"  # Wydawca obrazu.
    offer     = "windows-11"  # Oferta systemu operacyjnego.
    sku       = "win11-22h2-ent"  # SKU systemu (edycja Enterprise Windows 11).
    version   = "latest"  # Najnowsza wersja obrazu.
  }
}