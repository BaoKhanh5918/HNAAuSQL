-- bài 1 
select 
count(*) as TongSoSanPham, AVG(ListPrice) as GiaTrungBinh, MAX(ListPrice) as GiaCaoNhat,
Min(ListPrice) as GiaThapNhat 
from Production.Product;

-- bài 2 
select ProductID,sum(OrderQty) as TongSoLuongBan
from Sales.SalesOrderDetail
group by productID;

-- bài 3 

