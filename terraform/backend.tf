terraform {
  backend "s3" {
    bucket       = "finance-n8n-automation"
    key          = "state/terraform.tfstate"
    region       = "eu-north-1"
    use_lockfile = true
    encrypt      = true
  }
}