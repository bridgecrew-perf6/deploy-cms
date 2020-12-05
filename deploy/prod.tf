module "s3_bucket" {
  source = "./s3_bucket"
}

module "cloudsql" {
  source = "./cloud_sql"
}

module "gcr_cloud_run" {
  source = "./gcr_cloud_run"
}