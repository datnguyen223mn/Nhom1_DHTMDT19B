﻿/*Phần A - Xây dựng mô hình ER
Bài tập 1: Quản lý hoạt động của một trung tâm đại học
Qua quá trình khảo sát, điều tra hoạt động của một trung tâm đại học ta rút ra các quy tắc quản lý sau:
Bài tập phần 1 làm theo nội dung đã chia sẵn theo nhóm.
Nội dung bao gồm các công việc sau
A - Phần 1 – Mô hình ERD và lược đồ quan hệ - SQL
1. Xây dựng mô hình ER
2. Chuyển sang lược đồ quan hệ
3. Cài đặt lược đồ quan hệ vào trong hệ quản trị CSDL SQL Server – nhập liệu mỗi bảng ít nhất 5 record.
4. Tự suy nghĩ ra mỗi thành viên 2 câu hỏi truy vấn (không trùng nhau) và giải đáp bằng lệnh SQL (Xem ví dụ minh họa các câu hỏi trong bài tập 1)

B - Phần 2 : Chuẩn hóa dữ liệu
Tùy theo số lượng thành viên trong nhóm – mỗi thành viên chọn 2 câu bất kỳ trong phần B để thực hiện.

Bài tập 1: Quản lý hoạt động của một trung tâm đại học
Trung tâm được chia làm nhiều trường và mỗi trường có 1 hiệu trưởng để quản lý nhà trường.
Một trường chia làm nhiều khoa, mỗi khoa thuộc về một trường.
Mỗi khoa cung cấp nhiều môn học. Mỗi môn học thuộc về 1 khoa (thuộc quyền quản lý của 1 khoa).
Mỗi khoa thuê nhiều giáo viên làm việc. Nhưng mỗi giáo viên chỉ làm việc cho 1 khoa.
Mỗi khoa có 1 chủ nhiệm khoa, đó là một giáo viên.
Mỗi giáo viên có thể dạy nhiều nhất 4 môn học và có thể không dạy môn học nào.
Mỗi sinh viên có thể học nhiều môn học, nhưng ít nhất là 1 môn. Mỗi môn học có thể có
nhiều sinh viên học, có thể không có sinh viên nào.
Một khoa quản lý nhiều sinh viên chỉ thuộc về một khoa.
Mỗi giáo viên có thể được cử làm chủ nhiệm của lớp, lớp đó có thể có nhiều nhất 100 sinh viên.*/

-- Câu 3 Phần A
-- Tạo cơ sở dữ liệu
CREATE DATABASE QuanLyTrungTamDH
ON PRIMARY ( 
    NAME = 'QuanLyTrungTamDH_DATA', 
    FILENAME = 'D:\CSDL\QuanLyTrungTamDH.mdf', 
    SIZE = 4048KB, 
    MAXSIZE = 10240KB, 
    FILEGROWTH = 20% )
LOG ON ( 
    NAME = 'QuanLyTrungTamDH_LOG', 
    FILENAME = 'D:\CSDL\QuanLyTrungTamDH_log.ldf', 
    SIZE = 1024KB, 
    MAXSIZE = 10240KB, 
    FILEGROWTH = 10% )
GO

USE QuanLyTrungTamDH
GO

-- 1. Tạo bảng TRUNGTAM
CREATE TABLE TRUNGTAM (
    MaTT CHAR(10) PRIMARY KEY,
    TenTT NVARCHAR(100),
    DiaChi NVARCHAR(200) )
GO

-- 2. Tạo bảng TRUONG
CREATE TABLE TRUONG (
    MaTruong CHAR(10) PRIMARY KEY,
    TenTruong NVARCHAR(100),
    DiaChi NVARCHAR(200),
    MaHT CHAR(10),
    MaTT CHAR(10),
    FOREIGN KEY (MaTT) REFERENCES TRUNGTAM(MaTT) )
GO

-- 3. Tạo bảng HIEUTRUONG
CREATE TABLE HIEUTRUONG (
    MaHT CHAR(10) PRIMARY KEY,
    TenHT NVARCHAR(100),
    SDT VARCHAR(15),
    MaTruong CHAR(10)
    FOREIGN KEY (MaTruong) REFERENCES TRUONG(MaTruong) )
