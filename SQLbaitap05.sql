-- bài 1
use AdventureWorks2025;
go 
if object_ID('vw_SafeEmployeeInfo','V') is not null
   drop view vw_SafeEmployeeInfo;
go 
create view vw_SafeEmployeeInfo
as 
select E.BusinessEntityID, P.FirstName, P.LastName, E.JobTitle, E.HireDate
from HumanResources.Employee as E
inner join Person.Person as P
      on E.BusinessEntityID = P.BusinessEntityID;
go 
select * from vw_SafeEmployeeInfo;
go 

-- bài 2
use AdventureWorks2025;
go 
if object_ID('vw_OrderSummary','V') is not null 
   drop view vw_OrderSummary;
go 
create view vw_OrderSummary
as 
select H.SalesOrderID, H.OrderDate, Sum(D.LineTotal) as TotalDue
from 
Sales.SalesOrderHeader as H
inner join Sales.SalesOrderDetail as D
      on H.SalesOrderID = D.SalesOrderID
group by H.SalesOrderID, H.OrderDate;
go 
select * from vw_OrderSummary; 
go 
select top 1 SalesOrderID, OrderDate, TotalDue
from vw_OrderSummary
order by TotalDue desc;
go 

-- bài 3 
use AdventureWorks2025;
go 
alter view vw_OrderSummary
as 
select H.SalesOrderID, H.OrderDate, P.FirstName + ' ' + P.LastName as CustomerName, sum(D.LineTotal) as TotalDue
from Sales.SalesOrderHeader as H
inner join Sales.SalesOrderDetail as D
      on H.SalesOrderID = D.SalesOrderID
inner join Sales.Customer as C
      on H.CustomerID = C.CustomerID
inner join Person.Person as P
      on C.PersonID = P.BusinessEntityID
group by H.SalesOrderID, H.OrderDate, P.FirstName, P.LastName;
go 
select SalesOrderID, OrderDate, CustomerName, TotalDue
from vw_OrderSummary;
go 
select top 1 SalesOrderID, OrderDate, CustomerName, TotalDue
from vw_OrderSummary
order by TotalDue desc;
go 


--bài 4 
use AdventureWorks2025;
go 
if exists (select 1 from sys.indexes 
           where name = 'IX_Product_Name' 
           and object_id = object_ID('Production.Product'))
begin 
     drop index IX_Product_Name
     on Production.Product;
end 
go 
create NonClustered index IX_Product_Name
on Production.Product(Name);
go 
select ProductID, ProductNumber, Color, ListPrice 
from Production.Product
where name like 'B%';
go 


-- bài 5 
