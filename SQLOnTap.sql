-- bài 1 




-- bài 2 
use AdventureWorks2025;
go 
select 
      P.ProductID,
      P.Name as TenSanPham,
      sum(SOD.OrderQty) as TongSoLuongBan, 
      rank() over (Order by sum(SOD.OrderQty) desc) as XepHang
from Sales.SalesOrderDetail as SOD 
inner join Production.Product as P 
      on SOD.ProductID = P.ProductID
group by P.ProductID, P.Name
order by TongSoLuongBan desc,
         TenSanPham asc;
go 

-- bài 3 
use AdventureWorks2025;
go 
declare @year int = 2013;
with DanhSachThang as 
( select 1 as Thang 
  union all select 2
  union all select 3
  union all select 4
  union all select 5
  union all select 6
  union all select 7 
  union all select 8
  union all select 9 
  union all select 10 
  union all select 11
  union all select 12 ),
DoanhThuTheoThang as (select month(OrderDate) as Thang,
                             sum(TotalDue) as DoanhThu
                      from Sales.SalesOrderHeader 
                      where year(OrderDate) = @year
                      group by month(OrderDate))
select DST.Thang, IsNull(DTT.DoanhThu, 0) as DoanhThu
from DanhSachThang as DST
left join DoanhThuTheoThang as DTT
     on DST.Thang = DTT.Thang
order by DST.Thang;
go 

-- bài 4 
use AdventureWorks2025;
go 
declare @year int = 2013;
select CustomerID, count(SalesOrderID) as SoDonHang
from Sales.SalesOrderHeader
where year(OrderDate) = @year
group by CusTomerID
having count(SalesOrderID) >= 3
order by SoDonHang desc;
go 

-- bài 5 
use AdventureWorks2025;
go 
select top 3 
       P.ProductID,
       P.Name as TenSanPham,
       sum(SOD.OrderQty) as TongSoLuongBan
from Sales.SalesOrderDetail as SOD 
inner join Production.Product as P
      on SOD.ProductID = P.ProductID
group by P.ProductID, P.Name
order by TongSoLuongBan asc, TenSanPham asc;
go 

-- bài 6 
