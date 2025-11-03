-- Top few rows
-- Questions on each chapter
-- Indexes

use backup_sql_v2;
select top 10 * from vehicle_default_train
select top 10 * from branch

--select count(*) from vehicle_default_train 
--select count( distinct UniqueID) from vehicle_default_train
--select count(UniqueID) as cnt from vehicle_default_train where UniqueID is NOT NULL
-- Average Event Rate
-- sum/avg/min/max
select sum(loan_default) from vehicle_default_train
select sum(a.loan_default) from vehicle_default_train as a
select count(*) from vehicle_default_train
-- Mean deafult rate
select avg(a.loan_default*1.0) from vehicle_default_train as a
-- Alternative
-- Not work
-- window functions
select sum(a.loan_default*1.0)/sum(count(*)) 
from vehicle_default_train as a
-- Work
select sum(a.loan_default*1.0)/sum(count(*)) over() as prop  
from vehicle_default_train as a

-- Aggregate functions
select min(disbursed_amount) as min_Disb, 
max(disbursed_amount) as max_disb, 
sum(cast(disbursed_amount as decimal(20, 2))) as sum_disb_amt from vehicle_default_train


-- year / month /day form a date column
-- We can fetch year / month or day 
-- cast / convert 
-- Very useful for db information
SELECT * FROM sys.databases; 

-- Very Useful to know datatypes
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE table_name = 'vehicle_default_train'
-- Date of birth => varchar
--select day(a.varchar_date), 
--month(a.varchar_date), 
--year(a.varchar_date) from #t as a 

-- cast
Select cast(date_of_birth as varchar) as varchar_date Into #t 
From vehicle_default_train 
-- select top 10 * from #t
exec tempdb..sp_help '#t'
select top 10 * from #t

select convert(varchar, getdate(), 1) 
-- 102 , 104 are famous enough
-- Changing the format to date of 102 to something might fail if the format is not matched
-- mm/dd/yy
-- yyyy/mm/dd
select convert(date, varchar_date, 102) as varchar_date from #t

declare @x float;
set @x = 10.534
select convert(varchar, @x) as value

-- select top 10 * from vehicle_default_train
drop table #a

CREATE TABLE #a 
(  
    emp_id        TINYINT   IDENTITY,  
    hourly_wage   DECIMAL   NULL,  
    salary        DECIMAL   NULL,  
    commission    DECIMAL   NULL,  
    num_sales     TINYINT   NULL  
);  


INSERT #a (hourly_wage, salary, commission, num_sales)  
VALUES  
    (10.00, NULL, NULL, NULL),  
    (20.00, NULL, NULL, NULL),  
    (30.00, NULL, NULL, NULL),  
    (40.00, NULL, NULL, NULL),  
    (NULL, 10000.00, NULL, NULL),  
    (NULL, 20000.00, NULL, NULL),  
    (NULL, 30000.00, NULL, NULL),  
    (NULL, 40000.00, NULL, NULL),  
    (NULL, NULL, 15000, 3),  
    (NULL, NULL, 25000, 2),  
    (NULL, NULL, 20000, 6),  
    (NULL, NULL, 14000, 4),
	(20, 12001, 10001, 5),
	(NULL, NULL, NULL, NULL);

select * from #a;
-- #1 - 20800
-- # 5 - 10000
--- 9 - 45000
--- 13 - 41600
--- 14 - NULL

SELECT a.*,  CAST(COALESCE(hourly_wage * 40 * 52,   
   salary,   
   commission * num_sales) AS money) AS 'Total Salary'   
FROM #a as a

SELECT a.*,  CAST(COALESCE(hourly_wage,   
   salary,   
   commission) AS money) AS 'Total Salary'   
FROM #a as a

-- CharIndex and LEFT TRIM and RIGHT LTRIM, and TRIM
-- TRIM()
use backup_sql_v2;
select top 5  AVERAGE_ACCT_AGE from vehicle_default_train

select a.AVERAGE_ACCT_AGE, Charindex(' ', a.AVERAGE_ACCT_AGE) as position 
from vehicle_default_train as a
-- RTIM , LTRIM
select a.AVERAGE_ACCT_AGE, 
LEFT(a.AVERAGE_ACCT_AGE, Charindex(' ', a.AVERAGE_ACCT_AGE) - 1) 
from vehicle_default_train as a

