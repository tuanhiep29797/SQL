--1. Tạo cơ sở dữ liệu
--Tạo cơ sở dữ liệu với tên ProductManagementSystem

create database ProductManagementSystem
go

--Sử dụng cơ sở dữ liệu vừa tạo

use ProductManagementSystem
go

--2. Tạo bảng
--tblUser – bảng lưu thông tin người dùng
--UserID: INT, NOT NULL
--UserName: NVARCHAR(50)

create table tblUser
(
	UserID int not null,
	UserName nvarchar(50)
)
go

--tblOrder – bảng lưu thông tin đơn hàng
--OrderID: INT, NOT NULL
--UserID: INT, NOT NULL
--OrderDate: DATETIME

create table tblOrder
(
	OrderID int not null,
	UserID int not null,
	OrderDate datetime
)
go

--tblProduct – bảng lưu thông tin sản phẩm
--ProductID: INT, NOT NULL
--ProductName: NVARCHAR(50)
--Quantity: INT
--Price: MONEY
--Description: NTEXT

create table tblProduct
(
	ProductID int not null,
	ProductName nvarchar(50),
	Quantity int,
	Price money,
	Description ntext
)
go

--tblOrderDetail – bảng lưu thông tin chi tiết đơn hàng
--OrderID: INT, NOT NULL
--ProductID: INT, NOT NULL
--Quantity: INT
--Price: MONEY

create table tblOrderDetail
(
	OrderID int not null,
	ProductID int not null,
	Quantity int, 
	Price money
)
go

--3. Tạo Index và thay đổi bảng
--Tạo Clustered Index:
--CI_tblUser_UserID trên tblUser(UserID)
	
create clustered index CI_tblUser_UserID on tblUser (UserID)
go

--Xóa clustered index vừa tạo.

drop index CI_tblUser_UserID
go

--Alter table tblUser, thêm cột [BirthDate] với kiểu dữ liệu DATETIME.

alter table tblUser
add BirthDate datetime
go

--Ràng buộc DEFAULT
--DF_tblOrder_OrderDate → Bảng: tblOrder, Cột: OrderDate, Giá trị mặc định: GETDATE()

alter table tblOrder
add constraint DF_tblOrder_OrderDate default getdate() for OrderDate
go
 
--Khóa chính (PRIMARY KEY)
--PK_tblUser → tblUser(UserID)

alter table tblUser
add constraint PK_tblUser primary key (UserID)
go

--PK_tblOrder → tblOrder(OrderID)

alter table tblOrder
add constraint PK_tblOrder primary key (OrderID)
go

--PK_tblProduct → tblProduct(ProductID)

alter table tblProduct
add constraint PK_tblProduct primary key (ProductID)
go

--PK_tblOrderDetail → tblOrderDetail(OrderID, ProductID)

alter table tblOrderDetail
add constraint PK_tblOrderDetail primary key (OrderID, ProductID)
go

--Khóa ngoại (FOREIGN KEY)
--FK_tblOrder_tblUser → tblOrder(UserID) → tblUser(UserID)

alter table tblOrder
add constraint FK_tblOrder_tblUser foreign key (UserID) references tblUser(UserID)
go

--FK_tblOrderDetail_tblOrder → tblOrderDetail(OrderID) → tblOrder(OrderID)

alter table tblOrderDetail
add constraint FK_tblOrderDetail_tblOrder foreign key (OrderID) references tblOrder(OrderID)
go

--FK_tblOrderDetail_tblProduct → tblOrderDetail(ProductID) → tblProduct(ProductID)

alter table tblOrderDetail
add constraint FK_tblOrderDetail_tblProduct foreign key (ProductID) references tblProduct(ProductID)
go

--Ràng buộc CHECK
--CK_tblOrder_OrderDate → tblOrder(OrderDate), điều kiện: OrderDate nằm trong khoảng từ ‘2000-01-01’ đến ngày hiện tại

alter table tblOrder
add constraint CK_tblOrder_OrderDate check (OrderDate between '2000-01-01' and getdate())
go

--Ràng buộc UNIQUE
--UN_tblUser_UserName → tblUser(UserName)

alter table tblUser
add constraint UN_tblUser_UserName unique (UserName)
go

--5. Thêm dữ liệu
--tblUser:
--stevejobs – 1996-08-28
--billgates – 1998-06-18
--larry – 1997-05-25
--mark – 1984-03-27
--dell – 1955-08-15
--eric – 1955-07-28

insert into dbo.tblUser
values
('stevejobs', '1996-08-28'),
('billgates', '1998-06-18'),
('larry', '1997-05-25'),
('mark', '1984-03-27'),
('dell', '1955-08-15'),
('eric', '1955-07-28')
go

