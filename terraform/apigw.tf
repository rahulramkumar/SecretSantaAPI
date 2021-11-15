resource "aws_apigatewayv2_api" "apigw-api" {
  name          = "secret-santa-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "apigw-stage" {
  api_id = aws_apigatewayv2_api.apigw-api.id

  name        = "prod"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.apigw-log-group.arn
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

resource "aws_apigatewayv2_integration" "apigw-integration" {
  api_id           = aws_apigatewayv2_api.apigw-api.id

  integration_uri = aws_lambda_function.secret-santa-api.invoke_arn
  integration_type = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "all-route" {
  api_id    = aws_apigatewayv2_api.apigw-api.id

  route_key = "ANY /api/{proxy+}"
  target = "integrations/${aws_apigatewayv2_integration.apigw-integration.id}"
}

resource "aws_apigatewayv2_route" "status-route" {
  api_id    = aws_apigatewayv2_api.apigw-api.id

  route_key = "GET /status"
  target    = "integrations/${aws_apigatewayv2_integration.apigw-integration.id}"
}

resource "aws_lambda_permission" "apigw-lambda-permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.secret-santa-api.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.apigw-api.execution_arn}/*/*"
}

resource "aws_cloudwatch_log_group" "apigw-log-group" {
  name = "/aws/api_gw/${aws_apigatewayv2_api.apigw-api.name}"

  retention_in_days = 90
}