resource "aws_redshift_cluster" "airflow-deployment-redshift-cluster" {
  cluster_identifier = "airflow-deployment-redshift-cluster"
  database_name      = "airflowdb"
  master_username    = aws_ssm_parameter.airflow-deployment-redshift-username.value
  master_password    = aws_ssm_parameter.airflow-deployment-redshift-password.value
  node_type          = "ra3.large" #"dc1.large"
  cluster_type       = "single-node"
  cluster_subnet_group_name = aws_redshift_subnet_group.airflow-deployment-redshift-subnet-group.name
  multi_az = false
  port = 5439
  publicly_accessible = true 
  #iam_roles          = [aws_iam_role.airflow-deployment-redshift-role.arn]
  skip_final_snapshot = true
  vpc_security_group_ids = [aws_security_group.airflow-deployment-redshift-sg.id]

  tags = {
    project = "airflow-deployment"
  }
}


resource "aws_redshift_subnet_group" "airflow-deployment-redshift-subnet-group" {
  name       = "airflow-deployment-redshift-subnet-group"
  subnet_ids = [aws_subnet.airflow-deployment-private-subnet-d.id, 
                aws_subnet.airflow-deployment-private-subnet-e.id,
                aws_subnet.airflow-deployment-private-subnet-f.id]

  tags = {
    project = "airflow-deployment"
  }
}


resource "aws_ssm_parameter" "airflow-deployment-redshift-username" {
  name        = "/airflow-deployment/redshift/username/master"
  description = "master username for the redshift database"
  type        = "String"
  value       = var.redshift_master_username

  tags = {
    project = "airflow-deployment"
  }
}

resource "aws_ssm_parameter" "airflow-deployment-redshift-password" {
  name        = "/airflow-deployment/redshift/password/master"
  description = "master password for the redshift database"
  type        = "String"
  value       = var.redshift_master_password

  tags = {
    project = "airflow-deployment"
  }
}


resource "aws_security_group" "airflow-deployment-redshift-sg" {
  name        = "airflow-deployment-redshift-sg"
  description = "Security group for Redshift cluster"
  vpc_id      = aws_vpc.airflow-deployment-vpc.id

  ingress {
    from_port   = 5439
    to_port     = 5439
    protocol    = "tcp"
    cidr_blocks = ["10.1.0.0/16"]
  }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
      project = "airflow-deployment"
    }
}