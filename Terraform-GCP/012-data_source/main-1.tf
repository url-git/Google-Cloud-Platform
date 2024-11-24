data local_file foo {
  filename = "sample1.txt"
}

output name1 {
  value       = data.local_file.foo.content
}



# Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

# Outputs:

# name1 = "This is fro datasource."

# Ten kod Terraform ma na celu odczytanie zawartości lokalnego pliku (sample1.txt) i wyświetlenie jej jako wyjściowej wartości w konsoli Terraform.