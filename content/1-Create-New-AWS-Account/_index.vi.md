---
title : "Bước chuẩn bị"
date : "2025-01-27"
weight : 1
chapter : false
pre : " <b> 1. </b> "
---

### Chuẩn bị cho Serverless Failover Architecture

Trước khi bắt đầu xây dựng kiến trúc Serverless Failover, chúng ta cần chuẩn bị một số thành phần cơ bản:

### Yêu cầu trước khi bắt đầu

1. **Tài khoản AWS**: Đảm bảo bạn có tài khoản AWS với quyền Administrator
2. **Tên miền**: Chuẩn bị một tên miền để cấu hình Route 53 (tùy chọn)
3. **Kiến thức cơ bản**: Hiểu biết về các dịch vụ AWS cơ bản

### Các Region sẽ sử dụng

Trong bài lab này, chúng ta sẽ sử dụng 2 Region:
- **Primary Region**: Singapore (ap-southeast-1)
- **Secondary Region**: Tokyo (ap-northeast-1)

### Kiến trúc tổng quan

![Serverless Failover Architecture](/images/1/0001.png?v=2025&featherlight=false&width=60pc)
Chúng ta sẽ xây dựng một ứng dụng serverless có khả năng failover tự động với các thành phần:

1. **DynamoDB Global Tables**: Lưu trữ dữ liệu đồng bộ giữa các Region
2. **Lambda Functions**: Xử lý logic backend
3. **API Gateway**: Cung cấp REST API endpoints
4. **Route 53**: DNS failover và health checks
5. **S3**: Hosting website tĩnh


**Nội dung:**

1. [Đăng kí tên miền tại TENTEN.VN](1.1-find-account-id/)
2. [Hosting trên DATAONLINE.VN](1.2-update-account/)
3. [Sử dụng Cloudflare để quản lý tên miền)](1.3-aws-account-alias/)

