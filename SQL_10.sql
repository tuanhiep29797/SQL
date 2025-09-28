--1. Mô tả bài toán
--Trung tâm Aptech xây dựng một căng-tin để phục vụ sinh viên và nhân viên. Ứng dụng cần hỗ trợ 3 loại đối tượng chính: Quản lý, Nhân viên, Phục vụ.
--Các chức năng chính:
--Quản lý sản phẩm bán trong căng-tin.
--Tạo lập và quản lý hóa đơn bán hàng.
--Quản lý nhân viên.
--Thống kê sản phẩm và doanh thu.
--Ứng dụng được triển khai trên SQL Server với các yêu cầu:
--Tạo CSDL, bảng, khóa chính, khóa ngoại, unique, check.
--Thêm, sửa, xóa dữ liệu có điều kiện.
--Truy vấn dữ liệu.
--Nonclustered Index.
--View (2 câu).
--Stored Procedure (2 câu).
--Trigger (2 câu: update và insert).
--2. Thiết kế CSDL

create database Canteen
go

use Canteen
go

--Bảng Staff (Nhân viên)
--StaffID: INT, PRIMARY KEY, IDENTITY(1,1)
--FullName: NVARCHAR(100), NOT NULL
--Gender: CHAR(1), CHECK (Gender IN ('M','F'))
--BirthDate: DATE, NULL
--Phone: VARCHAR(15), UNIQUE
--Position: NVARCHAR(50), NOT NULL
--Salary: DECIMAL(12,2), DEFAULT 0

create table Staff
(
	StaffID int primary key identity(1,1),
	FullName nvarchar(100) not null,
	Gender char(1) check (Gender in ('M', 'F')),
	BirthDate date null,
	Phone varchar(15) unique,
	Position nvarchar(50) not null,
	Salary decimal(12,2) default(0)
)
go

--Bảng Customer (Khách hàng – tùy chọn)
--CustomerID: INT, PRIMARY KEY, IDENTITY(1,1)
--FullName: NVARCHAR(100), NOT NULL
--Phone: VARCHAR(15), NULL

create table Customer
(
	CustomerID int primary key identity(1,1),
	FullName nvarchar(100) not null,
	Phone varchar(15) null
)
go

--Bảng Product (Sản phẩm)
--ProductID: INT, PRIMARY KEY, IDENTITY(1,1)
--ProductName: NVARCHAR(100), NOT NULL
--Unit: NVARCHAR(20), NOT NULL
--Price: DECIMAL(12,2), CHECK (Price >= 0)
--Quantity: INT, CHECK (Quantity >= 0)
--Category: NVARCHAR(50), NULL

create table Product
(
	ProductID INT PRIMARY KEY IDENTITY(1,1),
	ProductName NVARCHAR(100) NOT NULL,
	Unit NVARCHAR(20) NOT NULL,
	Price DECIMAL(12,2) CHECK (Price >= 0),
	Quantity INT CHECK (Quantity >= 0),
	Category NVARCHAR(50) NULL
)
go

--Bảng Bill (Hóa đơn)
--BillID: INT, PRIMARY KEY, IDENTITY(1,1)
--BillDate: DATETIME, DEFAULT GETDATE()
--StaffID: INT, FOREIGN KEY REFERENCES Staff(StaffID)
--CustomerID: INT, FOREIGN KEY REFERENCES Customer(CustomerID), NULL
--TotalAmount: DECIMAL(12,2), DEFAULT 0

create table Bill
(
	BillID INT PRIMARY KEY IDENTITY(1,1),
	BillDate DATETIME DEFAULT GETDATE(),
	StaffID INT FOREIGN KEY REFERENCES Staff(StaffID),
	CustomerID INT FOREIGN KEY REFERENCES Customer(CustomerID) NULL,
	TotalAmount DECIMAL(12,2) DEFAULT 0
)
go

--Bảng BillDetail (Chi tiết hóa đơn)
--BillDetailID: INT, PRIMARY KEY, IDENTITY(1,1)
--BillID: INT, FOREIGN KEY REFERENCES Bill(BillID)
--ProductID: INT, FOREIGN KEY REFERENCES Product(ProductID)
--Quantity: INT, CHECK (Quantity > 0)
--UnitPrice: DECIMAL(12,2), NOT NULL
--SubTotal: DECIMAL(12,2), NOT NULL

create table BillDetail
(
	BillDetailID INT PRIMARY KEY IDENTITY(1,1),
	BillID INT FOREIGN KEY REFERENCES Bill(BillID),
	ProductID INT FOREIGN KEY REFERENCES Product(ProductID),
	Quantity INT CHECK (Quantity > 0),
	UnitPrice DECIMAL(12,2) NOT NULL,
	SubTotal DECIMAL(12,2) NOT NULL
)
go

--3. Yêu cầu triển khai

--Tạo Database và Table với các ràng buộc:

