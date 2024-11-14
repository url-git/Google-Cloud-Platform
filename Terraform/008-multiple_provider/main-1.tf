# Definicja zasobu typu local_file
resource "local_file" "name" {
  content  = "This is HCL"  # Treść, która zostanie zapisana w pliku
  filename = "sample.txt"   # Ścieżka do pliku, który zostanie utworzony
}

# Definicja zasobu typu random_string
resource "random_string" "name" {
  length = 5  # Generuje losowy ciąg znaków o długości 5
}

# terraform init  - Inicjalizuje środowisko Terraform, pobiera wymagane wtyczki
# terraform plan  - Wyświetla plan działania, pokazując, jakie zasoby zostaną utworzone
# terraform apply - Tworzy zasoby zgodnie z planem

# Jeśli plik z nazwą dynamiczną zostanie utworzony (po dodaniu interpolacji), może być używany jako unikalny zasób w procesach automatyzacji, np. logach, identyfikatorach plików, danych tymczasowych w lokalnym środowisku.