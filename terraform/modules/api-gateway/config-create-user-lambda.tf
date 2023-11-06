resource "aws_apigatewayv2_integration" "create_user_lambda" {
  api_id             = aws_apigatewayv2_api.main.id
  integration_uri    = var.create_user_lambda_invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "create_user_lambda" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "POST /createUser"
  target    = "integrations/${aws_apigatewayv2_integration.create_user_lambda.id}"
}

resource "aws_lambda_permission" "api_gw_create_user_lambda" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.create_user_lambda_function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.main.execution_arn}/*/*"
}
