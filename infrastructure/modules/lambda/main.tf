# IAM role for Lambda functions
resource "aws_iam_role" "lambda_role" {
  name = "${var.project_name}-${var.environment}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# IAM policy for DynamoDB access
resource "aws_iam_policy" "lambda_dynamodb_policy" {
  name = "${var.project_name}-${var.environment}-lambda-dynamodb"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem"
        ]
        Resource = var.dynamodb_table_arn
      }
    ]
  })
}

# Attach policies to Lambda role
resource "aws_iam_role_policy_attachment" "lambda_basic" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_role.name
}

resource "aws_iam_role_policy_attachment" "lambda_vpc" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
  role       = aws_iam_role.lambda_role.name
}

resource "aws_iam_role_policy_attachment" "lambda_dynamodb" {
  policy_arn = aws_iam_policy.lambda_dynamodb_policy.arn
  role       = aws_iam_role.lambda_role.name
}

# Create ZIP file for shorten function
data "archive_file" "shorten_zip" {
  type        = "zip"
  source_dir  = "../src/shorten"
  output_path = "shorten.zip"
}

# Shorten URL Lambda function
resource "aws_lambda_function" "shorten" {
  filename         = data.archive_file.shorten_zip.output_path
  function_name    = "${var.project_name}-${var.environment}-shorten"
  role            = aws_iam_role.lambda_role.arn
  handler         = "index.handler"
  runtime         = "python3.9"
  timeout         = 10
  source_code_hash = data.archive_file.shorten_zip.output_base64sha256

  vpc_config {
    subnet_ids         = var.vpc_subnet_ids
    security_group_ids = var.security_group_ids
  }

  environment {
    variables = {
      DYNAMODB_TABLE = var.dynamodb_table_name
    }
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-shorten"
    Environment = var.environment
    Project     = var.project_name
  }
}

# Create ZIP file for redirect function
data "archive_file" "redirect_zip" {
  type        = "zip"
  source_dir  = "../src/redirect"
  output_path = "redirect.zip"
}

# Redirect Lambda function
resource "aws_lambda_function" "redirect" {
  filename         = data.archive_file.redirect_zip.output_path
  function_name    = "${var.project_name}-${var.environment}-redirect"
  role            = aws_iam_role.lambda_role.arn
  handler         = "index.handler"
  runtime         = "python3.9"
  timeout         = 10
  source_code_hash = data.archive_file.redirect_zip.output_base64sha256

  vpc_config {
    subnet_ids         = var.vpc_subnet_ids
    security_group_ids = var.security_group_ids
  }

  environment {
    variables = {
      DYNAMODB_TABLE = var.dynamodb_table_name
    }
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-redirect"
    Environment = var.environment
    Project     = var.project_name
  }
}