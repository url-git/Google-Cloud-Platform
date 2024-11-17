resource "google_bigtable_instance" "bt-from-tf" {

  name = "bt-from-tf"
  deletion_protection = false # Pole deletion_protection ustawione na false pozwala na usunięcie instancji bez dodatkowych potwierdzeń.
  labels = {
    "env" = "testing" # dodaje metadane, co może być pomocne do organizacji zasobów
  }
  cluster { # definiuje klaster w instancji
    cluster_id = "bt-from-tf-1"
    num_nodes = 1
    storage_type = "SSD"
  }

}


resource "google_bigtable_table" "tb1" { # Tworzy tabelę o nazwie tb-from-tf w instancji bt-from-tf
  name = "tb-from-tf"
  instance_name = google_bigtable_instance.bt-from-tf.name
}