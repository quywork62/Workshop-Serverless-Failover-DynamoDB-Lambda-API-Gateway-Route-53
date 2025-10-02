---
title : "Tạo Lambda Functions ở cả hai Region"
date : "2025-01-27" 
weight : 4
chapter : false
pre : " <b> 4. </b> "
---

### Giới thiệu về  **Amazon Lambda**

**AWS Lambda** là dịch vụ serverless compute của AWS. Với Lambda, bạn có thể chạy code mà không cần quản lý máy chủ – chỉ cần viết code, upload, và AWS sẽ tự động lo việc cấp phát tài nguyên, mở rộng (scaling), và tính phí theo số lần gọi hàm (invocations).

Một số đặc điểm chính:

- Không cần quản lý hạ tầng → AWS vận hành toàn bộ phần backend.

- Tự động mở rộng → Lambda có thể xử lý từ vài request đến hàng nghìn request/giây.

- Tích hợp chặt chẽ với các dịch vụ AWS khác (DynamoDB, S3, API Gateway, v.v.).

Chức năng Lambda trong bước này

**Trong bài lab này**, Lambda đóng vai trò là lớp xử lý logic ứng dụng nằm giữa **API Gateway** và **DynamoDB**:

**ReadFunction**: đọc toàn bộ dữ liệu từ bảng DynamoDB và trả kết quả về dưới dạng JSON.

**WriteFunction**: nhận dữ liệu từ request (qua API Gateway), sau đó ghi (put item) vào DynamoDB.

Trong bước này, chúng ta sẽ tạo các Lambda Functions để xử lý logic backend cho ứng dụng ở cả hai Region (Primary và Secondary).

### Nội dung

1. [Mở AWS Lambda Console](#1-mở-aws-lambda-console)
2. [Tạo hàm Lambda đọc dữ liệu (ReadFunction)](#2-tạo-hàm-lambda-đọc-dữ-liệu-readfunction)
3. [Tạo hàm Lambda ghi dữ liệu (WriteFunction)](#3-tạo-hàm-lambda-ghi-dữ-liệu-writefunction)
4. [Triển khai hàm ở Region phụ (Secondary Region)](#4-triển-khai-hàm-ở-region-phụ-secondary-region)

#### 1. Mở AWS Lambda Console


- Đăng nhập vào **AWS Management Console**.

- Tìm và chọn dịch vụ **Lambda**.



![Route53](/images/4/1.png?featherlight=false&width=90pc)

#### 2. Tạo hàm Lambda đọc dữ liệu (ReadFunction)

- Chọn **Create function**.

- Nhập cấu hình:

- **Function name**: ```ReadFunction```

- Runtime: **Python 3.9**

- **Execution role**: Chọn **Use an existing role** và chọn **LambdaDynamoDBRole** (đã tạo ở bước trước).

![Route53](/images/4/2.png?featherlight=false&width=90pc)
![Route53](/images/4/3.png?featherlight=false&width=90pc)

**Execution role**: Chọn **Use an existing role** và chọn **LambdaDynamoDBRole** (đã tạo ở bước trước).

![Route53](/images/4/4.png?featherlight=false&width=90pc)

 Copy code sau và dán vào **lambda_function.py**.




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

![Route53](/images/4/5.png?featherlight=false&width=90pc)
 - Nhấn **Deploy** để lưu code.
![Route53](/images/4/6.png?featherlight=false&width=90pc)
#### Bạn đã tạo hàm Lambda đọc dữ liệu (ReadFunction) thành công! 
![Route53](/images/4/7.png?featherlight=false&width=90pc)






#### 3. Tạo hàm Lambda ghi dữ liệu (WriteFunction)

- Chọn **Create function** lần nữa.

- Nhập cấu hình:

- **Function name**: ```WriteFunction```

- **Runtime**: Python 3.9

- **Execution role**: chọn lại LambdaDynamoDBRole


![Route53](/images/4/8.png?featherlight=false&width=90pc)
**Execution role**: Chọn **Use an existing role** và chọn **LambdaDynamoDBRole** 
![Route53](/images/4/9.png?featherlight=false&width=90pc)

Copy code sau và dán vào **lambda_function.py**.
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
                    'message': f'Đã xóa thành công item "{item_id}"!',
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
                    'message': 'Dữ liệu đã được lưu thành công!',
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
                'message': 'Không thể lưu dữ liệu. Vui lòng thử lại sau.'
            }, ensure_ascii=False)
        }

```

![Route53](/images/4/10.png?featherlight=false&width=90pc)

- Nhấn **Deploy** để lưu code.
![Route53](/images/4/11.png?featherlight=false&width=90pc)

 Bạn đã tạo thành công 2 Lambda functions tên là **ReadFunction** và **WriteFunction** trong Region **Asia Pacific (Singapore)** với runtime là Python 3.9.
![Route53](/images/4/12.png?featherlight=false&width=90pc)

#### 4. Triển khai hàm ở Region phụ (Secondary Region)
- Triển khai hàm ở Region phụ (Secondary Region)

- Chuyển sang Region dự phòng (ví dụ: ```ap-northeast-1```).

- Lặp lại bước 2 và bước 3 để tạo cùng 2 hàm (**ReadFunction**và **WriteFunction**) tại Region này.

![Route53](/images/4/13.png?featherlight=false&width=90pc)

Bạn đã tạo thành công 2 **Lambda functions** tên là **ReadFunction** và **WriteFunction** trong Region **Asia Pacific (Tokyo)** với runtime là Python 3.9.
![Route53](/images/4/14.png?featherlight=false&width=90pc)


