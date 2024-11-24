# resource local_file sample_res {
#   filename = var.filename1
#   content = var.filename1
# }

# resource "local_file" "sample_res" {
#   filename = var.content1[0]  # Używa pierwszego elementu listy jako nazwy pliku
#   content  = var.content1[0]  # Zawartość pliku pochodzi z drugiego elementu listy
# }

resource "local_file" "sample_res" {
  filename = var.content1["name"]
  content  = var.content1["name"]  
}

# terraform init
# terraform plan
# terraform apply