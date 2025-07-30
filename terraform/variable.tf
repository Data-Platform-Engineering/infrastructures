variable "database_master_password" {
  description = "The master password for the RDS database"
  type        = string
  sensitive   = true

}

variable "database_master_username" {
  description = "The master username for the RDS database"
  type        = string
  default     = "admin"

}

variable "redshift_master_password" {
  description = "The master password for the redshift"
  type        = string
  sensitive   = true

}

variable "redshift_master_username" {
  description = "The master username for the redshift"
  type        = string
  default     = "admin"

}

variable "project_name" {
  description = "The name of the project"
  type        = string
  default     = "airflow-deployment"

}

variable "environment" {
  description = "The environment for the deployment"
  type        = string
  default     = "production"

}

variable "team" {
  description = "The team responsible for the deployment"
  type        = string
  default     = "Data platform engineering team"

}

variable "private_subnets" {
  description = "Map of private subnets for RDS and Redshift"
  type        = map(any)
  default = {
    rds-a      = { cidr_block = "10.1.2.0/24", availability_zone = "eu-west-1a", service = "private subnet1 for RDS", vpc_resource = "RDS" }
    rds-b      = { cidr_block = "10.1.3.0/24", availability_zone = "eu-west-1b", service = "private subnet2 for RDS", vpc_resource = "RDS" }
    rds-c      = { cidr_block = "10.1.4.0/24", availability_zone = "eu-west-1c", service = "private subnet3 for RDS", vpc_resource = "RDS" }
    redshift-d = { cidr_block = "10.1.5.0/24", availability_zone = "eu-west-1a", service = "private subnet1 for REDSHIFT", vpc_resource = "REDSHIFT" }
    redshift-e = { cidr_block = "10.1.6.0/24", availability_zone = "eu-west-1b", service = "private subnet2 for REDSHIFT", vpc_resource = "REDSHIFT" }
    redshift-f = { cidr_block = "10.1.7.0/24", availability_zone = "eu-west-1c", service = "private subnet3 for REDSHIFT", vpc_resource = "REDSHIFT" }
  }
}


