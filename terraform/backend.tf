terraform {
  backend "s3" {
    bucket       = "airflow-infra-prod"
    key          = "state/terraform.tfstate"
    region       = "eu-north-1"
    use_lockfile = true
    encrypt      = true
  }
}