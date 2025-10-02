---
title : "Serverless Failover: DynamoDB, Lambda, API Gateway & Route 53"
date : "2025-01-27" 
weight : 1 
chapter : false
---

# Serverless Failover: DynamoDB, Lambda, API Gateway & Route 53

## Tổng quan

Trong môi trường sản xuất (production), một trong những rủi ro lớn nhất là ngừng hoạt động (downtime) khi một AWS Region gặp sự cố. Đối với những ứng dụng yêu cầu tính sẵn sàng cao (**High Availability – HA**) và khả năng phục hồi sau thảm họa (**Disaster Recovery – DR**), việc triển khai hạ tầng đa Region là một chiến lược quan trọng.

Trong bài lab này, bạn sẽ xây dựng một ứng dụng serverless đa Region, có khả năng:

- **Chịu lỗi (Fault-Tolerant)**: Ứng dụng vẫn hoạt động bình thường khi một thành phần bị lỗi.
- **Khôi phục sau thảm họa (DR)**: Nếu Region chính (Primary) ngừng hoạt động, hệ thống sẽ tự động chuyển sang Region dự phòng (Secondary) mà không gián đoạn dịch vụ cho người dùng cuối.

Mục tiêu chính là kết hợp nhiều dịch vụ serverless của AWS để hình thành một kiến trúc toàn diện, an toàn và tự động failover.

## Kiến trúc của ứng dụng mà chúng ta sẽ xây dựng

![Serverless Failover Architecture](/images/1/0001.png?v=2025&featherlight=false&width=60pc)

## Các thành phần chính của kiến trúc

### 1. Amazon DynamoDB Global Tables

**Vai trò**: Là hệ thống lưu trữ dữ liệu chính cho ứng dụng theo mô hình multi-region, multi-active.

**Cách hoạt động**: Mọi dữ liệu ghi ở Region này sẽ được tự động đồng bộ sang Region khác chỉ trong vài giây (ví dụ: Singapore ↔ Tokyo).

**Lợi ích trong DR**: Khi Primary Region gặp sự cố, Secondary Region vẫn có dữ liệu mới nhất để phục vụ người dùng. Nhờ đó, ứng dụng tránh được mất dữ liệu (zero data loss) và duy trì tính liên tục.

### 2. AWS Lambda (Python Functions)

**Vai trò**: Cung cấp lớp xử lý backend mà không cần quản lý hạ tầng máy chủ.

**Cách hoạt động**: Các Lambda function được triển khai song song ở cả hai Region, có nhiệm vụ đọc và ghi dữ liệu từ DynamoDB. Khi người dùng gọi API, Lambda sẽ thực thi logic và trả kết quả ngay.

**Lợi ích trong DR**: Vì Lambda thuộc loại serverless, AWS sẽ tự động đảm bảo tính sẵn sàng ở cả hai Region. Khi Route 53 chuyển hướng request, Lambda tại Region còn lại sẽ tiếp tục xử lý mà không cần thay đổi cấu hình thủ công.

### 3. Amazon API Gateway

**Vai trò**: Đóng vai trò là cửa ngõ API RESTful, kết nối giữa client và Lambda.

**Cách hoạt động**: API Gateway được triển khai ở cả Primary và Secondary Region, cung cấp các endpoint thống nhất (stage /prod). Ngoài ra còn hỗ trợ logging, throttling để kiểm soát request.

**Lợi ích trong DR**: Người dùng không cần biết API đang chạy ở Region nào. Khi failover xảy ra, Route 53 tự động chuyển DNS sang API Gateway của Region dự phòng, giúp trải nghiệm liền mạch.

### 4. Amazon Route 53

**Vai trò**: Quản lý DNS và thực hiện failover dựa trên health check.

**Cách hoạt động**: Bạn sẽ cấu hình bản ghi DNS cho domain (ví dụ: api.example.com) trỏ tới API Gateway ở Primary Region, và bản ghi dự phòng (failover) trỏ tới Secondary. Route 53 liên tục giám sát endpoint chính, nếu phát hiện lỗi thì sẽ điều hướng sang Region còn lại.

**Lợi ích trong DR**: Việc chuyển hướng được thực hiện hoàn toàn tự động, đảm bảo zero downtime và giảm thiểu rủi ro gián đoạn dịch vụ cho người dùng.

### 5. AWS Certificate Manager (ACM)

**Vai trò**: Cấp và quản lý chứng chỉ SSL/TLS cho custom domain.

**Cách hoạt động**: ACM phát hành chứng chỉ miễn phí, sau đó chứng chỉ này được gắn vào API Gateway Custom Domain để kích hoạt HTTPS.

**Lợi ích trong DR**: Giúp mọi request từ client tới API luôn được bảo mật qua HTTPS, tuân thủ các tiêu chuẩn bảo mật và tạo niềm tin cho người dùng.

### 6. Amazon S3 (Frontend Website Hosting)

**Vai trò**: Lưu trữ và phân phát website tĩnh (HTML, CSS, JS).

**Cách hoạt động**: Website frontend được host trên một bucket S3, có thể kết hợp CloudFront để tăng tốc. Website này sẽ gọi API thông qua domain đã cấu hình với Route 53.

**Lợi ích trong DR**: Vì frontend được phân phát từ một nguồn tĩnh và ổn định, khi backend failover, website vẫn hoạt động bình thường. Người dùng sẽ tiếp tục sử dụng mà không cần thay đổi bất kỳ URL nào.

## Nội dung chính

1. [Bước chuẩn bị](1-create-new-aws-account/)
2. [Tạo bảng DynamoDB ở Region chính](2-MFA-Setup-For-AWS-User-(root)/)
3. [Tạo IAM Role cho Lambda Functions](3-create-admin-user-and-group/)
4. [Tạo Lambda Functions ở cả hai Region](4-verify-new-account/)
5. [Thiết lập API Gateway ở cả hai Region](5-setup-api-gateway/)
6. [Thiết lập DNS Route 53 và cấu hình Failover cho API Gateway](6-setup-dns-route53-failover/)
7. [Create the Frontend Website](7-create-frontend-website/)
8. [Kiểm thử cơ chế chuyển đổi dự phòng bằng cách xóa API ở primary (Singapore)](8-test-failover-delete-primary-api/)
9. [Xóa tài nguyên (Clean Up)](9-clean-up-resources/)