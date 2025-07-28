resource "aws_s3_bucket" "airflow-deployment-s3-bucket" {
  bucket = "airflow-deployment-s3-bucket"

  tags = {
    project = "airflow-deployment"
  }
}