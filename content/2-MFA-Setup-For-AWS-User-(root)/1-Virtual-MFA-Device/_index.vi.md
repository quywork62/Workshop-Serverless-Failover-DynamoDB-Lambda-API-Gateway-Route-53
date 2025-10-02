---
title : "Kích hoạt Global Tables và thêm Region phụ"
date : "2025-01-27" 
weight : 1
chapter : false
pre : " <b> 2.1 </b> "
---

#### Amazon DynamoDB Global Tables

**Amazon DynamoDB Global Tables** là một tính năng cho phép nhân bản dữ liệu tự động đa Region. Khi bạn bật Global Tables, dữ liệu được ghi ở một Region sẽ được tự động sao chép sang các Region khác theo mô hình multi-active (cả hai Region đều có thể đọc/ghi).

Điều này giúp ứng dụng:

- **Tính sẵn sàng cao (High Availability)**: Nếu một Region gặp sự cố, ứng dụng vẫn có thể truy cập dữ liệu từ Region còn lại.
- **Khả năng phục hồi sau thảm họa (Disaster Recovery – DR)**: Đảm bảo dữ liệu không bị gián đoạn và có thể khôi phục nhanh chóng.
- **Hiệu suất toàn cầu**: Người dùng ở các khu vực khác nhau có thể truy cập dữ liệu từ Region gần nhất để giảm độ trễ.

Trong bài lab này, sau khi tạo bảng DynamoDB ở Region chính (ví dụ us-east-1), bạn sẽ bật Global Tables để tạo bản sao sang Region phụ (us-west-2). Khi hoàn tất, mọi thay đổi trên bảng ở một Region sẽ được đồng bộ gần như theo thời gian thực sang bảng ở Region còn lại.

### Bước 2: Kích hoạt Global Tables và thêm Region phụ

#### 1. Sau khi hoàn thành bước đầu, tiếp theo ta sẽ click vào bảng **HighAvailabilityTable** mới tạo

![DynamoDB](/images/2/7.png?featherlight=false&width=90pc)

#### 2. Trong bảng vừa tạo, chuyển đến tab **Global Tables**

![DynamoDB](/images/2/8.png?featherlight=false&width=90pc)

#### 3. Chọn Create replica → chọn Region dự phòng (ví dụ: Tokyo ap-northeast-1)

![DynamoDB](/images/2/9.png?featherlight=false&width=90pc)

#### 4. Sau khi tạo chúng ta sẽ đợi từ 3 - 5 phút để khởi tạo tài nguyên. Cuối cùng khi thấy "Replica" chuyển sang Status **Active** là thành công

![DynamoDB](/images/2/10.png?featherlight=false&width=90pc)



