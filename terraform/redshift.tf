data "aws_ssm_parameter" "redshift_password" {
  name            = var.ssm_password_name
  with_decryption = true
}

module "airflow_redshift" {
  source = "./modules/redshift"

  sg_name           = "airflow-deployment-redshift-sg"
  vpc_id            = aws_vpc.airflow-deployment-vpc.id
  subnet_group_name = "airflow-deployment-redshift-subnet-group"
  subnet_ids = [
    aws_subnet.public_subnets["redshift-d"].id,
    aws_subnet.public_subnets["redshift-e"].id,
    aws_subnet.public_subnets["redshift-f"].id

  ]

  cluster_identifier  = "airflow-deployment-redshift-cluster"
  database_name       = "airflowdb"
  node_type           = "ra3.large"
  cluster_type        = "single-node"
  multi_az            = false
  port                = 5439
  publicly_accessible = true
  skip_final_snapshot = true

  redshift_master_username = var.redshift_master_username
  redshift_master_password = data.aws_ssm_parameter.redshift_password.value

  ingress_rules = [
    {
      from_port   = 5439
      to_port     = 5439
      protocol    = "tcp"
      cidr_blocks = ["10.1.0.0/16"]
    }
  ]

  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  common_tags = local.common_tags
}
