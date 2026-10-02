# CloudFront requires its certificate to live in us-east-1
resource "aws_acm_certificate" "site" {
  domain_name               = "balabalabear.com"
  subject_alternative_names = ["www.balabalabear.com"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "site" {
  certificate_arn         = aws_acm_certificate.site.arn
  validation_record_fqdns = [for record in aws_route53_record.site_acm : record.fqdn]
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
