provider "aws" {
  region = var.region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_s3_bucket" "bucket" {
  bucket = var.aws_bucket_name
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
      "arn:aws:s3:::".${var.aws_bucket_name},
      "arn:aws:s3:::".${var.aws_bucket_name}."/*"
    ]
  }]
}
POLICY
}

