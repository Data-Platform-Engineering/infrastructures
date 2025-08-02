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


# public subnet for the VPC
# resource "aws_subnet" "airflow-deployment-public-subnet" {
#   vpc_id                  = aws_vpc.airflow-deployment-vpc.id
#   cidr_block              = "10.1.1.0/24"
#   availability_zone       = "eu-west-1a"
#   map_public_ip_on_launch = true

#   tags = merge(local.common_tags, {
#     service = "Public Subnet"
#     Name    = "${var.project_name}-public-subnet"
#   })
# }

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

#private subnet for the VPC
# resource "aws_subnet" "private_subnets" {
#   for_each = var.private_subnets

#   vpc_id            = aws_vpc.airflow-deployment-vpc.id
#   cidr_block        = each.value.cidr_block
#   availability_zone = each.value.availability_zone

#   tags = merge(local.common_tags, {
#     service      = each.value.service
#     vpc_resource = each.value.vpc_resource
#     Name         = "${var.project_name}-${each.key}"
#   })

# }

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


# route table for the public subnet
# resource "aws_route_table_association" "airflow-deployment-public-subnet-association" {
#   subnet_id      = aws_subnet.airflow-deployment-public-subnet.id
#   route_table_id = aws_route_table.airflow-deployment-public-route-table.id
# }

#nat gateway for the VPC
# resource "aws_eip" "airflow-deployment-eip" {
#   domain = "vpc"

#   tags = merge(local.common_tags, {
#     service = "Elastic IP for NAT Gateway"
#     Name    = "${var.project_name}-nat-gateway-eip"
#   })

# }

# resource "aws_nat_gateway" "airflow-deployment-nat-gateway" {
#   allocation_id = aws_eip.airflow-deployment-eip.id
#   subnet_id     = aws_subnet.airflow-deployment-public-subnet.id
#   depends_on    = [aws_internet_gateway.airflow-deployment-igw]

#   tags = merge(local.common_tags, {
#     service = "NAT Gateway"
#     Name    = "${var.project_name}-nat-gateway"
#   })


# }

# # private route table for the VPC
# resource "aws_route_table" "airflow-deployment-private-route-table" {
#   vpc_id = aws_vpc.airflow-deployment-vpc.id

#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.airflow-deployment-nat-gateway.id
#   }

#   tags = merge(local.common_tags, {
#     service = "Private Route Table"
#     Name    = "${var.project_name}-private-route-table"
#   })

# }

# resource "aws_route_table_association" "private_subnet_associations" {
#   for_each = aws_subnet.private_subnets

#   subnet_id      = each.value.id
#   route_table_id = aws_route_table.airflow-deployment-private-route-table.id
# }