-- LTRIM(RTRIM())
select a.AVERAGE_ACCT_AGE, 
LEFT(a.AVERAGE_ACCT_AGE, Charindex(' ', a.AVERAGE_ACCT_AGE)) as pos 
from vehicle_default_train as a

declare @y varchar(10);
set @y = ' this  ';
-- length = 7
-- left trim = 6
-- right trim = 5
-- trim = 4
select @y as orig_value, DATALENGTH(@y) as length, 
DATALENGTH(LTRIM(@y)) as left_trim,
DATALENGTH(RTRIM(@y)) as right_trim, 
DATALENGTH(TRIM(@y)) as trim_output 

select a.AVERAGE_ACCT_AGE, 
TRIM(RIGHT(a.AVERAGE_ACCT_AGE, Charindex(' ', a.AVERAGE_ACCT_AGE) - 0)) 
from vehicle_default_train as a


-- Counting nulls

--select top 10 * from dbo.earthquake_new
--select count(*) from dbo.earthquake_new where horizontalerror is NULL
--select count(*) from dbo.earthquake_new where horizontalerror is not NULL
--select horizontalerror, deptherror, coalesce(horizontalerror, deptherror) as error from dbo.earthquake_new 

--where horizontalerror is not NULL

-- 20th position the dot is present there
--select charindex('.', cast(time as varchar)) from dbo.earthquake_new

-- More involved example

SELECT CASE
         WHEN a.AVERAGE_ACCT_AGE LIKE '% %' THEN LEFT(a.AVERAGE_ACCT_AGE, Charindex(' ', a.AVERAGE_ACCT_AGE) - 0)
         ELSE a.AVERAGE_ACCT_AGE
       END as col1,
       CASE
         WHEN a.AVERAGE_ACCT_AGE LIKE '% %' THEN RIGHT(a.AVERAGE_ACCT_AGE, Charindex(' ', Reverse(a.AVERAGE_ACCT_AGE)) - 0)
       END as col2
FROM   vehicle_default_train  as a


select concat(col1 ,'-',col2) as result from(
SELECT CASE
         WHEN a.AVERAGE_ACCT_AGE LIKE '% %' THEN LEFT(a.AVERAGE_ACCT_AGE, Charindex(' ', a.AVERAGE_ACCT_AGE) - 1)
         ELSE a.AVERAGE_ACCT_AGE
       END as col1,
       CASE
         WHEN a.AVERAGE_ACCT_AGE LIKE '% %' THEN RIGHT(a.AVERAGE_ACCT_AGE, Charindex(' ', Reverse(a.AVERAGE_ACCT_AGE)) - 1)
       END as col2
FROM   vehicle_default_train  as a
) as a

-- Handles nULL values as well so a null value results in NULL when concat_ws is used
select concat_ws('-', col1 ,col2) as result from(
SELECT CASE
         WHEN a.AVERAGE_ACCT_AGE LIKE '% %' THEN LEFT(a.AVERAGE_ACCT_AGE, Charindex(' ', a.AVERAGE_ACCT_AGE) - 1)
         ELSE a.AVERAGE_ACCT_AGE
       END as col1,
       CASE
         WHEN a.AVERAGE_ACCT_AGE LIKE '% %' THEN RIGHT(a.AVERAGE_ACCT_AGE, Charindex(' ', Reverse(a.AVERAGE_ACCT_AGE)) - 1)
       END as col2
FROM   vehicle_default_train  as a
) as a

-- These two are completely different thing
-- Note You can also use + operator
SELECT CONCAT_WS
(' ','1 Microsoft Way', NULL, NULL, 'Redmond', 'WA', 98052) 
AS Address;

SELECT CONCAT('1 Microsoft Way', NULL, NULL, 'Redmond', 'WA', 98052) 
AS Address;

-- plus as a concat of strings
select 'abc' + 'def'  as abcdef

-- select 2 + '3' as num



select format(cast('07:35' as time), 'hh\:mm') as timeval into #d
exec tempdb..sp_help '#d'

drop table #d

--select cast('07:35' as time) as timeval into #c
--exec tempdb..sp_help '#c'
-- FORMAT with TIME
-- FORMAT(time, ...here..format) -- the way we want to see things

-- select '07:35' 
select cast('07:35' as time)
SELECT FORMAT(cast('07:35' as time), N'hh.mm');   --> returns NULL  
SELECT FORMAT(cast('07:35' as time), N'hh:mm');   --> returns NULL  

