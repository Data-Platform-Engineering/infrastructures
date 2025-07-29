# Security Group for RDS
resource "aws_security_group" "rds_sg" {
  name        = var.sg_name
  description = "Security group for RDS instance"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.rds_ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = var.rds_egress_rules
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }

  tags = merge(var.common_tags, { service = "RDS security group" })
}

# Subnet group for RDS
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = var.subnet_group_name
  subnet_ids = var.subnet_ids

  tags = merge(var.common_tags, { service = "RDS subnet group" })
}

# SSM Parameters for credentials
resource "aws_ssm_parameter" "db_username" {
  name        = var.ssm_username_name
  description = "Master username for the RDS database"
  type        = "String"
  value       = var.database_master_username
  tags        = merge(var.common_tags, { service = "RDS ssm parameter" })
}

resource "aws_ssm_parameter" "db_password" {
  name        = var.ssm_password_name
  description = "Master password for the RDS database"
  type        = "String"
  value       = var.database_master_password
  tags        = merge(var.common_tags, { service = "RDS ssm parameter password" })
}

# RDS Instance
resource "aws_db_instance" "rds_instance" {
  allocated_storage      = var.allocated_storage
  storage_type           = var.storage_type
  storage_encrypted      = var.storage_encrypted
  publicly_accessible    = var.publicly_accessible
  db_name                = var.db_name
  identifier             = var.db_identifier
  multi_az               = var.multi_az
  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  username               = aws_ssm_parameter.db_username.value
  password               = aws_ssm_parameter.db_password.value
  skip_final_snapshot    = var.skip_final_snapshot
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name

  depends_on = [
    aws_db_subnet_group.rds_subnet_group,
    aws_ssm_parameter.db_username,
    aws_ssm_parameter.db_password
  ]

  tags = merge(var.common_tags, { service = "RDS" })
}
