-- Code for Chapter 2 (DQL)
-- Code for chapter 2 (DML-DDL) is present in another code

use backup_sql_v2;

-- SELECT 
-- Comment , a comment starts from --
select 42 as result;

-- calculate -> + / * / - / /
select  12 as raw_value, 
		12*3 as mult_value, 
		23+5 as add_value, 
		20/5 as div_value,
		20- 7 as diff_value

select 4*1.0/3 as div1, 3*1.0/4 as div2

-- Select with from

select top 10 SK_ID_CURR, target*10 as new_Target, NAME_CONTRACT_TYPE 
from application_train

select SK_ID_CURR, AMT_INCOME_TOTAL from application_train
where AMT_INCOME_TOTAL > 10000000;

select SK_ID_CURR, NAME_CONTRACT_TYPE from application_train
where NAME_CONTRACT_TYPE <> 'Cash loans'

-- <> not equal to 
-- = , >=, <=, > , < , IN, LIKE, BETWEEN
-- <>, >, >=, IN, LIKE and BETWEEN 

-- OR/AND
-- SELECT SERVERPROPERTY('COLLATION') - CI / CS
-- CI => Case Insensitive , CS => Case Sensisitve
-- SQL Server is, by default, case insensitive; however, 
-- it is possible to create a case-sensitive SQL Server database 
-- and even to make specific table columns case sensitive.
-- Where with => IN, BETWEEN, NOT, AND, OR
-- LIKE

select * from localdb_pk.dbo.Employees

-- BETWEEN
select * from localdb_pk.dbo.Employees
where ManagerID between 2 and 5

-- NOT with Between
select * from localdb_pk.dbo.Employees
where ManagerID NOT BETWEEN 2 AND 5

-- IN
select * from localdb_pk.dbo.Employees
where ManagerID in (2, 3, 4, 5)

-- SELECT SERVERPROPERTY('COLLATION')
-- CASE INSENSITIVITY
-- Filter with 'terri'
select * from localdb_pk.dbo.Employees
where FirstName = 'terri'


-- Filter with 'terri' and manager id greater than 2
select * from localdb_pk.dbo.Employees
where FirstName = 'terri' and ManagerID > 2

-- GROUP BY
select top 10 * from vehicle_default_train

-- Total default count
select sum(loan_default*1.0) as total_default from vehicle_default_train
-- Average default rate
select avg(loan_default*1.0) as total_default from vehicle_default_train
-- Average disbursed amount
select avg(disbursed_amount*1.0) as total_default from vehicle_default_train
-- Casted value using cast function
select avg(cast(disbursed_amount as bigint)) as total_default from vehicle_default_train

-- defaults as 1 , non deafaults as 0
-- Average value of disbursed_amount based on default and non deafult
select distinct loan_default from vehicle_default_train
select sum(loan_default*1.0) as total_default from vehicle_default_train;
select loan_default, avg(disbursed_amount*1.0) as avg_disb_amt from vehicle_default_train
group by loan_default

-- Showing top 10
select top 10 * from vehicle_default_train
-- Showing distinct count of branches
select count(distinct branch_id) as count_dis from vehicle_default_train
-- Showing count of records total in the table
select count(*) from vehicle_default_train
-- Showing total count of defaults in the table
select sum(loan_default*1.0) as total_default from vehicle_default_train;

--- More Group BY

select loan_default, avg(disbursed_amount*1.0) as avg_disb_amt,  
count(UniqueID) as count_of_cust ,
count(distinct branch_id) as cnt_dis_branch,
sum(disbursed_Amount*1.0) as total_Disb
from vehicle_default_train
group by loan_default

-- Complex group by situation
select top 10 * from vehicle_default_train

-- disbursed_amount, asset_cost => Aggregate side
-- Employment_Type, PERFROM_CNS_SCORE_DESCRIPTION => Group by

---- Another group by  on Employment Type, CNS SCORE DESCRIPTION
select Employment_Type, PERFORM_CNS_SCORE_DESCRIPTION, 
avg(disbursed_amount*1.0) as avg_disb_amt,
avg(asset_cost*1.0) as avg_asset_cost from vehicle_default_train
where Employment_Type is not NULL
group by Employment_Type, PERFORM_CNS_SCORE_DESCRIPTION

---- Another group by only on CNS SCORE DESCRIPTION
select  PERFORM_CNS_SCORE_DESCRIPTION, 
avg(disbursed_amount*1.0) as avg_disb_amt,
avg(asset_cost*1.0) as avg_asset_cost from vehicle_default_train
group by  PERFORM_CNS_SCORE_DESCRIPTION

--- Group by StateId and aggregate on disb amount sorted by state id
select top 10 * from  vehicle_default_train
order by State_ID

---
select top 10 * from vehicle_default_train
select state_id, avg(disbursed_amount*1.0) as amt_disb from vehicle_default_train
group by state_id
order by state_id desc;

select Employment_Type, branch_id, avg(disbursed_amount*1.0) as amt_disb from vehicle_default_train
where Employment_Type is not NULL
group by Employment_Type, branch_id
order by branch_id desc, Employment_Type desc ;

--- Having Clause
select top 10 * from vehicle_default_train

--- 1, 0, 1, 1, 0, 0, 1 (we have two values 1/0)
select branch_id, count(*) as obs, sum(loan_default) as event_count 
from vehicle_default_train
group by branch_id
having sum(loan_default) > 200
order by branch_id

-- only want to see count not less than 200, count > 200
-- Rollup / Cube / Grouping sets

-- Import this mtcars (csv)
select count(distinct cyl) from mtcars
select count(distinct gear) from mtcars


-- Cube = 3(cyl) x 3 (gear) - 1(not present) + 3 (cyl)  + 3 (gear) + 1(grand total)
-- 15 records
select avg(mpg) from mtcars
select cyl, gear, avg(mpg) as mean_mpg from mtcars
group by cube(cyl, gear)
order by cyl, gear

-- Rollup - 3(cyl) x 3 (gear) - 1 (not present) + 3(3 unique levels of cyl) + 1 (grand total)

select avg(mpg) from mtcars
select cyl, gear, avg(mpg) as mean_mpg from mtcars
group by rollup(cyl, gear)
order by cyl, gear

-- cube 
--select avg(mpg) from mtcars
select cyl, gear, avg(mpg) as mean_mpg from mtcars
group by cube(cyl, gear)
order by cyl, gear


-- grouping sets
--select avg(mpg) from mtcars
select cyl, gear, avg(mpg) as mean_mpg from mtcars
group by grouping sets((cyl, gear), ())
order by cyl, gear

----------------------- Important codes not for teaching ------------
--SELECT 
--TABLE_CATALOG,
--TABLE_SCHEMA,
--TABLE_NAME, 
--COLUMN_NAME, 
--DATA_TYPE 
--FROM INFORMATION_SCHEMA.COLUMNS
--where TABLE_NAME = 'vehicle_default_train' 

-- SELECT SERVERPROPERTY('COLLATION')
-- SELECT name, collation_name FROM sys.databases