GO

-- Cập nhật bảng TRUONG để thêm khóa ngoại đến HIEUTRUONG
ALTER TABLE TRUONG ADD CONSTRAINT FK_TRUONG_HIEUTRUONG FOREIGN KEY (MaHT) REFERENCES HIEUTRUONG(MaHT)
GO

-- 4. Tạo bảng GIAOVIEN trước vì KHOA có tham chiếu đến GIAOVIEN (ChuNhiemKhoa)
CREATE TABLE GIAOVIEN (
    MaGV CHAR(10) PRIMARY KEY,
    TenGV NVARCHAR(100),
    NgaySinh DATE,
    GioiTinh NVARCHAR(10),
    DiaChi NVARCHAR(200),
    SDT VARCHAR(15),
    Luong DECIMAL(18,2),
	MaKhoa CHAR(10) )
GO

-- 5. Tạo bảng KHOA
CREATE TABLE KHOA (
    MaKhoa CHAR(10) PRIMARY KEY,
    TenKhoa NVARCHAR(100),
    NgTLap DATE,
    MaTruong CHAR(10),
    ChuNhiemKhoa CHAR(10),
    FOREIGN KEY (MaTruong) REFERENCES TRUONG(MaTruong),
    FOREIGN KEY (ChuNhiemKhoa) REFERENCES GIAOVIEN(MaGV) )
GO

-- Cập nhật GIAOVIEN để thêm khóa ngoại MaKhoa sau khi KHOA đã được tạo
ALTER TABLE GIAOVIEN ADD CONSTRAINT FK_GIAOVIEN_KHOA FOREIGN KEY (MaKhoa) REFERENCES KHOA(MaKhoa)
GO

-- 6. Tạo bảng MONHOC
CREATE TABLE MONHOC (
    MaMH CHAR(10) PRIMARY KEY,
    TenMH NVARCHAR(100),
    SoTinChi INT,
    MaKhoa CHAR(10)
    FOREIGN KEY (MaKhoa) REFERENCES KHOA(MaKhoa) )
GO

-- 7. Tạo bảng LOP
CREATE TABLE LOP (
    MaLop CHAR(10) PRIMARY KEY,
    TenLop NVARCHAR(100),
    SiSo INT,
    MaGV_ChuNhiem CHAR(10),
	FOREIGN KEY (MaGV_ChuNhiem) REFERENCES GIAOVIEN (MaGV) )
GO

-- 8. Tạo bảng SINHVIEN
CREATE TABLE SINHVIEN (
    MaSV CHAR(10) PRIMARY KEY,
    HoTen NVARCHAR(100),
    NgaySinh DATE,
    GioiTinh NVARCHAR(10),
    DiaChi NVARCHAR(200),
    SDT VARCHAR(15),
    MaLop CHAR(10),
	MaKhoa CHAR(10)
	FOREIGN KEY (MaLop) REFERENCES LOP(MaLop),
	FOREIGN KEY (MaKhoa) REFERENCES Khoa (MaKhoa))
GO

-- 9. Tạo bảng GIANGDAY (bảng liên kết nhiều-nhiều giữa GIAOVIEN và MONHOC)
CREATE TABLE GIANGDAY (
    MaGV CHAR(10),
    MaMH CHAR(10),
    PRIMARY KEY (MaGV, MaMH),
    FOREIGN KEY (MaGV) REFERENCES GIAOVIEN(MaGV),
    FOREIGN KEY (MaMH) REFERENCES MONHOC(MaMH) )
GO

-- 10. Tạo bảng HOC
CREATE TABLE HOC (
    MaSV CHAR(10) NOT NULL,
    MaMH CHAR(10) NOT NULL,
    Diem DECIMAL(4,2),
    PRIMARY KEY (MaSV, MaMH),
    FOREIGN KEY (MaSV) REFERENCES SINHVIEN(MaSV),
    FOREIGN KEY (MaMH) REFERENCES MONHOC(MaMH) )
GO

