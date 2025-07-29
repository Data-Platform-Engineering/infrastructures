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

