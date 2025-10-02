---
title : "Tạo IAM Role cho Lambda Functions"
date : "2025-01-27" 
weight : 3
chapter : false
pre : " <b> 3. </b> "
---


Trong AWS, **IAM Role** giống như một “tập quyền” (permission set) được định nghĩa sẵn. Role không gắn cố định cho một người dùng cụ thể, mà được các dịch vụ AWS hoặc ứng dụng tạm thời “mượn” để có quyền thực hiện hành động.

**Ví dụ:**

**AWS Lambda** cần một Role để có quyền đọc/ghi dữ liệu vào **DynamoDB**.

EC2 Instance có thể gán một Role để truy cập S3 mà không cần lưu Access Key/Secret Key trong máy.

Điểm khác biệt so với IAM User:

User: gắn liền với một cá nhân hoặc ứng dụng, có username & password hoặc access key.

Role: không có thông tin đăng nhập riêng, chỉ cấp quyền tạm thời cho dịch vụ hoặc user/ứng dụng assume (nhận) nó.

👉 Trong bài lab này, bạn sẽ tạo một Role tên **LambdaDynamoDBRole** để cho phép Lambda Functions:

- Truy cập DynamoDB.

- Ghi log vào CloudWatch.

### Nội dung

1. [Mở IAM Console](#1-mở-iam-console)
2. [Tạo Role mới cho Lambda](#2-tạo-role-mới-cho-lambda)
3. [Gán quyền cho Role](#3-gán-quyền-cho-role)
4. [Đặt tên và tạo Role](#4-đặt-tên-và-tạo-role)
5. [Lưu lại ARN của Role](#5-lưu-lại-arn-của-role)


## Tạo IAM Role cho Lambda Functions 






#### 1. Mở IAM Console
- Đăng nhập **AWS Management Console**.

- Tìm và chọn dịch vụ **IAM**.

![Lambda](/images/3/1.png?featherlight=false&width=90pc)
#### 2. Tạo Role mới cho Lambda
- Chọn **Roles** → **Create role**.

- Ở mục **Trusted entity type**, chọn **AWS Service**.

- Chọn dịch vụ **Lambda**, sau đó bấm **Next**.
![Lambda](/images/3/2.png?featherlight=false&width=90pc)





![Lambda](/images/3/3.png?featherlight=false&width=90pc)
![Lambda](/images/3/4.png?featherlight=false&width=90pc)
![Lambda](/images/3/5.png?featherlight=false&width=90pc)

#### 3. Gán quyền cho Role
- Tìm và chọn 2 policy:

- ```AmazonDynamoDBFullAccess``` → cho phép Lambda thao tác với DynamoDB.

- ```AWSLambdaBasicExecutionRole``` → cho phép Lambda ghi log lên CloudWatch.
![Lambda](/images/3/6.png?featherlight=false&width=90pc)
![Lambda](/images/3/7.png?featherlight=false&width=90pc)
#### Nhấn **Next**
![Lambda](/images/3/8.png?featherlight=false&width=90pc)
#### 4. Đặt tên và tạo Role
- Nhập Role name: ```LambdaDynamoDBRole```.

- Nhấn **Create role** để hoàn tất.

![Lambda](/images/3/9.png?featherlight=false&width=90pc)
![Lambda](/images/3/10.png?featherlight=false&width=90pc)
#### Bạn đã tạo **Role** thành công 
![Lambda](/images/3/11.png?featherlight=false&width=90pc)

#### 5. Lưu lại ARN của Role
- Sau khi tạo, mở chi tiết Role.

- Copy **Role ARN** (sẽ cần khi gán cho Lambda function sau này).
![Lambda](/images/3/12.png?featherlight=false&width=90pc)



