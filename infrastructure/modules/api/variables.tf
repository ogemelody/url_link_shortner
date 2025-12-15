variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
}

variable "shorten_lambda_arn" {
  description = "ARN of the shorten Lambda function"
  type        = string
}

variable "redirect_lambda_arn" {
  description = "ARN of the redirect Lambda function"
  type        = string
}

variable "shorten_lambda_name" {
  description = "Name of the shorten Lambda function"
  type        = string
}

variable "redirect_lambda_name" {
  description = "Name of the redirect Lambda function"
  type        = string
}