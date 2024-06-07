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

resource "aws_acm_certificate" "api" {
  domain_name       = "api.balabalabear.com"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "api" {
  certificate_arn         = aws_acm_certificate.api.arn
  validation_record_fqdns = [aws_route53_record.api_acm.fqdn]
}