-- select format('07:35', N'hh\.mm')
SELECT FORMAT(cast('07:35' as time), N'hh\.mm') as timeval ;
SELECT FORMAT(cast('07:35' as time), N'hh\:mm') as timeval; --> returns 07.35  
SELECT FORMAT(cast('07:35' as time), N'hh\-mm') as timeval ;

-- exec tempdb..sp_help '#ta'
SELECT FORMAT(cast('17:35' as time), N'hh\:mm\:ss');  --> returns 07:35
SELECT FORMAT(cast('17:35:23' as time), N'hh\:mm\:ss');  --> returns 07:35  

--select SYSDATETIME() as dateval into #a
--exec tempdb..sp_help '#a'

--select cast('07:35' as time) as timeval into #b
--exec tempdb..sp_help '#b'
-- Datetime -> datatype datetime2
select SYSDATETIME() as dt ; -- date/time with seconds.+ fractional part
SELECT FORMAT(SYSDATETIME(), N'hh:mm'); 
SELECT FORMAT(SYSDATETIME(), N'hh:mm tt'); -- returns 09:22 AM
SELECT FORMAT(SYSDATETIME(), N'hh:mm t'); -- returns 09:23 A

 -- returns 14:00
select FORMAT(CAST('2018-12-11 01:45' AS datetime2), N'hh:mm tt') -- returns 01:00 AM
select FORMAT(CAST('2018-12-21 03:10' AS datetime2), N'hh:mm t')  -- returns 01:00 A
select FORMAT(CAST('2019-04-03 14:00' AS datetime2), N'hh:mm tt') -- returns 02:00 PM
select FORMAT(CAST('2019-04-04 14:00' AS datetime2), N'hh:mm t') -- returns 02:00 P
select FORMAT(CAST('2018-03-01 14:25' AS datetime2), N'HH:mm')
SELECT FORMAT (sysdatetime(), 'd') -- mm/dd/yyyy
SELECT FORMAT (CAST('2018-11-21 14:25' AS datetime2), 'd') -- It shows the day of the month from 1 through 31.
SELECT FORMAT (CAST('2018-11-21 14:25' AS datetime2), 'D') --  It gives a detailed output in Weekday, Month, Date, Year format.
SELECT FORMAT (CAST('2018-11-21 14:25' AS datetime2), 'f') -- It adds timestamp as well in the output of D parameter.it does not include seconds information.
SELECT FORMAT (CAST('2018-11-21 14:25' AS datetime2), 'F') --  It adds seconds (ss) information also in the output generated from f parameter.
SELECT FORMAT (CAST('2018-11-21 14:25' AS datetime2), 'g')--  It gives  in MM/DD/YYYY hh: mm AM/PM.
SELECT FORMAT (CAST('2018-11-21 14:25' AS datetime2), 'G') -- Output format MM/DD/YYYY hh:mm: ss AM/PM.
-- There are other alphabets like 'O', 'M','R', 'S', 'U', 'T', 'Y' etc

SELECT FORMAT(CAST('2018-11-21 14:25' AS datetime2), 'yyyy-MM-dd')
SELECT FORMAT(CAST('2018-11-21 14:25' AS datetime2), 'MMM d yyyy h:mm:ss tt')
SELECT FORMAT(CAST('2018-11-21 14:25' AS datetime2), 'yyyy.MM.dd') -- custom format
SELECT FORMAT(GETDATE(), 'yy.MM.dd') -- custom format
SELECT FORMAT(GETDATE(), 'HH:mm:ss') -- time
SELECT FORMAT(GETDATE(), 'hh:mm:ss tt')
SELECT FORMAT(GETDATE(), 'MMM d yyyy h:mm:ss tt')
-- varchar()
-- 05/13/2023
-- 
DECLARE @d DATETIME= '03/05/2023' -- dd/mm/yyyy or mm/dd/yyyy
SELECT 
	   FORMAT(@d, 'd') AS 'Default',
	   FORMAT(@d, 'd', 'en-US') AS 'US English format', 
       FORMAT(@d, 'd', 'en-gb') AS 'Great Britain English format', 
       FORMAT(@d, 'd', 'de-de') AS 'German format', 
       FORMAT(@d, 'd', 'zh-cn') AS 'Simplified Chinese (PRC) format', 
       FORMAT(@d, 'd', 'hi-IN') AS 'India format', 
       FORMAT(@d, 'd', 'ru-RU') AS 'Russian  format', 
       FORMAT(@d, 'd', 'gl-ES') AS 'Galician (Spain) format';

