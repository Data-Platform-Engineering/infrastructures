resource "aws_s3_bucket" "airflow-deployment-s3-bucket" {
  bucket = var.bucket_name
  tags = var.tags
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.airflow-deployment-s3-bucket.id
  versioning_configuration {
    status = var.versioning_status == "Enabled" ? "Enabled" : "Suspended"
  }
}