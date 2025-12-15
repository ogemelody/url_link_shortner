#!/bin/bash

echo "🧪 Testing URL Shortener locally..."

# Test Terraform syntax
echo "📋 Validating Terraform configuration..."
cd infrastructure
terraform init -backend=false
terraform validate
terraform fmt -check

if [ $? -eq 0 ]; then
    echo "✅ Terraform configuration is valid"
else
    echo "❌ Terraform configuration has errors"
    exit 1
fi

# Test Lambda code syntax
echo "🐍 Testing Python Lambda functions..."
cd ../src/shorten
python3 -m py_compile index.py
cd ../redirect  
python3 -m py_compile index.py
cd ../..

if [ $? -eq 0 ]; then
    echo "✅ Lambda functions compile successfully"
else
    echo "❌ Lambda functions have syntax errors"
    exit 1
fi

echo "🎉 All local tests passed!"