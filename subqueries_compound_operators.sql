-- subqurey
use backup_sql_v2;
select count(a.uniqueId) from
(select uniqueid, disbursed_amount from vehicle_default_train
where disbursed_amount > 100000
)as a

select count(*) from vehicle_default_train 
where disbursed_amount > 100000

select count(*) from vehicle_default_train
where uniqueid in (
select uniqueid from vehicle_default_train
where disbursed_amount > 100000
)

-- Correlated queries

USE AdventureWorks2019; 

select * from sales.SalesOrderHeader WHERE CustomerID = 29974;
-- customer has more than one record
use AdventureWorks2019;
select * from sales.Customer 
-- customer id has one record

SELECT TerritoryID 
        FROM Sales.Customer         
        WHERE CustomerID = 29974  

SELECT CustomerID,
       DueDate,        
       TotalDue
FROM Sales.SalesOrderHeader 
WHERE CustomerID = 29974;

-- Combining above two tables
SELECT CustomerID,
       DueDate,        
       TotalDue, (SELECT TerritoryID 
        FROM Sales.Customer         
        WHERE CustomerID = 29974 ) as TerId
FROM Sales.SalesOrderHeader 
WHERE CustomerID = 29974;
---
SELECT TOP 5 C.CustomerID, 
       (SELECT SUM(TotalDue) FROM Sales.SalesOrderHeader H
        WHERE H.CustomerID = C.CustomerID) AS TotalDue
FROM Sales.Customer C
ORDER BY TotalDue DESC;

-- CustomerId : 29818 - 989184.082
-- select count(distinct customerId), count(*) from sales.customer
select * from sales.Customer where customerId = 29818
select sum(TotalDue) from  Sales.SalesOrderHeader where customerId = 29818

--------- another uncorrelated query -----------
SELECT CustomerID,
       DueDate,
       TotalDue,
       (SELECT TerritoryID FROM Sales.Customer
        WHERE CustomerID = 29974) AS TerritoryID,
       (SELECT StoreID FROM Sales.Customer
        WHERE CustomerID = 29974) AS StoreID
FROM Sales.SalesOrderHeader
WHERE CustomerID = 29974;


----------- compound operators------------------------------------------
declare @a int = 0;

set @a += 10

select @a;

--- Compound Operators in SQL Server ---------
DECLARE @x1 INT = 27;  
SET @x1 += 2 ; 

SELECT @x1 AS Added_2;  
  
DECLARE @x2 INT = 27;  
SET @x2 -= 2 ;  

SELECT @x2 AS Subtracted_2;  
  
DECLARE @x3 INT = 27;  
SET @x3 *= 2 ;  
SELECT @x3 AS Multiplied_by_2;  
  
DECLARE @x4 INT = 27;  
SET @x4 /= 2 ;  
SELECT @x4 AS Divided_by_2;  

-- modulo
-- remainder 

DECLARE @x5 INT = -32;  
SET @x5 %= 3 ;  
SELECT @x5 AS Modulo_of_27_divided_by_2;  
  

--- Operators in SQL Server ------------------
-- AND/OR/NOT/IN
use localdb_pk;
select * from employees2
select * from employees2 where salary >=30000 AND gender = 'male'
select * from employees2 where NOT (city='chennai' or gender = 'male')
select * from employees2 where NOT city='chennai' and not gender = 'male';

-- DE MORGAN's LAW:
-- NOT (city='chennai' or gender = 'male')
-- NOT city = 'channai' and not gender  = 'male'
select * from employees2 where city = 'chennai'
select * from employees2 where gender = 'male'

select * from student
select * from student where city in ('mumbai', 'delhi')
select * from student where city = 'mumbai' or city = 'delhi'

-- LIKE
select * from student
-- ai at end of city name
-- [A-D]
select * from student where city like '[^A]%ai' -- 
select * from employees2 where city like '[^A-M]%ai' -- chennai and chennai

CREATE TABLE amount (
    id INT IDENTITY(1, 1) PRIMARY KEY, 
    proportions    varchar(20) NOT NULL
);

INSERT INTO amount(proportions)
VALUES('20_'),
      ('30%'),
      ('20_40%'),
	  ('%20%');
-- % zero or more characters
-- _ which means one character