-- Chèn dữ liệu vào các bảng trong cơ sở dữ liệu QuanLyTrungTamDH
-- 1. Thông tin TRUNGTAM
INSERT INTO TRUNGTAM (MaTT, TenTT, DiaChi) VALUES
('TT01', N'Trung tâm Đào tạo Công nghệ', N'12 Nguyễn Văn Bảo, TP.HCM'),
('TT02', N'Trung tâm Đào tạo Kinh tế', N'254 Nguyễn Trãi, Hà Nội'),
('TT03', N'Trung tâm Giáo dục và Phát triển', N'45 Lê Lợi, Đà Nẵng'),
('TT04', N'Trung tâm Nghiên cứu Khoa học', N'67 Hùng Vương, Huế'),
('TT05', N'Trung tâm Sư phạm', N'89 Trần Hưng Đạo, Cần Thơ')
GO

-- 2. Thông tin HIEUTRUONG
INSERT INTO HIEUTRUONG (MaHT, TenHT, SDT, MaTruong) VALUES 
('HT01', N'ThS. Trần Quốc Việt', '0911111111', NULL),
('HT02', N'TS. Lê Thị Kim Oanh', '0922222222', NULL),
('HT03', N'PGS. Nguyễn Văn Hòa', '0933333333', NULL),
('HT04', N'TS. Phạm Hồng Sơn', '0944444444', NULL),
('HT05', N'ThS. Đỗ Thị Minh Thư', '0955555555', NULL)
GO

-- 3. Thông tin TRUONG
INSERT INTO TRUONG (MaTruong, TenTruong, DiaChi, MaHT, MaTT) VALUES 
('T01', N'ĐH Công nghiệp TP.HCM', N'12 Nguyễn Văn Bảo, TP.HCM', 'HT01', 'TT01'),
('T02', N'ĐH Kinh tế Quốc dân', N'254 Nguyễn Trãi, Hà Nội', 'HT02', 'TT02'),
('T03', N'ĐH Sư phạm Đà Nẵng', N'45 Lê Lợi, Đà Nẵng', 'HT03', 'TT03'),
('T04', N'ĐH Khoa học Huế', N'67 Hùng Vương, Huế', 'HT04', 'TT04'),
('T05', N'ĐH Cần Thơ', N'89 Trần Hưng Đạo, Cần Thơ', 'HT05', 'TT05')
GO

-- Cập nhật MaTruong cho HIEUTRUONG
UPDATE HIEUTRUONG SET MaTruong = 'T01' WHERE MaHT = 'HT01'
UPDATE HIEUTRUONG SET MaTruong = 'T02' WHERE MaHT = 'HT02'
UPDATE HIEUTRUONG SET MaTruong = 'T03' WHERE MaHT = 'HT03'
UPDATE HIEUTRUONG SET MaTruong = 'T04' WHERE MaHT = 'HT04'
UPDATE HIEUTRUONG SET MaTruong = 'T05' WHERE MaHT = 'HT05'
GO

-- 4. Thông tin GIAOVIEN chủ nhiệm khoa
INSERT INTO GIAOVIEN (MaGV, TenGV, NgaySinh, GioiTinh, DiaChi, SDT, Luong, MaKhoa) VALUES 
('GV01', N'ThS. Nguyễn Văn Tùng', '1980-05-12', N'Nam', N'TP.HCM', '0901111111', 20000000, NULL),
('GV02', N'ThS. Phạm Thị Hạnh', '1982-03-10', N'Nữ', N'Hà Nội', '0902222222', 19000000, NULL),
('GV03', N'TS. Trần Quốc Cường', '1979-07-19', N'Nam', N'Đà Nẵng', '0903333333', 21000000, NULL),
('GV04', N'ThS. Đinh Thị Trang', '1985-11-11', N'Nữ', N'Huế', '0904444444', 18500000, NULL),
('GV05', N'PGS. Vũ Hồng Quân', '1981-09-09', N'Nam', N'Cần Thơ', '0905555555', 22000000, NULL)
GO

