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
  default     = "your_secure_password_here" 
  
}

variable "redshift_master_username" {
  description = "The master username for the redshift"
  type        = string
  default     = "admin" 
  
}
