
-- Create a scalar-valued function in SQL Server
-- Name of a function
-- Create function fun_name(@x int , @y varchar(2)) 
-- return (returns int)
-- unit item -> integer
use backup_sql_v2;
drop function dbo.CalculateTotalPrice
-- using create statement
-- create statement 
CREATE FUNCTION dbo.CalculateTotalPrice
(
    @UnitPrice DECIMAL(10, 2),
    @Quantity INT
)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @TotalPrice DECIMAL(10, 2)
    SET @TotalPrice = @UnitPrice * @Quantity
    RETURN @TotalPrice
END


CREATE FUNCTION dbo.CalculateTotalPrice2
(
    @UnitPrice DECIMAL(10, 2),
    @Quantity INT
)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    RETURN @UnitPrice * @Quantity
END



-- Example usage of the CalculateTotalPrice function
DECLARE @Price DECIMAL(10, 2)
DECLARE @Price2 DECIMAL(10, 2)
SET @Price = dbo.CalculateTotalPrice(12.99, 5)

SET @Price2 = dbo.CalculateTotalPrice2(12.99, 5)
SELECT @Price AS TotalPrice, @Price2 as TotalPrice2

--create table price(
--id int primary key,
--unitprice int ,
--quantity int
--)
--insert into price values(1, 100, 3), (2, 20, 5), (3, 16, 8)

select a.* from price as a
select a.*, dbo.CalculateTotalPrice2(a.unitprice, a.quantity) as total_value from price as a

-- Another example scalar function
--Defining a scalar function which does concatenation of Contact Email and City
-- one unit
use AdventureWorksDW;
create function dbo.fun_JoinEmpColumnInfo
(
   @EmpContact nchar(15),
   @EmpEmail nvarchar(50),
   @EmpCity varchar(30)
)
returns nvarchar(100)
as
begin 
	return @EmpContact+ ' ' +@EmpEmail + ' ' + @EmpCity
end


select dbo.fun_JoinEmpColumnInfo(geographykey, emailaddress, phone)
as info_key from DimCustomer


--- Inline table valued functions----------------
use AdventureWorksDW
drop function Fun_EmployeeInformation

Create function Fun_EmployeeInformation() 
returns table as return(select top 5 * from DimAccount )

-- Execute the function
select * from Fun_EmployeeInformation();


--- Another example without parameter ----
-- Create an inline table-valued function in AdventureWorks2019
USE AdventureWorks2019;
GO

drop function GetProductsWithCategories
CREATE FUNCTION GetProductsWithCategories()
RETURNS TABLE
AS
RETURN
(
    SELECT
        p.ProductID,
        p.Name AS ProductName,
        pc.ProductCategoryID,
        pc.Name AS CategoryName
    FROM
        Production.Product p
    INNER JOIN
        Production.ProductSubcategory ps ON 
		p.ProductSubcategoryID = ps.ProductSubcategoryID
    INNER JOIN
        Production.ProductCategory pc ON 
		ps.ProductCategoryID = pc.ProductCategoryID
);


-- Example usage of the GetProductsWithCategories function
SELECT * FROM dbo.GetProductsWithCategories();

-----------------
 
USE AdventureWorks2019;
GO
-- Create an inline table-valued function with a parameter 
-- in AdventureWorks2019
-- Another example with parameter

drop function GetProductsByCategory
CREATE FUNCTION GetProductsByCategory
(
    @CategoryID INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        p.ProductID,
        p.Name AS ProductName,
		ps.ProductCategoryID as productcategoryid
    FROM
        Production.Product p
    INNER JOIN
        Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
    WHERE
        ps.ProductCategoryID = @CategoryID
);

select top 5 ProductCategoryID from Production.ProductSubcategory
SELECT * FROM dbo.GetProductsByCategory(2);

---  End -------Inline Table Valued Example ------------------

--- Multiline table valued functions -------------
USE AdventureWorks2019;
GO

select top 5 * from HumanResources.EmployeeDepartmentHistory
select top 5 * from HumanResources.Department
select top 5 * from Person.Person
select top 5 * from HumanResources.Employee
drop function GetEmployeesWithDepartments

CREATE FUNCTION GetEmployeesWithDepartments()
RETURNS @EmployeeTable TABLE
(
    EmployeeID INT,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    DepartmentName NVARCHAR(50)
)
AS
BEGIN
    INSERT INTO @EmployeeTable (EmployeeID, FirstName, LastName, DepartmentName)
    SELECT
        e.BusinessEntityID AS EmployeeID,
        p.FirstName,
        p.LastName,
        d.Name AS DepartmentName
    FROM
        HumanResources.Employee e
    INNER JOIN
        Person.Person p ON e.BusinessEntityID = p.BusinessEntityID
    INNER JOIN
        HumanResources.EmployeeDepartmentHistory edh ON e.BusinessEntityID = edh.BusinessEntityID
    INNER JOIN
        HumanResources.Department d ON edh.DepartmentID = d.DepartmentID
    WHERE
        edh.EndDate IS NULL; -- Only current department assignments
		-- Since the EndDate will be not null for a person who was there in 
		-- other departments and hence it is important as join
    RETURN;
