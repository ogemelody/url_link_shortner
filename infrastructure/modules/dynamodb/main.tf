# DynamoDB table for storing URL mappings
resource "aws_dynamodb_table" "url_table" {
  name           = "${var.project_name}-${var.environment}-urls"
  billing_mode   = "PAY_PER_REQUEST"  # Serverless pricing
  hash_key       = "short_code"

  attribute {
    name = "short_code"
    type = "S"
  }

  # TTL for automatic cleanup (optional)
  ttl {
    attribute_name = "expires_at"
    enabled        = true
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-urls"
    Environment = var.environment
    Project     = var.project_name
  }
}