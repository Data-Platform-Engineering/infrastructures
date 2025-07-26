resource "aws_vpc" "airflow-deployment-vpc" {
  cidr_block = "10.1.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    project = "airflow-deployment"
  }
}


# public subnet for the VPC
resource "aws_subnet" "airflow-deployment-public-subnet" {
  vpc_id     = aws_vpc.airflow-deployment-vpc.id
  cidr_block = "10.1.1.0/24"
  availability_zone = "eu-central-1a"

  tags = {
    project = "airflow-deployment"
  }
}

#private subnet for the VPC
resource "aws_subnet" "airflow-deployment-private-subnet-a" {
  vpc_id     = aws_vpc.airflow-deployment-vpc.id
  cidr_block = "10.1.2.0/24"
  availability_zone = "eu-central-1a"

    tags = {
        project = "airflow-deployment"
        vpc_resource = "RDS"
    }
}

resource "aws_subnet" "airflow-deployment-private-subnet-b" {
  vpc_id     = aws_vpc.airflow-deployment-vpc.id
  cidr_block = "10.1.3.0/24"
  availability_zone = "eu-central-1b"

    tags = {
        project = "airflow-deployment"
        vpc_resource = "RDS"
    }
}

resource "aws_subnet" "airflow-deployment-private-subnet-c" {
  vpc_id     = aws_vpc.airflow-deployment-vpc.id
  cidr_block = "10.1.4.0/24"
  availability_zone = "eu-central-1c"

    tags = {
        project = "airflow-deployment"
        vpc_resource = "RDS"
    }
}

resource "aws_subnet" "airflow-deployment-private-subnet-d" {
  vpc_id     = aws_vpc.airflow-deployment-vpc.id
  cidr_block = "10.1.5.0/24"
  availability_zone = "eu-central-1a"

    tags = {
        project = "airflow-deployment"
        vpc_resource = "REDSHIFT"
    }
}

resource "aws_subnet" "airflow-deployment-private-subnet-e" {
  vpc_id     = aws_vpc.airflow-deployment-vpc.id
  cidr_block = "10.1.6.0/24"
  availability_zone = "eu-central-1b"

    tags = {
        project = "airflow-deployment"
        vpc_resource = "REDSHIFT"
    }
}

resource "aws_subnet" "airflow-deployment-private-subnet-f" {
  vpc_id     = aws_vpc.airflow-deployment-vpc.id
  cidr_block = "10.1.7.0/24"
  availability_zone = "eu-central-1c"

    tags = {
        project = "airflow-deployment"
        vpc_resource = "REDSHIFT"
    }
}

resource "aws_internet_gateway" "airflow-deployment-igw" {
  vpc_id = aws_vpc.airflow-deployment-vpc.id

  tags = {
    project = "airflow-deployment"
  }
}

# public route table for the VPC
resource "aws_route_table" "airflow-deployment-public-route-table" {
  vpc_id = aws_vpc.airflow-deployment-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.airflow-deployment-igw.id
  }

  tags = {
    project = "airflow-deployment"
  }
}


# route table for the public subnet
resource "aws_route_table_association" "airflow-deployment-public-subnet-association" {
  subnet_id      = aws_subnet.airflow-deployment-public-subnet.id
  route_table_id = aws_route_table.airflow-deployment-public-route-table.id
}

#nat gateway for the VPC
resource "aws_eip" "airflow-deployment-eip" {
  domain = "vpc"

  tags = {
    project = "airflow-deployment"
  }
}

resource "aws_nat_gateway" "airflow-deployment-nat-gateway" {
  allocation_id = aws_eip.airflow-deployment-eip.id
  subnet_id     = aws_subnet.airflow-deployment-public-subnet.id
  depends_on = [ aws_internet_gateway.airflow-deployment-igw ]

  tags = {
    project = "airflow-deployment"
  }
}

# private route table for the VPC
resource "aws_route_table" "airflow-deployment-private-route-table" {
  vpc_id = aws_vpc.airflow-deployment-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.airflow-deployment-nat-gateway.id
    }
    tags = {
      project = "airflow-deployment"
    }
}

resource "aws_route_table_association" "airflow-deployment-private-subnet-association-a" {
    subnet_id      = aws_subnet.airflow-deployment-private-subnet-a.id
    route_table_id = aws_route_table.airflow-deployment-private-route-table.id
}

resource "aws_route_table_association" "airflow-deployment-private-subnet-association-b" {
    subnet_id      = aws_subnet.airflow-deployment-private-subnet-b.id
    route_table_id = aws_route_table.airflow-deployment-private-route-table.id
}

resource "aws_route_table_association" "airflow-deployment-private-subnet-association-c" {
    subnet_id      = aws_subnet.airflow-deployment-private-subnet-c.id
    route_table_id = aws_route_table.airflow-deployment-private-route-table.id
}

resource "aws_route_table_association" "airflow-deployment-private-subnet-association-d" {
    subnet_id      = aws_subnet.airflow-deployment-private-subnet-d.id
    route_table_id = aws_route_table.airflow-deployment-private-route-table.id
}

resource "aws_route_table_association" "airflow-deployment-private-subnet-association-e" {
    subnet_id      = aws_subnet.airflow-deployment-private-subnet-e.id
    route_table_id = aws_route_table.airflow-deployment-private-route-table.id
}

resource "aws_route_table_association" "airflow-deployment-private-subnet-association-f" {
    subnet_id      = aws_subnet.airflow-deployment-private-subnet-f.id
    route_table_id = aws_route_table.airflow-deployment-private-route-table.id
}

# ## security group for the RDS instance
# resource "aws_security_group" "airflow-deployment-rds-sg" {
#   vpc_id = aws_vpc.airflow-deployment-vpc.id

#   ingress {
#     from_port   = 3306
#     to_port     = 3306
#     protocol    = "tcp"
#     cidr_blocks = ["10.1.0.0/16"]
#   }

#     egress {
#         from_port   = 0
#         to_port     = 0
#         protocol    = "-1"
#         cidr_blocks = ["0.0.0.0/0"]
#     }

#     tags = {
#         project = "airflow-deployment"
#     }

# }


# data "aws_instance" "airflow-deployment-instance" {
#   instance_id = "i-0fb6b4cf6cde0a1a8"

#   filter {
#     name   = "project"
#     values = ["airflow-deployment"]
#   }
# }