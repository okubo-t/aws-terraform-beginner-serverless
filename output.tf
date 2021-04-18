# UserPool
output "userPoolId" {
  value = aws_cognito_user_pool.user_pool.id
}

output "appClientId" {
  value = aws_cognito_user_pool_client.pool_client.id
}

# Federated Identity
output "identityPoolId" {
  value = aws_cognito_identity_pool.id_pool.id
}
