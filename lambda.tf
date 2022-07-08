resource "aws_s3_bucket" "lambda_bucket" {
  bucket        = "lm-lambda-src"
  force_destroy = true
}

data "archive_file" "lambda_xmpp_client" {
  type        = "zip"
  source_dir  = "${path.module}/xmpp-client"
  output_path = "${path.module}/xmpp-client.zip"
}

resource "aws_s3_object" "lambda_xmpp_client" {
  bucket = aws_s3_bucket.lambda_bucket.id
  key    = "xmpp-client.zip"
  source = data.archive_file.lambda_xmpp_client.output_path
  etag   = filemd5(data.archive_file.lambda_xmpp_client.output_path)
}

resource "aws_lambda_function" "xmpp_client" {
  function_name    = "XMPPClient"
  s3_bucket        = aws_s3_bucket.lambda_bucket.id
  s3_key           = aws_s3_object.lambda_xmpp_client.key
  runtime          = "nodejs12.x"
  handler          = "xmpp-client.handler"
  source_code_hash = data.archive_file.lambda_xmpp_client.output_base64sha256
  role             = aws_iam_role.lambda_exec.arn
  depends_on       = [aws_lb.lm-lb]
  environment {
    variables = {
      load_balancer_url = aws_lb.lm-lb.dns_name
    }
  }
}

resource "aws_cloudwatch_log_group" "xmpp_client_log" {
  name              = "/aws/lambda/${aws_lambda_function.xmpp_client.function_name}"
  retention_in_days = 30
}

resource "aws_iam_role" "lambda_exec" {
  name = "serverless_lambda"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_apigatewayv2_api" "lambda" {
  name          = "serverless_lambda_gw"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "lambda" {
  api_id      = aws_apigatewayv2_api.lambda.id
  name        = "serverless_lambda_stage"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gw.arn
    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
      }
    )
  }
}

resource "aws_apigatewayv2_integration" "xmpp_client" {
  api_id             = aws_apigatewayv2_api.lambda.id
  integration_uri    = aws_lambda_function.xmpp_client.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "xmpp_client" {
  api_id    = aws_apigatewayv2_api.lambda.id
  route_key = "GET /xmpp-client"
  target    = "integrations/${aws_apigatewayv2_integration.xmpp_client.id}"
}

resource "aws_cloudwatch_log_group" "api_gw" {
  name              = "/aws/api_gw/${aws_apigatewayv2_api.lambda.name}"
  retention_in_days = 30
}

resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.xmpp_client.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*"
}
