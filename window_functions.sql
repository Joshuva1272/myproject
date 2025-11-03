
use backup_sql_v2;
select top 5 * from vehicle_default_train

select count(*) from vehicle_default_train
select count(distinct supplier_id) from vehicle_default_train

-- Percentage of supplier of supplier amount against total amount 

select supplier_id, SUM(disbursed_amount) as tot_amount from vehicle_default_train
group by supplier_id


SELECT supplier_id, SUM(disbursed_amount) as 'Total Price Product',
(SUM(disbursed_amount*1.0))/sum(SUM(disbursed_amount*1.0)) OVER() as 'Percentage of Total Price'
FROM vehicle_default_train
GROUP BY supplier_id

-- Why two sums , because you have many supplier for every every supplier
-- there is one sum, but you need overall sum hence summing all the supplier again !!!
-- Over clause without partion means the window is entire table

-- Problem: Get the difference between first and all latest business 
-- of a supplier

select top 20 supplier_id, DisbursalDate from  vehicle_default_train
order by supplier_id

use backup_sql_v2
select top 20 supplier_id, disbursaldate, min(disbursaldate) 
over (
 partition by supplier_id
) as min_date,
avg(disbursed_amount) over(partition by supplier_id) 
from vehicle_default_train
order by supplier_id


select a.* , DATEDIFF(day, a.min_date, a.DisbursalDate) as diff_days from (
select supplier_id, disbursaldate, min(disbursaldate) 
over (
 partition by supplier_id
) as min_date from vehicle_default_train
) as a
order by supplier_id, diff_Days
-- Now you can do a group by to get the max value of diff_days

-- An alternate could be to use both min and max in a group by 
-- and subtract which is much easier, but you can do this difference between min max
-- You can't use it in generic way, a generic way could to pick any nth record
-- so in those cases above approach is better

-- Can we create a counter on above such that we can pull specific record
-- we can!!!
--- An Example of ROW_NUMBER()

select UniqueID, disbursaldate, row_number() over(order by uniqueid, disbursaldate) as rn from vehicle_default_train

select a.* , DATEDIFF(day, a.min_date, a.DisbursalDate) 
as diff_days from (
select supplier_id, disbursaldate, min(disbursaldate) 
over (partition by supplier_id) as min_date,
ROW_NUMBER() over(partition by supplier_id order by supplier_id,
disbursaldate) as countr from vehicle_default_train
) as a
order by supplier_id, diff_Days

-- A Bivariate Analysis ------

-- Bivariate analysis
-- use backup_sql_v2;

select top 10 * from vehicle_default_train

select PERFORM_CNS_SCORE_DESCRIPTION, sum(loan_default) as event,
count(*) as group_pop, count(*)*1.0/sum(count(*)) over() prop_pop,
sum(loan_default)*1.0/sum(count(*)) over() as event_rate
from vehicle_default_train
group by PERFORM_CNS_SCORE_DESCRIPTION

select a.PERFORM_CNS_SCORE_DESCRIPTION, a.event, 
a.group_pop, a.event*1.0/a.group_pop as event_rate,
a.group_pop*1.0/a.prop_pop as prop_pop_new from
(
select PERFORM_CNS_SCORE_DESCRIPTION, sum(loan_default) as event,
count(*) as group_pop, sum(count(*)) over() prop_pop
from vehicle_default_train
group by PERFORM_CNS_SCORE_DESCRIPTION
) as a





select NAME_CONTRACT_TYPE, sum(target) as event_count, 
count(*) as pop_count,
sum(count(*)) over() as total_pop from dbo.application_train
group by NAME_CONTRACT_TYPE

select a.NAME_CONTRACT_TYPE, event_count*100.0/pop_count as event_rate, pop_count*100.0/total_pop  as pop_percentage from(
select NAME_CONTRACT_TYPE, sum(target) as event_count, count(*) as pop_count,
sum(count(*)) over() as total_pop from dbo.application_train
group by NAME_CONTRACT_TYPE
) as a
--- One more example ----
--- Creating quantiles ---

