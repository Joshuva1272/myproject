--- Exact Type
-- int, bigint, decimal, numeric, tinyint, money, smallmoney
declare @myint decimal(6, 4); -- p = 15, s = 12
set @myint = 10.123456789123656789
select @myint

declare @myint1 numeric(12, 5);
set @myint1 = 10.12345778
select @myint1

------------ TinyInt and Int ------------------
declare @myint2 tinyint;
set @myint2 = 255
select @myint2

use mydb;
drop table student;
create table student (  
RollNo tinyint, 
Gender int
) 

-- 1=> Male, 2 => Female
insert into student 
values (3, 2);

insert into student 
values (25, 2)

select * from student


select * from student;

--------Money-----------
------------------------
select 1 as m into #y
select $ as n into #x
select $20 as k into #z
select cast(1.0/7 as float) as a into #b
select 1.0/7 as a
select cast(1.234567890123456789 as float) as a
exec tempdb..sp_help '#b'
-----------------
DECLARE @mymoney_sm SMALLMONEY = 3148.29,  
        @mymoney    MONEY = 3148.29;  
SELECT  CAST(@mymoney_sm AS VARCHAR) AS 'SM_MONEY varchar',  
        CAST(@mymoney AS DECIMAL(6, 2))    AS 'MONEY DECIMAL';  

---- Floats and inexact data -----------------
drop table t1

CREATE TABLE t1 (i INT, d1 NUMERIC, d2 NUMERIC);

INSERT INTO t1 VALUES (1, 101.40, 21.40), (1, -80.00, 0.00),
    (2, 0.00, 0.00), (2, -13.20, 0.00), (2, 59.60, 46.40),
    (2, 30.40, 30.40), (3, 37.00, 7.40), (3, -29.60, 0.00),
    (4, 60.00, 15.40), (4, -10.60, 0.00), (4, -34.00, 0.00),
    (5, 33.00, 0.00), (5, -25.80, 0.00), (5, 0.00, 7.20),
    (6, 0.00, 0.00), (6, -51.40, 0.00);

select * from t1

SELECT i, SUM(d1) AS a, SUM(d2) AS b 
FROM t1 
GROUP BY i 
HAVING sum(d1) <> sum(d2)
-------------------- Floats -----------------------
------------ Another Example ----------------------
SELECT 
CASE WHEN CAST(.1 AS FLOAT)+ CAST(.2 AS FLOAT) = CAST(.3 AS FLOAT) 
THEN 1 ELSE 0 END

------------------datetime--------------------------
-- datetime, date and time , datetime2

DECLARE @date date = '2016-12-01';  -- ISO YYYY-MM-DD
DECLARE @datetime datetime = @date;  
SELECT @datetime AS '@datetime', @date AS '@date';

DECLARE @time time(4) = '12:10:05.1237';  
-- 1900-01-01
DECLARE @datetime datetime = @time;  
DECLARE @datetime2 datetime2 = @time;
SELECT @datetime AS '@datetime', @time AS '@time' , 
@datetime2 as '@datetime2';  

DECLARE @smalldatetime smalldatetime = '12-01-16 12:32:05';  
DECLARE @datetime datetime = @smalldatetime;  
SELECT @datetime AS '@datetime', @smalldatetime AS '@smalldatetime'; 


SELECT   
     CAST('2007-05-08 12:35:29.1234567 +12:15' AS time(7)) AS 'time'   
    ,CAST('2007-05-08 12:35:29.1234567 +12:15' AS date) AS 'date'   
    ,CAST('2007-05-08 12:35:29.123' AS smalldatetime) AS   
        'smalldatetime'   
    ,CAST('2007-05-08 12:35:29.123' AS datetime) AS 'datetime'   
    ,CAST('2007-05-08 12:35:29. 1234567 +12:15' AS datetime2(7)) AS   
        'datetime2'  
    ,CAST('2007-05-08 12:35:29.1234567 +12:15' AS datetimeoffset(7)) AS   
        'datetimeoffset'; 


drop table #b
drop table #a

-- SQL server 2012 after
select datefromparts(2020, 10, 01) as a into #b
-- select datefromparts(2020, 10, 01) as a into #b

select * from #b

------------------CHAR and VARCHAR-----------
-- A common misconception is to think that with char(n) and varchar(n), 
-- the n defines the number of characters. 
-- However, in char(n) and varchar(n), the n defines the string 
-- length in bytes (0 to 8,000). n never defines numbers of 
-- characters that can be stored.

-- The misconception happens because when using single-byte encoding, 
-- the storage size of char and varchar is n bytes and the number of 
-- characters is also n. 
-- However, for multibyte encoding such as UTF-8

DECLARE @myVariable AS VARCHAR(10) = ' abcdef ';
DECLARE @myNextVariable AS CHAR(20) = 'abccdefghij';
--The following returns 1
SELECT @myVariable, @myNextVariable, 
DATALENGTH(@myVariable), DATALENGTH(@myNextVariable),
LEN(@myVariable);

DECLARE @myVariable AS VARCHAR(50);
SET @myVariable = 'This string is longer than thirty characters';

SELECT CAST(@myVariable AS VARCHAR);
SELECT DATALENGTH(CAST(@myVariable AS VARCHAR)) AS 'VarcharDefaultLength';

SELECT CAST(@myVariable AS VARCHAR(50));
SELECT DATALENGTH(CAST(@myVariable AS VARCHAR(50))) 
AS 'VarcharDefaultLength';

SELECT CAST(@myVariable AS CHAR(50));
SELECT DATALENGTH(CAST(@myVariable AS CHAR(50))) AS 'VarcharDefaultLength';

-------------------- NULL Values ------------------------
-- Allowing null values in column definitions introduces 
-- three-valued logic into your application.
-- A comparison can evaluate to one of three conditions:

	-- True

	-- False

	-- Unknown (one should never use =, >= , <= <> )
	-- ISNULL()
	-- (IS / IS NOT) NULL

-- Because null is considered to be unknown, two null values 
-- compared to each other are not considered to be equal. 
-- In expressions using arithmetic operators, if any of the operands is null, 
-- the result is null as well.

SELECT SQL_VARIANT_PROPERTY(NULL, 'BaseType');
DECLARE @x DATE;
SELECT SQL_VARIANT_PROPERTY(@x, 'BaseType');
DECLARE @y DATE = SYSDATETIME();
SELECT SQL_VARIANT_PROPERTY(@y, 'BaseType');

SELECT x = NULL INTO #x;
EXEC tempdb..sp_columns '#x';

--- IS NOT / IS NULL
select *, isnull(ManagerID, 0) 
as New_Manager_ID from localdb_pk.dbo.Employees

-- How many missing values (NULLs)
select count(*) as total_count_missing 
from localdb_pk.dbo.Employees
where ManagerId is NULL


--------------- End ----------------------