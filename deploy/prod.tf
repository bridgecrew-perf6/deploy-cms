variable "GC_PROJECT_ID" {}
variable "IMAGE" {}

module "s3_bucket" {
  source = "./s3_bucket"
  GC_PROJECT_ID = "${var.GC_PROJECT_ID}"
  IMAGE   = "${var.IMAGE}"
}

module "cloudsql" {
  source = "./cloud_sql"
  GC_PROJECT_ID = "${var.GC_PROJECT_ID}"
  IMAGE   = "${var.IMAGE}"
}

module "gcr_cloud_run" {
  source = "./gcr_cloud_run"
  GC_PROJECT_ID = "${var.GC_PROJECT_ID}"
  IMAGE   = "${var.IMAGE}"
}