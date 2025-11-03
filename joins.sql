-- Left Join
use backup_sql_v2

select top 5 * from vehicle_default_train
select top 5 * from branch
select min(DisbursalDate) from vehicle_default_train where branch_id = 67
select count(*), count(distinct branch_id) from branch

select count(*) from (
select a.UniqueID, a.DisbursalDate, a.branch_id, a.loan_default, 
b.event_count_branch 
from vehicle_default_train as a 
left join branch as b
on a.branch_id = b.branch_id
-- where a.branch_id = 67
) as k
select b.UniqueID, b.DisbursalDate, b.branch_id, b.loan_default, 
a.event_count_branch 
from branch as a 
right join vehicle_default_train as b
on a.branch_id = b.branch_id
-- where b.branch_id = 67


-- More than 2 tables join
select top 5 * from vehicle_default_train
select top 5 * from branch
select top 5 * from manufacturer


select a.UniqueID, a.DisbursalDate, a.branch_id,c.manufacturer_id, a.loan_default, 
b.event_count_branch, c.event_count_manufacturer
from vehicle_default_train as a
left join
branch as b
on a.branch_id = b.branch_id
left join
manufacturer as c
on a.manufacturer_id = c.manufacturer_id
-- Never use a column as primary key if they contain floats

select count(*) from vehicle_default_train
-- more records from input base table You should worry
-- Varchar() or big int or int

-- 
-- CREATE SCHEMA test;
-- GO
use backup_sql_v2;
drop table test.demog
drop table test.income

CREATE TABLE test.demog(
    AccountNumber INT PRIMARY KEY not null,
    Age int NOT NULL,
	Gender varchar(10) not null
);

CREATE TABLE test.income(
    AccountNumber INT PRIMARY KEY not null,
    income float NOT NULL
);

insert into test.demog(accountnumber, age, gender)
values (1, 25, 'm'),(2, 30, 'f'),
		(3, 56, 'f'),(4, 12, 'm'),
		(5, 34, 'o'),(6, 39, 'o'),
		(7, 45, 'f');

insert into test.income(AccountNUmber, income)
values (1, 2000),(3, 6782),
		(4, 2560),(7, 3453),
		(9,4599);

select * from test.demog;
select * from test.income;

select a.*, b.income from test.demog as a
inner join 
test.income as b
on a.accountnumber = b.accountnumber

-- Use isnull also instead of coalesce , you can see it gives correct output as well
select coalesce(a.AccountNumber, b.AccountNumber) as AccountNUmber,
a.Age, a.Gender, b.income from test.demog as a
full outer join 
test.income as b
on a.accountnumber = b.accountnumber

use AdventureWorks2019;

SELECT a.ProductID, b.BusinessEntityID, a.StandardPrice as sp, b.Name
FROM Purchasing.ProductVendor  as a INNER JOIN Purchasing.Vendor as b 
    ON (b.BusinessEntityID = a.BusinessEntityID)
WHERE a.StandardPrice > $10
  AND b.Name LIKE N'F%';

 --- self join
use backup_sql_v2;

 CREATE TABLE test.Employees (
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(50),
    ManagerID INT
);

INSERT INTO test.Employees (EmployeeID, EmployeeName, ManagerID)
VALUES
    (1, 'John', NULL),
    (2, 'Alice', 1),
    (3, 'Bob', 1),
    (4, 'Carol', 2),
    (5, 'David', 3);

select * from test.Employees
-- self join 
SELECT e1.EmployeeName AS Employee, e2.EmployeeName AS Manager
FROM test.Employees as e1
LEFT JOIN test.Employees as e2 ON e1.ManagerID = e2.EmployeeID;

-- CROSS JOIN

select count(*)  from test.Employees

SELECT e1.EmployeeName AS Employee, e2.EmployeeName AS Manager
FROM test.Employees e1
CROSS JOIN test.Employees e2


-- ANTI JOIN --- 
-- An anti-join, also known as an anti-semi-join, is a type of join 
-- in SQL that returns rows from one table where there is no match 
-- in another table. In other words, it retrieves records from the 
-- first table that do not have corresponding matches in the second
-- table. Anti-joins are particularly useful when you want to find
-- records that are missing or exclude certain records based on a 
-- specific condition.

use AdventureWorks2019
SELECT count(*) from (
SELECT  P.BusinessEntityID, P.FirstName, P.LastName
FROM Person.Person AS P
LEFT JOIN Sales.SalesOrderHeader AS SOH
    ON P.BusinessEntityID = SOH.SalesPersonID
 WHERE SOH.SalesPersonID IS NULL
) as a

-- union and union all ---
use backup_sql_v2;

create table test.Teachers1(
FName varchar(20),
LName varchar(20)
)

create table test.Teachers2(
FName varchar(20),
LName varchar(20)
)

insert into test.Teachers1 
values('Maria', 'G'), ('Adams', 'G'), 
	  ('Priya', 'M'), ('Salma', 'R'), 
	  ('Rajini', 'K'), ('Sameera', 'R')

insert into test.Teachers2 
values('George', 'T'), ('Raman', 'G'), 
	  ('Sujeet', 'S'), ('Salma', 'R'), 
	  ('Rajini', 'K'), ('Amit', 'C')

-- if these two are same, can we stack them together (yes) -> Union All
-- Can we remove duplicates (Yes ) union


select * from test.Teachers1
select * from test.Teachers2;

select * from test.Teachers1
union 
select * from test.Teachers2
order by LNAME, FNAME

-- Subquery with Aggregation

-- find the total number of orders 
-- placed by each customer in the Sales.Customer table.
use AdventureWorks2019

select top 5 * from sales.customer

SELECT C.CustomerID,  C.AccountNumber,
    (SELECT COUNT(SO.SalesOrderID)
     FROM Sales.SalesOrderHeader AS SO
     WHERE SO.CustomerID = C.CustomerID) AS TotalOrders
FROM Sales.Customer AS C;
-- Here the subquery calculates the total number of orders for
-- each customer by counting the rows in the Sales.SalesOrderHeader
-- table where the CustomerID matches the CustomerID from the outer
-- query.

-- Subquery in the FROM Clause (Derived Table)

SELECT AVG(ProductsPerOrder)
--  want to find the average number of products sold per order,

FROM (
    SELECT  COUNT(SOD.ProductID) AS ProductsPerOrder
    FROM Sales.SalesOrderHeader AS SO
    JOIN Sales.SalesOrderDetail AS SOD ON SO.SalesOrderID = SOD.SalesOrderID
    GROUP BY SO.SalesOrderID
) AS DerivedTable;

SELECT MAX(ListPrice)
    FROM Production.Product

-- subquery with scalar subquery
SELECT ProductID, Name, ListPrice
-- Retrieve a single value (a scalar value) and use it in an outer 
-- query. For example, if you want to find the product with the 
-- highest list price, you can use a scalar subquery
FROM Production.Product
WHERE ListPrice = (
    SELECT MAX(ListPrice)
    FROM Production.Product
);

