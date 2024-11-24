# W tym przypadku Terraform planuje utworzenie pliku lokalnego o nazwie sample.txt z określoną zawartością i uprawnieniami.

resource local_file sample_res {
  filename = "sample.txt"
  content = "I Love Terraform"
}


# terraform init - 	Cel: Przygotowanie środowiska do pracy z Terraformem.
# terraform plan - Cel: Przegląd planowanych zmian w infrastrukturze.
# terraform apply - Cel: Wprowadzenie zmian w infrastrukturze zgodnie z wygenerowanym planem.