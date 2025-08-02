locals {
  common_tags = {
    project     = var.project_name
    environment = var.environment
    team        = var.team
  }
}

resource "aws_vpc" "airflow-deployment-vpc" {
  cidr_block           = "10.1.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(local.common_tags, {
    service = "VPC"
    Name    = "${var.project_name}-vpc"
  })
}


resource "aws_subnet" "public_subnets" {
  for_each = var.public_subnets

  vpc_id            = aws_vpc.airflow-deployment-vpc.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone

  tags = merge(local.common_tags, {
    service      = each.value.service
    vpc_resource = each.value.vpc_resource
    Name         = "${var.project_name}-${each.key}"
  })

}

resource "aws_internet_gateway" "airflow-deployment-igw" {
  vpc_id = aws_vpc.airflow-deployment-vpc.id

  tags = merge(local.common_tags, {
    service = "Internet Gateway"
    Name    = "${var.project_name}-igw"
  })

}

# public route table for the VPC
resource "aws_route_table" "airflow-deployment-public-route-table" {
  vpc_id = aws_vpc.airflow-deployment-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.airflow-deployment-igw.id
  }

  tags = merge(local.common_tags, {
    service = "Public Route Table"
    Name    = "${var.project_name}-public-route-table"
  })

}

resource "aws_route_table_association" "public_subnet_associations" {
  for_each = aws_subnet.public_subnets

  subnet_id      = each.value.id
  route_table_id = aws_route_table.airflow-deployment-public-route-table.id
}

