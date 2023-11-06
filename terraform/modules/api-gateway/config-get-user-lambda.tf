resource "aws_apigatewayv2_integration" "get_user_lambda" {
  api_id             = aws_apigatewayv2_api.main.id
  integration_uri    = var.get_user_lambda_invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "get_user_lambda" {
  api_id             = aws_apigatewayv2_api.main.id
  route_key          = "POST /user"
  target             = "integrations/${aws_apigatewayv2_integration.get_user_lambda.id}"
  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.api_authorize.id
}

resource "aws_lambda_permission" "api_gw_get_user_lambda" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.get_user_lambda_function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.main.execution_arn}/*/*"
}
