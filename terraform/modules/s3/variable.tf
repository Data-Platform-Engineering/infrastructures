variable "tags" {
  description = "Tags to apply to the S3 bucket"
  type        = map(string)

}

variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string

}

variable "versioning_status" {
  description = "Versioning status for the bucket (Enabled or Suspended)"
  type        = string
}


variable "enable_encryption" {
  description = "Enable server-side encryption (AES256) for the bucket"
  type        = bool
  default     = false
}

variable "encryption_algorithm" {
  description = "If server-side encryption is enabled for bucket"
  type        = string
  default     = "AES256"
}