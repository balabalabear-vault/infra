resource "aws_api_gateway_account" "vault_frontend_api" {
  cloudwatch_role_arn = aws_iam_role.cloudwatch.arn
}

resource "aws_api_gateway_rest_api" "vault_frontend_api" {
  name = "vault-contact-me"
  body = templatefile(
    "${path.module}/definitions/api_definition.tpl",
    {
      lambda_uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${aws_lambda_function.test_lambda.arn}/invocations"
    }
  )

  endpoint_configuration {
    types = ["EDGE"]
  }
}

resource "aws_api_gateway_domain_name" "api" {
  certificate_arn = aws_acm_certificate_validation.api.certificate_arn
  domain_name     = "api.balabalabear.com"
}


resource "aws_api_gateway_deployment" "prod" {
  rest_api_id = aws_api_gateway_rest_api.vault_frontend_api.id

  triggers = {
    redeployment = sha256(
      templatefile(
        "${path.module}/definitions/api_definition.tpl",
        {
          lambda_uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${aws_lambda_function.test_lambda.arn}/invocations"
        }
      )
    )
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "prod" {
  deployment_id = aws_api_gateway_deployment.prod.id
  rest_api_id   = aws_api_gateway_rest_api.vault_frontend_api.id
  stage_name    = "prod"
}

resource "aws_api_gateway_base_path_mapping" "example" {
  api_id      = aws_api_gateway_rest_api.vault_frontend_api.id
  stage_name  = aws_api_gateway_stage.prod.stage_name
  domain_name = aws_api_gateway_domain_name.api.domain_name
}
