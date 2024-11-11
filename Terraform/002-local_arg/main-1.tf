resource local_file sample_res {
  filename = "sample_args.txt"
  sensitive_content = "I Love Terraform"
  file_permission = "0700"
}

# Użycie "sensitive_content" sprawia, że treść jest traktowana jako poufna:
# - Nie będzie widoczna w logach Terraform, co zapobiega przypadkowemu ujawnieniu.

# file_permission = "0700"
# Ustawia uprawnienia do pliku w formacie zgodnym z systemami Unix/Linux.
# "0700" oznacza:
# - Właściciel (user): Pełny dostęp (czytanie, pisanie, wykonywanie).
# - Grupa i inni użytkownicy: Brak dostępu.

# terraform init
# terraform plan
# terraform apply