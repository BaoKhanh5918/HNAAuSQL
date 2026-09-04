-- bài 1 
use AdventureWorks2025;
go 
if OBJECT_ID('Production.ProductPriceLog', 'U') is not Null
   drop table Production.ProductionPriceLog;
go 
create table Production.ProductPriceLog
   (LogID int Identity(1,1) Primary Key, ProductID int not Null, OldPrice Money,NewPrice Money, ModifiedDate DateTime default GetDate());
go 
if object_ID('Production.trg_LogPriceChange','TR') is not Null
   drop trigger Production.trg_LogPriceChage;
go 
create trigger Production.trg_LogPriceChange
on Production.Product
after update
as
begin
  set nocount on;
if update(ListPrice)
begin
  insert into Production.ProductPriceLog (ProductID, OldPrice, NewPrice, ModifiedDate)
  select d.ProductID, d.ListPrice, i.ListPrice,GetDate()
  from deleted as d
  inner join inserted as i
       on d.ProductID = i.ProductID
  where isnull(d.ListPrice,0) <> isnull(i.ListPrice, 0);
  end
end;
go 
update Production.Product 
set ListPrice = ListPrice + 100
where ProductID = 680;
go 
select * from Production.ProductPriceLog
order by LogID;
go

-- bài 2
use AdventureWorks2025;
go 
if object_ID('Sale.trg_PreventInvaliOrderQty', 'TR') is not Null
   drop trigger Sales.trg_PrevenInvaliOrderQty;
go 
create trigger Sales.trg_PreventInvaliOrderQty
on Sales.SalesOrderDetail
after insert, update
as
begin
     set nocount on;
     if exists( select 1 from inserted i inner join 
     (select ProductID, Sum(Quantity) as Quantity from Production.ProductInventory group by ProductID) pi
     on i.ProductID = pi.ProductID
     where i.OrderQty > pi.Quantity)
begin
raiserror(N'Số lượng đặt hàng không được lớn hơn số lượng tồn kho!',16,1);
rollback transaction;
return;
end
end;
go 

-- bài 3
use AdventureWorks2025;
go
if object_ID('dbo.sp_TransferInventory','P') is not Null 
   drop procedure dbo.sp_TransferInventory; 
go 
create procedure dbo.sp_TransferInventory
      @ProductID int, @FromLocationID smallint, @ToLocationID smallint, @Quantity int
as
begin 
   set nocount on;
begin try 
     update Production.ProductInventory
     set Quantity = Quantity - @Quantity
     where ProductID = @ProductID
     and LocationID = @FromLocationID;
if exists
(select 1 from Production.ProductInventory
          where ProductID = @ProductID
          and LocationID = @FromLocationID
          and Quantity < 0)
begin 
     rollback transaction; 
     raiserror(N'Không đủ hàng để chuyển',16,1);
     return;
end;
   update Production.ProductInventory
   set Quantity = Quantity + @Quantity
   where ProductID = @ProductID
   and LocationID = @ToLocationID;
   commit transaction;
end try
begin catch 
      if @@TRANCOUNT > 0
         rollback transaction;
      raiserror(N'Có lỗi xảy ra khi chuyển tồn kho',16,1);
      return;
end catch
end;
go 
exec dbo.sp_TransferInventory
     @ProductID = 680,
     @FromLocationID = 1,
     @ToLocationID = 6,
     @Quantity = 10;
go 

-- bài 4 
use AdventureWorks2025
go 
if object_ID('dbo.sp_SafeDeleteProduct','P') is not Null 
   drop procedure dbo.sp_SafeDeleteProduct;
go 
create procedure dbo.sp_SafeDeleteProduct
                 @ProductID int
as 
begin
     set nocount on; 
     begin transaction;
     begin try 
          Delete from Production.ProductInventory
          where ProductID = @ProductID;
          Delete from Production.ProductCostHistory
          where ProductID = @ProductID;
          Delete from Production.Product
          where ProductID = @ProductID;
          commit transaction;
    end try 
    begin catch 
         if @@TRANCOUNT > 0
            rollback transaction; 
        raiserror(N'Xóa sản phẩm thất bại.Giao dịch đã được RollBack.',16,1);
        return;
    end catch 
end;
go 
exec dbo.sp_SafeDeleteProduct @ProductID = 680;
go 


-- bài 5 
use AdventureWorks2025
go 
declare @BusinessEntityID int, @JobTitle NvarChar(50), @VacationHours int;
declare EmployeeCursor Cursor for 
select 
      e.BusinessEntityID, e.JobTitle, e.VacationHours 
from HumanResources.Employee as e 
inner join HumanResources.EmployeeDepartmentHistory as edh
      on e.BusinessEntityID = edh.BusinessEntityID
inner join HumanResources.Department as d
      on edh.DepartmentID = d.DepartmentID
where d.Name = N'Research and Development'
   and edh.EndDate is Null; 
Open EmployeeCursor;
fetch next from EmployeeCursor
into @BusinessentityID, @JobTitle, @VacationHours;
while @@FETCH_STATUS = 0
begin
     Print N'Nhân viên: ' + @JobTitle + N' - Mã NV: ' + cast(@BusinessEntityID as NvarChar(10))+
     N' - Số giờ nghỉ phép hiện tại: ' + cast(@VacationHours as NvarChar(10));
fetch next from EmployeeCursor
into @BusinessEntityID, @JobTitle, @VacationHours;
end;
close EmployeeCursor;
deallocate EmployeeCursor; 
go 

                                                   