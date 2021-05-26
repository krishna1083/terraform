# My provider = AWS login
provider "aws" {
region = "${var.region}"
access_key = "${var.access_key}"
secret_key = "${var.secret_key}"

}

# Creating VPC with the name of my-vpc (Here resource name = aws_vpc & resource id = vpc)

resource "aws_vpc" "vpc" {
  cidr_block       = "192.168.0.0/16"

# Basic VPC cost will apply for below line and another tipe is dedicated (this is cost effective) 
  instance_tenancy = "default"

# Enabling DNS hostname for VPC
  enable_dns_support   = true
  enable_dns_hostnames = true

# My VPC name is my-vpc
  tags = {
    Name = "MY-VPC"
  }
}

# Creating Public-Subnet (Here Subnet name= Pub-sub)
resource "aws_subnet" "Pub" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "192.168.1.0/24"

# Enabling auto-assign ip

map_public_ip_on_launch = true

  tags = {
    Name = "PUB-SUB"
  }
}

# Creating Private-Subnet (Here Subnet name= Prv-sub)
resource "aws_subnet" "Prv" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "192.168.3.0/24"

  tags = {
    Name = "PRV-SUB"
  }
}

# Creating Internet-gateway with the name of MY-IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "MY-IGW"
  }
}

# Creating RT1-route-tables

resource "aws_route_table" "rt1" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

    tags = {
    Name = "MY-R-TABLE"
  }
}

# Route table association 

resource "aws_route_table_association" "as-1" {
  subnet_id      = aws_subnet.Pub.id
  route_table_id = aws_route_table.rt1.id
}

# Deploying Instance in to public-subnet using MY-VPC

resource "aws_instance" "ubuntu-20" {
  ami           = "ami-0c1a7f89451184c8b"
  instance_type = "t2.micro"

# Below is the public sub-net id
  subnet_id = "subnet-0119c306b7ead6ffb"
  tags = {
    Name = "Terraform-Server"
  }
}