-- 25th percentile, 50 percentile, 75th percentile
select asset_cost from vehicle_default_train
order by asset_cost


SELECT  a.uniqueid, a.asset_cost, 
	cast (PERCENT_RANK() OVER(order by asset_cost) as decimal(10,6)) AS PctRank 
	FROM vehicle_default_train as a

use backup_sql_v2;

SELECT  a.uniqueid, a.asset_cost, 
	PERCENT_RANK() OVER(order by asset_cost) AS PctRank 
	FROM vehicle_default_train as a

select ranks, count(*) as cnt, sum(loan_default) as event from (
select b.uniqueid, b.asset_cost, b.loan_default,  b.PctRank, 
case when b.PctRank >= 0 and b.PctRank < .25 then 'b25' 
when b.PctRank >=.25 and b.pctRank < .50 then 'b50'
when b.PctRank >= .50 and b.PctRank < .75 then 'b75'
else 'b100'
end  as ranks from (
    SELECT  a.uniqueid, a.asset_cost, a.loan_default, 
	PERCENT_RANK() OVER(order by asset_cost) AS PctRank 
	FROM vehicle_default_train as a
) as b
) as c group by ranks

----- ROWS RANGE ------

USE AdventureWorks2019;

SELECT
    pc.ProductCategoryID,
    pc.Name AS ProductCategory,
    sod.SalesOrderID,
    sod.SalesOrderDetailID,
    sod.OrderQty,
    sod.UnitPrice,
    sod.LineTotal,
    SUM(sod.LineTotal) 
	OVER (PARTITION BY pc.ProductCategoryID) AS TotalSalesByCategory
FROM
    Sales.SalesOrderDetail AS sod
JOIN
    Production.Product AS p ON sod.ProductID = p.ProductID
JOIN
    Production.ProductSubcategory AS ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
JOIN
    Production.ProductCategory AS pc ON ps.ProductCategoryID = pc.ProductCategoryID;


--- Ranking values
use AdventureWorksDW;
select top 10 OrderMonth, AnnualSales from DimReseller

select OrderMonth, AnnualSales, 
rank() over(partition by ordermonth 
order by AnnualSales, OrderMonth) as Rankv 
from DimReseller where OrderMonth is not NULL

-- dense rank
select OrderMonth, AnnualSales, dense_rank() 
over(partition by ordermonth order by AnnualSales, OrderMonth) 
as Rankv from DimReseller where OrderMonth is not NULL


-- Percent Rank
use AdventureWorksDW;
select OrderMonth, LastOrderYear, 
	sum(AnnualSales) as total_sales from DimReseller
    where OrderMonth is not NULL
	group by  OrderMonth, LastOrderYear
	order by LastOrderYear, OrderMonth

-- Percent_Rank()
select a.OrderMonth, LastOrderYear, total_sales, 
Format(PERCENT_RANK() 
over (Partition by a.LastOrderYear order by a.total_sales), 'P') 
as percentile_rank 
from (
	select OrderMonth, LastOrderYear, 
	sum(AnnualSales) as total_sales from DimReseller
    where OrderMonth is not NULL
	group by LastOrderYear, OrderMonth
 ) as a
order by LastOrderYear, total_sales


select OrderMonth, LastOrderYear, sum(AnnualSales) as total_sales from DimReseller
	where OrderMonth is not NULL
	group by LastOrderYear, OrderMonth

-- NTILE -- percent rank (ranking)
select a.OrderMonth, LastOrderYear, 
total_sales, NTILE(4) 
over (Partition by a.LastOrderYear order by a.total_sales) as percentile_tile
from (
	select OrderMonth, LastOrderYear, sum(AnnualSales) as total_sales 
	from DimReseller
	where OrderMonth is not NULL
	group by LastOrderYear, OrderMonth
) as a
order by LastOrderYear, total_sales

