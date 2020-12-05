
module "s3_bucket" {
  source = "./s3_bucket"
}

module "cloudsql" {
  source = "./cloud_sql"
  GC_PROJECT_ID = "${var.GC_PROJECT_ID}"
}

module "gcr_cloud_run" {
  source = "./gcr_cloud_run"
  GC_PROJECT_ID = "${var.GC_PROJECT_ID}"
  IMAGE   = "${var.IMAGE}"
}