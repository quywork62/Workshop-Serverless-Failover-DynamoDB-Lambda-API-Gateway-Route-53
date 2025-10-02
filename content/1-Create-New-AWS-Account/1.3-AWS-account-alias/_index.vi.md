---
title : "Sử dụng Cloudflare để quản lý tên miền"
date : "2025-01-27"
weight : 3
chapter : false
pre : " <b> 1.3 </b> "
---



Sau khi đã trỏ tên miền turtleclouds.id.vn về địa chỉ IP hosting trên DataOnline, bước tiếp theo là sử dụng Cloudflare để quản lý và tối ưu tên miền. Cloudflare hoạt động như một lớp trung gian giữa người dùng và máy chủ, vừa giúp tăng tốc độ truy cập nhờ hệ thống CDN toàn cầu, vừa tăng cường bảo mật với tường lửa và chống tấn công DDoS. Trước tiên, bạn cần tạo một tài khoản miễn phí tại dash.cloudflare.com và thêm tên miền turtleclouds.id.vn vào hệ thống. Cloudflare sẽ tự động quét và nhập các bản ghi DNS hiện có, đồng thời cung cấp cho bạn hai Nameserver mới.

### Nội dung

1. [Đăng nhập vào Cloudflare và nhập tên miền](#bước-1-đăng-nhập-vào-cloudflare-và-nhập-tên-miền-đã-đăng-kí-ở-đây-ví-dụ-turtlecloudsidvn)
2. [Cấu hình DNS Records](#bước-2-vào-bảng-điều-khiển-chọn-dns-tiếp-đó-chọn-records-tiếp-đó-cọn-add-records-để-thêm-2-bản-ghi)
3. [Cập nhật Nameserver tại tenten.vn](#bước-3-cập-nhật-nameserver-tại-tentenvn)
4. [Kiểm tra kết quả](#bước-4bước-kiểm-tra-cuối-cùng) 
 

#### Bước 1: Đăng nhập vào Cloudflare và nhập tên miền đã đăng kí , ở đây ví dụ turtleclouds.id.vn
 
![Create Account](/images/1.3/1.png?featherlight=false&width=90pc)

#### Bước 2: Vào bảng điều khiển chọn **DNS** tiếp đó chọn **Records**. Tiếp đó cọn **Add records** để thêm 2 bản ghi 

![Create Account](/images/1.3/2.png?featherlight=false&width=90pc)

![Create Account](/images/1.3/3.png?featherlight=false&width=90p)




#### Bước 3: Cập nhật Nameserver tại tenten.vn
- Tiếp theo, bạn đăng nhập vào trang quản lý tên miền tại **tenten.vn**, tìm đến phần **Quản lý Nameserver** và thay đổi các **Nameserver** mặc định sang hai địa chỉ mà **Cloudflare** vừa cung cấp. Lưu lại thay đổi và chờ hệ thống cập nhật.

![Create Account](/images/1.3/4.png?featherlight=false&width=90p)
- Vào **Thao tác** tiếp đó chọn **Cài đặt NS**

![Create Account](/images/1.3/5.png?featherlight=false&width=90p)
#### Thay đổi 2 bản ghi NS của tenten.vn bằng 2 bản ghi NS của **Cloudflare** và nhấn **Cập nhật** 
![Create Account](/images/1.3/6.png?featherlight=false&width=90p)


![Create Account](/images/1.3/7.png?featherlight=false&width=90p)

#### Bước 4:Bước kiểm tra cuối cùng

- Sau khi đã cấu hình **Nameserver** tại **tenten.vn** và hoàn tất thiết lập **DNS** trên **Cloudflare**, hãy mở **Command Prompt** hoặc **PowerShell** trên máy tính và sử dụng lệnh:

```
ping turtleclouds.id.vn

```
#### Kết quả 
![Create Account](/images/1.3/9.png?featherlight=false&width=90p)




