# Security Group for Redshift
resource "aws_security_group" "redshift_sg" {
  name        = var.sg_name
  description = "Security group for Redshift cluster"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = var.egress_rules
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }

  tags = merge(var.common_tags, { service = "Redshift security group" })
}

# Subnet group for Redshift
resource "aws_redshift_subnet_group" "redshift_subnet_group" {
  name       = var.subnet_group_name
  subnet_ids = var.subnet_ids

  tags = merge(var.common_tags, { service = "Redshift subnet group" })
}

# Redshift Cluster
resource "aws_redshift_cluster" "redshift_cluster" {
  cluster_identifier        = var.cluster_identifier
  database_name             = var.database_name
  master_username           = var.redshift_master_username
  master_password           = var.redshift_master_password
  node_type                 = var.node_type
  cluster_type              = var.cluster_type
  cluster_subnet_group_name = aws_redshift_subnet_group.redshift_subnet_group.name
  multi_az                  = var.multi_az
  port                      = var.port
  publicly_accessible       = var.publicly_accessible
  skip_final_snapshot       = var.skip_final_snapshot
  vpc_security_group_ids    = [aws_security_group.redshift_sg.id]

  tags = merge(var.common_tags, { service = "Redshift" })
}
