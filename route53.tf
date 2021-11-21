variable "domain_name" {
    description ="any arbitrary domain"
}
data "aws_route53_zone" "myzone" {
  name         = "${var.domain_name}."
}

resource "aws_route53_record" "ecommerce-route53" {
  allow_overwrite = true
  name            = var.domain_name
  type            = "A"
  zone_id         = data.aws_route53_zone.myzone.zone_id

  alias {
    name                   = aws_alb.alb_ecommerce.dns_name
    zone_id                = aws_alb.alb_ecommerce.zone_id
    evaluate_target_health = false
  }
}
