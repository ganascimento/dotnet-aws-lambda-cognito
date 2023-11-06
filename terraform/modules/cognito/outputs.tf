output "issuer" {
  value = aws_cognito_user_pool.pool.endpoint
}

output "audience" {
  value = aws_cognito_user_pool_client.client.id
}
