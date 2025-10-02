---
title : "Thiết lập DNS Route 53 và cấu hình Failover cho API Gateway"
date : "2025-01-27" 
weight : 6
chapter : false
pre : " <b> 6. </b> "
---

### Thiết lập DNS Route 53 và cấu hình Failover cho API Gateway

Trong bước này, chúng ta sẽ cấu hình DNS failover tự động sử dụng Amazon Route 53 để đảm bảo tính sẵn sàng cao cho API Gateway. Khi Primary Region gặp sự cố, Route 53 sẽ tự động chuyển hướng traffic sang Secondary Region.





### Tại sao cần DNS Failover?

- **Automatic Failover**: Tự động chuyển hướng traffic khi Primary Region gặp sự cố
- **Health Monitoring**: Liên tục giám sát tình trạng API endpoints
- **Zero Manual Intervention**: Không cần can thiệp thủ công khi failover xảy ra
- **Custom Domain**: Sử dụng domain riêng thay vì URL AWS mặc định
- **SSL/TLS Security**: Đảm bảo HTTPS cho tất cả requests

### Kiến trúc DNS Failover

1. **Route 53 Hosted Zone**: Quản lý DNS cho subdomain `api.turtleclouds.id.vn`
2. **ACM Certificates**: SSL certificates cho cả hai Region
3. **Custom Domains**: API Gateway custom domains với SSL
4. **Health Checks**: Giám sát tình trạng API endpoints
5. **Failover Records**: Primary/Secondary routing policy

### Nội dung

1. [Quyết định DNS cho api.turtleclouds.id.vn](6.1-setup-dns-delegation/)
2. [Làm ACM DNS validation cho cả 2 region](6.2-acm-ssl-certificates/)
3. [Tạo Custom domain cho API Gateway (mỗi region một cái)](6.3-api-gateway-custom-domains/)
4. [Route 53 Health check + Failover record](6.4-route53-health-check-failover/)

### Lưu ý quan trọng

{{%notice warning%}}
**Yêu cầu trước khi bắt đầu:**
- Đã có domain `turtleclouds.id.vn` được quản lý bởi Cloudflare
- API Gateway đã được tạo ở cả hai Region (Singapore và Tokyo)
- Lambda Functions đã hoạt động bình thường
- DynamoDB Global Tables đã được cấu hình
{{%/notice%}}

### Quy trình thực hiện

1. **Bước 6.1**: Tạo Route 53 Hosted Zone cho subdomain `api.turtleclouds.id.vn`
2. **Bước 6.2**: Request SSL certificates từ ACM cho cả hai Region
3. **Bước 6.3**: Tạo Custom Domain Names cho API Gateway
4. **Bước 6.4**: Cấu hình Health Checks và Failover Records

### Kết quả mong đợi

Sau khi hoàn thành, bạn sẽ có:

- ✅ **Custom Domain**: `api.turtleclouds.id.vn` trỏ đến API Gateway
- ✅ **SSL/TLS**: HTTPS được kích hoạt cho tất cả requests
- ✅ **Health Monitoring**: Route 53 liên tục kiểm tra tình trạng API
- ✅ **Automatic Failover**: Tự động chuyển sang Secondary Region khi cần
- ✅ **Zero Downtime**: Người dùng không bị gián đoạn dịch vụ