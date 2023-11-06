output "auth_lambda_invoke_arn" {
  value = aws_lambda_function.auth_lambda.invoke_arn
}

output "auth_lambda_function_name" {
  value = aws_lambda_function.auth_lambda.function_name
}

output "create_user_lambda_invoke_arn" {
  value = aws_lambda_function.create_user_lambda.invoke_arn
}

output "create_user_lambda_function_name" {
  value = aws_lambda_function.create_user_lambda.function_name
}

output "get_user_lambda_invoke_arn" {
  value = aws_lambda_function.get_user_lambda.invoke_arn
}

output "get_user_lambda_function_name" {
  value = aws_lambda_function.get_user_lambda.function_name
}
