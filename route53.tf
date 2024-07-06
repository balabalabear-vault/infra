data "aws_route53_zone" "balabalabear" {
  name = "balabalabear.com"
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

resource "aws_route53_record" "api_acm" {
  name    = tolist(aws_acm_certificate.api.domain_validation_options)[0].resource_record_name
  type    = tolist(aws_acm_certificate.api.domain_validation_options)[0].resource_record_type
  zone_id = data.aws_route53_zone.balabalabear.id # Replace with your Route 53 Hosted Zone ID
  records = [tolist(aws_acm_certificate.api.domain_validation_options)[0].resource_record_value]
  ttl     = 60
}

resource "aws_route53_record" "api" {
  name    = aws_api_gateway_domain_name.api.domain_name
  type    = "A"
  zone_id = data.aws_route53_zone.balabalabear.id

  alias {
    evaluate_target_health = true
    name                   = aws_api_gateway_domain_name.api.cloudfront_domain_name
    zone_id                = aws_api_gateway_domain_name.api.cloudfront_zone_id
  }
}


# # Example Route53 MX record
resource "aws_route53_record" "mail_from_mx" {
  zone_id = data.aws_route53_zone.balabalabear.id
  name    = aws_ses_domain_mail_from.mail.mail_from_domain
  type    = "MX"
  ttl     = "600"
  records = ["10 feedback-smtp.us-east-1.amazonses.com"]
}

# Example Route53 TXT record for SPF
resource "aws_route53_record" "mail_from_txt" {
  zone_id = data.aws_route53_zone.balabalabear.id
  name    = "_amazonses.${aws_ses_domain_identity.mail.domain}"
  type    = "TXT"
  ttl     = "600"
  records = [aws_ses_domain_identity.mail.verification_token]
}
