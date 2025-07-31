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