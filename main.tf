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

resource "aws_internet_gateway" "ecommerce-ig" {
  vpc_id = aws_vpc.ecommerce-vpc.id

  tags = {
    Name = "ECommerceIG"
  }
}
resource "aws_route_table" "ecommerce-public-route-table" {
  vpc_id = aws_vpc.ecommerce-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ecommerce-ig.id
  }

  tags = {
    Name = "ecommerce-route"
  }
}

resource "aws_route_table_association" "ecommerce-public-zone1" {
  subnet_id      = aws_subnet.public_subnet_zone1.id
  route_table_id = aws_route_table.ecommerce-public-route-table.id
}

resource "aws_route_table_association" "ecommerce-public-zone2" {
  subnet_id      = aws_subnet.public_subnet_zone2.id
  route_table_id = aws_route_table.ecommerce-public-route-table.id
}
resource "aws_route_table_association" "ecommerce-private-zone1" {
  subnet_id      = aws_subnet.private_subnet_zone1.id
  route_table_id = aws_route_table.ecommerce-private-route-table1.id
}

resource "aws_route_table_association" "ecommerce-private-zone2" {
  subnet_id      = aws_subnet.private_subnet_zone2.id
  route_table_id = aws_route_table.ecommerce-private-route-table2.id
}

resource "aws_eip" "eip_zone1" {
  vpc = true
}

resource "aws_eip" "eip_zone2" {
  vpc = true
}
resource "aws_nat_gateway" "nat_gateway_zone1" {
  allocation_id = aws_eip.eip_zone1.id
  subnet_id = aws_subnet.public_subnet_zone1.id
  tags = {
    "Name" = "ECommerceNatGatewayZone1"
  }
  depends_on = [aws_internet_gateway.ecommerce-ig]
}

resource "aws_nat_gateway" "nat_gateway_zone2" {
  allocation_id = aws_eip.eip_zone2.id
  subnet_id = aws_subnet.public_subnet_zone2.id
  tags = {
    "Name" = "ECommerceNatGatewayZone2"
  }
  depends_on = [aws_internet_gateway.ecommerce-ig]
}

resource "aws_route_table" "ecommerce-private-route-table1" {
  vpc_id = aws_vpc.ecommerce-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_zone1.id
  }
  
  tags = {
    Name = "ecommerce-route1"
  }
}
resource "aws_route_table" "ecommerce-private-route-table2" {
  vpc_id = aws_vpc.ecommerce-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_zone2.id
  }
  
  tags = {
    Name = "ecommerce-route2"
  }
}


