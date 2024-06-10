resource "aws_cloudwatch_log_group" "lambda_test" {
  name              = "/aws/lambda/test_lambda"
  retention_in_days = 14
}