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






  


--------------------printing -----------------

DECLARE @start int;
set @start = 10;
while(@start >= 0)
Begin 
    print @start
    set @start = @start - 1
end
-------------------date of birth---------------
declare @dob datetime,  @age datetime, @tempdate datetime, @years int, @months int, @days int
set @dob = '12/08/2000' -- 8 december

select @tempdate = @dob

select @years = datediff(year, @tempdate, getdate()) -  case when (month(@dob) > month(getdate())) or
         ((month(@dob) = month(getdate())) and day(@dob) > day(getdate()))
         then 1 else 0
end

select @tempdate = dateadd(year, @years, @tempdate)

select @months = datediff(month, @tempdate, getdate()) -  
            case when day(@dob) > day(getdate())
              then 1 else 0
end

select @tempdate = dateadd(month, @months, @tempdate)

select @days = datediff(day, @tempdate, getdate())

select @years as years, @months as months, @days as days

---------------- Scalar function ----------------------------------

GO
-- Create function  to create a function
-- alter and drop to alter the function or drop the function
create function fn_compute_age_n(@dob datetime) returns varchar(50) 
as begin 

declare  @tempdate datetime, @years int, @months int, @days int
--set @dob = '12/08/2000' -- 8 december
select @tempdate = @dob

select @years = datediff(year, @tempdate, getdate()) -  case when (month(@dob) > month(getdate())) or
         ((month(@dob) = month(getdate())) and day(@dob) > day(getdate()))
         then 1 else 0
end

select @tempdate = dateadd(year, @years, @tempdate)
select @months = datediff(month, @tempdate, getdate()) -  
            case when day(@dob) > day(getdate())
              then 1 else 0
end

select @tempdate = dateadd(month, @months, @tempdate)
select @days = datediff(day, @tempdate, getdate())

declare @age_new  VARCHAR(50)
set @age_new = cast(@years as varchar(5))+ ' years ' + cast(@months as varchar(5))+ ' months ' + cast(@days as varchar(2)) + ' days'
--select @years as years, @months as months, @days as days
return @age_new
end
GO

select  dbo.fn_compute_age_n('11/20/1982')AS AGE

-------------------------- Views and Indexes -------------------------------------
USE mydb;

GO 
create view  myview2  as select * from mydb.dbo.gender1;
GO

drop view myview

--- altering table properties --------------
-- Generate first not null requirement
ALTER TABLE [imdb].dbo.vehicle_default_train alter column UniqueId int NOT NULL

-- Genderate then primary key
ALTER TABLE [imdb].dbo.vehicle_default_train
ADD PRIMARY KEY (UniqueId);

-- Generate the not null requirement for other keys as well
ALTER TABLE [imdb].dbo.vehicle_default_train alter column Branch_id int NOT NULL

-- Generate the not null 
-- In the main table the same key is foreign but the other table it is primary
-- so set it as primary
ALTER TABLE [imdb].dbo.Branch alter column Branch_id int NOT NULL
ALTER TABLE [imdb].dbo.Branch
ADD PRIMARY KEY (Branch_id);


-- To create  a foreign key you need to alter the original table (primary table)
-- add constraint of with foreign key with the other table
ALTER TABLE [imdb].dbo.vehicle_default_train
ADD CONSTRAINT fk_branch_id 
FOREIGN KEY (branch_id)
REFERENCES [imdb].dbo.Branch(branch_id)

-- so set it as primary (another example for state_id)
ALTER TABLE [imdb].dbo.vehicle_default_train alter column state_id int NOT NULL
ALTER TABLE [imdb].dbo.state alter column state_id int NOT NULL


ALTER TABLE [imdb].dbo.state alter column state_id int NOT NULL
ALTER TABLE [imdb].dbo.state
ADD PRIMARY KEY (state_id);

ALTER TABLE [imdb].dbo.vehicle_default_train
ADD CONSTRAINT fk_state_id 
FOREIGN KEY (state_id)
REFERENCES [imdb].dbo.state(state_id)

-- Another example with manufacturer

ALTER TABLE [imdb].dbo.vehicle_default_train alter column manufacturer_id int NOT NULL
ALTER TABLE [imdb].dbo.manufacturer alter column manufacturer_id int NOT NULL


ALTER TABLE [imdb].dbo.manufacturer alter column manufacturer_id int NOT NULL
ALTER TABLE [imdb].dbo.manufacturer
ADD PRIMARY KEY (manufacturer_id);

ALTER TABLE [imdb].dbo.vehicle_default_train
ADD CONSTRAINT fk_manufacturer_id 
FOREIGN KEY (manufacturer_id)
REFERENCES [imdb].dbo.manufacturer(manufacturer_id)




