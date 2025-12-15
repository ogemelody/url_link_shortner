#!/bin/bash

# URL Shortener MVP Deployment Script

echo "🚀 Deploying URL Shortener MVP..."

# Create Lambda deployment packages
echo "📦 Creating Lambda deployment packages..."

cd src/shorten
zip -r ../../infrastructure/shorten.zip .
cd ../redirect
zip -r ../../infrastructure/redirect.zip .
cd ../..

# Deploy with Terraform
echo "🏗️ Deploying infrastructure with Terraform..."
cd infrastructure

terraform init
terraform plan
terraform apply -auto-approve

echo "✅ Deployment complete!"
echo "🌐 API Gateway URL: $(terraform output -raw api_gateway_url)"
echo "📊 DynamoDB Table: $(terraform output -raw dynamodb_table_name)"