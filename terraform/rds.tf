data "aws_ssm_parameter" "rds_password" {
  name            = var.rds_ssm_password_name
  with_decryption = true
}

module "airflow_rds" {
  source = "./modules/rds"

  sg_name           = "airflow-deployment-rds-sg"
  vpc_id            = aws_vpc.airflow-deployment-vpc.id
  subnet_group_name = "airflow-deployment-db-subnet-group"
  subnet_ids = [
    aws_subnet.public_subnets["rds-a"].id,
    aws_subnet.public_subnets["rds-b"].id,
    aws_subnet.public_subnets["rds-c"].id
  ]

  db_name             = "airflow_deployment_db"
  db_identifier       = "airflow-deployment-db-instance"
  engine              = "postgres"
  engine_version      = "16.3"
  instance_class      = "db.t3.micro"
  allocated_storage   = 20
  storage_type        = "gp2"
  storage_encrypted   = false
  publicly_accessible = true
  multi_az            = false
  skip_final_snapshot = true

  database_master_username = var.database_master_username
  database_master_password = data.aws_ssm_parameter.rds_password.value

  rds_ingress_rules = [
    {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    }
  ]

  rds_egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  common_tags = local.common_tags
}