select * from amount 
-- filer the first row
-- % (wild cards)

select * from amount where proportions like '__!_' escape '!'
select * from amount where proportions like '__!%' escape '!'
select * from amount where proportions like '%!_%!%' escape '!'
select * from amount where proportions like '!%%!%' escape '!'


-- Table
use localdb_pk;
--drop table team1
--drop table team2
CREATE TABLE Team1 (
    id INT IDENTITY(1, 1) PRIMARY KEY, 
    name    varchar(20) NOT NULL,
	age int not null
);

CREATE TABLE Team2 (
    id INT IDENTITY(1, 1) PRIMARY KEY, 
    name    varchar(20) NOT NULL,
	age int not null
);

INSERT INTO Team1(name, age)
VALUES('sumit shekhar', 29),
      ('sundhi suman', 39),
      ('ahmad kazi', 34),
	  ('Robert cardozo', 19);

INSERT INTO Team2(name, age)
VALUES('Ram shampat', 43),
      ('Shyamli S', 20),
      ('Gaurav Aneja', 35),
	  ('Gurpreet Singh', 28)
	  ;

INSERT INTO Team1(name, age)
VALUES('Ragahav K', 43),
      ('Shyam R', 49);


-- All and Any
select * from team1;
select * from team2; -- 20, 28, 35, 43

select * from team1
where age = any(
select age from team2
)

select * from team1
-- 29 39 34 19 43 49 
where age < any(
-- 20, 28, 35, 43
select age from team2
)

select * from team1 
-- 29 39 34 19 43 49 
where age > any(
-- 20, 28, 35, 43
select age from team2
)

select * from team1
-- 29 39 34 19 43 49 
where age < all(
-- 20, 28, 35, 43
select age from team2
)

select * from team1
-- 29 39 34 19 43 49
where age > all(
-- 20, 28, 35, 43
select age from team2
)
--insert into team2(name, age)
--values('Megha M', 34);

-- EXISTS
-- some is equivalent to any


use AdventureWorks2019

select top 5 FirstName, LastName from Person.Person

select count(distinct(BusinessEntityID)) from HUmanResources.Employee
select count(BusinessEntityID) from HUmanResources.Employee

select count(distinct(BusinessEntityID)) from Person.Person
select count(BusinessEntityID) from Person.Person

select * from HumanResources.Employee where BusinessEntityID = 49
select * from Person.Person where BusinessEntityID = 49

SELECT a.BusinessEntityID,a.FirstName, a.LastName  
FROM Person.Person as a 
where a.BusinessEntityID in (
select b.BusinessEntityID from HumanResources.Employee as b) 
and a.LastName = 'Johnson'


SELECT a.BusinessEntityID,a.FirstName, a.LastName  
FROM Person.Person AS a  
WHERE EXISTS  
(SELECT *   
    FROM HumanResources.Employee AS b  
    WHERE a.BusinessEntityID = b.BusinessEntityID  
    AND a.LastName = 'Johnson') ; 


-- Any with = 
SELECT a.BusinessEntityID,a.FirstName, a.LastName  
FROM Person.Person AS a  
WHERE  a.BusinessEntityID in  
(SELECT BusinessEntityID  
    FROM HumanResources.Employee AS b  
    WHERE a.BusinessEntityID = b.BusinessEntityID  and a.LastName = 'Johnson' ) ; 

-- Uses AdventureWorks  
use AdventureWorksDW; 
SELECT a.LastName, a.BirthDate  
FROM DimCustomer AS a  
WHERE EXISTS  
(SELECT *   
    FROM dbo.ProspectiveBuyer AS b  
    WHERE (a.LastName = b.LastName) AND (a.BirthDate = b.BirthDate)) ;

SELECT a.LastName, a.BirthDate  
FROM DimCustomer as a inner join dbo.ProspectiveBuyer as b
on a.LastName = b.LastName and a.BirthDate = b.Birthdate

-- Uses AdventureWorks  
  
SELECT a.LastName, a.BirthDate  
FROM DimCustomer AS a  
WHERE NOT EXISTS  
(SELECT *   
    FROM dbo.ProspectiveBuyer AS b  
    WHERE (a.LastName = b.LastName) AND (a.BirthDate = b.BirthDate)) ;


