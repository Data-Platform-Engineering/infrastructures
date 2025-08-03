resource "aws_db_instance" "airflow-deployment-db-instance" {
  allocated_storage    = 20
  storage_type         = "gp2"
  storage_encrypted    = false
  publicly_accessible  = true
  db_name              = "airflow_helm_deployment_db"
  identifier           = "airflow-deployment-db-instance"
  multi_az             = false
  engine               = "postgres"
  engine_version       = "16.3"
  instance_class       = "db.t3.micro"
  username             = aws_ssm_parameter.airflow-deployment-db-username.value
  password             = aws_ssm_parameter.airflow-deployment-db-password.value
  skip_final_snapshot  = true
  vpc_security_group_ids = [ aws_security_group.airflow-deployment-rds-sg.id]
  depends_on = [
    aws_db_subnet_group.airflow-deployment-db-subnet-group,
    aws_ssm_parameter.airflow-deployment-db-username,
    aws_ssm_parameter.airflow-deployment-db-password
  ]
  db_subnet_group_name = aws_db_subnet_group.airflow-deployment-db-subnet-group.name

  tags = {
    project = "airflow-deployment"
    environment = "production"
    team = "Data platform engineering team"
    service = "RDS"
  }
}

# DB subnet group for the RDS instance
resource "aws_db_subnet_group" "airflow-deployment-db-subnet-group" {
  name       = "airflow-deployment-db-subnet-group"
  subnet_ids = [aws_subnet.airflow-deployment-private-subnet-a.id,
                aws_subnet.airflow-deployment-private-subnet-b.id,
                aws_subnet.airflow-deployment-private-subnet-c.id
                ]

  tags = {
    project = "airflow-deployment"
    environment = "production"
    team = "Data platform engineering team"
    service = "RDS subnet group"
  }
}

# security group for the RDS instance
resource "aws_security_group" "airflow-deployment-rds-sg" {
  name        = "airflow-deployment-rds-sg"
  description = "Security group for RDS instance"
  vpc_id      = aws_vpc.airflow-deployment-vpc.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    project = "airflow-deployment"
    environment = "production"
    team = "Data platform engineering team"
    service = "RDS security group"
  }
  }

resource "aws_ssm_parameter" "airflow-deployment-db-username" {
  name        = "environment/dpe/airflow/rds/username"
  description = "master username for the RDS database"
  type        = "String"
  value       = var.database_master_username

  tags = {
    project = "airflow-deployment"
    environment = "production"
    team = "Data platform engineering team"
    service = "RDS ssm parameter"
  }
}

resource "aws_ssm_parameter" "airflow-deployment-db-password" {
  name        = "environment/dpe/airflow/rds/password"
  description = "master password for the RDS database"
  type        = "String"
  value       = var.database_master_password

  tags = {
    project = "airflow-deployment"
    environment = "production"
    team = "Data platform engineering team"
    service = "RDS ssm parameter password"
  }
}
