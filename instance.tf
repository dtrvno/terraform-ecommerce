variable "ecommerce_ami" {
   description="aws generated https certificate for load  balancer" 
}
variable "key_pair_name" {
    description="key pair created for the user for certain region"
}

resource "aws_instance" "ecommerce-angular-zone1" {
    ami=var.ecommerce_ami
    instance_type="t2.micro"
    availability_zone="${data.aws_availability_zones.available.names[0]}"
    key_name=var.key_pair_name
    subnet_id="${aws_subnet.public_subnet_zone1.id}"
    security_groups=["${aws_security_group.security_group_public.id}"]
    user_data = <<-EOF
            #!/bin/bash
            yum update -y
            yum install docker -y
            service docker start
            usermod -a -G docker ec2-user
            docker pull dtrvno/angular-ecommerce2
            docker run --name angular-ecommerce2 -d -p 4200:4200 dtrvno/angular-ecommerce2
            EOF
   tags = {
     Name="angular-ecommerce1"
   }
   
}

resource "aws_instance" "ecommerce-angular-zone2" {
    ami=var.ecommerce_ami
    instance_type="t2.micro"
    availability_zone="${data.aws_availability_zones.available.names[1]}"
    key_name=var.key_pair_name
    subnet_id="${aws_subnet.public_subnet_zone2.id}"
    security_groups=["${aws_security_group.security_group_public.id}"]
    user_data = <<-EOF
            #!/bin/bash
            yum update -y
            yum install docker -y
            service docker start
            usermod -a -G docker ec2-user
            docker pull dtrvno/angular-ecommerce2
            docker run --name angular-ecommerce2 -d -p 4200:4200 dtrvno/angular-ecommerce2
            EOF
   tags = {
     Name="angular-ecommerce2"
   }
   
}

resource "aws_instance" "ecommerce-spring-zone1" {
    ami=var.ecommerce_ami
    instance_type="t2.micro"
    availability_zone="${data.aws_availability_zones.available.names[0]}"
    key_name=var.key_pair_name
    subnet_id="${aws_subnet.private_subnet_zone1.id}"
    security_groups=["${aws_security_group.security_group_private.id}"]
    user_data = <<-EOF
            #!/bin/bash
            yum update -y
            yum install docker -y
            service docker start
            usermod -a -G docker ec2-user
            docker pull dtrvno/spring-boot-ecommerce2
            docker run --name spring-boot-ecommerce2 -d -p 8443:8443 dtrvno/spring-boot-ecommerce2
            EOF
   tags = {
     Name="spring-ecommerce1"
   }
   depends_on=[aws_nat_gateway.nat_gateway_zone1]
}
resource "aws_instance" "ecommerce-spring-zone2" {
    ami=var.ecommerce_ami
    instance_type="t2.micro"
    availability_zone="${data.aws_availability_zones.available.names[1]}"
    key_name=var.key_pair_name
    subnet_id="${aws_subnet.private_subnet_zone2.id}"
    security_groups=["${aws_security_group.security_group_private.id}"]
    user_data = <<-EOF
            #!/bin/bash
            yum update -y
            yum install docker -y
            service docker start
            usermod -a -G docker ec2-user
            docker pull dtrvno/spring-boot-ecommerce2
            docker run --name spring-boot-ecommerce2 -d -p 8443:8443 dtrvno/spring-boot-ecommerce2
            EOF
   tags = {
     Name="spring-ecommerce2"
   }
   depends_on=[aws_nat_gateway.nat_gateway_zone2]
}

resource "aws_lb_target_group_attachment" "ecommerce_angular1" {
  target_group_arn = aws_alb_target_group.alb_angular_ecommerce.arn
  target_id        = aws_instance.ecommerce-angular-zone1.id
  port             = 4200
  depends_on = [aws_instance.ecommerce-angular-zone1]
}
resource "aws_lb_target_group_attachment" "ecommerce_angular2" {
  target_group_arn = aws_alb_target_group.alb_angular_ecommerce.arn
  target_id        = aws_instance.ecommerce-angular-zone2.id
  port             = 4200
  depends_on = [aws_instance.ecommerce-angular-zone2]
}
resource "aws_lb_target_group_attachment" "ecommerce_spring1" {
  target_group_arn = aws_alb_target_group.alb_spring_ecommerce.arn
  target_id        = aws_instance.ecommerce-spring-zone1.id
  port             = 8443
  depends_on = [aws_instance.ecommerce-spring-zone1]
}
resource "aws_lb_target_group_attachment" "ecommerce_spring2" {
  target_group_arn = aws_alb_target_group.alb_spring_ecommerce.arn
  target_id        = aws_instance.ecommerce-spring-zone2.id
  port             = 8443
  depends_on = [aws_instance.ecommerce-spring-zone2]
}