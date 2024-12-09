# Tworzenie grupy zasobów w Azure
resource "azurerm_resource_group" "main_rg" {
  name     = "HelloTerraform_RG"  # Nazwa grupy zasobów, pod którą będą przechowywane inne zasoby.
  location = "East US"            # Lokalizacja (region) w Azure, w którym będzie utworzona grupa zasobów.
}

# Tworzenie sieci wirtualnej w Azure
resource "azurerm_virtual_network" "main_vnet" {
  name                = "Terraform_VNET"                      # Nazwa sieci wirtualnej.
  location            = azurerm_resource_group.main_rg.location  # Lokalizacja sieci wirtualnej; powiązana z grupą zasobów.
  resource_group_name = azurerm_resource_group.main_rg.name      # Nazwa grupy zasobów, do której należy sieć wirtualna.

  address_space = ["10.1.0.0/16"]  # Przestrzeń adresowa sieci w formacie CIDR. Tutaj mamy zakres od 10.1.0.0 do 10.1.255.255.

  # Tworzenie pierwszej podsieci
  subnet {
    name           = "dev_subnet"     # Nazwa podsieci, identyfikująca ją w sieci.
    address_prefix = "10.1.1.0/24"   # Przestrzeń adresowa podsieci w formacie CIDR. Tutaj obejmuje adresy od 10.1.1.0 do 10.1.1.255.
  }

  # Tworzenie drugiej podsieci
  subnet {
    name           = "tst_subnet"     # Nazwa podsieci, używana do testów.
    address_prefix = "10.1.2.0/24"   # Przestrzeń adresowa podsieci w formacie CIDR. Tutaj obejmuje adresy od 10.1.2.0 do 10.1.2.255.
  }
}


# Do utworzenia planu i zapisania go w pliku do wykorzystania w przyszłości można użyć opcji—out:
terraform plan—out=./myplan.tfplan
# Aby taki plan następnie wykorzystać w poleceniu apply użyj:
terraform apply myplan.tfplan