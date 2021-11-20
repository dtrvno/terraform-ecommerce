
data "aws_route53_zone" "myzone" {
  name         = "dtrubov.net."
}
resource "aws_route53_record" "ecommerce-route53" {
  allow_overwrite = true
  name            = "dtrubov.net"
  type            = "A"
  zone_id         = data.aws_route53_zone.myzone.zone_id

  alias {
    name                   = aws_alb.alb_ecommerce.dns_name
    zone_id                = aws_alb.alb_ecommerce.zone_id
    evaluate_target_health = false
  }
}
