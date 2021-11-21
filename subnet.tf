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
    Name="ecommerce-private-subnet1"
  }
  
}

resource "aws_subnet" "private_subnet_zone2" {
  availability_zone = data.aws_availability_zones.available.names[1]
  vpc_id=aws_vpc.ecommerce-vpc.id
  cidr_block="10.0.3.0/24"
  tags = {
    Name="ecommerce-private-subnet2"
  }
  
}

resource "aws_network_acl" "ecommerce-acl-public" {
  vpc_id=aws_vpc.ecommerce-vpc.id
  subnet_ids=[aws_subnet.public_subnet_zone1.id,aws_subnet.public_subnet_zone2.id]

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_block      = "0.0.0.0/0"
    rule_no    = 100
    action     = "allow"
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block      = "0.0.0.0/0"
    from_port  = 4200
    to_port    = 4200
  }
  ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block      = "0.0.0.0/0"
    from_port  = 22
    to_port    = 22
  }
  ingress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block      = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }
  ingress {
    protocol   = "icmp"
    rule_no    = 400
    action     = "allow"
    cidr_block      = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  ingress {
    protocol   = "tcp"
    rule_no    = 500
    action     = "allow"
    cidr_block      = "0.0.0.0/0"
    from_port  = 32768
    to_port    = 65535
  }
  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_block      = "0.0.0.0/0"
    rule_no    = 600
    action     = "allow"
  }


  tags = {
    Name = "ecommerce-acl-public"
  }
}

resource "aws_network_acl" "ecommerce-acl-private" {
  vpc_id=aws_vpc.ecommerce-vpc.id
  subnet_ids=[aws_subnet.private_subnet_zone1.id,aws_subnet.private_subnet_zone2.id]

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_block      = "0.0.0.0/0"
    rule_no    = 100
    action     = "allow"
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block      = "0.0.0.0/0"
    from_port  = 8443
    to_port    = 8443
  }
  ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block      = "0.0.0.0/0"
    from_port  = 22
    to_port    = 22
  }
  ingress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block      = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }
  ingress {
    protocol   = "icmp"
    rule_no    = 400
    action     = "allow"
    cidr_block      = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  ingress {
    protocol   = "tcp"
    rule_no    = 500
    action     = "allow"
    cidr_block      = "0.0.0.0/0"
    from_port  = 32768
    to_port    = 65535
  }

  tags = {
    Name = "ecommerce-acl-private"
  }
}


