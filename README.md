# Thước Lụa — Bản nâng cấp AI thật (miễn phí 100%)

Bản này thêm 3 thứ vào demo gốc:

1. **Chatbot AI thật** — lời tư vấn phối đồ và ô "Hỏi AI" dùng Google Gemini (miễn phí), thay vì chỉ có câu mẫu cố định.
2. **Database thật** — sản phẩm và lịch sử chat lưu trong Supabase (Postgres miễn phí), thay vì mảng viết cứng trong code.
3. **Ảnh AI** — phần này demo gốc đã có sẵn (Pollinations.ai + Kolors Virtual Try-On qua Hugging Face), không cần thêm gì.

Nếu bạn **chưa làm bước nào cả**, web vẫn chạy được ngay (dùng dữ liệu mẫu offline + câu trả lời mẫu). Làm tới đâu, tính năng thật "bật" tới đó — không sợ làm hỏng demo.

Tổng thời gian làm hết 4 bước dưới đây: khoảng 20–30 phút, không cần thẻ tín dụng.

---

## Bước 0 — Tạo tài khoản GitHub (nếu chưa có)

Vào https://github.com/signup, đăng ký miễn phí. GitHub dùng để lưu code và để Vercel tự động deploy mỗi khi bạn sửa code.

Tạo 1 repository mới (ví dụ tên `thuoc-lua-ai`), sau đó upload toàn bộ các file trong thư mục này lên (kéo-thả file trên giao diện web GitHub là được, không cần biết dùng lệnh git).

Cấu trúc cần upload đúng như sau:
```
thuoc-lua-ai/
├── index.html
├── vercel.json
├── api/
│   └── chat.js
└── supabase/
    └── schema.sql   (chỉ để tham khảo, không cần deploy file này)
```

---

## Bước 1 — Tạo database Supabase (miễn phí)

1. Vào https://supabase.com → **Start your project** → đăng nhập bằng GitHub.
2. Bấm **New project**. Đặt tên tuỳ ý, tạo 1 mật khẩu database (lưu lại phòng khi cần), chọn region gần Việt Nam nhất (Singapore).
3. Đợi khoảng 1–2 phút để project khởi tạo xong.
4. Vào menu bên trái **SQL Editor** → **New query**.
5. Mở file `supabase/schema.sql` trong thư mục này, copy toàn bộ nội dung, dán vào ô query → bấm **Run**.
   - Lệnh này tạo 2 bảng (`products`, `chat_logs`) và nạp sẵn 37 sản phẩm mẫu.
6. Vào menu **Project Settings** (biểu tượng bánh răng) → **API**.
   - Copy giá trị **Project URL** (dạng `https://xxxxxxxx.supabase.co`)
   - Copy giá trị **anon public** key (chuỗi dài, KHÔNG copy `service_role` — key đó phải giữ bí mật tuyệt đối).
7. Mở file `index.html`, tìm đoạn:
   ```js
   const SUPABASE_URL = '';
   const SUPABASE_ANON_KEY = '';
   ```
   Dán 2 giá trị vừa copy vào giữa 2 dấu nháy đơn tương ứng, rồi lưu file.

> **Vì sao dùng `anon key` ngay trong code phía trình duyệt lại an toàn?**
> Vì Supabase thiết kế `anon key` để lộ công khai — nó chỉ dùng để "gõ cửa", còn quyền hạn thật sự do các dòng `RLS policy` trong `schema.sql` quyết định (ví dụ: cho đọc sản phẩm, cho ghi log chat, nhưng không cho ai sửa/xoá dữ liệu người khác).

---

## Bước 2 — Lấy API key Gemini miễn phí (Google AI Studio)

1. Vào https://aistudio.google.com/app/apikey → đăng nhập bằng tài khoản Google.
2. Bấm **Create API key** → **Create API key in new project**.
3. Copy chuỗi key hiện ra (dạng `AIzaSy...`). **Không dán key này vào `index.html`** — key này sẽ được cấu hình riêng trên Vercel ở bước 3 để không bị lộ công khai.

Free tier của Gemini (model `gemini-2.0-flash`) đủ dùng thoải mái cho demo — không cần thẻ tín dụng.

---

## Bước 3 — Deploy lên Vercel (miễn phí) + cấu hình API key

1. Vào https://vercel.com/signup → chọn **Continue with GitHub**.
2. Bấm **Add New** → **Project** → chọn repository `thuoc-lua-ai` bạn đã tạo ở Bước 0 → **Import**.
3. Ở phần cấu hình project, mở mục **Environment Variables**, thêm:
   - Name: `GEMINI_API_KEY`
   - Value: (dán API key Gemini từ Bước 2 vào)
4. Bấm **Deploy**. Đợi khoảng 30–60 giây.
5. Xong! Vercel sẽ cho bạn 1 đường link dạng `https://thuoc-lua-ai-xxxx.vercel.app` — đây chính là web đã có đầy đủ AI thật + database thật.

Từ lần sau, mỗi khi bạn sửa `index.html` trên GitHub và commit, Vercel sẽ **tự động deploy lại** sau vài chục giây.

---

## Kiểm tra mọi thứ hoạt động

- Mở web đã deploy → làm hết luồng hỏi đáp → tới bước gợi ý outfit, nếu thấy dòng "Đang nhờ AI viết lời tư vấn riêng cho bạn..." rồi đổi thành một đoạn văn tự nhiên (không phải câu mẫu cứng) → Gemini đã hoạt động.
- Gõ 1 câu hỏi bất kỳ vào ô "Hỏi AI" ở cuối khung chat → nếu AI trả lời được → thành công.
- Vào lại Supabase → **Table Editor** → bảng `chat_logs` → nếu thấy các dòng tin nhắn xuất hiện sau khi bạn chat → database đã hoạt động.
- Muốn sửa/thêm sản phẩm: vào Supabase → **Table Editor** → bảng `products` → sửa trực tiếp, không cần đụng vào code, refresh lại web là thấy ngay.

---

## Giới hạn cần biết (vẫn miễn phí nhưng có hạn mức)

| Dịch vụ | Hạn mức free tier (tham khảo, có thể thay đổi) |
|---|---|
| Vercel | Băng thông & lượt gọi function hào phóng cho dự án cá nhân/demo |
| Supabase | Project free tạm ngưng nếu không hoạt động ~1 tuần (chỉ cần vào lại dashboard để "đánh thức") |
| Google Gemini | Có giới hạn số request/phút cho free tier — đủ dùng cho demo, không phù hợp traffic lớn |
| Pollinations.ai / Kolors (Hugging Face Space) | Dịch vụ cộng đồng miễn phí, có thể chậm hoặc quá tải giờ cao điểm (đã có sẵn cơ chế fallback trong code) |

Nếu sau này lượng người dùng thật tăng lên và cần nâng cấp, đó là lúc cân nhắc các gói trả phí — nhưng để demo/học tập/portfolio thì mức miễn phí này thoải mái đủ dùng.
