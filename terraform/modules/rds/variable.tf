variable "sg_name" { type = string }
variable "vpc_id" { type = string }
variable "subnet_group_name" { type = string }
variable "subnet_ids" { type = list(string) }

variable "db_name" { type = string }
variable "db_identifier" { type = string }
variable "engine" { type = string }
variable "engine_version" { type = string }
variable "instance_class" { type = string }
variable "allocated_storage" { type = number }
variable "storage_type" { type = string }
variable "storage_encrypted" { type = bool }
variable "publicly_accessible" { type = bool }
variable "multi_az" { type = bool }
variable "skip_final_snapshot" { type = bool }

variable "database_master_username" { type = string }
variable "database_master_password" { type = string }

variable "rds_ingress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}

variable "rds_egress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}

variable "common_tags" {
  type = map(string)
}
