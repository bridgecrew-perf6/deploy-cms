###################################
## Declare environment variables ##
###################################
variable "GC_PROJECT_ID" {}
variable "IMAGE" {}


##########################################################
## Provision PSQL instance and database on Google Cloud ##
##########################################################
provider "google" {
  project = "${var.GC_PROJECT_ID}"
  region      = var.region
##  credentials = file("credentials.json")
}

## Use the Google Secret Manager API for the database secrets
data "google_secret_manager_secret_version" "database_instance_name" {
  secret  = "database_instance_name"
  version = "1"
}


###########################################
## Run the container on Google Cloud Run ##
###########################################

## The container uses a GCR image created during the Github workflow (the previous step)
resource "google_cloud_run_service" "website" {
  name     = "${var.IMAGE}"
  location = var.location
  template {
    spec {
      containers {
        image = "gcr.io/${var.GC_PROJECT_ID}/${var.IMAGE}"
      }
    }
    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale"      = "1000"
        "run.googleapis.com/cloudsql-instances" = "${var.GC_PROJECT_ID}:${var.region}:${data.google_secret_manager_secret_version.database_instance_name.secret_data}"
        "run.googleapis.com/client-name"        = "terraform"
      }
    }
  }
  traffic {
    percent         = 100
    latest_revision = true
  }
}

data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location    = google_cloud_run_service.website.location
  project     = google_cloud_run_service.website.project
  service     = google_cloud_run_service.website.name
  policy_data = data.google_iam_policy.noauth.policy_data
}


## This outputs the container URL
output "url" {
  value = google_cloud_run_service.website.status[0].url
}