---
title : "Create Lambda Functions in Both Regions"
date : "2025-01-27"
weight : 4
chapter : false
pre : " <b> 4. </b> "
---

### Introduction to **Amazon Lambda**

**AWS Lambda** is AWS's serverless compute service. With Lambda, you can run code without managing servers – just write code, upload it, and AWS automatically handles resource provisioning, scaling, and billing based on function invocations.

Key characteristics:

- No infrastructure management → AWS operates the entire backend.
- Automatic scaling → Lambda can handle from a few requests to thousands of requests per second.
- Tight integration with other AWS services (DynamoDB, S3, API Gateway, etc.).

**Lambda Function Role in This Step**

**In this lab**, Lambda serves as the application logic layer between **API Gateway** and **DynamoDB**:

**ReadFunction**: reads all data from the DynamoDB table and returns results in JSON format.

**WriteFunction**: receives data from requests (via API Gateway), then writes (put item) to DynamoDB.

In this step, we will create Lambda Functions to handle backend logic for the application in both Regions (Primary and Secondary).

### Content

1. [Open AWS Lambda Console](#1-open-aws-lambda-console)
2. [Create Lambda Function for Reading Data (ReadFunction)](#2-create-lambda-function-for-reading-data-readfunction)
3. [Create Lambda Function for Writing Data (WriteFunction)](#3-create-lambda-function-for-writing-data-writefunction)
4. [Deploy Functions in Secondary Region](#4-deploy-functions-in-secondary-region)

#### 1. Open AWS Lambda Console

- Sign in to **AWS Management Console**.
- Find and select the **Lambda** service.

![Lambda](/images/4/1.png?featherlight=false&width=90pc)

#### 2. Create Lambda Function for Reading Data (ReadFunction)

- Choose **Create function**.
- Enter configuration:
  - **Function name**: ```ReadFunction```
  - **Runtime**: **Python 3.9**
  - **Execution role**: Choose **Use an existing role** and select **LambdaDynamoDBRole** (created in previous step).

![Lambda](/images/4/2.png?featherlight=false&width=90pc)
![Lambda](/images/4/3.png?featherlight=false&width=90pc)

**Execution role**: Choose **Use an existing role** and select **LambdaDynamoDBRole** (created in previous step).

![Lambda](/images/4/4.png?featherlight=false&width=90pc)

Copy the following code and paste it into **lambda_function.py**:

```python
import json
import boto3
from boto3.dynamodb.conditions import Key
from decimal import Decimal

# Initialize DynamoDB resource
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('HighAvailabilityTable')

# Helper function to convert Decimal to regular types for JSON serialization
def decimal_default(obj):
    if isinstance(obj, Decimal):
        return float(obj)
    raise TypeError

def lambda_handler(event, context):
    # Handle preflight OPTIONS request for CORS
    if event.get('httpMethod') == 'OPTIONS':
        return {
            'statusCode': 200,
            'headers': {
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
                'Access-Control-Allow-Headers': 'Content-Type, Authorization',
                'Access-Control-Max-Age': '86400'
            },
            'body': ''
        }
    
    try:
        # Scan the table to get all items
        response = table.scan()
        items = response['Items']
        
        # Handle pagination if there are more items
        while 'LastEvaluatedKey' in response:
            response = table.scan(ExclusiveStartKey=response['LastEvaluatedKey'])
            items.extend(response['Items'])
        
        # Sort items by ItemId for consistent ordering
        items.sort(key=lambda x: str(x.get('ItemId', '')))
        
        return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
                'Access-Control-Allow-Headers': 'Content-Type, Authorization',
                'Cache-Control': 'no-cache, no-store, must-revalidate',
                'Pragma': 'no-cache',
                'Expires': '0'
            },
            'body': json.dumps(items, default=decimal_default, ensure_ascii=False)
        }
        
    except Exception as e:
        print(f"Error reading data: {str(e)}")  # Log error for debugging
        return {
            'statusCode': 500,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
                'Access-Control-Allow-Headers': 'Content-Type, Authorization'
            },
            'body': json.dumps({
                'error': 'Internal server error',
                'message': 'Unable to read data from database'
            }, ensure_ascii=False)
        }

```

![Lambda](/images/4/5.png?featherlight=false&width=90pc)

- Click **Deploy** to save the code.

![Lambda](/images/4/6.png?featherlight=false&width=90pc)

#### You have successfully created the Lambda function for reading data (ReadFunction)!

![Lambda](/images/4/7.png?featherlight=false&width=90pc)

#### 3. Create Lambda Function for Writing Data (WriteFunction)

- Choose **Create function** again.
- Enter configuration:
  - **Function name**: ```WriteFunction```
  - **Runtime**: **Python 3.9**
  - **Execution role**: Choose **LambdaDynamoDBRole** again

![Lambda](/images/4/8.png?featherlight=false&width=90pc)

**Execution role**: Choose **Use an existing role** and select **LambdaDynamoDBRole**

![Lambda](/images/4/9.png?featherlight=false&width=90pc)

Copy the following code and paste it into **lambda_function.py**:

```python
import json
import boto3
from datetime import datetime
import uuid

# Initialize DynamoDB resource
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('HighAvailabilityTable')

def lambda_handler(event, context):
    # Handle preflight OPTIONS request for CORS
    if event.get('httpMethod') == 'OPTIONS':
        return {
            'statusCode': 200,
            'headers': {
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
                'Access-Control-Allow-Headers': 'Content-Type, Authorization',
                'Access-Control-Max-Age': '86400'
            },
            'body': ''
        }
    
    try:
        # Parse request body
        if not event.get('body'):
            raise ValueError('Request body is required')
            
        body = json.loads(event['body'])
        
        # Check if this is a DELETE action
        if body.get('Action') == 'DELETE':
            # Handle DELETE operation
            if 'ItemId' not in body:
                raise ValueError('ItemId is required for delete operation')
                
            item_id = str(body['ItemId']).strip()
            
            if not item_id:
                raise ValueError('ItemId cannot be empty')
            
            # Check if item exists before deleting
            try:
                response = table.get_item(Key={'ItemId': item_id})
                if 'Item' not in response:
                    raise ValueError(f'Item with ID "{item_id}" not found')
            except Exception as e:
                if 'not found' in str(e):
                    raise e
                else:
                    print(f"Error checking item existence: {str(e)}")
            
            # Delete from DynamoDB
            table.delete_item(Key={'ItemId': item_id})
            
            print(f"Successfully deleted item: {item_id}")  # Log for debugging
            
            return {
                'statusCode': 200,
                'headers': {
                    'Content-Type': 'application/json',
                    'Access-Control-Allow-Origin': '*',
                    'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
                    'Access-Control-Allow-Headers': 'Content-Type, Authorization'
                },
                'body': json.dumps({
                    'message': f'Successfully deleted item "{item_id}"!',
                    'itemId': item_id,
                    'action': 'DELETE',
                    'timestamp': datetime.utcnow().isoformat() + 'Z'
                }, ensure_ascii=False)
            }
        
        else:
            # Handle CREATE/UPDATE operation
            # Validate required fields
            if 'ItemId' not in body or 'Data' not in body:
                raise ValueError('ItemId and Data are required fields')
                
            item_id = str(body['ItemId']).strip()
            data = str(body['Data']).strip()
            
            # Validate input data
            if not item_id or not data:
                raise ValueError('ItemId and Data cannot be empty')
                
            if len(item_id) > 100:
                raise ValueError('ItemId cannot exceed 100 characters')
                
            if len(data) > 1000:
                raise ValueError('Data cannot exceed 1000 characters')
            
            # Add timestamp and unique identifier for better tracking
            timestamp = datetime.utcnow().isoformat() + 'Z'
            
            # Prepare item for DynamoDB
            item = {
                'ItemId': item_id,
                'Data': data,
                'CreatedAt': timestamp,
                'UpdatedAt': timestamp
            }
            
            # Save to DynamoDB
            table.put_item(Item=item)
            
            print(f"Successfully saved item: {item_id}")  # Log for debugging
            
            return {
                'statusCode': 200,
                'headers': {
                    'Content-Type': 'application/json',
                    'Access-Control-Allow-Origin': '*',
                    'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
                    'Access-Control-Allow-Headers': 'Content-Type, Authorization'
                },
                'body': json.dumps({
                    'message': 'Data has been saved successfully!',
                    'itemId': item_id,
                    'timestamp': timestamp
                }, ensure_ascii=False)
            }
        
    except json.JSONDecodeError:
        print("Error: Invalid JSON in request body")
        return {
            'statusCode': 400,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
                'Access-Control-Allow-Headers': 'Content-Type, Authorization'
            },
            'body': json.dumps({
                'error': 'Invalid JSON format',
                'message': 'Request body must be valid JSON'
            }, ensure_ascii=False)
        }
        
    except ValueError as ve:
        print(f"Validation error: {str(ve)}")
        return {
            'statusCode': 400,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
                'Access-Control-Allow-Headers': 'Content-Type, Authorization'
            },
            'body': json.dumps({
                'error': 'Validation error',
                'message': str(ve)
            }, ensure_ascii=False)
        }
        
    except Exception as e:
        print(f"Unexpected error: {str(e)}")  # Log error for debugging
        return {
            'statusCode': 500,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
                'Access-Control-Allow-Headers': 'Content-Type, Authorization'
            },
            'body': json.dumps({
                'error': 'Internal server error',
                'message': 'Unable to save data. Please try again later.'
            }, ensure_ascii=False)
        }

```

![Lambda](/images/4/10.png?featherlight=false&width=90pc)

- Click **Deploy** to save the code.

![Lambda](/images/4/11.png?featherlight=false&width=90pc)

You have successfully created 2 Lambda functions named **ReadFunction** and **WriteFunction** in the **Asia Pacific (Singapore)** region with Python 3.9 runtime.

![Lambda](/images/4/12.png?featherlight=false&width=90pc)

#### 4. Deploy Functions in Secondary Region

- Deploy functions in Secondary Region
- Switch to the backup region (e.g., ```ap-northeast-1```).
- Repeat steps 2 and 3 to create the same 2 functions (**ReadFunction** and **WriteFunction**) in this region.

![Lambda](/images/4/13.png?featherlight=false&width=90pc)

You have successfully created 2 **Lambda functions** named **ReadFunction** and **WriteFunction** in the **Asia Pacific (Tokyo)** region with Python 3.9 runtime.

![Lambda](/images/4/14.png?featherlight=false&width=90pc)