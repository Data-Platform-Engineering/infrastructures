variable "sg_name" { type = string }
variable "vpc_id" { type = string }
variable "subnet_group_name" { type = string }
variable "subnet_ids" { type = list(string) }

variable "cluster_identifier" { type = string }
variable "database_name" { type = string }
variable "node_type" { type = string }
variable "cluster_type" { type = string }
variable "multi_az" { type = bool }
variable "port" { type = number }
variable "publicly_accessible" { type = bool }
variable "skip_final_snapshot" { type = bool }

variable "redshift_master_username" { type = string }
variable "redshift_master_password" { type = string }

variable "ingress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}

variable "egress_rules" {
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
