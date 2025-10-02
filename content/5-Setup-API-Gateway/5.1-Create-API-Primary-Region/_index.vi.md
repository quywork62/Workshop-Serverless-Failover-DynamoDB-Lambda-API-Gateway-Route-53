---
title : "Tạo API Gateway ở Region chính"
date : "2025-01-27" 
weight : 1
chapter : false
pre : " <b> 5.1 </b> "
---

### Tạo API Gateway ở Region chính (Singapore)

Trong bước này, chúng ta sẽ tạo API Gateway ở Region chính (Singapore ap-southeast-1) để cung cấp REST API endpoints cho ứng dụng frontend.

### Nội dung

1. [Truy cập API Gateway Console](#1-truy-cập-api-gateway-console)
2. [Tạo REST API mới](#2-tạo-rest-api-mới)
3. [Cấu hình thông tin cơ bản](#3-cấu-hình-thông-tin-cơ-bản)
4. [Tạo Resource](#4-tạo-resource)
5. [Tạo GET Method (cho ReadFunction)](#5-tạo-get-method-cho-readfunction)
6. [Tạo POST Method (cho WriteFunction)](#7-tạo-post-method-cho-writefunction)
7. [Enable CORS cho Resource](#8-enable-cors-cho-resource)
8. [Deploy API](#9-deploy-api)
9. [Lưu lại Invoke URL](#10-lưu-lại-invoke-url)
10. [Test API Endpoints](#11-test-api-endpoints)

#### 1. Truy cập API Gateway Console

- Đăng nhập **AWS Management Console**
- Đảm bảo bạn đang ở Region **Singapore (ap-southeast-1)**
- Tìm và chọn dịch vụ **API Gateway**

![API Gateway](/images/5/1.png?featherlight=false&width=90pc)

#### 2. Tạo REST API mới

- Chọn **Create API**
- Trong phần **REST API**, chọn **Build** (không phải Private REST API)

![API Gateway](/images/5/2.png?featherlight=false&width=90pc)
![API Gateway](/images/5/3.png?featherlight=false&width=90pc)

#### 3. Cấu hình thông tin cơ bản

- **Choose the protocol**: REST
- **Create new API**: New API
- **API name**: ```HighAvailabilityAPI```
- **Description**: ```Primary Region API for Serverless Failover```
- **Endpoint Type**: **Regional**
- Chọn **Create API**

![API Gateway](/images/5/4.png?featherlight=false&width=90pc)


#### 4. Tạo Resource ```read```

- Trong API vừa tạo, chọn **Actions** → **Create Resource**
- **Resource Name**: ``` read ```
- **Resource Path**: ```/read ```
- **Enable API Gateway CORS**: ✅ (bật)
- Chọn **Create Resource**

![API Gateway](/images/5/5.png?featherlight=false&width=90pc)
![API Gateway](/images/5/6.png?featherlight=false&width=90pc)

#### 5. Tạo Resource ```write```

- Trong API vừa tạo, chọn **Actions** → **Create Resource**
- **Resource Name**: ``` write ```
- **Resource Path**: ```/write ```
- **Enable API Gateway CORS**: ✅ (bật)
- Chọn **Create Resource**
![API Gateway](/images/5/7.png?featherlight=false&width=90pc)
![API Gateway](/images/5/8.png?featherlight=false&width=90pc)

#### 6. Tạo GET Method (cho ReadFunction)

- Chọn resource ``` /read ``` vừa tạo
- Chọn **Actions** → **Create Method**
- Từ dropdown, chọn **GET** và click dấu ✅
![API Gateway](/images/5/9.png?featherlight=false&width=90pc)

**Cấu hình Integration:**
- **Integration type**: Lambda Function
- **Use Lambda Proxy integration**: ✅ (bật)
- **Lambda Region**: ap-southeast-1
- **Lambda Function**: ```ReadFunction```
- Chọn **Save**


![API Gateway](/images/5/10.png?featherlight=false&width=90pc)

![API Gateway](/images/5/11.png?featherlight=false&width=90pc)
![API Gateway](/images/5/12.png?featherlight=false&width=90pc)
#### 7. Tạo POST Method (cho WriteFunction)

- Chọn resource ``` /write ``` vừa tạo
- Chọn **Actions** → **Create Method**
- Từ dropdown, chọn **POST** và click dấu ✅

![API Gateway](/images/5/13.png?featherlight=false&width=90pc)
**Cấu hình Integration:**
- **Integration type**: Lambda Function
- **Use Lambda Proxy integration**: ✅ (bật)
- **Lambda Region**: ap-southeast-1
- **Lambda Function**: ```WriteFunction```
- Chọn **Save**


![API Gateway](/images/5/14.png?featherlight=false&width=90pc)
![API Gateway](/images/5/15.png?featherlight=false&width=90pc)







#### 8. Enable CORS cho Resource

- Chọn resource ```/```
- Chọn **Actions** → **Enable CORS**
![API Gateway](/images/5/21.png?featherlight=false&width=90pc)
**Cấu hình CORS:**
- **Access-Control-Allow-Origin**: ```*```
- **Access-Control-Allow-Headers**: 
  ```
  Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token
  ```



![API Gateway](/images/5/22.png?featherlight=false&width=90pc)
![API Gateway](/images/5/23.png?featherlight=false&width=90pc)

#### 9. Deploy API

- Chọn **Actions** → **Deploy API**
- **Deployment stage**: [New Stage]
- **Stage name**: ```prod```
- **Stage description**: ```Production stage for Primary Region```
- **Deployment description**: ```Initial deployment```
- Chọn **Deploy**

![API Gateway](/images/5/16.png?featherlight=false&width=90pc)
![API Gateway](/images/5/17.png?featherlight=false&width=90pc)
![API Gateway](/images/5/18.png?featherlight=false&width=90pc)
#### 10. Lưu lại Invoke URL

Sau khi deploy thành công, trong tab **Stages** → **prod**, bạn sẽ thấy **Invoke URL**:

```
https://xxxxxxxxxx.execute-api.ap-southeast-1.amazonaws.com/prod
```

![API Gateway](/images/5/19.png?featherlight=false&width=90pc)
**Lưu lại URL này** - chúng ta sẽ cần nó để:
- Test API functionality
- Cấu hình Route 53 health checks
- Tích hợp với frontend application

