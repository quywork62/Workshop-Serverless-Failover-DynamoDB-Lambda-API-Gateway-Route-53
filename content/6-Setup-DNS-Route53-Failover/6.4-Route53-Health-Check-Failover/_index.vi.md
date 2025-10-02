---
title : "Route 53 Health check + Failover record (trong zone api.turtleclouds.id.vn)"
date : "2025-01-27" 
weight : 4
chapter : false
pre : " <b> 6.4 </b> "
---

### Route 53 Health check + Failover record

Bước cuối cùng là tạo Health Checks để giám sát tình trạng API endpoints và cấu hình Failover Records để tự động chuyển hướng traffic khi Primary Region gặp sự cố.

### Tại sao cần Health Check và Failover?

- **Automatic Monitoring**: Route 53 liên tục kiểm tra tình trạng API endpoints
- **Instant Failover**: Tự động chuyển sang Secondary Region khi Primary fail
- **Zero Manual Intervention**: Không cần can thiệp thủ công
- **High Availability**: Đảm bảo 99.9% uptime cho API service

### Nội dung

1. [Tạo Health Check cho Primary Region](#1-tạo-health-check-cho-primary-region)
2. [Tạo Health Check cho Secondary Region](#2-tạo-health-check-cho-secondary-region)
3. [Tạo Failover Record cho Primary](#3-tạo-failover-record-cho-primary)
4. [Tạo Failover Record cho Secondary](#4-tạo-failover-record-cho-secondary)
5. [Test Failover Scenario](#5-test-failover-scenario)

#### 1. Tạo Health Check cho Primary Region

- Truy cập **Route 53** → **Health checks**
- Chọn **Create health check**

![Route 53](/images/6.4/1.png?featherlight=false&width=90pc)
![Route 53](/images/6.4/2.png?featherlight=false&width=90pc)

**Cấu hình Health Check Primary:**
- **Name**: ```Primary Singapore```
- **What to monitor**: **Endpoint**
- **Specify endpoint by**: **Domain name**
- **Protocol**: **HTTPS**
- **Domain name**: ```dynw0bc977.execute-api.ap-southeast-1.amazonaws.com/prod/read``` (API ID của Singapore)
- **Request interval**: **Fast (10 seconds)**
- **Failure threshold**: **3**
![Route 53](/images/6.4/3.png?featherlight=false&width=90pc)

![Route 53](/images/6.4/4.png?featherlight=false&width=90pc)
**Advanced configuration:**
- **Enable SNI**: **Yes**
- **Enable health checker regions**: **3 region tại Asia Pacific**:

Asia Pacific (Tokyo) ✅

Asia Pacific (Singapore) ✅

Asia Pacific (Sydney) ✅

![Route 53](/images/6.4/5.png?featherlight=false&width=90pc)

![Route 53](/images/6.4/6.png?featherlight=false&width=90pc)

![Route 53](/images/6.4/7.png?featherlight=false&width=90pc)

{{%notice warning%}}
**Quan trọng**: KHÔNG dùng Regional domain của custom domain (d-a7cx5xv22d.execute-api...) cho Health Check vì có thể gây lỗi 403/401. Sử dụng invoke URL theo API ID thay thế.
{{%/notice%}}

#### 2. Tạo Health Check cho Secondary Region

- Chọn **Create health check** một lần nữa

**Cấu hình Health Check Secondary:**
- **Name**: ```Secondary Tokyo```
- **What to monitor**: **Endpoint**
- **Specify endpoint by**: **Domain name**
- **Protocol**: **HTTPS**
- **Domain name**: ```qp3nkjwlde.execute-api.ap-northeast-1.amazonaws.com/prod/read``` (API ID của Tokyo)

**Request interval**: **Fast (10 seconds)**
- **Failure threshold**: **3**

**Advanced configuration:**
- **Enable SNI**: **Yes**
- **Enable health checker regions**: **3 region tại Asia Pacific**:

Asia Pacific (Tokyo) ✅

Asia Pacific (Singapore) ✅

Asia Pacific (Sydney) ✅

![Route 53](/images/6.4/8.png?featherlight=false&width=90pc)

#### 3. Tạo Failover Record cho Primary

- Truy cập **Route 53** → **Hosted zones**
- Chọn zone **api.turtleclouds.id.vn**
- Chọn **Create record**
![Route 53](/images/6.4/9.png?featherlight=false&width=90pc)
![Route 53](/images/6.4/10.png?featherlight=false&width=90pc)
![Route 53](/images/6.4/11.png?featherlight=false&width=90pc)

**Cấu hình Primary Failover Record:**
- **Record name**: để trống (root của api.turtleclouds.id.vn)
- **Record type**: **A**
- **Alias**: **Yes**
- **Route traffic to**: **Alias to API Gateway API**
- **Choose Region**: **Asia Pacific (Singapore)**
- **Choose API Gateway**: Chọn API Gateway Singapore từ dropdown
- **Routing policy**: **Failover**
- **Failover record type**: **Primary**
- **Health check**: Chọn ```Primary Singapore```
- **Record ID**: ```primary-ap-southeast-1```



![Route 53](/images/6.4/12.png?featherlight=false&width=90pc)
![Route 53](/images/6.4/13.png?featherlight=false&width=90pc)
![Route 53](/images/6.4/14.png?featherlight=false&width=90pc)

#### 4. Tạo Failover Record cho Secondary

- Chọn **Create record** một lần nữa

**Cấu hình Secondary Failover Record:**
- **Record name**: để trống (root của api.turtleclouds.id.vn)
- **Record type**: **A**
- **Alias**: **Yes**
- **Route traffic to**: **Alias to API Gateway API**
- **Choose Region**: **Asia Pacific (Tokyo)**
- **Choose API Gateway**: Chọn API Gateway Tokyo từ dropdown
- **Routing policy**: **Failover**
- **Failover record type**: **Secondary**
- **Health check**: Chọn ```Secondary Tokyo```
- **Record ID**: ```secondary-ap-northeast-1```
![Route 53](/images/6.4/15.png?featherlight=false&width=90pc)
![Route 53](/images/6.4/16.png?featherlight=false&width=90pc)
![Route 53](/images/6.4/17.png?featherlight=false&width=90pc)


{{%notice info%}}
**Lưu ý**: Nếu menu "Alias to API Gateway" không hiện, bạn có thể dùng **Record type CNAME** trỏ thẳng tới Regional domain của custom domain API Gateway.
{{%/notice%}}


**Kiểm tra Health Check Status**
- Truy cập **Route 53** → **Health checks**
- Kiểm tra status của cả hai health checks
- Status **Success** có nghĩa là endpoint đang hoạt động bình thường

![Route 53](/images/6.4/8.png?featherlight=false&width=90pc)



### Kết quả

Sau khi hoàn thành bước này:

- ✅ **Health Checks** đã được tạo cho cả hai Region
- ✅ **Failover Records** đã được cấu hình
- ✅ **DNS Failover** hoạt động tự động
- ✅ **Custom Domain** `api.turtleclouds.id.vn` đã sẵn sàng
- ✅ **High Availability** đã được đảm bảo

