---
title : "Làm ACM DNS validation cho cả 2 region"
date : "2025-01-27" 
weight : 2
chapter : false
pre : " <b> 6.2 </b> "
---

### Làm ACM DNS validation cho cả 2 region

Bạn đang dùng Regional API ở ap-southeast-1 (Singapore – chính) và ap-northeast-1 (Tokyo – phụ), nên cần 2 certificate, mỗi cái ở đúng region tương ứng.

### Tại sao cần SSL Certificates cho cả hai Region?

- **Regional Requirement**: API Gateway Regional endpoints cần certificate ở cùng Region
- **Custom Domain**: Để sử dụng domain riêng thay vì URL AWS mặc định
- **HTTPS Security**: Đảm bảo tất cả API calls được mã hóa
- **Failover Support**: Cả hai Region đều cần có SSL để failover hoạt động

### Nội dung

1. [Tạo Certificate cho Singapore Region](#1-tạo-certificate-cho-singapore-region)
2. [DNS Validation cho Singapore](#2-dns-validation-cho-singapore)
3. [Tạo Certificate cho Tokyo Region](#3-tạo-certificate-cho-tokyo-region)
4. [DNS Validation cho Tokyo](#4-dns-validation-cho-tokyo)
5. [Kiểm tra Certificate Status](#5-kiểm-tra-certificate-status)

#### 1. Tạo Certificate cho Singapore Region

- Đảm bảo bạn đang ở Region **Singapore (ap-southeast-1)**
- Truy cập **AWS Certificate Manager (ACM)**
- Chọn **Request a certificate**

![ACM](/images/6.2/1.png?featherlight=false&width=90pc)

**Cấu hình Certificate:**
- **Certificate type**: **Request a public certificate**
- Chọn **Next**

![ACM](/images/6.2/2.png?featherlight=false&width=90pc)

**Domain names:**
- **Fully qualified domain name**: ```api.turtleclouds.id.vn```
- Nếu cần thêm SAN (Subject Alternative Names): ```www.api.turtleclouds.id.vn```
- **Validation method**: **DNS validation**
- **Key algorithm**: **RSA 2048**
- Chọn **Request**

![ACM](/images/6.2/3.png?featherlight=false&width=90pc)
![ACM](/images/6.2/4.png?featherlight=false&width=90pc)
![Route 53](/images/6.2/5.png?featherlight=false&width=90pc)

![Route 53](/images/6.2/6.png?featherlight=false&width=90pc)
#### 2. DNS Validation cho Singapore

ACM sẽ hiển thị thông tin validation. Bạn sẽ thấy một bản ghi CNAME cần tạo:

**Ví dụ CNAME record:**
- **Name**: ```_4724b28c2f251eaf0f8e5de086a13395.api.turtleclouds.id.vn```
- **Value**: ```_d527ab199f33beee1a7c9dedf48c932a.xlfgrmvvlj.acm-validations.aws```



👉 Ở giao diện **ACM**, chọn **Create records in Route 53** để tạo tự động.
![ACM](/images/6.2/7.png?featherlight=false&width=90pc)

- Tạo bản ghi DNS trong **Route 53**

Khi bấm nút, ACM sẽ mở giao diện tạo bản ghi DNS trên Route 53.

**Domain**: ```api.turtleclouds.id.vn```

**Validation status***: **Pending validation**

Chọn **Create records** để xác nhận.
![ACM](/images/6.2/8.png?featherlight=false&width=90pc)

- Xác minh trạng thái

Sau khi tạo xong, quay lại màn hình chi tiết certificate trong ACM.

Trạng thái sẽ là **Pending validation**.

Sau vài phút, khi DNS propagation hoàn tất, ACM sẽ tự động đổi sang **Issued**.
![ACM](/images/6.2/9.png?featherlight=false&width=90pc)
![ACM](/images/6.2/10.png?featherlight=false&width=90pc)


{{%notice info%}}
Lưu ý: Vì subdomain api.* đã được ủy quyền DNS cho Route 53, bạn tạo bản ghi CNAME trực tiếp trong Route 53 (zone: api.turtleclouds.id.vn), không cần thao tác ở Cloudflare.
{{%/notice%}}

#### 3. Tạo Certificate cho Tokyo Region

- Chuyển sang Region **Tokyo (ap-northeast-1)**
- Truy cập **AWS Certificate Manager (ACM)**
- Lặp lại các bước tương tự như Singapore



**Cấu hình Certificate:**
- **Domain name**: ```api.turtleclouds.id.vn```
- **Validation method**: **DNS validation**
- **Key algorithm**: **RSA 2048**
- Chọn **Request**

#### 4. DNS Validation cho Tokyo

ACM Tokyo sẽ cung cấp một CNAME record khác để validation:

**Ví dụ CNAME record cho Tokyo:**
- **Name**: ```_8956c39d4e362bfb2c9f7a180b24567e.api.turtleclouds.id.vn```
- **Value**: ```_f638bc210e44ceef2d8d0f57f49c843b.ylfgrmvvlj.acm-validations.aws```



👉 Ở giao diện **ACM**, chọn **Create records in Route 53** để tạo tự động.


- Tạo bản ghi DNS trong **Route 53**

Khi bấm nút, ACM sẽ mở giao diện tạo bản ghi DNS trên Route 53.

**Domain**: ```api.turtleclouds.id.vn```

**Validation status***: **Pending validation**

Chọn **Create records** để xác nhận.

- Xác minh trạng thái

Sau khi tạo xong, quay lại màn hình chi tiết certificate trong ACM.

Trạng thái sẽ là **Pending validation**.

Sau vài phút, khi DNS propagation hoàn tất, ACM sẽ tự động đổi sang **Issued**.


![ACM](/images/6.2/11.png?featherlight=false&width=90pc)

{{%notice info%}}
Lưu ý: Vì subdomain api.* đã được ủy quyền DNS cho Route 53, bạn tạo bản ghi CNAME trực tiếp trong Route 53 (zone: api.turtleclouds.id.vn), không cần thao tác ở Cloudflare.
{{%/notice%}}

#### 5. Kiểm tra Certificate Status

**Kiểm tra Singapore Certificate:**
- Quay lại ACM trong Region **Singapore**
- Đợi status chuyển từ **Pending validation** → **Issued** (thường 2-10 phút)

![ACM](/images/6.2/10.png?featherlight=false&width=90pc)

**Kiểm tra Tokyo Certificate:**
- Chuyển sang ACM trong Region **Tokyo**
- Đợi status chuyển từ **Pending validation** → **Issued**

![ACM](/images/6.2/11.png?featherlight=false&width=90pc)

### Troubleshooting

Nếu certificate không được issued sau 15 phút:

1. **Kiểm tra CNAME records**: Đảm bảo đã tạo đúng trong Route 53
2. **Kiểm tra DNS propagation**: Sử dụng `nslookup` để verify
3. **Kiểm tra TTL**: Đảm bảo TTL không quá cao (khuyến nghị 300s)

```bash
nslookup -type=CNAME _4724b28c2f251eaf0f8e5de086a13395.api.turtleclouds.id.vn
```

### Kết quả

Sau khi hoàn thành bước này:

- ✅ **SSL Certificate** đã được issued cho Singapore Region
- ✅ **SSL Certificate** đã được issued cho Tokyo Region
- ✅ **DNS Validation** hoạt động chính xác
- ✅ **CNAME Records** đã được tạo trong Route 53

### Chuẩn bị cho bước tiếp theo

Với 2 SSL certificates đã sẵn sàng, chúng ta có thể tạo Custom Domain Names cho API Gateway ở cả hai Region trong bước tiếp theo.