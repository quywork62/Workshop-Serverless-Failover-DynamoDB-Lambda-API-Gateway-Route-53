---
title : "Tạo Custom domain cho API Gateway (mỗi region một cái)"
date : "2025-01-27" 
weight : 3
chapter : false
pre : " <b> 6.3 </b> "
---

### Tạo Custom domain cho API Gateway (mỗi region một cái)

Sau khi có SSL certificates ở cả hai Region, chúng ta sẽ tạo Custom Domain Names cho API Gateway để sử dụng domain riêng thay vì URL AWS mặc định.

### Tại sao cần Custom Domain?

- **Professional URL**: Sử dụng `api.turtleclouds.id.vn` thay vì URL AWS dài
- **SSL/TLS**: Kích hoạt HTTPS với certificate riêng
- **Branding**: Thống nhất với brand và domain chính
- **Failover Ready**: Chuẩn bị cho Route 53 failover configuration

### Nội dung

1. [Tạo Custom Domain cho Singapore Region](#1-tạo-custom-domain-cho-singapore-region)
2. [Cấu hình API Mapping cho Singapore](#2-cấu-hình-api-mapping-cho-singapore)
3. [Lưu Regional Domain Name Singapore](#3-lưu-regional-domain-name-singapore)
4. [Tạo Custom Domain cho Tokyo Region](#4-tạo-custom-domain-cho-tokyo-region)
5. [Cấu hình API Mapping cho Tokyo](#5-cấu-hình-api-mapping-cho-tokyo)
6. [Lưu Regional Domain Name Tokyo](#6-lưu-regional-domain-name-tokyo)

#### 1. Tạo Custom Domain cho Singapore Region

- Đảm bảo bạn đang ở Region **Singapore (ap-southeast-1)**
- Truy cập **API Gateway** → **Custom domain names**
- Chọn **Add domain names**

![API Gateway](/images/6.3/1.png?featherlight=false&width=90pc)

**Cấu hình Custom Domain:**
- **Domain name**: ```api.turtleclouds.id.vn```
- **Endpoint type**: **Regional**
- **ACM certificate**: Chọn certificate **Issued** của Singapore Region
- **Security policy**: **TLS 1.2**
- Chọn **Add domain name**

![API Gateway](/images/6.3/2.png?featherlight=false&width=90pc)
![API Gateway](/images/6.3/3.png?featherlight=false&width=90pc)
![API Gateway](/images/6.3/4.png?featherlight=false&width=90pc)
![API Gateway](/images/6.3/5.png?featherlight=false&width=90pc)
#### 2. Cấu hình API Mapping cho Singapore

Sau khi tạo custom domain, cần map với API Gateway:

- Trong custom domain vừa tạo, chọn tab **API mappings**
- Chọn **Configure API mappings**


![API Gateway](/images/6.3/6.png?featherlight=false&width=90pc)
**Thêm API Mapping:**
- Chọn **Add new mapping**
- **API**: Chọn ```HighAvailabilityAPI```
- **Stage**: ```prod```
- **Path**: để trống (root path)
- Chọn **Save**
![API Gateway](/images/6.3/7.png?featherlight=false&width=90pc)

![API Gateway](/images/6.3/9.png?featherlight=false&width=90pc)
![API Gateway](/images/6.3/10.png?featherlight=false&width=90pc)
#### 3. Lưu Regional Domain Name Singapore

Sau khi tạo custom domain, API Gateway sẽ sinh ra một **Regional domain name**. Lưu lại thông tin này:

**Ví dụ Regional Domain Name:**
```
d-a7cx5xv22d.execute-api.ap-southeast-1.amazonaws.com
```
![API Gateway](/images/6.3/10.1.png?featherlight=false&width=90pc)


{{%notice info%}}
**Quan trọng**: Regional domain name này sẽ được sử dụng trong Route 53 để tạo ALIAS records cho failover.
{{%/notice%}}

#### 4. Tạo Custom Domain cho Tokyo Region

- Chuyển sang Region **Tokyo (ap-northeast-1)**
- Truy cập **API Gateway** → **Custom domain names**
- Chọn **Add domain names**



**Cấu hình Custom Domain:**
- **Domain name**: ```api.turtleclouds.id.vn```
- **Endpoint type**: **Regional**
- **ACM certificate**: Chọn certificate **Issued** của Tokyo Region
- **Security policy**: **TLS 1.2**
- Chọn **Add domain name**



#### 5. Cấu hình API Mapping cho Tokyo

- Trong custom domain Tokyo, chọn tab **API mappings**
- Chọn **Configure API mappings**

**Thêm API Mapping:**
- Chọn **Add new mapping**
- **API**: Chọn ```HighAvailabilityAPI```
- **Stage**: ```prod```
- **Path**: để trống (root path)
- Chọn **Save**

![API Gateway](/images/6.3/11.png?featherlight=false&width=90pc)

#### 6. Lưu Regional Domain Name Tokyo

Lưu lại **Regional domain name** của Tokyo:

**Ví dụ Regional Domain Name Tokyo:**
```
d-b8dy6yw33e.execute-api.ap-northeast-1.amazonaws.com
```

![API Gateway](/images/6.3/11.1.png?featherlight=false&width=90pc)



### Kết quả

Sau khi hoàn thành bước này:

- ✅ **Custom Domain** đã được tạo cho Singapore Region
- ✅ **Custom Domain** đã được tạo cho Tokyo Region
- ✅ **API Mappings** đã được cấu hình cho cả hai Region
- ✅ **Regional Domain Names** đã được lưu lại để sử dụng trong Route 53

### Thông tin cần lưu

| Region | Custom Domain | Regional Domain Name | Certificate |
|--------|---------------|---------------------|-------------|
| **Singapore** | api.turtleclouds.id.vn | d-pbm3eqaneb.execute-api.ap-southeast-1.amazonaws.com | ACM Singapore |
| **Tokyo** | api.turtleclouds.id.vn | d-15ro7mhib1.execute-api.ap-northeast-1.amazonaws.com | ACM Tokyo |

### Chuẩn bị cho bước tiếp theo

Với Custom Domains đã sẵn sàng, chúng ta có thể tạo Route 53 Health Checks và Failover Records trong bước cuối cùng.