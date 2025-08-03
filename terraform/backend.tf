terraform {
  backend "s3" {
    bucket       = "dpe-terraform-state"
    key          = "production/production.tfstate"
    region       = "eu-north-1"
    use_lockfile = true
    encrypt      = true
  }
}