-- 5. Thông tin KHOA
INSERT INTO KHOA (MaKhoa, TenKhoa, NgTLap, MaTruong, ChuNhiemKhoa) VALUES
('K01', N'Công nghệ Thông tin', '2000-01-01', 'T01', 'GV01'),
('K02', N'Kinh tế', '2001-03-03', 'T02', 'GV02'),
('K03', N'Ngoại ngữ', '2002-05-05', 'T03', 'GV03'),
('K04', N'Kỹ thuật', '2003-07-07', 'T04', 'GV04'),
('K05', N'Sư phạm', '2004-09-09', 'T05', 'GV05')
GO

-- Thông tin GIAOVIEN giảng dạy
INSERT INTO GIAOVIEN (MaGV, TenGV, NgaySinh, GioiTinh, DiaChi, SDT, Luong, MaKhoa) VALUES
('GV06', N'ThS. Lê Thị Thu Hà', '1986-06-01', N'Nữ', N'TP.HCM', '0906666666', 18000000, 'K01'),
('GV07', N'ThS. Nguyễn Minh Nhật', '1984-08-20', N'Nam', N'Hà Nội', '0907777777', 18500000, 'K02'),
('GV08', N'ThS. Bùi Thanh Tâm', '1987-10-15', N'Nữ', N'Đà Nẵng', '0908888888', 18200000, 'K03'),
('GV09', N'TS. Hồ Văn Dũng', '1983-12-12', N'Nam', N'Huế', '0909999999', 19000000, 'K04'),
('GV10', N'ThS. Võ Thị Kim Ngân', '1990-04-04', N'Nữ', N'Cần Thơ', '0910000000', 17500000, 'K05')
GO

-- Cập nhật MaKhoa cho GIAOVIEN chủ nhiệm
UPDATE GIAOVIEN SET MaKhoa = 'K01' WHERE MaGV = 'GV01'
UPDATE GIAOVIEN SET MaKhoa = 'K02' WHERE MaGV = 'GV02'
UPDATE GIAOVIEN SET MaKhoa = 'K03' WHERE MaGV = 'GV03'
UPDATE GIAOVIEN SET MaKhoa = 'K04' WHERE MaGV = 'GV04'
UPDATE GIAOVIEN SET MaKhoa = 'K05' WHERE MaGV = 'GV05'
GO

-- 6. Thông tin MONHOC
INSERT INTO MONHOC (MaMH, TenMH, SoTinChi, MaKhoa) VALUES
('MH01', N'Lập trình C++', 3, 'K01'),
('MH02', N'Kinh tế học vi mô', 3, 'K02'),
('MH03', N'Giao tiếp tiếng Anh', 2, 'K03'),
('MH04', N'Cơ học công trình', 3, 'K04'),
('MH05', N'Tâm lý học giáo dục', 2, 'K05')
GO

-- 7. Thông tin LOP
INSERT INTO LOP (MaLop, TenLop, SiSo, MaGV_ChuNhiem) VALUES
('L01', N'Lớp CNTT 1', 45, 'GV06'),
('L02', N'Lớp Kinh tế 1', 40, 'GV07'),
('L03', N'Lớp Ngoại ngữ 1', 38, 'GV08'),
('L04', N'Lớp Kỹ thuật 1', 35, 'GV09'),
('L05', N'Lớp Sư phạm 1', 42, 'GV10')
GO

-- 8. Thông tin SINHVIEN
INSERT INTO SINHVIEN (MaSV, HoTen, NgaySinh, GioiTinh, DiaChi, SDT, MaLop, MaKhoa) VALUES 
('SV01', N'Nguyễn Văn A', '2003-01-01', N'Nam', N'TP.HCM', '0981111111', 'L01', 'K01'),
('SV02', N'Trần Thị B', '2003-02-02', N'Nữ', N'Hà Nội', '0982222222', 'L02', 'K02'),
('SV03', N'Lê Văn C', '2003-03-03', N'Nam', N'Đà Nẵng', '0983333333', 'L03', 'K03'),
('SV04', N'Phạm Thị D', '2003-04-04', N'Nữ', N'Huế', '0984444444', 'L04', 'K04'),
('SV05', N'Đỗ Văn E', '2003-05-05', N'Nam', N'Cần Thơ', '0985555555', 'L05', 'K05')
GO

