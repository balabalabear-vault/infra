# Example SES Domain Identity
resource "aws_ses_domain_identity" "mail" {
  domain = data.aws_route53_zone.balabalabear.name
}

resource "aws_ses_domain_identity_verification" "mail" {
  domain = aws_ses_domain_identity.mail.domain

  depends_on = [
        aws_route53_record.mail_from_txt
    ]
}

resource "aws_ses_domain_mail_from" "mail" {
  domain           = aws_ses_domain_identity.mail.domain
  mail_from_domain = "mail.${aws_ses_domain_identity.mail.domain}"
}

resource "aws_ses_email_identity" "mail_sandbox" {
  email = "kuenyuikwok1106@outlook.com"
}


