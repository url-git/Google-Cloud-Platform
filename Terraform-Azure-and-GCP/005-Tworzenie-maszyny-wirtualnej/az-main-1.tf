# Definicja bloku głównego konfiguracji Terraform
terraform {
  required_providers {
    azurerm = {  # Określenie providera dla Azure Resource Manager
      source = "hashicorp/azurerm"  # Pobranie providera z repozytorium HashiCorp
      version = "=3.0.0"  # Wersja providera, w tym przypadku dokładnie 3.0.0
    }
  }
}

# Konfiguracja providera dla Microsoft Azure
provider "azurerm" {
  features {}  # Funkcje providera (wymagane, nawet jeśli puste)
}

# Tworzenie grupy zasobów
resource "azurerm_resource_group" "main_rg" {
  name     = "App-VM-RG"  # Nazwa grupy zasobów
  location = "East US"    # Lokalizacja grupy zasobów w regionie Azure
}

# Tworzenie sieci wirtualnej (VNet)
resource "azurerm_virtual_network" "main_vnet" {
  name                = "App_VNET"  # Nazwa sieci wirtualnej
  location            = azurerm_resource_group.main_rg.location  # Lokalizacja dziedziczona z grupy zasobów
  resource_group_name = azurerm_resource_group.main_rg.name       # Grupa zasobów, w której znajduje się sieć
  address_space       = ["10.1.0.0/16"]  # Przestrzeń adresowa sieci

  # Definicja podsieci dla środowiska developerskiego
  subnet {
    name           = "dev_subnet"      # Nazwa podsieci
    address_prefix = "10.1.1.0/24"    # Zakres adresów IP podsieci
  }
  # Definicja podsieci dla środowiska testowego
  subnet {
    name           = "tst_subnet"      # Nazwa podsieci
    address_prefix = "10.1.2.0/24"    # Zakres adresów IP podsieci
  }
}

# Tworzenie dynamicznego publicznego adresu IP
resource "azurerm_public_ip" "app01vm_pub_ip" {
  name                = "app01vm_ip"  # Nazwa zasobu publicznego adresu IP
  resource_group_name = azurerm_resource_group.main_rg.name  # Przypisanie do grupy zasobów
  location            = azurerm_resource_group.main_rg.location  # Lokalizacja
  allocation_method   = "Dynamic"  # Adres IP będzie przydzielany dynamicznie
}

# Tworzenie interfejsu sieciowego dla maszyny wirtualnej
resource "azurerm_network_interface" "app01vm_nic" {
  name                = "app01vm-nic"  # Nazwa interfejsu sieciowego
  location            = azurerm_resource_group.main_rg.location  # Lokalizacja
  resource_group_name = azurerm_resource_group.main_rg.name       # Przypisanie do grupy zasobów

  # Konfiguracja adresu IP
  ip_configuration {
    name                          = "internal"  # Nazwa konfiguracji IP
    subnet_id                     = azurerm_virtual_network.main_vnet.subnet.*.id[0]  # Podłączenie do pierwszej podsieci w VNet
    private_ip_address_allocation = "Dynamic"  # Dynamiczne przydzielanie prywatnego adresu IP
    public_ip_address_id          = azurerm_public_ip.app01vm_pub_ip.id  # Powiązanie z publicznym adresem IP
  }
}

# Tworzenie grupy zabezpieczeń sieciowych (NSG)
resource "azurerm_network_security_group" "nsg_rdp" {
  name                = "app01vm-nsg"  # Nazwa grupy zabezpieczeń sieciowych
  location            = azurerm_resource_group.main_rg.location  # Lokalizacja
  resource_group_name = azurerm_resource_group.main_rg.name       # Przypisanie do grupy zasobów

  # Reguła bezpieczeństwa dla protokołu RDP
  security_rule {
    name                        = "RDP"  # Nazwa reguły
    priority                    = 300    # Priorytet reguły (niższe wartości = wyższy priorytet)
    direction                   = "Inbound"  # Kierunek ruchu: przychodzący
    access                      = "Allow"    # Zezwolenie na ruch
    protocol                    = "Tcp"      # Protokół: TCP
    source_port_range           = "*"        # Zakres portów źródłowych (dowolne)
    destination_port_range      = "3389"     # Port docelowy: 3389 (RDP)
    source_address_prefix       = "*"        # Adresy źródłowe (dowolne)
    destination_address_prefix  = "*"        # Adresy docelowe (dowolne)
  }
}

# Powiązanie NSG z interfejsem sieciowym
resource "azurerm_network_interface_security_group_association" "nsg_association" {
  network_interface_id         = azurerm_network_interface.app01vm_nic.id  # ID interfejsu sieciowego
  network_security_group_id    = azurerm_network_security_group.nsg_rdp.id  # ID grupy NSG
}

# Tworzenie maszyny wirtualnej z systemem Windows
resource "azurerm_windows_virtual_machine" "app01vm" {
  name                  = "app01vm"  # Nazwa maszyny wirtualnej
  resource_group_name   = azurerm_resource_group.main_rg.name  # Przypisanie do grupy zasobów
  location              = azurerm_resource_group.main_rg.location  # Lokalizacja
  size                  = "Standard_B2s"  # Rozmiar maszyny wirtualnej
  network_interface_ids = [azurerm_network_interface.app01vm_nic.id]  # Powiązany interfejs sieciowy
  admin_username        = "adminuser"  # Nazwa administratora
  admin_password        = "TheAnswerIs42."  # Hasło administratora

  # Dysk systemowy
  os_disk {
    caching              = "ReadWrite"  # Typ buforowania dysku
    storage_account_type = "Standard_LRS"  # Typ magazynu dla dysku
  }

  # Odniesienie do obrazu systemu operacyjnego
  source_image_reference {
    publisher = "microsoftwindowsdesktop"  # Dostawca obrazu
    offer     = "windows-11"  # Oferta obrazu
    sku       = "win11-22h2-ent"  # SKU obrazu
    version   = "latest"  # Najnowsza wersja obrazu
  }
}

# Wyjście - publiczny adres IP maszyny wirtualnej
output "public_ip" {
  value = azurerm_public_ip.app01vm_pub_ip.ip_address  # Wyświetlenie adresu IP
}