-- 9. Thông tin GIANGDAY
INSERT INTO GIANGDAY (MaGV, MaMH) VALUES 
('GV06', 'MH01'),
('GV07', 'MH02'),
('GV08', 'MH03'),
('GV09', 'MH04'),
('GV10', 'MH05')
GO

-- 10. Thông tin HOC
INSERT INTO HOC (MaSV, MaMH, Diem) VALUES
('SV01', 'MH01', 8.5),
('SV02', 'MH02', 7.0),
('SV03', 'MH03', 9.0),
('SV04', 'MH04', 6.5),
('SV05', 'MH05', 8.0)
GO

-- Kiểm tra thông tin các bảng
SELECT * FROM TRUNGTAM
SELECT * FROM TRUONG
SELECT * FROM HIEUTRUONG
SELECT * FROM GIAOVIEN
SELECT * FROM KHOA
SELECT * FROM MONHOC
SELECT * FROM LOP
SELECT * FROM SINHVIEN
SELECT * FROM GIANGDAY
SELECT * FROM HOC

-- Câu 4 Phần A
-- Câu 1: Liệt kê các khoa có từ 2 giáo viên trở lên, gồm MaKhoa, TenKhoa, và số lượng giáo viên.
SELECT K.MaKhoa, K.TenKhoa, COUNT(GV.MaGV) AS SoLuongGV
FROM KHOA K
JOIN GIAOVIEN GV
ON K.MaKhoa = GV.MaKhoa
GROUP BY K.MaKhoa, K.TenKhoa
HAVING COUNT(GV.MaGV) >= 2
GO

-- Câu 2: Tìm các giáo viên có giảng dạy ít nhất 1 môn thuộc khoa Công nghệ Thông tin, gồm MaGV, TenGV.
SELECT GV.MaGV, GV.TenGV
FROM GIAOVIEN GV
WHERE EXISTS (	SELECT GD.MaGV FROM GIANGDAY GD
				JOIN MONHOC MH ON GD.MaMH = MH.MaMH
				JOIN KHOA K ON MH.MaKhoa = K.MaKhoa
				WHERE GD.MaGV = GV.MaGV AND K.TenKhoa = N'Công nghệ Thông tin')
GO

-- Câu 3: Tìm các giáo viên có mức lương cao hơn mức lương trung bình của khoa mà họ đang giảng dạy.
SELECT GV.MaGV, GV.TenGV, GV.Luong, K.TenKhoa
FROM GIAOVIEN GV
JOIN KHOA K ON GV.MaKhoa = K.MaKhoa
WHERE GV.Luong > (	SELECT AVG(Luong) FROM GIAOVIEN
					WHERE MaKhoa = GV.MaKhoa )
ORDER BY K.TenKhoa ASC, GV.Luong DESC
GO

-- Câu 4: Cập nhật số điện thoại cho hiệu trưởng của trường Đại học Công nghiệp TP.HCM.
UPDATE HIEUTRUONG
SET SDT = N'0966666666'
WHERE MaHT IN (
    SELECT HT.MaHT
    FROM HIEUTRUONG HT
    JOIN TRUONG T ON HT.MaHT = T.MaHT
    WHERE T.TenTruong = N'ĐH Công nghiệp TP.HCM')
GO

-- Câu 5:  Liệt kê sinh viên Nam thuộc khoa Công nghệ thông tin học lớp CNTT 1.
SELECT SV.MaSV, SV.HoTen, SV.NgaySinh, SV.DiaChi, SV.SDT, L.TenLop, K.TenKhoa
FROM SINHVIEN SV
JOIN LOP L ON SV.MaLop = L.MaLop
JOIN KHOA K ON SV.MaKhoa = K.MaKhoa
WHERE SV.GioiTinh = N'Nam'
AND K.TenKhoa = N'Công nghệ Thông tin'
AND L.TenLop = N'Lớp CNTT 1'
GO

