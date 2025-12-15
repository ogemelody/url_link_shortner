output "api_gateway_url" {
  description = "URL of the API Gateway"
  value       = module.api.api_gateway_url
}

output "dynamodb_table_name" {
  description = "Name of the DynamoDB table"
  value       = module.dynamodb.table_name
}