--tblOrder:
--(UserID=2, 2002-12-01)
--(UserID=3, 2000-03-02)
--(UserID=2, 2004-08-03)
--(UserID=1, 2001-05-12)
--(UserID=4, 2002-10-04)
--(UserID=6, 2002-03-08)
--(UserID=5, 2002-05-02)

insert into dbo.tblOrder
values
(2, '2002-12-01'),
(3, '2000-03-02'),
(2, '2004-08-03'),
(1, '2001-05-12'),
(4, '2002-10-04'),
(6, '2002-03-08'),
(5, '2002-05-02')
go

--tblProduct:
--Asus Zen – 2 – 10 – "See what others can’t see."
--BPhone – 10 – 20 – "The first flat-design smartphone in the world."
--iPhone – 13 – 300 – "The only thing that’s changed is everything."
--XPéria – 7 – 80 – "The world’s first 4K smartphone."
--Galaxy Note – 12 – 120 – "Created to reflect your desire."

insert into dbo.tblProduct
values
('Asus Zen', 2, 10, 'See what others can’t see.'),
('BPhone', 10, 20, 'The first flat-design smartphone in the world.'),
('iPhone', 13, 300, 'The only thing that’s changed is everything.'),
('XPéria', 7, 80, 'The world’s first 4K smartphone.'),
('Galaxy Note', 12, 120, 'Created to reflect your desire.')
go

--tblOrderDetail:
--(1,1,10,10)
--(1,2,4,20)
--(2,3,5,50)
--(3,4,6,80)
--(4,2,21,120)
--(5,2,122,300)

insert into dbo.tblOrderDetail
values
(1,1,10,10),
(1,2,4,20),
(2,3,5,50),
(3,4,6,80),
(4,2,21,120),
(5,2,122,300)
go


--6. Các thao tác Query
--Cập nhật [Price] trong bảng [tblProduct] giảm 10%, với điều kiện [ProductID] = 3.

update tblProduct set Price = Price * 0.9
where ProductID = 3
go

--Hiển thị dữ liệu từ 4 bảng tblUser, tblOrder, tblOrderDetail, tblProduct gồm:
--(UserName, OrderID, OrderDate, Quantity, Price, ProductName)

select u.UserName, o.OrderID, o.OrderDate, od.Quantity, od.Price, p.ProductName
from tblUser u left join tblOrder o on u.UserID = o.UserID
left join tblOrderDetail od on o.OrderID = od.OrderID
left join tblProduct p on od.ProductID = p.ProductID
go

--7. View
--Tạo view tên [view_Top2Product] để hiển thị 2 sản phẩm bán chạy nhất.

create view view_Top2Product
as
select top(2) p.ProductName, sum(od.Quantity) 'So luong'
from tblOrderDetail od left join tblProduct p on od.ProductID = p.ProductID
group by p.ProductName
order by 'So luong' desc
offset 0 rows
go

select * from view_Top2Product
go

--8. Thủ tục (Procedure)
--Tạo thủ tục tên [sp_TimSanPham] với tham số:
--@GiaMua MONEY (giá tối đa để lọc sản phẩm)
--@count INT OUTPUT (tổng số bản ghi tìm thấy)

create proc sp_TimSanPham
	@GiaMua money,
	@count int output
as
begin
	select * from tblProduct
	where Price <= @GiaMua

	select @count = count(*) from tblProduct
	where Price <= @GiaMua
end
go

--Thực thi [sp_TimSanPham] với @GiaMua = 50.
declare @count_output int
exec sp_TimSanPham 50, @count_output output
go

--9. Trigger
--Tạo trigger cho sự kiện UPDATE tên [TG_tblProduct_Update] để kiểm tra giá trị cột [Price] trong bảng tblProduct.

create trigger TG_tblProduct_Update on tblProduct
for update
as
begin
	if (select count(*) from inserted where (price < 10)) > 0
	begin
		print N'You don’t update price less than 10'
		rollback transaction
	end
end
go

--Nếu Price < 10 → rollback và in ra thông báo: “You don’t update price less than 10”.

--Xóa trigger này.

drop trigger TG_tblProduct_Update
go

--10. Trigger
--Tạo trigger cho sự kiện UPDATE tên [TG_tblUser_Update] để kiểm tra giá trị cột [UserName] trong bảng tblUser.
--Nếu cột UserName bị cập nhật → rollback và in ra thông báo: “You don’t update the column UserName”.

create trigger TG_tblUser_Update on tblUser
for update
as
begin
	if update(UserName)
	begin
		print N'You don’t update the column UserName'
		rollback transaction
	end
end
go