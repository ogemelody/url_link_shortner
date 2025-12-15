# URL Shortener MVP - Main Terraform Configuration

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# VPC and networking
module "network" {
  source = "./modules/network"
  
  project_name = var.project_name
  environment  = var.environment
}

# DynamoDB table for URL mappings
module "dynamodb" {
  source = "./modules/dynamodb"
  
  project_name = var.project_name
  environment  = var.environment
}

# Lambda functions for URL operations
module "lambda" {
  source = "./modules/lambda"
  
  project_name = var.project_name
  environment  = var.environment
  dynamodb_table_name = module.dynamodb.table_name
  dynamodb_table_arn  = module.dynamodb.table_arn
  vpc_subnet_ids      = module.network.private_subnet_ids
  security_group_ids  = [module.network.lambda_security_group_id]
}

# API Gateway for HTTP endpoints
module "api" {
  source = "./modules/api"
  
  project_name = var.project_name
  environment  = var.environment
  shorten_lambda_arn    = module.lambda.shorten_lambda_arn
  redirect_lambda_arn   = module.lambda.redirect_lambda_arn
  shorten_lambda_name   = module.lambda.shorten_lambda_name
  redirect_lambda_name  = module.lambda.redirect_lambda_name
}