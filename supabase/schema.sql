-- ============================================================
-- SCHEMA CHO SUPABASE — DỰ ÁN THƯỚC LỤA
-- ============================================================

-- 1) BẢNG SẢN PHẨM ------------------------------------------------
create table if not exists products (
  id bigint generated always as identity primary key,
  loai text not null,          -- ao_dai, ao_thun, so_mi, dam, quan_jeans, chan_vay, ao_khoac
  nhom text not null,          -- full, top, bottom
  gioi_tinh text not null,     -- nam, nu, unisex
  ten text not null,
  mua text not null,           -- xuan_he, thu_dong
  mau text not null,           -- sang, toi, pastel, ruc_ro, dat
  phong_cach text not null,    -- basic, cong_so, dao_pho, nang_dong
  gia integer not null,
  mota text not null,
  keyword text not null,
  created_at timestamptz default now()
);

-- Cho phép mọi người (kể cả chưa đăng nhập) ĐỌC danh sách sản phẩm
alter table products enable row level security;
create policy "Cho phép đọc sản phẩm công khai"
  on products for select
  using (true);

-- 2) BẢNG LỊCH SỬ CHAT ---------------------------------------------
create table if not exists chat_logs (
  id bigint generated always as identity primary key,
  session_id text not null,
  role text not null,          -- 'user' hoặc 'bot'
  content text not null,
  created_at timestamptz default now()
);

-- Cho phép trình duyệt (anon key) GHI log chat, nhưng KHÔNG cho đọc lại công khai
-- (bảo vệ quyền riêng tư của khách khác)
alter table chat_logs enable row level security;
create policy "Cho phép ghi log chat công khai"
  on chat_logs for insert
  with check (true);

