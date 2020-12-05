## Configure GCP project
provider "google" {
  project = var.project_id
}

## Use Google Secret Manager API
data "google_secret_manager_secret_version" "database_instance_name" {
  secret  = "database_instance_name"
  version = "1"
}


## Deploy image to Cloud Run
resource "google_cloud_run_service" "website" {
  name     = var.website_name
  location = var.location
  template {
    spec {
      containers {
        image = var.gcr_image
      }
    }
    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale"      = "1000"
        "run.googleapis.com/cloudsql-instances" = ${var.project_id}:${var.region}:data.google_secret_manager_secret_version.database_instance_name.secret_data
        "run.googleapis.com/client-name"        = "terraform"
      }
    }
  }
  traffic {
    percent         = 100
    latest_revision = true
  }
}

## Create public access
data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

## Enable public access on Cloud Run service
resource "google_cloud_run_service_iam_policy" "noauth" {
  location    = google_cloud_run_service.website.location
  project     = google_cloud_run_service.website.project
  service     = google_cloud_run_service.website.name
  policy_data = data.google_iam_policy.noauth.policy_data
}


output "url" {
  value = google_cloud_run_service.website.status[0].url
}
