# Công cụ soạn tin chăm sóc khách hàng

Công cụ soạn nhanh tin nhắn chăm sóc khách hàng từ mẫu, dùng cho đội sales tư vấn dịch vụ tên miền / hosting / email tại Mắt Bão.

**Người lập dự án:** Lương Thị Phượng — Team Bựa — Phòng Tư vấn Mắt Bão

## Nội dung repo

| File | Mô tả |
|---|---|
| `index.html` | Bản demo độc lập (v1) — 20 mẫu tin nhúng sẵn trong code, chạy được ngay không cần cấu hình gì, mở trực tiếp bằng trình duyệt. |
| `cong-cu-soan-tin-v2.html` | Bản v2 — đọc/ghi dữ liệu mẫu từ một database bên ngoài (Supabase hoặc dịch vụ tương đương có REST API), có thêm "Chế độ quản lý" để tự thêm/sửa/xóa mẫu. Cần điền `SUPABASE_URL` và `SUPABASE_ANON_KEY` (hoặc thông tin tương đương) ở đầu file trước khi dùng. |
| `setup-database.sql` | Script tạo bảng `templates` và nạp sẵn 20 mẫu tin, chạy trong SQL Editor của database (PostgreSQL). |
| `kho-mau-tin-nhan.md` | Kho 20 mẫu tin nhắn, phân loại theo Tên miền / Hosting / Email / Chăm sóc chung. |

## Nhóm mẫu tin

1. **Tên miền** — tư vấn đăng ký mới, nhắc gia hạn, khôi phục domain hết hạn, transfer, xử lý khóa/tranh chấp
2. **Hosting / Cloud Server** — tư vấn chọn gói, nhắc gia hạn, xử lý sự cố, upsell, hết dung lượng
3. **Email doanh nghiệp (Email Pro / M365)** — tư vấn mua mới, hướng dẫn cấu hình, nhắc gia hạn license, sự cố gửi/nhận mail, thêm mailbox
4. **Chăm sóc chung** — chào khách mới, follow-up báo giá, cảm ơn sau chốt đơn, xin lỗi khi có sự cố, khảo sát hài lòng

## Cách dùng nhanh

1. Mở `index.html` để dùng thử ngay với dữ liệu mẫu có sẵn.
2. Khi muốn cả team cùng thêm/sửa mẫu, tạo database (PostgreSQL) trên nền tảng có hỗ trợ REST API tự động, chạy `setup-database.sql`, rồi cấu hình `cong-cu-soan-tin-v2.html` để trỏ tới database đó.
3. Deploy file HTML lên hosting nội bộ (ví dụ Vibe Hosting) để cả team truy cập qua một link chung.
