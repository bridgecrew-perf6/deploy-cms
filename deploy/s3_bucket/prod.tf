provider "aws" {
  region = var.region
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
}

resource "aws_s3_bucket" "bucket" {
  bucket = var.AWS_STORAGE_BUCKET_NAME
  acl = "public-read-write"
  force_destroy = true
  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
    max_age_seconds = 3000
  }
  policy =<<POLICY
{
  "Version":"2012-10-17",
  "Statement":[{
    "Sid":"PublicReadGetObject",
    "Effect":"Allow",
    "Principal": "*",
    "Action":["s3:GetObject"],
    "Resource":[
      "arn:aws:s3:::".${var.AWS_STORAGE_BUCKET_NAME},
      "arn:aws:s3:::".${var.AWS_STORAGE_BUCKET_NAME}."/*"
    ]
  }]
}
POLICY
}

