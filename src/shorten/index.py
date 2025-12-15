import json
import os
import boto3
import string
import random
from datetime import datetime, timedelta

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table(os.environ['DYNAMODB_TABLE'])

def generate_short_code(length=6):
    """Generate a random short code"""
    chars = string.ascii_letters + string.digits
    return ''.join(random.choice(chars) for _ in range(length))

def handler(event, context):
    try:
        # Parse request body
        body = json.loads(event['body'])
        long_url = body.get('url')
        
        if not long_url:
            return {
                'statusCode': 400,
                'body': json.dumps({'error': 'URL is required'})
            }
        
        # Generate unique short code
        short_code = generate_short_code()
        
        # Store in DynamoDB
        expires_at = int((datetime.now() + timedelta(days=365)).timestamp())
        
        table.put_item(
            Item={
                'short_code': short_code,
                'long_url': long_url,
                'created_at': datetime.now().isoformat(),
                'expires_at': expires_at,
                'click_count': 0
            }
        )
        
        # Return short URL
        api_url = event['requestContext']['domainName']
        short_url = f"https://{api_url}/{short_code}"
        
        return {
            'statusCode': 200,
            'body': json.dumps({
                'short_url': short_url,
                'short_code': short_code
            })
        }
        
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }