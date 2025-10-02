---
title : "Thiết lập API Gateway ở cả hai Region"
date : "2025-01-27" 
weight : 5
chapter : false
pre : " <b> 5. </b> "
---

### Giới thiệu về Amazon API Gateway

**Amazon API Gateway** là dịch vụ được quản lý hoàn toàn giúp các nhà phát triển dễ dàng tạo, xuất bản, duy trì, giám sát và bảo mật API ở mọi quy mô. API Gateway hoạt động như "cửa ngõ" cho các ứng dụng truy cập dữ liệu, logic nghiệp vụ hoặc chức năng từ các dịch vụ backend như AWS Lambda, Amazon EC2, hoặc bất kỳ dịch vụ web nào.

**Trong bài lab này**, API Gateway đóng vai trò quan trọng trong kiến trúc Serverless Failover:

- **Cung cấp REST API endpoints**: Tạo các endpoint thống nhất cho ứng dụng frontend gọi đến
- **Kết nối với Lambda Functions**: Tích hợp với ReadFunction và WriteFunction đã tạo trước đó
- **Hỗ trợ CORS**: Cho phép frontend từ domain khác truy cập API
- **Logging và Monitoring**: Theo dõi performance và debug issues
- **Throttling**: Kiểm soát số lượng request để bảo vệ backend

### Lợi ích của API Gateway trong DR Strategy

- **Multi-Region Deployment**: Triển khai ở cả Primary và Secondary Region
- **Health Check Integration**: Tích hợp với Route 53 để kiểm tra tình trạng endpoint
- **Custom Domain**: Sử dụng domain riêng thay vì URL mặc định của AWS
- **SSL/TLS**: Tự động hỗ trợ HTTPS thông qua AWS Certificate Manager

### Nội dung

1. [Tạo API Gateway ở Region chính (Primary)](5.1-create-api-primary-region/)
2. [Nhân bản API Gateway sang Region phụ (Secondary)](5.2-create-api-secondary-region/)

