resource "google_sql_database_instance" "mysql-from-tf" {
  name = "mysql-from-tf"
  deletion_protection = false
  region = "europe-central2"

  settings {
    tier = "db-f1-micro"
  }

}

resource "google_sql_user" "myuser" {
  name = "peter"
  password = "cjhsdhc#$%#$y634fkah"
  instance = google_sql_database_instance.mysql-from-tf.name
}