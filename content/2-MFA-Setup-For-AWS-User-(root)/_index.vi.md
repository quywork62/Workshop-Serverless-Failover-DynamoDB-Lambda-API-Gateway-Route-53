---
title : "Tạo bảng DynamoDB ở Region chính"
date : "2025-01-27" 
weight : 2
chapter : false
pre : " <b> 2. </b> "
---

### Giới thiệu DynamoDB

Amazon DynamoDB là dịch vụ cơ sở dữ liệu NoSQL được quản lý hoàn toàn (fully managed NoSQL database), cung cấp khả năng lưu trữ dữ liệu dạng key-value và document với độ trễ chỉ vài mili-giây ở mọi quy mô. Ưu điểm lớn của DynamoDB là tự động mở rộng (auto scaling), không cần quản lý máy chủ, và tích hợp sẵn tính năng bảo mật, backup, caching.

Trong bài lab này, DynamoDB đóng vai trò là nền tảng lưu trữ chính của ứng dụng, đảm bảo dữ liệu được nhân bản tự động giữa nhiều Region thông qua Global Tables, giúp ứng dụng duy trì tính sẵn sàng và nhất quán ngay cả khi một Region gặp sự cố.

 #### **Nội dung**

1. [Tạo bảng DynamoDB ở Region chính](#step-1-tạo-bảng-dynamodb-ở-region-chính)
2. [Kích hoạt Global Tables và thêm Region phụ](1-virtual-mfa-device/)


###  Bước 1. Tạo bảng DynamoDB ở Region chính

#### 1. Đăng nhập AWS Management Console

#### 2. Vào dịch vụ [DynamoDB](https://ap-southeast-1.console.aws.amazon.com/dynamodbv2/home?region=ap-southeast-1#service)

![DynamoDB](/images/2/2.png?featherlight=false&width=90pc)

#### 3. Tạo bảng mới trong Region chính (ví dụ: ap-southeast-1)

Table name: ```HighAvailabilityTable```

Partition key: ```ItemId``` (String)

![DynamoDB](/images/2/1.png?featherlight=false&width=90pc)
![DynamoDB](/images/2/3.png?featherlight=false&width=90pc)

#### 4. Ta sẽ chọn "Default Settings" ở bảng Table Settings

![DynamoDB](/images/2/4.png?featherlight=false&width=90pc)

#### 5. Cuối cùng chọn "Create table"

![DynamoDB](/images/2/5.png?featherlight=false&width=90pc)

#### Đợi khoảng 2 - 3 phút để khởi tạo tài nguyên. Kiểm tra Status chuyển sang "Active" là thành công

![DynamoDB](/images/2/6.png?featherlight=false&width=90pc)
