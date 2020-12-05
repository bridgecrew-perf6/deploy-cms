variable "GC_PROJECT_ID" {}
variable "region" {}

## Configure GCP project
provider "google" {
  project = "${var.GC_PROJECT_ID}"
}

## Use Google Secret Manager API for Database User/Password
data "google_secret_manager_secret_version" "database_instance_name" {
  secret  = "database_instance_name"
  version = "1"
}

data "google_secret_manager_secret_version" "database_name" {
  secret  = "database_name"
  version = "1"
}

data "google_secret_manager_secret_version" "database_user" {
  secret  = "database_user"
  version = "1"
}

data "google_secret_manager_secret_version" "database_password" {
  secret  = "database_password"
  version = "1"
}

## Provisioning a Postgres Database
resource "google_sql_database_instance" "myinstance" {
  name = data.google_secret_manager_secret_version.database_instance_name.secret_data
  region = var.region
  database_version = "POSTGRES_11"

  settings {
    tier = "db-f1-micro"
  }
}

resource "google_sql_user" "users" {
  name     = data.google_secret_manager_secret_version.database_user.secret_data
  instance = google_sql_database_instance.myinstance.name
  password = data.google_secret_manager_secret_version.database_password.secret_data
}

resource "google_sql_database" "database" {
  name     = data.google_secret_manager_secret_version.database_name.secret_data
  instance = google_sql_database_instance.myinstance.name
}