END;

-- Example usage of the GetEmployeesWithDepartments function
SELECT * FROM dbo.GetEmployeesWithDepartments();

-- We join the HumanResources.Employee table with the Person.Person table to 
	-- get employee names (first name and last name).
-- The BusinessEntityID column from the Person.Person table is used as EmployeeID.
--  Inside the function, there is an INSERT INTO statement that populates the 
    -- table variable @EmployeeTable with data from the HumanResources.
	-- Employee, HumanResources.EmployeeDepartmentHistory, and HumanResources.Department 
	-- tables. We are joining these tables to get employee information along with their current 
	-- department.


--------------------------------------------------

---------------------------------------------STORED PROCEDURES----------------------------------------------
-- Store Procedure
-- Using the view data not a table
-------------------------------------------------

USE AdventureWorks2019
GO

drop procedure dbo.uspGetAddress

CREATE PROCEDURE dbo.uspGetAddress @City varchar(30)
AS
SELECT * 
FROM Person.Address
WHERE City = @City

EXECUTE dbo.uspGetAddress @City = 'New York'

-- @City varchar(30) defines a parameter named @City with a data type 
-- of nvarchar(30). 
-- This parameter will allow you to pass a city name as an argument 
-- to the stored procedure.
---------------------------------------------------

USE AdventureWorks2019
GO
drop procedure dbo.uspGetAdd3
-- It will return a blank dataset as it is looking for city 
-- where the value is NULL
CREATE PROCEDURE dbo.uspGetAdd3 @City nvarchar(30) = NULL
AS
SELECT *
FROM Person.Address
WHERE City = @City
GO

EXEC dbo.uspGetAdd3 
-- A better way to write above is to use
----------------------------------------------------

USE AdventureWorks2019
GO
drop procedure dbo.uspGetAdd4
CREATE PROCEDURE dbo.uspGetAdd4 @City nvarchar(30) = 'New York'
AS
SELECT *
FROM Person.Address
WHERE City = ISNULL(@City,City)
GO

select distinct City from Person.Address

EXEC dbo.uspGetAdd4 @City = 'Calgary'
---------------------------------------------------

USE AdventureWorks2019
GO
drop procedure dbo.uspGetAdd2
CREATE PROCEDURE dbo.uspGetAdd2 @City nvarchar(30) = NULL, @AddressLine1 varchar(60) = NULL
AS
SELECT *
FROM Person.Address
WHERE City = ISNULL(@City,City)
AND AddressLine1 LIKE '%' + ISNULL(@AddressLine1 ,AddressLine1) + '%'
GO

-- return rows where City equals Calgary
EXEC dbo.uspGetAdd2 @City = 'Calgary' 

-- return rows where City equals Calgary and AddresLine1 contains A
EXEC dbo.uspGetAdd2 @City = 'Calgary', @AddressLine1 = 'A' 

-- return rows where AddresLine1 contains Acardia
EXEC dbo.uspGetAdd2 @AddressLine1 = 'Acardia'

-- this will return all rows
EXEC dbo.uspGetAdd2 

----------------## Procedure ## -----------------------

GO
CREATE PROCEDURE dbo.uspGetAdd @City nvarchar(30) 
AS 
SELECT * 
FROM Person.Address 
WHERE City LIKE @City + '%' 
GO

EXEC dbo.uspGetAdd @City = 'New'

--------------------------------------------------------
USE AdventureWorks2019;  
GO  
drop procedure HumanResources.uspGetEmployeesTest2  
CREATE PROCEDURE HumanResources.uspGetEmployeesTest2   
    @LastName nvarchar(50),   
    @FirstName nvarchar(50)   
AS   
    SET NOCOUNT ON;  
	-- Prevent the messages to be printed here.
    SELECT FirstName, LastName, Department  
    FROM HumanResources.vEmployeeDepartmentHistory  
    WHERE FirstName = @FirstName AND LastName = @LastName  
    AND EndDate IS NULL;  
GO  

EXECUTE HumanResources.uspGetEmployeesTest2 N'Ackerman', N'Pilar';  
EXECUTE HumanResources.uspGetEmployeesTest2 @FirstName = N'Pilar', @LastName = N'Ackerman'; 

--------------------------------------------------------



