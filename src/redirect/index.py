import json
import os
import boto3
from boto3.dynamodb.conditions import Key

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table(os.environ['DYNAMODB_TABLE'])

def handler(event, context):
    try:
        # Extract short code from path
        short_code = event['pathParameters']['shortCode']
        
        # Get URL from DynamoDB
        response = table.get_item(
            Key={'short_code': short_code}
        )
        
        if 'Item' not in response:
            return {
                'statusCode': 404,
                'body': json.dumps({'error': 'Short URL not found'})
            }
        
        item = response['Item']
        long_url = item['long_url']
        
        # Update click count
        table.update_item(
            Key={'short_code': short_code},
            UpdateExpression='ADD click_count :inc',
            ExpressionAttributeValues={':inc': 1}
        )
        
        # Return redirect
        return {
            'statusCode': 301,
            'headers': {
                'Location': long_url
            }
        }
        
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }