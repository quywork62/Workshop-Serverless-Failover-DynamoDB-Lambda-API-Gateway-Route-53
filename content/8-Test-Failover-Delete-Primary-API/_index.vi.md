---
title : "Kiểm thử cơ chế chuyển đổi dự phòng bằng cách xóa API ở primary (Singapore)"
date : "2025-01-27" 
weight : 8
chapter : false
pre : " <b> 8. </b> "
---



Trong bước này, ta sẽ xóa hẳn API ở region Singapore (ap-southeast-1) để kiểm chứng cơ chế Failover sang region Secondary (Tokyo).

{{%notice warning%}}
**⚠️ Lưu ý quan trọng**: Việc này không thể hoàn nguyên nếu bạn chưa export API. Vì vậy nên export trước khi xóa để có thể khôi phục sau.
{{%/notice%}}

### Tại sao cần Test Failover?

- **Validate Architecture**: Xác minh cơ chế failover hoạt động đúng
- **Real-world Simulation**: Mô phỏng tình huống thực tế khi Primary Region gặp sự cố
- **Business Continuity**: Đảm bảo dịch vụ không bị gián đoạn
- **Confidence Building**: Tạo niềm tin vào hệ thống High Availability

### Nội dung

1. [(Tùy chọn) Export API](#1-tùy-chọn-export-api)
2. [Xóa Domain Mapping (nếu có)](#2-xóa-domain-mapping-nếu-có)
3. [Xóa API trên Console](#3-xóa-api-trên-console)
4. [Kiểm tra Health Check (Route 53)](#4-kiểm-tra-health-check-route-53)
5. [Xác minh Failover](#5-xác-minh-failover)

#### 1. (Tùy chọn) Export API

- Điều hướng đến **API Gateway** → **APIs** → chọn **HighAvailabilityAPI**
- Vào **Stages** → chọn **prod**
- Chọn **Export** để tải file Swagger/OpenAPI definition

![API Gateway](/images/8/1.png?featherlight=false&width=90pc)
![API Gateway](/images/8/2.png?featherlight=false&width=90pc)


👉 Lưu file này để khôi phục hoặc redeploy lại API nếu cần.

#### 2. Xóa Domain Mapping (nếu có)

Một số tài khoản AWS yêu cầu gỡ domain mapping trước khi xóa API.

**Thao tác:**
- Vào **Custom domain names** → chọn domain
- Chọn **Delete API mapping**
![API Gateway](/images/8/3.png?featherlight=false&width=90pc)
![API Gateway](/images/8/4.png?featherlight=false&width=90pc)
![API Gateway](/images/8/5.png?featherlight=false&width=90pc)

#### 3. Xóa API trên Console

- Quay lại **APIs** → chọn **HighAvailabilityAPI**
- Chọn **Actions** → **Delete**
- Gõ ```delete``` để xác nhận

![API Gateway](/images/8/6.png?featherlight=false&width=90pc)
![API Gateway](/images/8/7.png?featherlight=false&width=90pc)
![API Gateway](/images/8/8.png?featherlight=false&width=90pc)

**Hoặc qua AWS CLI:**

**Lấy danh sách API ở Singapore:**
```bash
aws apigateway get-rest-apis --region ap-southeast-1
```

**Xóa API:**
```bash
aws apigateway delete-rest-api \
  --rest-api-id <API_ID> \
  --region ap-southeast-1
```

#### 4. Kiểm tra Health Check (Route 53)

Sau khi API Singapore bị xóa, health check của Primary sẽ báo **Unhealthy** (HTTP 404/403).

Route 53 sẽ tự động failover toàn bộ traffic sang Secondary (Tokyo – ap-northeast-1).

- Truy cập **Route 53** → **Health checks**
- Kiểm tra status của **Primary Singapore** health check
- Status sẽ chuyển từ **Success** → **Failure**

![Route 53](/images/8/9.png?featherlight=false&width=90pc)
![Route 53](/images/8/10.png?featherlight=false&width=90pc)

**Kiểm tra Frontend Website:**

Trong lúc chờ health check phát hiện lỗi, bạn có thể test frontend website để thấy sự thay đổi:

- Truy cập frontend website: ```http://api.turtleclouds.id.vn.s3-website-ap-southeast-1.amazonaws.com```
- Thử các chức năng CRUD
- Ban đầu có thể gặp lỗi khi API Singapore vừa bị xóa
- Sau 2-3 phút, website sẽ hoạt động bình thường trở lại khi traffic được chuyển sang Tokyo

![Website](/images/8/11.png?featherlight=false&width=90pc)
![Website](/images/8/12.png?featherlight=false&width=90pc)
![Website](/images/8/13.png?featherlight=false&width=90pc)

{{%notice info%}}
**Lưu ý**: Health check có thể mất 2-3 phút để phát hiện lỗi và trigger failover.
{{%/notice%}}

#### 5. Xác minh Failover

**Cách 1: Test trực tiếp trong Route 53**

- Vào **Route 53 Console** → **Hosted zones** → chọn domain **api.turtleclouds.id.vn**
- Nhấn **Test record**

![Route 53](/images/8/14.png?featherlight=false&width=90pc)

**Nhập:**
- Record name: ```api.turtleclouds.id.vn```
- Record type: **A**
- Nhấn **Test**

![Route 53](/images/8/15.png?featherlight=false&width=90pc)

👉 Nếu failover thành công, record sẽ resolve sang IP ở Tokyo (ap-northeast-1) thay vì Singapore.

**Cách 2: Xác minh IP thực tế**

**Kiểm tra DNS/IP từ terminal:**
```bash
dig api.turtleclouds.id.vn
```

**Hoặc trên Windows PowerShell:**
```powershell
Resolve-DnsName api.turtleclouds.id.vn
```

![Terminal](/images/8/16.png?featherlight=false&width=90pc)

👉 Kết quả sẽ hiển thị danh sách IP (ví dụ: 35.74.x.x, 52.199.x.x, 52.193.x.x) — tất cả thuộc Tokyo region.

**Cách 3: Reverse DNS để xác định Region**

**Trên Linux/Mac:**
```bash
host <IP>
```

**Trên Windows PowerShell:**
```powershell
Resolve-DnsName <IP> -Type PTR
```

![Terminal](/images/8/17.png?featherlight=false&width=90pc)
![Terminal](/images/8/18.png?featherlight=false&width=90pc)

👉 Nếu kết quả hiển thị **ap-northeast-1** (Tokyo) → chứng tỏ failover thành công. 🎉


### Kết quả mong đợi

✅ **API ở Singapore đã bị xóa**

✅ **Health check chuyển sang Unhealthy**

✅ **Route 53 failover sang Tokyo (ap-northeast-1)**

✅ **Truy cập domain api.turtleclouds.id.vn sẽ trả về response từ API Tokyo**

### Monitoring và Verification

**CloudWatch Metrics:**
- Route 53 Health Check status changes
- API Gateway request metrics (should show 0 for Singapore, increased for Tokyo)
- Lambda invocation metrics shift to Tokyo region

**Timeline Expectations:**
- **0-2 minutes**: API deletion completed
- **2-5 minutes**: Health check detects failure
- **5-7 minutes**: DNS failover propagation
- **7+ minutes**: All traffic routed to Tokyo

### Troubleshooting

**Nếu failover không hoạt động:**

1. **Kiểm tra Health Check configuration**
2. **Verify Failover records setup đúng**
3. **Check DNS TTL settings**
4. **Ensure Tokyo API và Lambda functions hoạt động bình thường**

**Nếu muốn khôi phục Singapore API:**

1. **Import lại API từ exported file**
2. **Redeploy Lambda functions**
3. **Recreate Custom Domain mapping**
4. **Wait for Health Check to recover**

### Kết luận

Bạn đã thành công kiểm chứng cơ chế **Serverless Failover** hoạt động tự động và hiệu quả. Hệ thống có khả năng:

- **Tự động phát hiện lỗi** thông qua Route 53 Health Checks
- **Chuyển đổi traffic** sang Region dự phòng trong vòng 5-7 phút
- **Duy trì tính liên tục** của dịch vụ mà không cần can thiệp thủ công
- **Đảm bảo data consistency** nhờ DynamoDB Global Tables

{{%notice success%}}
**Chúc mừng!** Bạn đã xây dựng thành công một kiến trúc **High Availability Serverless** với khả năng chịu lỗi và tự động phục hồi.
{{%/notice%}}