-- Câu 6:  Cho biết tên các khoa không có giảng viên nào dạy trên 10 lớp
SELECT K.TenKhoa, K.MaKhoa
FROM KHOA K
WHERE K.MaKhoa NOT IN (	SELECT DISTINCT GV.MaKhoa
						FROM GIAOVIEN GV
						JOIN GIANGDAY GD ON GV.MaGV = GD.MaGV
						GROUP BY GV.MaGV, GV.MaKhoa
						HAVING COUNT(GD.MaMH) > 10 )
ORDER BY K.TenKhoa
GO

-- Câu 7: Xóa các trường không có khoa nào quản lý.
DELETE FROM TRUONG
WHERE MaTruong NOT IN (	SELECT DISTINCT MaTruong FROM KHOA
						WHERE MaTruong IS NOT NULL )
AND MaTruong IN (	SELECT T.MaTruong FROM TRUONG T
					LEFT JOIN KHOA K ON T.MaTruong = K.MaTruong
					GROUP BY T.MaTruong
					HAVING COUNT(K.MaKhoa) = 0 )
GO

-- Câu 8: Cập nhật lương tăng 10% cho giáo viên là chủ nhiệm khoa và dạy môn có số tín chỉ >= 3 tại các trường ở TP.HCM. 
UPDATE GIAOVIEN
SET Luong = Luong * 1.1
WHERE MaGV IN (	SELECT GV.MaGV FROM GIAOVIEN GV
				JOIN KHOA K ON GV.MaGV = K.ChuNhiemKhoa
				JOIN TRUONG T ON K.MaTruong = T.MaTruong
				JOIN GIANGDAY GD ON GV.MaGV = GD.MaGV
				JOIN MONHOC MH ON GD.MaMH = MH.MaMH
				WHERE T.DiaChi LIKE N'%TP.HCM%'
				AND MH.SoTinChi >= 3 )
GO

-- Câu 9: Tìm giáo viên có lương cao nhất mỗi khoa.
SELECT  K.TenKhoa, GV.TenGV, GV.Luong
FROM GIAOVIEN GV
JOIN KHOA K ON GV.MaKhoa = K.MaKhoa
WHERE GV.Luong = (	SELECT MAX(Luong) FROM GIAOVIEN
					WHERE MaKhoa = GV.MaKhoa )
ORDER BY GV.Luong DESC
GO

-- Câu 10: Hãy liệt kê mã và tên giáo viên kèm theo tên môn học họ đang giảng dạy.
SELECT GV.MaGV, GV.TenGV, MH.TenMH
FROM GIAOVIEN GV
JOIN GIANGDAY GD ON GV.MaGV = GD.MaGV
JOIN MONHOC MH ON GD.MaMH = MH.MaMH
GO

-- Câu 11: Xóa các môn học không có giáo viên nào giảng dạy.
DELETE FROM MONHOC
WHERE MaMH NOT IN (SELECT DISTINCT MaMH FROM GIANGDAY)
GO

-- Câu 12: Tìm mã và tên các khoa có số lượng sinh viên có ít nhất 1 người.
SELECT K.MaKhoa, K.TenKhoa
FROM KHOA K
JOIN GIAOVIEN GV ON GV.MaKhoa = K.MaKhoa
JOIN LOP L ON L.MaGV_ChuNhiem = GV.MaGV
JOIN SINHVIEN SV ON SV.MaLop = L.MaLop
GROUP BY K.MaKhoa, K.TenKhoa
HAVING COUNT(SV.MaSV) >= 1
GO

-- Câu hỏi cuối kỳ Cơ sở dữ liệu
-- Câu 1: Tìm giáo viên chưa dạy môn nào
SELECT GV.MaGV, GV.TenGV
FROM GIAOVIEN GV
WHERE GV.MaGV NOT IN (SELECT MaGV FROM GIANGDAY)
GO

SELECT * FROM GIAOVIEN
SELECT * FROM GIANGDAY

-- Câu 2: Tìm giáo viên dạy nhiều môn nhất
SELECT GV.MaGV, GV.TenGV, COUNT(GD.MaMH) AS SoMonDay
FROM GIAOVIEN GV
JOIN GIANGDAY GD ON GV.MaGV = GD.MaGV
GROUP BY GV.MaGV, GV.TenGV
ORDER BY COUNT(GD.MaMH) DESC
GO
