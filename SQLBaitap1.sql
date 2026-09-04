-- bài tập 1
select BusinessEntityID, JobTitle, HireDate  from HumanResources.Employee
where JobTitle IN('Sale Representative','Marketing Specialist','Recruiter')
order by JobTitle ASC, HireDate DESC;
-- bài tập 2
select ProductID,Name,Color from Production.Product
where Name like '%Bike%' and Color not like 'Red';
-- bài tập 3 
select BusinessEntityID, Title, FirstName, MiddleName, LastName from Person.Person
where Title is Null or MiddleName is Null;
-- bài tập 4 
select ProductID, Name, Weight, SellStartDate from Production.Product
where Weight between 10 and 50 and year(SellStartDate) = 2021
order by Weight ASC;
-- bài tập 5
select BusinessEntityID, Gender, MaritalStatus, VacationHours, SickLeaveHours from HumanResources.Employee
where Gender = 'M' and MaritalStatus = 'S' and (VacationHours > 50 or SickLeaveHours > 40);