select AnnualSales, ntile(4) over(order by AnnualSales) as tile4 
from  DimReseller

-- Solution for above part when there are ties
-- select  
--    AnnualSales,
--    1+(rank() over (order by AnnualSales)-1) * 4 / count(1) 
-- over (partition by (select 1)) as new_ntile
-- from DimReseller

select AnnualSales,RANK() OVER (ORDER BY AnnualSales) 
from DimReseller

--- 
SELECT
    AnnualSales,
    (1 + (RANK() OVER (ORDER BY AnnualSales) - 1) * 4) / COUNT(1) 
	OVER () AS new_ntile
FROM DimReseller;

--- LEAD and LAG ---
-- lead fetches data from subsequent rows
-- lag fetches data from previous rows
use AdventureWorksDW;
select a.OrderMonth, LastOrderYear, total_sales, 
LAG(total_sales, 1) 
over (Partition by a.LastOrderYear 
	order by a.OrderMonth, a.LastOrderYear
) as lag_value 
from (
	select OrderMonth, LastOrderYear, 
	sum(AnnualSales) as total_sales from DimReseller
	where OrderMonth is not NULL
	group by LastOrderYear, OrderMonth
) as a
order by LastOrderYear, OrderMonth , lag_value 

-- ROWS or RANGE
-- The ROWS clause limits the rows within a partition by specifying 
-- a fixed number of rows preceding or following the current row.

-- the RANGE clause logically limits the rows within a partition by specifying a range of 
-- values with respect to the value in the current row. 
-- Preceding and following rows are defined based on the ordering in 
-- the ORDER BY clause

-- ROWS BETWEEN 2 PRECEDING AND CURRENT ROW 
-- means that the window of rows that the function 
-- operates on is three rows in size, starting with 2 rows preceding
-- until and including the current row
-- UNBOUNDED PRECEDING: <unsigned int> PRECEDING
-- CURRENT ROW: Specifies that the window starts or ends at the current row when used 
-- with ROWS or the current value when used with RANGE. 
-- CURRENT ROW can be specified as both a starting and ending point.
-- BETWEEN AND: Used with either ROWS or RANGE to specify the lower 
-- (starting) and upper (ending) boundary points of the window. 
-- UNBOUNDED FOLLOWING : <unsigned int> FOLLOWING

select OrderMonth, LastOrderYear, sum(AnnualSales) as total_sales from DimReseller
	where OrderMonth is not NULL
	group by LastOrderYear, OrderMonth

use AdventureWorksDW
--- AVG_VALUE
select a.OrderMonth, LastOrderYear, total_sales, 
AVG(total_sales) 
over (Partition by a.LastOrderYear 
order by a.OrderMonth asc, a.LastOrderYear
-- range between unbounded preceding and unbounded following
rows between 2 preceding and 2 following
) as last_value 
from (
	select OrderMonth, LastOrderYear, sum(AnnualSales) as total_sales from DimReseller
	where OrderMonth is not NULL
	group by LastOrderYear, OrderMonth
) as a
order by  LastOrderYear, OrderMonth, last_value 


use AdventureWorksDW

--- LAST_VALUE
select a.OrderMonth, LastOrderYear, total_sales, 
FIRST_VALUE(OrderMonth) 
over (Partition by a.LastOrderYear 
order by a.OrderMonth asc, a.LastOrderYear
-- range between unbounded preceding and unbounded following
rows between 2 preceding and 2 following
) as last_value 
from (
	select OrderMonth, LastOrderYear, sum(AnnualSales) as total_sales from DimReseller
	where OrderMonth is not NULL
	group by LastOrderYear, OrderMonth
) as a
order by  LastOrderYear, OrderMonth, last_value 


--- FIRST_VALUE
select * from(
select row_num, customerkey, FirstName, FIRST_VALUE(row_num) over(partition by FirstName order by row_num
range between unbounded preceding and unbounded following) as final_value from(
SELECT ROW_NUMBER() OVER(
			 partition by  FirstName
             ORDER BY 
                BirthDate desc, FirstName
        ) row_num, 
        CustomerKey, 
        FirstName
FROM DimCustomer
) as a
) as b where final_value = row_num