--PRIMARY KEY, FOREIGN KEY.

--CHECK, UNIQUE.

--Thao tác dữ liệu:

--INSERT: Thêm dữ liệu mẫu cho các bảng.


-- Nhân viên
insert into Staff (FullName, Gender, BirthDate, Phone, Position, Salary) 
values
(N'Nguyễn Văn A', 'M', '1990-05-10', '0901234567', N'Quản lý', 15000000),
(N'Trần Thị B', 'F', '1995-08-20', '0902345678', N'Nhân viên bán hàng', 8000000),
(N'Lê Văn C', 'M', '1998-12-15', '0903456789', N'Phục vụ', 6000000)
go

-- Khách hàng
insert into Customer (FullName, Phone) 
values
(N'Phạm Minh H', '0911111111'),
(N'Lưu Thảo N', '0922222222'),
(N'Nguyễn Văn D', null)
go

-- Sản phẩm
insert into Product (ProductName, Unit, Price, Quantity, Category) 
values
(N'Cơm gà', N'Phần', 35000, 50, N'Đồ ăn'),
(N'Mì xào bò', N'Phần', 40000, 30, N'Đồ ăn'),
(N'Coca-Cola', N'Lon', 12000, 100, N'Nước uống'),
(N'Trà đá', N'Cốc', 3000, 200, N'Nước uống'),
(N'Bánh mì trứng', N'Ổ', 20000, 40, N'Đồ ăn')
go

-- Hóa đơn
insert into Bill (BillDate, StaffID, CustomerID, TotalAmount) 
values
('2025-09-25 10:15:00', 2, 1, 94000),
('2025-09-25 11:30:00', 3, 2, 49000)
go

-- Chi tiết hóa đơn
insert into BillDetail (BillID, ProductID, Quantity, UnitPrice, SubTotal) 
values
(1, 1, 2, 35000, 70000),
(1, 3, 2, 12000, 24000),
(2, 2, 1, 40000, 40000),
(2, 4, 3, 3000, 9000)
go

--UPDATE: Sửa dữ liệu có điều kiện (VD: cập nhật lương nhân viên).

update Staff set Salary = 16000000
where StaffID = 1
go

--DELETE: Xóa dữ liệu có điều kiện (VD: xóa sản phẩm hết hạn).

delete from Bill
where BillDate > getdate()
go

--SELECT: Truy vấn dữ liệu.

select * from Staff
go

--Nonclustered Index:

create nonclustered index NIX_position on Staff (Position)
go

--Tạo chỉ mục phụ cho cột ProductName trong bảng Product.

create index IX_productname on Product (ProductName)
go

--View (2 câu):

--View 1: Danh sách sản phẩm và số lượng tồn kho.

create view view_danh_sach_ton_kho
as
select p.ProductName, p.Quantity - sum(bd.Quantity) 'Ton kho'
from Product p inner join BillDetail bd on p.ProductID = bd.ProductID
group by p.ProductName, p.Quantity
go

select * from view_danh_sach_ton_kho
go

--View 2: Thống kê doanh thu theo ngày.

create view view_doanh_thu_theo_ngay
as
select cast(BillDate as Date) 'Date', sum(TotalAmount) 'Total'
from Bill
group by cast(BillDate as Date)
go


select * from view_doanh_thu_theo_ngay
go

--Stored Procedure (2 câu):

--SP1: Tạo mới hóa đơn cùng chi tiết.

create proc proc_new_bill
	@BillDate DATETIME,
	@StaffID INT,
	@CustomerID INT,
	@TotalAmount DECIMAL(12,2),
	@BillID INT,
	@ProductID INT,
	@Quantity INT,
	@UnitPrice DECIMAL(12,2),
	@SubTotal DECIMAL(12,2)
as
begin
	insert into dbo.Bill
	values
	(@BillDate, @StaffID, @CustomerID, @TotalAmount)

	insert into dbo.BillDetail
	values
	(@BillID, @ProductID, @Quantity, @UnitPrice, @SubTotal)
end
go

--SP2: Tìm kiếm sản phẩm theo tên hoặc mã.

create proc proc_search_product
	@ProductID int,
	@ProductName nvarchar(100)
as
begin
	select * from Product
	where ProductID = @ProductID or ProductName = @ProductName
end
go

--Trigger (2 câu):

--Trigger 1: AFTER UPDATE trên bảng BillDetail → Cập nhật lại TotalAmount trong Bill.

create trigger trigger_after_update on BillDetail
after update
as
begin
	update Bill set TotalAmount = sum(bd.SubTotal)
	from Bill inner join BillDetail bd on Bill.BillID = bd.BillID
end
go

--Trigger 2: FOR INSERT trên bảng Staff → Xuất thông báo/log khi thêm nhân viên mới.

create trigger trigger_insert_staff on Staff
for insert
as
begin
	print N'Đã thêm nhân viên mới'
end
go