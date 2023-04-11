resource "google_sql_database_instance" "fi_ops_test_db" {
  name             = "fi-ops-test-db"
  database_version = "POSTGRES_14"
  region           = "us-east1"

  deletion_protection=false

  settings {
    # Second-generation instance tiers are based on the machine
    # type. See argument reference below.
    tier = "db-f1-micro"
  }
}


resource "google_sql_user" "fi_ops_test_db_user" {
  name = "db-user"
  instance = google_sql_database_instance.fi_ops_test_db.name
  password = "mysecretpassword"
}

output "db_ip_address" {
  value = google_sql_database_instance.fi_ops_test_db.first_ip_address
}