--- LAST_VALUE
select * from(
select row_num, customerkey, FirstName, LAST_VALUE(row_num) over(partition by FirstName order by row_num
range between unbounded preceding and unbounded following) as final_value from(
SELECT ROW_NUMBER() OVER(
			 partition by  FirstName
             ORDER BY 
                BirthDate desc, FirstName
        ) row_num, 
        CustomerKey, 
        FirstName
FROM DimCustomer
) as a
) as b where final_value = row_num


---- Common table expressions ----
--- General structure of common table expression
-- Define a Common Table Expression (CTE)
-- Below will not work as it is just a template
WITH MyCTE AS (
    SELECT
        Column1,
        Column2
    FROM
        YourTableName
    WHERE
        SomeCondition
)
-- Query the CTE
SELECT * FROM MyCTE;

--- 
USE AdventureWorks2019;

-- Define a CTE to filter employees with the job title "Marketing Specialist"
WITH ms AS (
    SELECT
        BusinessEntityID,
        JobTitle
    FROM
        HumanResources.Employee
    WHERE
        JobTitle = 'Marketing Specialist'
)

-- Query the CTE
SELECT * FROM ms;


-- Selecting the cutomers uniquely without using distinct  (the very first observation and senior most person)
-- This is not super useful but it gives an idea
use AdventureWorksDW;

WITH cte_customers AS (
    SELECT 
        ROW_NUMBER() OVER(
			 partition by  FirstName
             ORDER BY 
                BirthDate desc, FirstName
        ) row_num, 
        CustomerKey, 
        FirstName, birthdate
     FROM 
        DimCustomer
) SELECT 
    CustomerKey, 
    FirstName,
	row_num
FROM 
    cte_customers
	where row_num = 1

use AdventureWorks2019;

-- select top 5 * from Sales.SalesOrderHeader

-- Define the CTE expression name and column list.
WITH Sales_CTE (SalesPersonID, SalesOrderID, SalesYear)
AS
-- Define the CTE query.
(
    SELECT SalesPersonID as a, SalesOrderID as b, YEAR(OrderDate) AS c
    FROM Sales.SalesOrderHeader
    WHERE SalesPersonID IS NOT NULL
)
-- Define the outer query referencing the CTE name.
SELECT SalesPersonID as id, COUNT(SalesOrderID) AS TotalSales, SalesYear as years
FROM Sales_CTE
GROUP BY SalesYear, SalesPersonID
ORDER BY SalesPersonID, SalesYear;


-------------------------------------------
use backup_sql_v2;
GO;

CREATE TABLE dbo.MyEmployees
(
EmployeeID SMALLINT NOT NULL,
FirstName NVARCHAR(30) NOT NULL,
LastName NVARCHAR(40) NOT NULL,
Title NVARCHAR(50) NOT NULL,
DeptID SMALLINT NOT NULL,
ManagerID SMALLINT NULL,
CONSTRAINT PK_EmployeeID PRIMARY KEY CLUSTERED (EmployeeID ASC),
CONSTRAINT FK_MyEmployees_ManagerID_EmployeeID FOREIGN KEY (ManagerID) REFERENCES dbo.MyEmployees (EmployeeID)
);
-- Populate the table with values.
INSERT INTO dbo.MyEmployees VALUES
(1, N'Ken', N'Sánchez', N'Chief Executive Officer',16, NULL)
,(273, N'Brian', N'Welcker', N'Vice President of Sales', 3, 1)
,(274, N'Stephen', N'Jiang', N'North American Sales Manager', 3, 273)
,(275, N'Michael', N'Blythe', N'Sales Representative', 3, 274)
,(276, N'Linda', N'Mitchell', N'Sales Representative', 3, 274)
,(285, N'Syed', N'Abbas', N'Pacific Sales Manager', 3, 273)
,(286, N'Lynn', N'Tsoflias', N'Sales Representative', 3, 285)
,(16, N'David', N'Bradley', N'Marketing Manager', 4, 273)
,(23, N'Mary', N'Gibson', N'Marketing Specialist', 4, 16);