-- ISO format : YYYY-mm-dd
use backup_sql_v2;
select top 5  Date_of_Birth, asset_cost, disbursed_amount from dbo.vehicle_default_train

select top 5 date_of_birth, disbursed_amount,asset_cost,
format(date_of_birth,N'dd-MMM-yyyy') as converted_date, 
format(disbursed_amount, 'Rs #') as disbamount ,
format(asset_cost, 'Rs ##########') as asset_cost_formated , 
format(disbursed_amount, '#,#') as disbamount2   
from dbo.vehicle_default_train 


exec tempdb..sp_help '#k'
-- More format options
SELECT TOP(5) disbursed_amount  
            ,FORMAT(disbursed_amount, 'N', 'en-us') AS 'Numeric Format'  
            ,FORMAT(disbursed_amount, 'G', 'en-us') AS 'General Format'  
            ,FORMAT(disbursed_amount, 'C', 'en-in') AS 'Currency Format' 
			from dbo.vehicle_default_train


select format(104.01, '###.##') as val

-- You need to see the documentation to see the dd MM yy values translated to
--  LEFT / LEN LOWER TRIM

select top 5  PERFORM_CNS_SCORE_DESCRIPTION, len(PERFORM_CNS_SCORE_DESCRIPTION) as lenvalue from dbo.vehicle_default_train
select top 5  AVERAGE_ACCT_AGE, left(AVERAGE_ACCT_AGE, 4) as leftval, right(AVERAGE_ACCT_AGE, 5) as rightval from dbo.vehicle_default_train
select top 20  AVERAGE_ACCT_AGE, trim(left(AVERAGE_ACCT_AGE, 5)) as leftval, trim(right(AVERAGE_ACCT_AGE, 5)) as rightval from dbo.vehicle_default_train
select top 20  AVERAGE_ACCT_AGE, UPPER(trim(left(AVERAGE_ACCT_AGE, 5))) as leftval, LOWER(trim(right(AVERAGE_ACCT_AGE, 5))) as rightval from dbo.vehicle_default_train
select top 20  AVERAGE_ACCT_AGE, UPPER(rtrim(left(AVERAGE_ACCT_AGE, 5))) as leftval, LOWER(ltrim(right(AVERAGE_ACCT_AGE, 5))) as rightval from dbo.vehicle_default_train

select top 10 place from dbo.earthquake_new

-- pattern recoginition inside a string and filtering it can be done using patindex along with substring
-- Note the output is not correct however this can be corrected by using replicate



-- Substring and PatIndex

declare @a varchar(100);
set @a = '59km distance';
-- select substring(@a, 1, 4), patindex('%[0-9]km%', @a)-1

declare @b varchar(100)
set @b = 'distance is 29km from this place'
-- select substring(@b, 13, 4), patindex('%[0-9]km%', @b)-1

declare @c varchar(100)
set @c = 'not greater than 5km'
-- select substring(@c, 18, 4), patindex('%[0-9]km%', @c)-1


select REPLACE(TRIM(substring(@a, patindex('%[0-9]km%', @a)-1,  4)), 'km', '') as a,
TRIM(substring(@b, patindex('%[0-9]km%', @b)-1, 4 )) as b,
TRIM(substring(@c, patindex('%[0-9]km%', @c)-1, 4)) as c

--- LOWER UPPER - REPLACE 
declare @e varchar(50); 
set @e = 'this is A string';
select upper(@e) as newvalue;

select replace(upper(@e), 'STRING', 'text') as newd


select TRIM(substring(@a, patindex('%[0-9]km%', @a)-1,  4)) as a,
TRIM(substring(@b, patindex('%[0-9]km%', @b)-1, 4 )) as b,
TRIM(substring(@c, patindex('%[0-9]km%', @c)-1, 4)) as c


--select patindex('%[0-9]km%', lower(place)) as pat_value_index from dbo.earthquake_new

--select substring(lower(place), patindex('%[0-9]km%', lower(place)), 4) as kms from dbo.earthquake_new 
--where patindex('%[0-9]km%', lower(place)) <> 0