-- 3) DỮ LIỆU MẪU  --
insert into products (loai, nhom, gioi_tinh, ten, mua, mau, phong_cach, gia, mota, keyword) values
('ao_dai','full','nu','Áo dài voan hoạ tiết nhẹ nhàng','xuan_he','pastel','basic',280000,'Voan mềm nhẹ, hoạ tiết nhỏ tinh tế, mức giá phổ thông dễ mua.','áo dài voan hoạ tiết nhẹ'),
('ao_dai','full','nu','Áo dài lụa truyền thống','xuan_he','sang','cong_so',450000,'Lụa tơ tằm mỏng nhẹ, form ôm nhẹ, tông màu sáng nền nã.','áo dài lụa nữ truyền thống'),
('ao_dai','full','nu','Áo dài cách tân hoạ tiết pastel','xuan_he','pastel','dao_pho',480000,'Form cách tân trẻ trung, hoạ tiết hoa nhí tông pastel.','áo dài cách tân pastel'),
('ao_dai','full','nu','Áo dài gấm cách tân','thu_dong','dat','cong_so',540000,'Gấm dày dặn ấm áp, thêu hoạ tiết hoa sen, hợp se lạnh.','áo dài gấm cách tân'),
('ao_dai','full','nu','Áo dài nhung đính đá','thu_dong','toi','cong_so',620000,'Nhung mềm rủ, đính đá nhẹ ở cổ, sang trọng cho tiệc/sự kiện.','áo dài nhung đính đá'),
('ao_thun','top','unisex','Áo thun cotton basic trơn','xuan_he','sang','basic',120000,'Cotton 100%, form regular, dễ phối mọi loại quần.','áo thun cotton basic trơn'),
('ao_thun','top','unisex','Áo thun oversize tối giản','xuan_he','toi','dao_pho',150000,'Form oversize Hàn Quốc, vải mềm rũ, hợp phong cách đường phố.','áo thun oversize basic'),
('ao_thun','top','unisex','Áo thun pastel form vừa','xuan_he','pastel','basic',135000,'Tông pastel dịu nhẹ, vải thun co giãn thoáng mát.','áo thun pastel form vừa'),
('ao_thun','top','unisex','Áo thun in graphic màu nổi','xuan_he','ruc_ro','nang_dong',160000,'Hoạ tiết in graphic cá tính, màu sắc nổi bật năng động.','áo thun graphic màu nổi'),
('ao_thun','top','unisex','Áo thun dài tay cotton dày','thu_dong','dat','basic',175000,'Cotton dày giữ ấm nhẹ, hợp layer mùa thu đông.','áo thun dài tay cotton dày'),
('ao_thun','top','unisex','Áo thun cotton cao cấp phối tay raglan','thu_dong','toi','nang_dong',350000,'Cotton cao cấp dày dặn, phối tay raglan, form chuẩn thể thao.','áo thun cotton cao cấp raglan'),
('ao_thun','top','unisex','Áo thun thương hiệu phiên bản giới hạn','xuan_he','ruc_ro','dao_pho',650000,'Chất liệu nhập khẩu, in phiên bản giới hạn, form đứng phom cao cấp.','áo thun thương hiệu phiên bản giới hạn'),
('so_mi','top','unisex','Sơ mi trắng basic công sở','xuan_he','sang','cong_so',230000,'Vải tuyết mưa không nhăn, form slimfit thanh lịch.','sơ mi trắng công sở'),
('so_mi','top','unisex','Sơ mi caro tông đất','thu_dong','dat','dao_pho',260000,'Hoạ tiết caro tông đất ấm, hợp phối layer mùa lạnh.','sơ mi caro tông đất'),
('so_mi','top','unisex','Sơ mi lụa pastel','xuan_he','pastel','cong_so',280000,'Chất lụa mềm rũ, tông pastel thanh lịch, nhẹ nhàng.','sơ mi lụa pastel'),
('so_mi','top','unisex','Sơ mi denim tối màu','thu_dong','toi','dao_pho',290000,'Chất denim form rộng, cá tính, hợp phong cách đường phố.','sơ mi denim form rộng'),
('so_mi','top','unisex','Sơ mi linen cao cấp','xuan_he','sang','cong_so',350000,'Linen cao cấp thoáng mát, đường may tỉ mỉ, chuẩn công sở.','sơ mi linen cao cấp'),
('so_mi','top','unisex','Sơ mi lụa tơ tằm thương hiệu','thu_dong','dat','cong_so',680000,'Lụa tơ tằm thật, đường may thủ công, đẳng cấp sang trọng.','sơ mi lụa tơ tằm thương hiệu'),
('dam','full','nu','Đầm suông cotton giá tốt','xuan_he','sang','basic',260000,'Cotton thoáng mát, dáng suông đơn giản, mức giá phổ thông.','đầm suông cotton giá tốt'),
('dam','full','nu','Đầm linen trắng dáng suông','xuan_he','sang','basic',320000,'Linen thoáng mát, dáng suông thoải mái, hợp đi chơi/đi làm.','đầm linen trắng dáng suông'),
('dam','full','nu','Đầm hoa pastel midi','xuan_he','pastel','dao_pho',350000,'Hoạ tiết hoa nhỏ tông pastel, midi dài qua gối nữ tính.','đầm hoa pastel midi'),
('dam','full','nu','Đầm len cổ lọ tối màu','thu_dong','toi','cong_so',380000,'Len mềm giữ ấm, cổ lọ thanh lịch, hợp công sở mùa lạnh.','đầm len cổ lọ tối màu'),
('dam','full','nu','Đầm dạ hội cao cấp đính đá','thu_dong','toi','cong_so',680000,'Vải cao cấp, đính đá tinh xảo, hợp sự kiện/tiệc sang trọng.','đầm dạ hội cao cấp đính đá'),
('quan_jeans','bottom','unisex','Quần jeans xanh basic ống suông','xuan_he','toi','basic',280000,'Form ống suông dễ mặc, dễ phối mọi loại áo.','quần jeans xanh ống suông'),
('quan_jeans','bottom','unisex','Quần jeans baggy tối màu','thu_dong','toi','dao_pho',320000,'Form baggy rộng rãi, cá tính đường phố.','quần jeans baggy tối màu'),
('quan_jeans','bottom','unisex','Quần jeans trắng kem ống đứng','xuan_he','sang','cong_so',300000,'Tông sáng thanh lịch, ống đứng gọn gàng.','quần jeans trắng ống đứng'),
('quan_jeans','bottom','unisex','Quần jeans premium selvedge','thu_dong','toi','dao_pho',650000,'Vải denim selvedge cao cấp, bền form, đường may chắc chắn.','quần jeans premium selvedge'),
('chan_vay','bottom','nu','Chân váy chữ A pastel','xuan_he','pastel','dao_pho',180000,'Dáng chữ A tôn dáng, tông pastel dịu dàng.','chân váy chữ A pastel'),
('chan_vay','bottom','nu','Chân váy dạ tối màu công sở','thu_dong','toi','cong_so',260000,'Vải dạ dày dặn giữ ấm, hợp công sở mùa lạnh.','chân váy dạ công sở tối màu'),
('chan_vay','bottom','nu','Chân váy tông đất nung','thu_dong','dat','basic',220000,'Tông đất nung ấm áp, dễ phối áo len/sơ mi.','chân váy tông đất nung'),
('chan_vay','bottom','nu','Chân váy xếp ly cao cấp','xuan_he','pastel','cong_so',350000,'Xếp ly tinh tế, vải rủ đẹp form, sang trọng nhẹ nhàng.','chân váy xếp ly cao cấp'),
('chan_vay','bottom','nu','Chân váy da cao cấp','thu_dong','toi','dao_pho',650000,'Chất da PU cao cấp, form ôm nhẹ cá tính, sang trọng.','chân váy da cao cấp'),
('ao_khoac','top','unisex','Áo khoác gió mỏng giá tốt','xuan_he','sang','basic',250000,'Vải gió mỏng nhẹ, chống nắng/gió nhẹ, mức giá phổ thông.','áo khoác gió mỏng giá tốt'),
('ao_khoac','top','unisex','Áo khoác denim basic','thu_dong','toi','basic',350000,'Denim bền form, dễ layer ngoài áo thun/sơ mi.','áo khoác denim basic'),
('ao_khoac','top','unisex','Áo khoác dù màu rực rỡ','thu_dong','ruc_ro','nang_dong',380000,'Chất liệu dù chống gió nhẹ, màu nổi bật năng động.','áo khoác dù màu nổi'),
('ao_khoac','top','unisex','Áo khoác len pastel','thu_dong','pastel','cong_so',420000,'Len mềm tông pastel, mặc ngoài áo thun/sơ mi đều hợp.','áo khoác len pastel'),
('ao_khoac','top','unisex','Áo khoác phao cao cấp giữ nhiệt','thu_dong','toi','nang_dong',680000,'Công nghệ giữ nhiệt cao cấp, chống lạnh sâu, form chuẩn.','áo khoác phao cao cấp giữ nhiệt');
