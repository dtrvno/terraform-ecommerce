resource "aws_alb" "alb_ecommerce" {
	name		=	"alb-ecommerce"
	internal	=	false
	security_groups	=	[aws_security_group.security_group_public.id,aws_security_group.security_group_private.id]
	subnets		=	["${aws_subnet.public_subnet_zone1.id}","${aws_subnet.public_subnet_zone2.id}"]
	enable_deletion_protection	=	false
}
resource "aws_alb_target_group" "alb_angular_ecommerce" {
	name	= "alb-angular-https"
	vpc_id = aws_vpc.ecommerce-vpc.id
	port	= "4200"
	protocol	= "HTTPS"
	
}
resource "aws_alb_target_group" "alb_spring_ecommerce" {
	name	= "alb-spring-https"
	vpc_id = aws_vpc.ecommerce-vpc.id
	port	= "8443"
	protocol	= "HTTPS"
    health_check {
        port="8443"
        protocol="HTTPS"
        healthy_threshold   = 5    
        unhealthy_threshold = 2    
        timeout             = 5    
        interval            = 30    
        path                = "/api/products"    
    }	
}
variable "certificate_arn" {
  description="aws generated certificate"
}

resource "aws_alb_listener" "alb_angular_https" {
	load_balancer_arn	=	"${aws_alb.alb_ecommerce.arn}"
	port			=	"4200"
	protocol		=	"HTTPS"
	ssl_policy		=	"ELBSecurityPolicy-2016-08"
	certificate_arn		=	var.certificate_arn

	default_action {
		target_group_arn	=	"${aws_alb_target_group.alb_angular_ecommerce.id}"
		type			=	"forward"
	}
}
resource "aws_alb_listener" "alb_sprintg_https" {
	load_balancer_arn	=	"${aws_alb.alb_ecommerce.arn}"
	port			=	"8443"
	protocol		=	"HTTPS"
	ssl_policy		=	"ELBSecurityPolicy-2016-08"
	certificate_arn		=	var.certificate_arn

	default_action {
		target_group_arn	=	"${aws_alb_target_group.alb_spring_ecommerce.id}"
		type			=	"forward"
	}
}