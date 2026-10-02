data "aws_route53_zone" "balabalabear" {
  name = "balabalabear.com"
}

resource "aws_route53_record" "site" {
  for_each = toset(flatten([
    for name in ["balabalabear.com", "www.balabalabear.com"] : [
      for type in ["A", "AAAA"] : "${name}|${type}"
    ]
  ]))

  zone_id = data.aws_route53_zone.balabalabear.zone_id
  name    = split("|", each.key)[0]
  type    = split("|", each.key)[1]

  alias {
    name                   = aws_cloudfront_distribution.site.domain_name
    zone_id                = aws_cloudfront_distribution.site.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "site_acm" {
  for_each = {
    for dvo in aws_acm_certificate.site.domain_validation_options : dvo.domain_name => dvo
  }

  zone_id = data.aws_route53_zone.balabalabear.zone_id
  name    = each.value.resource_record_name
  type    = each.value.resource_record_type
  records = [each.value.resource_record_value]
  ttl     = 60
  # The old certificates may have created identical validation records by hand
  allow_overwrite = true
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

