# Công cụ soạn tin chăm sóc khách hàng

Công cụ soạn nhanh tin nhắn chăm sóc khách hàng từ mẫu, dùng cho đội sales tư vấn dịch vụ tên miền / hosting / email tại Mắt Bão.

**Người lập dự án:** Lương Thị Phượng — Team Bựa — Phòng Tư vấn Mắt Bão

## Kiến trúc

- `server.js` — backend Node.js/Express, kết nối PostgreSQL qua biến môi trường `DATABASE_URL`, expose API `/api/templates` (GET/POST/PUT/DELETE).
- `public/index.html` — giao diện chính, gọi vào API nội bộ ở trên. Có "Chế độ quản lý" để tự thêm/sửa/xóa mẫu, dữ liệu lưu thẳng vào PostgreSQL.
- `setup-database.sql` — script tạo bảng `templates` và nạp sẵn 20 mẫu tin, chạy một lần trên database PostgreSQL.
- `demo-standalone.html` — bản demo độc lập, không cần database, 20 mẫu nhúng sẵn trong code, dùng để xem/thử nhanh.
- `kho-mau-tin-nhan.md` — kho 20 mẫu tin nhắn dạng đọc, phân loại theo Tên miền / Hosting / Email / Chăm sóc chung.

## Triển khai trên Vibe Host

1. **Tạo database:** vào menu "Tạo database" trên Vibe Host → chọn PostgreSQL → hoàn tất → lấy **Connection String (URI)** (chỉ hiển thị 1 lần, lưu lại cẩn thận).
2. **Chạy script SQL:** dùng công cụ quản trị database Vibe Host cung cấp (hoặc bất kỳ client PostgreSQL nào, ví dụ Adminer/pgAdmin) để chạy toàn bộ nội dung `setup-database.sql`, tạo bảng và nạp 20 mẫu có sẵn.
3. **Triển khai website:** vào menu "Triển khai website" → chọn nguồn GitHub → chọn repo này, nhánh `main`.
4. Ở bước Cấu hình, Vibe Host sẽ tự quét code và gợi ý biến môi trường — điền `DATABASE_URL` bằng Connection String lấy ở bước 1.
5. Bấm triển khai. Vibe Host sẽ tự nhận diện đây là app Node.js (nhờ `package.json`), cài `npm install`, chạy `npm start` (tức `node server.js`), và phục vụ giao diện tại `public/index.html`.

## Cách dùng nhanh (không cần deploy)

Chỉ cần xem/thử nhanh mà chưa deploy gì, mở trực tiếp `demo-standalone.html` bằng trình duyệt — chạy được ngay với dữ liệu mẫu, không cần cấu hình.

## Nhóm mẫu tin

1. **Tên miền** — tư vấn đăng ký mới, nhắc gia hạn, khôi phục domain hết hạn, transfer, xử lý khóa/tranh chấp
2. **Hosting / Cloud Server** — tư vấn chọn gói, nhắc gia hạn, xử lý sự cố, upsell, hết dung lượng
3. **Email doanh nghiệp (Email Pro / M365)** — tư vấn mua mới, hướng dẫn cấu hình, nhắc gia hạn license, sự cố gửi/nhận mail, thêm mailbox
4. **Chăm sóc chung** — chào khách mới, follow-up báo giá, cảm ơn sau chốt đơn, xin lỗi khi có sự cố, khảo sát hài lòng
