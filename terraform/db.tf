resource "google_sql_database_instance" "fi_ops_test_db" {
  name             = var.db_instance_name
  database_version = var.db_version
  region           = var.region
  project          = var.project

  deletion_protection=false

  settings {
    # Second-generation instance tiers are based on the machine
    # type. See argument reference below.
    tier = var.db_instance_size
  }
}

resource "google_sql_user" "fi_ops_test_db_user" {
  name     = var.db_user_name
  project  = var.project
  instance = google_sql_database_instance.fi_ops_test_db.name
  password = var.db_password
}

output "db_ip_address" {
  value = google_sql_database_instance.fi_ops_test_db.first_ip_address
}