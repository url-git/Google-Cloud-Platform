resource "local_file" "name1" {
  filename   = "explicit.txt"
  content    = "This is random String from RP : ${random_string.name2.id}"
  depends_on = [random_string.name2]
}

resource "random_string" "name2" {
  length = 10
}

# Przydatność:

# 	•	Automatyzacja: Kod ten pokazuje, jak można używać dynamicznych wartości w plikach konfiguracyjnych.
# 	•	Tworzenie unikalnych zasobów: Generowanie losowych ciągów może być przydatne do tworzenia unikalnych identyfikatorów, plików lub nazw zasobów.
# 	•	Zarządzanie zależnościami: Użycie depends_on umożliwia dokładną kontrolę nad kolejnością tworzenia zasobów.

# terraform init
# terraform plan
# terraform apply