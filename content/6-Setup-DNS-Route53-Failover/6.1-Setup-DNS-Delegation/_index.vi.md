---
title : "Quyết định DNS cho api.turtleclouds.id.vn"
date : "2025-01-27" 
weight : 1
chapter : false
pre : " <b> 6.1 </b> "
---

### Quyết định DNS cho api.turtleclouds.id.vn

Để làm Step 6 đúng chuẩn lab (Route 53 health check + failover), ta chỉ cần giao quyền DNS của riêng subdomain `api` cho Route 53, còn gốc domain `turtleclouds.id.vn` vẫn ở Cloudflare.

### Tại sao cần DNS Delegation?

- **Tách biệt quản lý**: API subdomain được quản lý bởi Route 53, domain chính vẫn ở Cloudflare
- **Health Check**: Route 53 có thể thực hiện health check và failover cho API endpoints
- **Flexibility**: Không ảnh hưởng đến các subdomain khác (www, mail, etc.)
- **AWS Integration**: Tích hợp tốt với các dịch vụ AWS khác

### Nội dung

1. [Tạo Route 53 Hosted Zone](#1-tạo-route-53-hosted-zone)
2. [Lưu lại NS Records](#2-lưu-lại-ns-records)
3. [Cấu hình NS Records trên Cloudflare](#3-cấu-hình-ns-records-trên-cloudflare)
4. [Kiểm tra DNS Delegation](#4-kiểm-tra-dns-delegation)

#### 1. Tạo Route 53 Hosted Zone

- Truy cập **Route 53** trong AWS Console
- Chọn **Hosted zones** → **Create hosted zone**

![Route 53](/images/6.1/1.png?featherlight=false&width=90pc)
![Route 53](/images/6.1/2.png?featherlight=false&width=90pc)



**Cấu hình Hosted Zone:**
- **Domain name**: ```api.turtleclouds.id.vn```
- **Type**: **Public hosted zone**
- **Comment**: ```Subdomain for API Gateway failover```
- Chọn **Create hosted zone**
![Route 53](/images/6.1/3.png?featherlight=false&width=90pc)
![Route 53](/images/6.1/4.png?featherlight=false&width=90pc)
![Route 53](/images/6.1/5.png?featherlight=false&width=90pc)


#### 2. Lưu lại NS Records

Sau khi tạo hosted zone, Route 53 sẽ cấp 4 bản ghi NS (Name Server). Lưu lại các NS records này:

```
ns-xxxx.awsdns-xx.org
ns-xxxx.awsdns-xx.net
ns-xxxx.awsdns-xx.com
ns-xxxx.awsdns-xx.co.uk
```
![Route 53](/images/6.1/5.png?featherlight=false&width=90pc)



{{%notice info%}}
**Lưu ý**: Các NS records của bạn sẽ khác với ví dụ trên. Hãy copy chính xác các NS records mà Route 53 cấp cho hosted zone của bạn.
{{%/notice%}}

#### 3. Cấu hình NS Records trên Cloudflare

- Đăng nhập vào **Cloudflare Dashboard**
- Chọn domain **turtleclouds.id.vn**
- Vào **DNS** → **Records**

![Cloudflare](/images/6.1/6.png?featherlight=false&width=90pc)


**Thêm NS Records:**

Tạo 4 bản ghi NS, mỗi bản ghi cho một NS server của Route 53:

**Bản ghi 1:**
- **Type**: NS
- **Name**: ```api```
- **Content**: ```ns-xxxx.awsdns-xx.org```
- **TTL**: Auto

**Bản ghi 2:**
- **Type**: NS
- **Name**: ```api```
- **Content**: ```ns-xxxx.awsdns-xx.net```
- **TTL**: Auto

**Bản ghi 3:**
- **Type**: NS
- **Name**: ```api```
- **Content**: ```ns-xxxx.awsdns-xx.com```
- **TTL**: Auto

**Bản ghi 4:**
- **Type**: NS
- **Name**: ```api```
- **Content**: ```ns-xxxx.awsdns-xx.co.uk```
- **TTL**: Auto

![Cloudflare](/images/6.1/7.png?featherlight=false&width=90pc)
![Cloudflare](/images/6.1/8.png?featherlight=false&width=90pc)


{{%notice warning%}}
**Quan trọng**: Đảm bảo **Proxy status** là **DNS only** (màu xám), không phải **Proxied** (màu cam) cho các NS records.
{{%/notice%}}

#### 4. Kiểm tra DNS Delegation

Sau khi cấu hình, kiểm tra xem DNS delegation đã hoạt động chưa:

**Sử dụng nslookup:**
```bash
nslookup -type=NS api.turtleclouds.id.vn
```

**Kết quả mong đợi:**
```
Server:  8.8.8.8
Address: 8.8.8.8#53

Non-authoritative answer:
api.turtleclouds.id.vn  nameserver = ns-xxxx.awsdns-xx.org.
api.turtleclouds.id.vn  nameserver = ns-xxxx.awsdns-xx.net.
api.turtleclouds.id.vn  nameserver = ns-xxxx.awsdns-xx.com.
api.turtleclouds.id.vn  nameserver = ns-xxxx.awsdns-xx.co.uk.
```

**Sử dụng dig (Linux/Mac):**
```bash
dig NS api.turtleclouds.id.vn
```

![DNS Check](/images/6.1/9.png?featherlight=false&width=90pc)

### Kết quả

Sau khi hoàn thành bước này:

- ✅ **Route 53 Hosted Zone** đã được tạo cho `api.turtleclouds.id.vn`
- ✅ **NS Records** đã được cấu hình trên Cloudflare
- ✅ **DNS Delegation** hoạt động chính xác
- ✅ **Subdomain api** giờ được quản lý bởi Route 53

### Chuẩn bị cho bước tiếp theo

Từ giờ, mọi bản ghi DNS của `*.api.turtleclouds.id.vn` sẽ do Route 53 quản lý, trong khi phần còn lại (`www`, `root`, etc.) vẫn ở Cloudflare như hiện tại.

Trong bước tiếp theo, chúng ta sẽ tạo SSL certificates cho domain này sử dụng AWS Certificate Manager.