---
title : "Create the Frontend Website"
date : "2025-01-27" 
weight : 7
chapter : false
pre : " <b> 7. </b> "
---

### Bước 7: Create the Frontend Website

Trong bước này, bạn sẽ triển khai frontend website tĩnh để giao tiếp với API. Website sử dụng HTML, Bootstrap để tạo giao diện, và JavaScript để gọi API thông qua Route 53 DNS name.

### Tại sao cần Frontend Website?

- **User Interface**: Cung cấp giao diện thân thiện để test API
- **Real-world Testing**: Kiểm tra failover từ góc độ người dùng cuối
- **Complete Solution**: Hoàn thiện kiến trúc full-stack với frontend + backend
- **Demonstration**: Minh họa cách tích hợp với API Gateway thông qua custom domain

### Nội dung


1. [Tải source code từ GitHub](#2-tải-source-code-từ-github)
2. [Tạo S3 Bucket](#1-tạo-s3-bucket)
3. [Chỉnh sửa cấu hình API](#3-chỉnh-sửa-cấu-hình-api)
4. [Upload file lên S3](#4-upload-file-lên-s3)
5. [Enable Static Website Hosting](#5-enable-static-website-hosting)
6. [Configuring Public Access Block](#6-configuring-public-access-block)
7. [Configuring Public Objects (Object ACLs)](#7-configuring-public-objects-object-acls)
8. [Kiểm tra Website](#8-kiểm-tra-website)

#### 1. Tải source code từ GitHub

Clone hoặc tải trực tiếp repository:
👉 **Front-end-Workshop-Failover**: https://github.com/quywork62/Front-end-Workshop-Failover-

**Nếu dùng git:**
```bash
git clone https://github.com/quywork62/Front-end-Workshop-Failover-.git
```

**Hoặc tải file ZIP và giải nén.**

![GitHub](/images/7/1.png?featherlight=false&width=90pc)
#### 2. Tạo S3 Bucket

- Truy cập **Amazon S3** → **Create bucket**
- Đặt tên bucket: ```api.turtleclouds.id.vn``` (Tên bucket phải trùng chính xác domain bạn sẽ sử dụng để host website)
- **Region**: chọn **ap-southeast-1 (Singapore)**
- Giữ nguyên các tùy chọn mặc định khác → Chọn **Create bucket**

![S3](/images/7/2.1.png?featherlight=false&width=90pc)

![S3](/images/7/3.png?featherlight=false&width=90pc)


![S3](/images/7/4.png?featherlight=false&width=90pc)
![Code](/images/7/5.png?featherlight=false&width=90pc)

#### 3. Chỉnh sửa cấu hình API

Trong source code, tìm file JavaScript chính (ví dụ  trong `index.html`) và chỉnh sửa:

```javascript
const apiUrl = 'https://api.<YOUR-DOMAIN>'; // Use Route 53 DNS name
---> const apiUrl = 'https://api.turtleclouds.id.vn/prod';  // Sử dụng Route 53 DNS name trỏ đến API Gateway
```

![S3](/images/7/2.png?featherlight=false&width=90pc)


{{%notice info%}}
**Lưu ý**: Đảm bảo URL API trỏ đến domain đã cấu hình trong Route 53, không phải regional domain names của API Gateway.
{{%/notice%}}

#### 4. Upload file lên S3

- Vào bucket **api.turtleclouds.id.vn** → **Upload**
- Chọn toàn bộ file code (HTML, CSS, JS, images) từ thư mục dự án
- Nhấn **Upload**

![S3](/images/7/6.png?featherlight=false&width=90pc)
![S3](/images/7/7.png?featherlight=false&width=90pc)
![S3](/images/7/8.png?featherlight=false&width=90pc)

#### 5. Enable Static Website Hosting

- Vào bucket → Tab **Properties**
- Cuộn xuống phần **Static website hosting** → Chọn **Edit**
![S3](/images/7/9.png?featherlight=false&width=90pc)
![S3](/images/7/10.png?featherlight=false&width=90pc)
**Cấu hình:**
- **Static website hosting**: **Enable**
- **Hosting type**: **Host a static website**
- **Index document**: ```index.html```
- Nhấn **Save changes**

![S3](/images/7/11.png?featherlight=false&width=90pc)
![S3](/images/7/12.png?featherlight=false&width=90pc)

👉 Sau khi bật, bạn sẽ thấy endpoint website do S3 cung cấp:
```
http://api.turtleclouds.id.vn.s3-website-ap-southeast-1.amazonaws.com
```

![S3](/images/7/13.png?featherlight=false&width=90pc)

#### 6. Configuring Public Access Block

Mặc định, S3 chặn public access. Cần tắt để cho phép truy cập website:

- Vào bucket → Tab **Permissions**
- Phần **Block public access (bucket settings)** → Chọn **Edit**
- **Bỏ chọn** "Block all public access"
- Chọn **Save changes** → Xác nhận **Confirm**

![S3](/images/7/14.png?featherlight=false&width=90pc)
![S3](/images/7/15.png?featherlight=false&width=90pc)
![S3](/images/7/16.png?featherlight=false&width=90pc)
![S3](/images/7/17.png?featherlight=false&width=90pc)

{{%notice warning%}}
**Cảnh báo**: Chỉ tắt public access block cho bucket chứa static website. Không áp dụng cho các bucket chứa dữ liệu nhạy cảm.
{{%/notice%}}

#### 7. Configuring Public Objects (Object ACLs)

**a. Bật ACLs trong Object Ownership**

- Vào bucket → Tab **Permissions**
- Phần **Access controls list(ACLs)** → **bucket owner enforced**
![S3](/images/7/18.png?featherlight=false&width=90pc)
![S3](/images/7/19.png?featherlight=false&width=90pc)

**Chọn:**
- **ACLs enabled**
- **Bucket owner preferred**
- Tick chọn "I acknowledge..."
- Nhấn **Save changes**
![S3](/images/7/20.png?featherlight=false&width=90pc)
![S3](/images/7/21.png?featherlight=false&width=90pc)


👉 Sau đó bạn sẽ thấy trạng thái: **Object Ownership = Bucket owner preferred (ACLs enabled)**

**b. Public các file frontend**

- Vào tab **Objects** → Chọn toàn bộ file website (HTML, CSS, JS, images)
- Nhấn **Actions** → **Make public using ACL**
- Xác nhận bằng **Make public**

![S3](/images/7/22.png?featherlight=false&width=90pc)
![S3](/images/7/23.png?featherlight=false&width=90pc)
![S3](/images/7/24.png?featherlight=false&width=90pc)


👉 Giờ đây, các file tĩnh đã công khai và có thể tải trực tiếp qua URL.

#### 8. Kiểm tra Website

**Test Static Website Endpoint:**
```
http://api.turtleclouds.id.vn.s3-website-ap-southeast-1.amazonaws.com
```

**Test Direct S3 URL:**
```
https://s3.ap-southeast-1.amazonaws.com/api.turtleclouds.id.vn/index.html
```

![S3](/images/7/25.png?featherlight=false&width=90pc)



### Kết quả

Sau khi hoàn thành bước này:

- ✅ **S3 Bucket** đã được tạo và cấu hình
- ✅ **Static Website Hosting** đã được kích hoạt
- ✅ **Frontend Code** đã được upload và public
- ✅ **Website** có thể truy cập qua S3 endpoint
- ✅ **API Integration** hoạt động với Route 53 domain

### Troubleshooting

**Nếu website không load:**
1. Kiểm tra **Block public access** đã tắt
2. Verify **Object ACLs** đã được set public
3. Đảm bảo **index.html** tồn tại trong bucket root

**Nếu API calls fail:**
1. Kiểm tra **CORS** configuration trên API Gateway
2. Verify **Route 53** records đã propagate
3. Test API endpoint trực tiếp bằng curl

### Chuẩn bị cho bước tiếp theo

Website frontend giờ đã sẵn sàng để test toàn bộ kiến trúc high availability. Bạn có thể test failover scenarios và monitor health checks từ giao diện người dùng.