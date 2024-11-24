terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0.0"
    }
  }
}

provider "random" {
  # Możesz zostawić pusty blok, jeśli nie wymaga konfiguracji
}


resource random_integer name {
  min = 0
  max = 100
}

# Starsze wersje providera (np. v2.3.1) nie były kompilowane dla architektury ARM (darwin_arm64). Od wersji 3.x HashiCorp zaczął oferować wsparcie dla tej platformy, co pozwala na użycie Terraform na komputerach z procesorami Apple M1/M2.

# Jeśli konieczne jest użycie starej wersji providera, uruchom Terraform na maszynie z procesorem x86-64 lub w środowisku wirtualnym.