-- ============================================================
-- Setup database cho Công cụ soạn tin chăm sóc khách hàng
-- Người lập dự án: Lương Thị Phượng — Team Bựa — Phòng Tư vấn Mắt Bão
-- Chạy toàn bộ file này trong Supabase > SQL Editor > Run
-- ============================================================

-- PostgreSQL 13+ đã có sẵn gen_random_uuid() trong lõi, không cần bật extension pgcrypto
-- (nhiều nền tảng hosting quản lý không cho tài khoản thường tự bật extension)

create table if not exists templates (
  id uuid primary key default gen_random_uuid(),
  category_id text not null,
  category_label text not null,
  scenario_label text not null,
  message_text text not null,
  sort_order int default 0,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- Không cần Row Level Security ở đây: chỉ có backend server.js (chạy trên Vibe Host,
-- kết nối bằng DATABASE_URL) truy cập trực tiếp vào database này. Trình duyệt của người
-- dùng không bao giờ chạm vào database, chỉ gọi qua API nội bộ do server.js cung cấp.

-- Nạp sẵn 20 mẫu đã chốt
insert into templates (category_id, category_label, scenario_label, message_text, sort_order) values
('domain','Tên miền','Tư vấn đăng ký domain mới','Chào anh/chị {ten_khach_hang}, em là {ten_sale} bên Mắt Bão. Em thấy tên miền {ten_mien} anh/chị quan tâm hiện vẫn còn trống ạ. Anh/chị có muốn em check thêm vài đuôi (.vn/.com/.com.vn) để so sánh giá và đăng ký sớm không, tránh trường hợp bị người khác mua trước ạ?',1),
('domain','Tên miền','Nhắc gia hạn domain sắp hết hạn','Chào anh/chị {ten_khach_hang}, tên miền {ten_mien} của mình sẽ hết hạn vào {ngay_het_han} (còn {so_ngay_con_lai} ngày). Em gửi anh/chị link gia hạn sớm để tránh gián đoạn website/email: {link_gia_han}. Anh/chị cần em hỗ trợ gì thêm không ạ?',2),
('domain','Tên miền','Domain đã hết hạn — hỗ trợ khôi phục','Anh/chị {ten_khach_hang} ơi, tên miền {ten_mien} đã hết hạn từ {ngay_het_han} và đang trong thời gian giữ chỗ (redemption). Em có thể hỗ trợ khôi phục ngay để website/email hoạt động lại bình thường, tuy nhiên phí khôi phục sẽ cao hơn phí gia hạn thông thường. Anh/chị xác nhận giúp em để em xử lý gấp ạ.',3),
('domain','Tên miền','Tư vấn chuyển domain về Mắt Bão','Chào anh/chị {ten_khach_hang}, để chuyển tên miền {ten_mien} về quản lý tại Mắt Bão, anh/chị cần: (1) mở khóa domain, (2) lấy mã Auth code từ nhà cung cấp cũ, (3) gửi em để khởi tạo lệnh chuyển. Quá trình thường mất 5-7 ngày, em sẽ đồng hành hỗ trợ từng bước ạ.',4),
('domain','Tên miền','Domain bị khóa/tranh chấp','Chào anh/chị {ten_khach_hang}, hệ thống ghi nhận tên miền {ten_mien} đang tạm khóa do {ly_do}. Em cần anh/chị bổ sung/xác nhận {thong_tin_can_thiet} để mở khóa sớm, tránh ảnh hưởng website đang vận hành ạ.',5),

('hosting','Hosting / Cloud Server','Tư vấn chọn gói phù hợp','Chào anh/chị {ten_khach_hang}, để tư vấn đúng gói Hosting/Cloud Server, em xin hỏi thêm: website của mình là loại gì (giới thiệu/bán hàng/portal), lượng truy cập trung bình khoảng bao nhiêu/tháng, và có dùng công nghệ đặc thù (WordPress, Java, NodeJS...) không ạ?',1),
('hosting','Hosting / Cloud Server','Nhắc gia hạn hosting','Chào anh/chị {ten_khach_hang}, gói {goi_dich_vu} sẽ hết hạn vào {ngay_het_han} (còn {so_ngay_con_lai} ngày). Anh/chị gia hạn sớm giúp em để website không bị gián đoạn nhé, link thanh toán: {link_thanh_toan}.',2),
('hosting','Hosting / Cloud Server','Website chậm/down — xử lý sự cố','Chào anh/chị {ten_khach_hang}, em đã ghi nhận sự cố website {ten_mien} bị {mo_ta_su_co}. Em đang phối hợp kỹ thuật kiểm tra và sẽ cập nhật tiến độ cho anh/chị trong vòng {thoi_gian_cam_ket}. Rất xin lỗi vì sự bất tiện này ạ.',3),
('hosting','Hosting / Cloud Server','Upsell nâng cấp gói','Chào anh/chị {ten_khach_hang}, em thấy website đang dùng gói {goi_dich_vu} gần đây có lượng truy cập/dữ liệu tăng khá nhiều, gần chạm giới hạn gói hiện tại. Để tránh ảnh hưởng tốc độ tải trang, anh/chị cân nhắc nâng cấp lên gói cao hơn không ạ? Em gửi bảng so sánh chi tiết để mình dễ quyết định.',4),
('hosting','Hosting / Cloud Server','Hết dung lượng lưu trữ','Chào anh/chị {ten_khach_hang}, dung lượng lưu trữ gói {goi_dich_vu} hiện đã sử dụng gần hết (>90%). Anh/chị có thể dọn bớt dữ liệu cũ hoặc nâng cấp dung lượng để website hoạt động ổn định. Em có thể hỗ trợ báo giá nâng cấp ngay ạ.',5),

('email','Email doanh nghiệp','Tư vấn mua email mới','Chào anh/chị {ten_khach_hang}, với nhu cầu dùng email theo tên miền công ty {ten_mien}, em gợi ý 2 lựa chọn: Email Pro (chi phí tối ưu, phù hợp SME) hoặc Microsoft 365 (kèm bộ Office, Teams, lưu trữ đám mây). Anh/chị cho em biết số lượng nhân sự cần dùng để em báo giá chính xác nhé.',1),
('email','Email doanh nghiệp','Hướng dẫn cấu hình ban đầu','Chào anh/chị {ten_khach_hang}, tài khoản email {goi_dich_vu} của mình đã khởi tạo xong. Em gửi anh/chị hướng dẫn cấu hình trên điện thoại/Outlook kèm thông tin đăng nhập. Trong quá trình cài đặt có vướng chỗ nào anh/chị cứ nhắn em hỗ trợ trực tiếp ạ.',2),
('email','Email doanh nghiệp','Nhắc gia hạn license','Chào anh/chị {ten_khach_hang}, license {goi_dich_vu} sẽ hết hạn vào {ngay_het_han}. Anh/chị gia hạn trước ngày hết hạn để tránh gián đoạn truy cập email/dữ liệu công việc nhé: {link_gia_han}.',3),
('email','Email doanh nghiệp','Sự cố gửi/nhận mail','Chào anh/chị {ten_khach_hang}, em đã tiếp nhận phản ánh về việc email {mo_ta_su_co}. Nguyên nhân thường gặp là do cấu hình SPF/DKIM/DMARC hoặc domain reputation. Em sẽ kiểm tra và phản hồi anh/chị kết quả trong {thoi_gian_cam_ket} ạ.',4),
('email','Email doanh nghiệp','Yêu cầu thêm user/mailbox','Chào anh/chị {ten_khach_hang}, để thêm {so_luong} mailbox mới vào gói {goi_dich_vu}, em cần anh/chị cung cấp tên và email liên hệ của nhân sự mới. Em sẽ khởi tạo và gửi thông tin đăng nhập trong ngày ạ.',5),

('chung','Chăm sóc chung','Chào khách mới liên hệ','Chào anh/chị {ten_khach_hang}, em là {ten_sale} — tư vấn viên phụ trách hỗ trợ mình bên Mắt Bão. Rất vui được đồng hành cùng anh/chị. Anh/chị đang cần hỗ trợ về dịch vụ nào ạ (tên miền/hosting/email/SSL) để em tư vấn nhanh và chính xác nhất?',1),
('chung','Chăm sóc chung','Follow-up sau báo giá chưa phản hồi','Chào anh/chị {ten_khach_hang}, em gửi lại báo giá gói {goi_dich_vu} hôm trước để tiện anh/chị xem lại. Anh/chị có câu hỏi hay cần điều chỉnh gì thêm không, em hỗ trợ ngay ạ. Nếu anh/chị cần thêm thời gian cân nhắc, em xin phép follow-up lại sau vài ngày nữa nhé.',2),
('chung','Chăm sóc chung','Cảm ơn sau khi chốt đơn','Cảm ơn anh/chị {ten_khach_hang} đã tin tưởng lựa chọn dịch vụ {goi_dich_vu} tại Mắt Bão! Trong quá trình sử dụng, nếu cần hỗ trợ gì anh/chị cứ liên hệ em trực tiếp, em luôn sẵn sàng đồng hành ạ.',3),
('chung','Chăm sóc chung','Xin lỗi khi có sự cố/khiếu nại','Chào anh/chị {ten_khach_hang}, em rất xin lỗi vì sự cố {mo_ta_su_co} đã gây bất tiện cho anh/chị. Em đã báo cáo bộ phận kỹ thuật xử lý ưu tiên và sẽ cập nhật tiến độ sớm nhất. Cảm ơn anh/chị đã kiên nhẫn ạ.',4),
('chung','Chăm sóc chung','Khảo sát hài lòng sau hỗ trợ','Chào anh/chị {ten_khach_hang}, cảm ơn anh/chị đã sử dụng dịch vụ hỗ trợ vừa rồi. Anh/chị đánh giá mức độ hài lòng thế nào (thang điểm 1-5) và có góp ý gì để em cải thiện chất lượng phục vụ tốt hơn không ạ?',5);
