output "shorten_lambda_arn" {
  description = "ARN of the shorten Lambda function"
  value       = aws_lambda_function.shorten.arn
}

output "redirect_lambda_arn" {
  description = "ARN of the redirect Lambda function"
  value       = aws_lambda_function.redirect.arn
}

output "shorten_lambda_name" {
  description = "Name of the shorten Lambda function"
  value       = aws_lambda_function.shorten.function_name
}

output "redirect_lambda_name" {
  description = "Name of the redirect Lambda function"
  value       = aws_lambda_function.redirect.function_name
}