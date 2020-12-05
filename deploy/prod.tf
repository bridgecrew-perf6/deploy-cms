
module "s3_bucket" {
  source = "./s3_bucket"
  region = "${var.region}"
  AWS_ACCESS_KEY_ID = "${var.AWS_ACCESS_KEY_ID}"
  AWS_SECRET_ACCESS_KEY = "${var.AWS_SECRET_ACCESS_KEY}"
  AWS_STORAGE_BUCKET_NAME = "${var.AWS_STORAGE_BUCKET_NAME}"
}

module "cloudsql" {
  source = "./cloud_sql"
  GC_PROJECT_ID = "${var.GC_PROJECT_ID}"
  region = "${var.region}"
}

module "gcr_cloud_run" {
  source = "./gcr_cloud_run"
  GC_PROJECT_ID = "${var.GC_PROJECT_ID}"
  IMAGE   = "${var.IMAGE}"
  region = "${var.region}"
  location = "${var.location}"
}