provider "aws" {
  region = "us-east-2"
}
resource "aws_vpc" "ecommerce-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name="ecommerce-production"
  }
}
data "aws_availability_zones" "available" {
  state = "available"
}


resource "aws_subnet" "public_subnet_zone1" {
  availability_zone = data.aws_availability_zones.available.names[0]
  vpc_id=aws_vpc.ecommerce-vpc.id
  cidr_block="10.0.0.0/24"
  map_public_ip_on_launch="true"
  tags = {
    Name="ecommerce-public-subnet1"
  }
  
}

resource "aws_subnet" "public_subnet_zone2" {
  availability_zone = data.aws_availability_zones.available.names[1]
  vpc_id=aws_vpc.ecommerce-vpc.id
  cidr_block="10.0.1.0/24"
  map_public_ip_on_launch="true"
  tags = {
    Name="ecommerce-public-subnet2"
  }
  
}
resource "aws_subnet" "private_subnet_zone1" {
  availability_zone = data.aws_availability_zones.available.names[0]
  vpc_id=aws_vpc.ecommerce-vpc.id
  cidr_block="10.0.2.0/24"
  tags = {
    Name="ecommerce-public-subnet1"
  }
  
}

resource "aws_subnet" "private_subnet_zone2" {
  availability_zone = data.aws_availability_zones.available.names[1]
  vpc_id=aws_vpc.ecommerce-vpc.id
  cidr_block="10.0.3.0/24"
  tags = {
    Name="ecommerce-public-subnet2"
  }
  
}