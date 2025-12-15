# URL Shortener MVP

A serverless URL shortener service built with AWS Lambda, API Gateway, DynamoDB, and VPC using Terraform.

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                        Internet                             │
└─────────────────────┬───────────────────────────────────────┘
                      │
┌─────────────────────▼───────────────────────────────────────┐
│                 API Gateway                                 │
│              (HTTP API + CORS)                             │
└─────────────────────┬───────────────────────────────────────┘
                      │
┌─────────────────────▼───────────────────────────────────────┐
│                     VPC                                     │
│  ┌─────────────────┬─────────────────┐                     │
│  │   AZ-1          │      AZ-2       │                     │
│  │ ┌─────────────┐ │ ┌─────────────┐ │                     │
│  │ │Private      │ │ │Private      │ │                     │
│  │ │Subnet       │ │ │Subnet       │ │                     │
│  │ │10.0.1.0/24  │ │ │10.0.2.0/24  │ │                     │
│  │ │             │ │ │             │ │                     │
│  │ │ ┌─────────┐ │ │ │ ┌─────────┐ │ │                     │
│  │ │ │Lambda   │ │ │ │ │Lambda   │ │ │                     │
│  │ │ │Functions│ │ │ │ │Functions│ │ │                     │
│  │ │ └─────────┘ │ │ │ └─────────┘ │ │                     │
│  │ └─────────────┘ │ └─────────────┘ │                     │
│  └─────────────────┴─────────────────┘                     │
│           │                                                 │
│           │ Security Group                                  │
│           ▼                                                 │
└───────────────────────────────────────────────────────────┘
                      │
┌─────────────────────▼───────────────────────────────────────┐
│                  DynamoDB                                   │
│              (URL Mappings)                                 │
└─────────────────────────────────────────────────────────────┘
                      │
┌─────────────────────▼───────────────────────────────────────┐
│                CloudWatch Logs                             │
└─────────────────────────────────────────────────────────────┘
```

## Components

- **API Gateway**: HTTP API for REST endpoints with CORS
- **VPC**: Network isolation with multi-AZ deployment
- **Private Subnets**: Lambda functions in isolated subnets (2 AZs)
- **Security Groups**: Network access control for Lambda
- **Lambda Functions**: 
  - Shorten URL function
  - Redirect function
- **DynamoDB**: Key-value store for URL mappings
- **CloudWatch**: Logging and monitoring

## API Endpoints

- `POST /shorten` - Create short URL
- `GET /{shortCode}` - Redirect to original URL

## Project Structure

```
infrastructure/
├── main.tf              # Root configuration
├── variables.tf         # Input variables
├── outputs.tf          # Output values
└── modules/
    ├── network/        # VPC, subnets, security groups
    ├── api/            # API Gateway module
    ├── lambda/         # Lambda functions module
    └── dynamodb/       # DynamoDB table module
src/
├── shorten/            # Shorten URL Lambda
└── redirect/           # Redirect Lambda
deploy.sh               # Deployment script
.gitignore              # Git ignore rules
```

## Deployment

```bash
cd infrastructure
terraform init
terraform plan
terraform apply
```

## Cost Estimation

- API Gateway: ~$3.50 per million requests
- Lambda: ~$0.20 per million requests
- DynamoDB: ~$0.25 per million reads/writes
- VPC: No additional cost (subnets/security groups are free)
- **Total MVP cost: <$5/month for moderate usage**

## Security Features

- **Network Isolation**: Lambda functions run in private VPC subnets
- **Multi-AZ Deployment**: High availability across availability zones
- **Security Groups**: Controlled network access
- **IAM Least Privilege**: Minimal required permissions
- **CORS Configuration**: Secure cross-origin requests