data "aws_route53_zone" "balabalabear" {
  name         = "balabalabear.com"
}

data "aws_acm_certificate" "tossl" {
  domain   = "balabalabear.com"
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

resource "aws_acm_certificate" "www" {
  domain_name       = "www.balabalabear.com"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "com" {
  zone_id = data.aws_route53_zone.balabalabear.zone_id
  name    = "balabalabear.com"
  type    = "A"

  alias {
    name                   = aws_alb.main.dns_name
    zone_id                = aws_alb.main.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.balabalabear.zone_id
  name    = "www.balabalabear.com"
  type    = "A"

  alias {
    name                   = aws_alb.main.dns_name
    zone_id                = aws_alb.main.zone_id
    evaluate_target_health = true
  }
}
