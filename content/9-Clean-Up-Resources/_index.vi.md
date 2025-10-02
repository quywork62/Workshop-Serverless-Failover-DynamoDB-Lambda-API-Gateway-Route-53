---
title : "Xóa tài nguyên (Clean Up)"
date : "2025-01-27" 
weight : 9
chapter : false
pre : " <b> 9. </b> "
---

### Bước 9: Xóa tài nguyên (Clean Up)

Sau khi đã test thành công cơ chế HA/DR & Failover, bạn cần xóa các tài nguyên AWS đã tạo để tránh phát sinh chi phí.

{{%notice warning%}}
**⚠️ Cảnh báo**: Việc xóa tài nguyên là không thể hoàn nguyên. Hãy chắc chắn bạn đã backup/export mọi thứ cần thiết trước khi thực hiện.
{{%/notice%}}

### Tại sao cần Clean Up?

- **Cost Optimization**: Tránh phát sinh chi phí không cần thiết
- **Resource Management**: Giữ tài khoản AWS gọn gàng
- **Security**: Loại bỏ các endpoint và resource không sử dụng
- **Best Practice**: Thói quen tốt trong quản lý cloud resources

### Nội dung

1. [Xóa API Gateway (Secondary – Tokyo)](#1-xóa-api-gateway-secondary-tokyo)
2. [Xóa DynamoDB Global Tables](#2-xóa-dynamodb-global-tables)
3. [Xóa Lambda Functions](#3-xóa-lambda-functions)
4. [Xóa Route 53 Health Checks & DNS Records](#4-xóa-route-53-health-checks-dns-records)
5. [Xóa ACM Certificates](#5-xóa-acm-certificates)
6. [Xóa S3 Bucket (Frontend Website)](#6-xóa-s3-bucket-frontend-website)
7. [Xóa IAM Roles](#7-xóa-iam-roles)

#### 1. Xóa API Gateway (Secondary – Tokyo)

**Bước 1: Xóa Custom Domain Mapping (nếu có)**

- Vào **API Gateway** tại region **Tokyo (ap-northeast-1)**
- Chọn **Custom domain names** → chọn **api.turtleclouds.id.vn**
- Tab **API mappings** → **Delete API mapping**



**Bước 2: Xóa API Gateway**

- Quay lại **APIs** → chọn **HighAvailabilityAPI**
- Chọn **Actions** → **Delete**
- Gõ ```delete``` để xác nhận



**Bước 3: Xóa Custom Domain**

- Vào **Custom domain names** → chọn **api.turtleclouds.id.vn**
- Chọn **Actions** → **Delete domain name**
- Gõ tên domain để xác nhận



**CLI (tùy chọn):**
```bash
# Lấy danh sách API
aws apigateway get-rest-apis --region ap-northeast-1

# Xóa API mapping trước
aws apigateway delete-base-path-mapping \
  --domain-name api.turtleclouds.id.vn \
  --base-path "" \
  --region ap-northeast-1

# Xóa API
aws apigateway delete-rest-api --rest-api-id <API_ID> --region ap-northeast-1

# Xóa custom domain
aws apigateway delete-domain-name \
  --domain-name api.turtleclouds.id.vn \
  --region ap-northeast-1
```

{{%notice info%}}
**Lưu ý**: API Gateway ở Singapore đã bị xóa trong bước test failover trước đó.
{{%/notice%}}

#### 2. Xóa DynamoDB Global Tables

**Bước 1: Xóa Global Table Replicas**

- Vào **DynamoDB** ở region **Tokyo (ap-northeast-1)**
- Chọn bảng **HighAvailabilityTable**
- Tab **Global Tables** → **Delete replica**



**Bước 2: Xóa Primary Table**

- Chuyển về region **Singapore (ap-southeast-1)**
- Chọn bảng **HighAvailabilityTable**
- **Actions** → **Delete table**
- Gõ ```delete``` để xác nhận



**CLI (tùy chọn):**
```bash
# Xóa replica ở Tokyo
aws dynamodb delete-table --table-name HighAvailabilityTable --region ap-northeast-1

# Xóa primary table ở Singapore
aws dynamodb delete-table --table-name HighAvailabilityTable --region ap-southeast-1
```

#### 3. Xóa Lambda Functions

**Xóa Lambda Functions ở Tokyo:**

- Vào **Lambda** ở region **Tokyo (ap-northeast-1)**
- Xóa các functions:
  - **ReadFunction**
  - **WriteFunction**
  - **DeleteFunction**



**Xóa Lambda Functions ở Singapore:**

- Vào **Lambda** ở region **Singapore (ap-southeast-1)**
- Xóa các functions tương tự (nếu còn)

**CLI (tùy chọn):**
```bash
# Tokyo
aws lambda delete-function --function-name ReadFunction --region ap-northeast-1
aws lambda delete-function --function-name WriteFunction --region ap-northeast-1
aws lambda delete-function --function-name DeleteFunction --region ap-northeast-1

# Singapore
aws lambda delete-function --function-name ReadFunction --region ap-southeast-1
aws lambda delete-function --function-name WriteFunction --region ap-southeast-1
aws lambda delete-function --function-name DeleteFunction --region ap-southeast-1
```

#### 4. Xóa Route 53 Health Checks & DNS Records

**Bước 1: Xóa Health Checks**

- Vào **Route 53 Console** → **Health checks**
- Xóa health checks:
  - **Primary Singapore**
  - **Secondary Tokyo**


**Bước 2: Xóa DNS Records**

- Vào **Hosted zones** → **api.turtleclouds.id.vn**
- Xóa các bản ghi failover:
  - Primary failover record
  - Secondary failover record
  - ACM validation CNAME records



**Bước 3: Xóa Hosted Zone (tùy chọn)**

- Nếu không cần nữa, có thể xóa luôn hosted zone **api.turtleclouds.id.vn**
- **Actions** → **Delete hosted zone**



{{%notice warning%}}
**Cảnh báo**: Chỉ xóa hosted zone nếu bạn chắc chắn không sử dụng subdomain api.* nữa.
{{%/notice%}}

#### 5. Xóa ACM Certificates

**Xóa Certificate ở Singapore:**

- Vào **AWS Certificate Manager (ACM)** ở region **Singapore (ap-southeast-1)**
- Chọn certificate **api.turtleclouds.id.vn**
- **Actions** → **Delete**



**Xóa Certificate ở Tokyo:**

- Vào **ACM** ở region **Tokyo (ap-northeast-1)**
- Xóa certificate tương tự

{{%notice info%}}
**Lưu ý**: Certificates chỉ có thể xóa khi không còn được sử dụng bởi bất kỳ resource nào.
{{%/notice%}}

#### 6. Xóa S3 Bucket (Frontend Website)

**Bước 1: Empty Bucket**

- Vào **S3 Console** → bucket **api.turtleclouds.id.vn**
- Chọn **Empty bucket**
- Gõ ```permanently delete``` để xác nhận



**Bước 2: Delete Bucket**

- Sau khi empty, chọn **Delete bucket**
- Gõ tên bucket để xác nhận





**CLI (tùy chọn):**
```bash
# Empty bucket
aws s3 rm s3://api.turtleclouds.id.vn --recursive

# Delete bucket
aws s3 rb s3://api.turtleclouds.id.vn
```

#### 7. Xóa IAM Roles

- Vào **IAM Console** → **Roles**
- Xóa các roles đã tạo cho Lambda:
  - **HighAvailabilityLambdaRole**
  - Các roles khác liên quan đến project





**CLI (tùy chọn):**
```bash
# Detach policies trước
aws iam detach-role-policy --role-name HighAvailabilityLambdaRole --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole

# Xóa role
aws iam delete-role --role-name HighAvailabilityLambdaRole
```

### Checklist Clean Up

Sau khi hoàn thành, hãy kiểm tra:

- ✅ **API Gateway** (cả Singapore và Tokyo) đã bị xóa
- ✅ **DynamoDB Global Tables** đã bị xóa hoàn toàn
- ✅ **Lambda Functions** ở cả hai regions đã bị xóa
- ✅ **Route 53 Health Checks** đã bị xóa
- ✅ **Route 53 DNS Records** đã bị xóa
- ✅ **ACM Certificates** ở cả hai regions đã bị xóa
- ✅ **S3 Bucket** và contents đã bị xóa
- ✅ **IAM Roles** không cần thiết đã bị xóa



### Kết luận

Bạn đã thành công xóa toàn bộ tài nguyên AWS được tạo trong lab này. Điều này giúp:

- **Tránh chi phí không cần thiết**
- **Giữ tài khoản AWS sạch sẽ**
- **Áp dụng best practices** trong quản lý cloud resources
- **Hoàn thành chu trình** development và testing

{{%notice success%}}
**Hoàn thành!** Bạn đã successfully clean up tất cả resources và hoàn thành lab Serverless Failover Architecture.
{{%/notice%}}