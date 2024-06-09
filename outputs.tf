output "alb_hostname" {
  value = "${aws_alb.main.dns_name}:3000"
}

output "lambda_url" {
  value = aws_lambda_function.test_lambda
}