--select cast(replace(substring(lower(place), patindex('%[0-9]km%', lower(place)), 4), 'km','') as int) as kms 
--from dbo.earthquake_new 
--where patindex('%[0-9]km%', lower(place)) <> 0

--- patindex and substring
-- select patindex(('%' + replicate('[0-9]',2) + '%'), lower(place))from dbo.earthquake_new

select replicate('[0-9]',3)

declare @m varchar(50)
set @m = 'a distance of 5km' -- 234km --45km
select patindex('%[0-9][0-9]%', @m)

select place from  dbo.earthquake_new

select place, substring(lower(place), patindex(('%' + replicate('[0-9]',3) +'%'), lower(place)), 5) from dbo.earthquake_new
where patindex('%[0-9]%', lower(place)) >= 1

-- 3 1158439
-- 2 1158439
-- 1
select count(*) as cnt from (
select place, substring(lower(place), patindex(('%' + replicate('[0-9]',2) + '%'), lower(place)), 5) as strs from dbo.earthquake_new
where patindex('%[0-9]%', lower(place)) = 1
) as b

-- str --
select str(34342, 5, 0),str(34342)
SELECT STR(123.45, 6, 1); -- works  
SELECT STR(123.45, 6, 2);  -- doesn't work

-- CEILING
select FLOOR (123.99), CEILING(123.11) -- Removing the fractional part
SELECT STR (FLOOR (123.45), 3, 3); -- See the leading blanks, use appropriate length

-- REVERSE
SELECT REVERSE(1234) AS Reversed ; 
SELECT name, REVERSE(name) FROM sys.databases; 

-- Returns a DIFFERENCE value of 4, the least possible difference.  

SELECT SOUNDEX('Green') as green, 
SOUNDEX('blue') as greene, 
DIFFERENCE('Green','Greene') as diff,
DIFFERENCE('sea', 'see') as diff2,
DIFFERENCE('sandeep', 'sundeep');

-- 0 to 4

-- Useful in cases where text matching with similar names can be verified (note it has some error margin)

declare @d1 datetime2, @d2 datetime2;
set @d1 = '2018-12-01';
set @d2 = '2019-05-05';

select 31 + 31 + 28 + 31 + 30 + 5
select datediff(day, @d1, @d2)/365.25;
select datepart(year, @d1) -- '20181201' 

-- Arithmatic between dates
select top 10 a.Date_of_Birth, a.DisbursalDate, 
DATEDIFF(year ,  a.Date_of_Birth, a.DisbursalDate) as age_during_disbursal,
DATEDIFF(day ,  a.Date_of_Birth, a.DisbursalDate)/365.25 as age_during_disbursal_fraction
from vehicle_default_train as a 


-- Using space to get spaces
select top 10 * from dbo.legislators
SELECT RTRIM(last_name) + ',' + SPACE(2) +  LTRIM(first_name)   as full_name
FROM dbo.legislators

-- STUFF
SELECT STUFF('abcdef', 2, 3, 'ijklmn');
select stuff('Subhash Bose', 8,1 , ' Chandra ');

select TRANSLATE('abcdef', 'abc', 'kl')
SELECT TRANSLATE('10*[13+43]/{17-12}', '[]{}', '{}[]');
select top 10 * from vehicle_default_train

select datediff(year, Date_of_Birth, DisbursalDate ) as age into #t
from vehicle_default_train 
select * from #t

select age, case 
when age <= 30 then '<=30'
when  age > 30 and age <= 35 then '>30-35'
when  age > 35 and age <= 45 then '>35-45'
else '>45'end as age_bin from #t








--select case
--when ... 
--when ...
--when ...
--else ...
--end as variable from table
select age,  case  
when age <= 30 then '<=30'
when age > 30 and age <= 35 then '>30-35'
when age > 35 and age <= 45 then '>35-45'
else '>45'
end 
as age_bin from #t;

-- <= 30, 30-35, 36-45 , >45







select PERFORM_CNS_SCORE_DESCRIPTION, case 
when  PERFORM_CNS_SCORE_DESCRIPTION LIKE '%High Risk%' then 'High Risk'
when PERFORM_CNS_SCORE_DESCRIPTION LIKE '%Medium Risk%' then 'Medium Risk'
when PERFORM_CNS_SCORE_DESCRIPTION LIKE '%Low Risk%' then 'Low Risk'
else 'Others'  end as newcol from vehicle_default_train




