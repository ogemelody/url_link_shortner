#!/bin/bash

# URL Shortener MVP Deployment Script

echo "🚀 Deploying URL Shortener MVP..."

# Deploy with Terraform (ZIP files created automatically)
echo "🏗️ Deploying infrastructure with Terraform..."
cd infrastructure

terraform init
terraform plan
terraform apply -auto-approve

echo "✅ Deployment complete!"
echo "🌐 API Gateway URL: $(terraform output -raw api_gateway_url)"
echo " DynamoDB Table: $(terraform output -raw dynamodb_table_name)"