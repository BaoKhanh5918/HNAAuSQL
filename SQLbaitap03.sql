--bài 1 
declare @mausac nvarchar(15);
set @mausac = N'Black';
select * from Production.Product
where color = @mausac;
-- bài 2 
if exists(select 1 from HumanResources.Employee
where JobTitle = 'Chief Executive Officer')
begin
print N'Đã tìm thấy Giám đốc đièu hành trong hệ thống.';
end
else
begin
print N'Hệ thống hiện chưa có thông tin Giám Đốc điều hành.';
end 
-- bài 3 
create procedure sp_LayDanhSachNhanVienSale
as 
begin 
select BusinessEntityID, JobTitle, VacationHours
from HumanResources.Employee
where JobTitle Like '%Sale%';
end;
go 
exec sp_LayDanhSachNhanVienSale;
-- bài 4
create procedure sp_TimKiemSanPhamTheoGia
@GiaToiThieu Money, @GiaToiDa Money
as
begin
select ProductID, Name, ListPrice
from Production.Product
where ListPrice between @GiaToiThieu and @GiaToiDa;
end
go
exec  sp_TimKiemSanPhamTheoGia
@GiaToiThieu = 100, @GiaToiDa = 500; 
-- bài 5 
create procedure sp_KiemTraVaCapNhatGia
@ProductID int, @GiaMoi money
as
begin
if exists(select 1 from Production.Product where ProductID = @ProductID)
begin
if @GiaMoi <= 0
begin 
Print N'Lỗi: Giá sản phẩm phải lớn hơn 0';
end
else
begin
update Production.Product
set ListPrice = @GiaMoi
where ProductID = @ProductID;
Print N'Cập nhật giá thành công!';
end
end
else
begin
Print N'Lỗi:Không tìm thấy mã sản phẩm này';
end
end
go
exec sp_KiemTraVaCapNhatGia 680, 150;















