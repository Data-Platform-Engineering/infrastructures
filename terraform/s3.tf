module "aws_s3_bucket" {
  source            = "./modules/s3"
  bucket_name       = "airflow-deployment-s3-bucket"
  versioning_status = "Enabled"


  tags = merge(local.common_tags, {
    service = "S3 bucket for Airflow deployment"
  })
}
