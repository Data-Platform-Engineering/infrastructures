output "bucket_name" {
  value = aws_s3_bucket.airflow-deployment-s3-bucket.id
}

output "bucket_arn" {
  value = aws_s3_bucket.airflow-deployment-s3-bucket.arn
}