select * from dbo.MyEmployees
GO;

SELECT ManagerID, EmployeeID, Title, 0 AS EmployeeLevel
    FROM dbo.MyEmployees
    WHERE ManagerID IS NULL

WITH DirectReports(ManagerID, EmployeeID, Title, EmployeeLevel) AS
(
    SELECT ManagerID, EmployeeID, Title, 0 AS EmployeeLevel
    FROM dbo.MyEmployees
    WHERE ManagerID is NULL
    UNION ALL
    SELECT e.ManagerID, e.EmployeeID, e.Title, EmployeeLevel + 1
    FROM dbo.MyEmployees AS e
        INNER JOIN DirectReports AS d
        ON e.ManagerID = d.EmployeeID
)
SELECT ManagerID, EmployeeID, Title, EmployeeLevel
FROM DirectReports
ORDER BY ManagerID;


--  local and global temporary tables

select  *  into #temp_local from dbo.MyEmployees
select  *  into ##temp_global from dbo.MyEmployees
select * from ##temp_global

-------------------- Views ------------------------------
use backup_sql_v2;
-- Note you have to drop these tables if you have already them before you recreate them

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

-- drop table test.income;
-- drop table test.demog;
select * from test.demog; -- a
select * from test.income; -- b

select a.*, b.income from test.demog as a
inner join 
test.income as b
on a.accountnumber = b.accountnumber

GO
drop view vwinner_join_query
GO
create view vwinner_join_query as  
select a.AccountNumber, a.Age, a.Gender, b.income from test.demog as a
inner join 
test.income as b
on a.accountnumber = b.accountnumber
-- Always recreate the views when you found that base table has been updated

-- virtual table or saved sql query
GO
sp_helptext vwinner_join_query;

-- 
select AccountNumber, age from vwinner_join_query
select * from vwinner_join_query
drop view vwinner_join_query
---- 
select * from test.income
select * from test.demog

insert into test.income(AccountNUmber, income)
values (13, 2021);
insert into test.demog(AccountNUmber, age, gender)
values (13, 28, 'f');

ALTER TABLE test.income 
ADD description VARCHAR (255);
ALTER TABLE test.income DROP COLUMN description;
GO


ALTER TABLE test.demog 
ADD location VARCHAR (255);
ALTER TABLE test.demog DROP COLUMN location;
GO

-- select * from vwinner_join_query
-- drop view vw_inner_join_query
-- drop view  vwinner_join_query
GO;
-- drop view vwsimple
create view  vwsimple as select * from test.demog
GO;

select * from vwsimple;
select * from test.demog

delete from vwsimple where AccountNumber  = 14
insert into vwsimple values (14, 25, 'm')
select * from test.demog

---- updating view (don't do this) -----
-- insert -- delete 
-- drop view vwinner_join_query
GO;
create view vwinner_join_query as  
select a.AccountNumber, a.Age, a.Gender, b.income from test.demog as a
inner join 
test.income as b
on a.accountnumber = b.accountnumber

GO;
select * from vwinner_join_query
GO;

select * from vwinner_join_query
select * from test.demog

update vwinner_join_query 
set Gender = 'f' where AccountNumber = 1
GO;

select * from vwinner_join_query
select * from test.demog

delete from vwinner_join_query where AccountNumber  = 1
insert into vwinner_join_query values (100, 25, 'm', 2000)

-- when we change our base tables views get affected
-- when we change views our base tables get affected



--CREATE TABLE test.gender(
--    gender varchar(10) not null,
--    gender_numeric int NOT NULL
--);

--insert into test.gender(gender, gender_numeric)
--values ('m', 1),('f', 2), ('o', 3)




