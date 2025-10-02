---
title : "Nhân bản API Gateway sang Region phụ"
date : "2025-01-27" 
weight : 2
chapter : false
pre : " <b> 5.2 </b> "
---

### Nhân bản API Gateway sang Region phụ (Tokyo)

Trong bước này, chúng ta sẽ tạo API Gateway tương tự ở Region phụ (Tokyo ap-northeast-1) để đảm bảo tính sẵn sàng cao và khả năng failover.

### Tại sao cần nhân bản API Gateway?

- **High Availability**: Nếu Primary Region gặp sự cố, Secondary Region vẫn có thể phục vụ
- **Disaster Recovery**: Đảm bảo zero downtime khi failover xảy ra
- **Performance**: Người dùng ở khu vực châu Á có thể truy cập từ Region gần hơn
- **Load Distribution**: Phân tán tải giữa các Region

### Nội dung

1. [Chuyển sang Region phụ](#1-chuyển-sang-region-phụ)
2. [Tạo API Gateway tương tự ở bước 5.1](#2-tạo-api-gateway-tương-tự-ở-bước-51)
3. [Truy cập API Gateway Console](#3-truy-cập-api-gateway-console)
4. [Tạo REST API mới](#4-tạo-rest-api-mới)
5. [Cấu hình thông tin cơ bản](#5-cấu-hình-thông-tin-cơ-bản)
6. [Tạo Resource read](#6-tạo-resource--read-)
7. [Tạo Resource write](#7-tạo-resource--write-)
8. [Tạo GET Method (cho ReadFunction)](#8-tạo-get-method-cho-readfunction)
9. [Tạo POST Method (cho WriteFunction)](#9-tạo-post-method-cho-writefunction)
10. [Enable CORS cho Resource](#10-enable-cors-cho-resource)
11. [Deploy API](#11-deploy-api)
12. [Lưu lại Invoke URL](#12-lưu-lại-invoke-url)


#### 1. Chuyển sang Region phụ

- Trong AWS Console, chuyển Region từ **Singapore** sang **Tokyo (ap-northeast-1)**
- Truy cập dịch vụ **API Gateway**


![API Gateway](/images/5/25.png?featherlight=false&width=90pc)
#### 2. Tạo API Gateway tương tự ở bước 5.1


#### 3. Truy cập API Gateway Console

- Đăng nhập **AWS Management Console**
- Đảm bảo bạn đang ở Region **Tokyo (ap-northeast-1)**
- Tìm và chọn dịch vụ **API Gateway**



#### 4. Tạo REST API mới

- Chọn **Create API**
- Trong phần **REST API**, chọn **Build** (không phải Private REST API)


#### 5. Cấu hình thông tin cơ bản

- **Choose the protocol**: REST
- **Create new API**: New API
- **API name**: ```HighAvailabilityAPI```
- **Description**: ```Primary Region API for Serverless Failover```
- **Endpoint Type**: **Regional**
- Chọn **Create API**




#### 6. Tạo Resource  ``` read ```

- Trong API vừa tạo, chọn **Actions** → **Create Resource**
- **Resource Name**: ``` read ```
- **Resource Path**: ```/read ```
- **Enable API Gateway CORS**: ✅ (bật)
- Chọn **Create Resource**



#### 7. Tạo Resource ``` write ```

- Trong API vừa tạo, chọn **Actions** → **Create Resource**
- **Resource Name**: ``` write ```
- **Resource Path**: ```/write ```
- **Enable API Gateway CORS**: ✅ (bật)
- Chọn **Create Resource**


#### 8. Tạo GET Method (cho ReadFunction)

- Chọn resource ``` /read ``` vừa tạo
- Chọn **Actions** → **Create Method**
- Từ dropdown, chọn **GET** và click dấu ✅


**Cấu hình Integration:**
- **Integration type**: Lambda Function
- **Use Lambda Proxy integration**: ✅ (bật)
- **Lambda Region**: Tokyo (ap-northeast-1)
- **Lambda Function**: ```ReadFunction```
- Chọn **Save**



#### 9. Tạo POST Method (cho WriteFunction)

- Chọn resource ``` /write ``` vừa tạo
- Chọn **Actions** → **Create Method**
- Từ dropdown, chọn **POST** và click dấu ✅


**Cấu hình Integration:**
- **Integration type**: Lambda Function
- **Use Lambda Proxy integration**: ✅ (bật)
- **Lambda Region**: Tokyo (ap-northeast-1)
- **Lambda Function**: ```WriteFunction```
- Chọn **Save**









#### 10. Enable CORS cho Resource

- Chọn resource ```/```
- Chọn **Actions** → **Enable CORS**

**Cấu hình CORS:**
- **Access-Control-Allow-Origin**: ```*```
- **Access-Control-Allow-Headers**: 
  ```
  Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token
  ```


#### 11. Deploy API

- Chọn **Actions** → **Deploy API**
- **Deployment stage**: [New Stage]
- **Stage name**: ```prod```
- **Stage description**: ```Production stage for Primary Region```
- **Deployment description**: ```Initial deployment```
- Chọn **Deploy**


![API Gateway](/images/5/20.png?featherlight=false&width=90pc)
#### 12. Lưu lại Invoke URL

Sau khi deploy thành công, trong tab **Stages** → **prod**, bạn sẽ thấy **Invoke URL**:

```
https://xxxxxxxxxx.execute-api.ap-northeast-1.amazonaws.com/prod
```

![API Gateway](/images/5/24.png?featherlight=false&width=90pc)
**Lưu lại URL này** - chúng ta sẽ cần nó để:
- Test API functionality
- Cấu hình Route 53 health checks
- Tích hợp với frontend application


