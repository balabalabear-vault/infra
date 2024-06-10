data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/lambdas/trial/index.mjs"
  output_path = "${path.module}/lambdas/trial/trial.zip"
}

resource "aws_lambda_function" "test_lambda" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  function_name = "trial"
  role          = aws_iam_role.lambda.arn

  filename = "${path.module}/lambdas/trial/trial.zip"
  handler  = "index.handler"

  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "nodejs20.x"

  # Advanced logging controls (optional)
  #   logging_config {
  #     log_format = "Text"
  #   }

  # ... other configuration ...
  depends_on = [
    aws_iam_role_policy_attachment.lambda_logs,
    aws_cloudwatch_log_group.lambda_test,
  ]

  environment {
    variables = {
      foo = "bar"
    }
  }
}

resource "aws_lambda_function_url" "test_lambda" {
  function_name      = aws_lambda_function.test_lambda.function_name
  authorization_type = "NONE"
}