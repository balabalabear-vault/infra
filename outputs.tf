output "alb_hostname" {
  value = "${aws_alb.main.dns_name}:3000"
}

output "lambda_url" {
  value = aws_lambda_function_url.test_lambda
}

output "aws_ses_domain_identity_mail" {
  value = aws_ses_domain_identity.mail
}