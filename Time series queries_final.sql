-- Trending the data
-- Simple trends
-- Seeing the trends of a timeseries data
use backup_sql_v2;
select top 50 * from us_retail_sales;
-- hypothesis 
-- is sales and reason_for_null are both NULL at same time -- count *
-- are there more business or just 10 -- count distinct
-- naics_code is primary ?
-- is this data monthly?
-- is there a chance that every kind of business would have only 12 in a year

select count(*) as cnt from us_retail_sales
where reason_for_null is NULL and sales is NULL

select count(*) from us_retail_sales where kind_of_business is null
select count (distinct kind_of_business) from us_retail_sales

select kind_of_business, count(*) from us_retail_sales
group by kind_of_business

select count(*) from us_retail_sales where naics_code is not null


select count(*) from us_retail_sales -- 22620
select count(sales_month) as cnt from 
us_retail_sales where naics_code is not null -- 20184

-- select distinct kind_of_business from us_retail_sales

select count(*) as cnt, count (distinct naics_code) as unq_cnt 
from (select * from us_retail_sales where naics_code is not NULL) as a

select top 20 * from us_retail_sales

select * from us_retail_sales

select  naics_code,years, count(distinct months) as counts from(
SELECT datepart(month, sales_month) as months, 
datepart(year, sales_month) as years,
naics_code
FROM us_retail_sales
where naics_code is not NULL
) as a
group by naics_code, years
having count(*) <> 12
order by years


-- select count(*) from us_retail_sales where kind_of_business is NULL

-- select min(sales_month), max(sales_month) from us_retail_sales

select kind_of_business , count(*) as countval from (
select kind_of_business, years,count(*) as count_val from (
select datepart(year, sales_month) as years, kind_of_business 
from us_retail_sales
-- where kind_of_business = 'Retail and food services sales, total'
) as a
--where kind_of_business = 'Gasoline stations'
group by years, kind_of_business
order by 2, 1
) as b
group by kind_of_business
-- having count(*) <> 29


-----------------------------------------
-- For a group 'Retail and food services sales, total' , generate a trend for sales
-- Group by aggregate with sales year on total aggregation

select top 10 * from us_retail_sales

-- select * from us_retail_sales where kind_of_business = 'Retail and food services sales, total'

SELECT datepart(year, b.sales_month) as sales_year
,sales FROM us_retail_sales as b
WHERE kind_of_business = 'Retail and food services sales, total'


-- 3 
select b.* from (
select a.sales_year, sum(a.sales) as sales_total from 
(SELECT datepart(year, b.sales_month) as sales_year
,sales FROM us_retail_sales as b
WHERE kind_of_business = 'Retail and food services sales, total'
) as a
GROUP BY sales_year
--ORDER BY sales_year
) as b
order by sales_total
;

-- Group by doesn't work with numbers 1, 2 etc
-- A computed column can't be used in SQL server even 
-- if it is not aggregated one
-- Comparing components
-- Adding more layers with sales value on time front

select b.sales_year, b.kind_of_business, 
sum(b.sales) as total_sales from
(
SELECT datepart(year,a.sales_month) as sales_year , a.kind_of_business ,a.sales
FROM us_retail_sales as a 
WHERE kind_of_business in ('Book stores','Sporting goods stores','Hobby, toy, and game stores')
) as b
group by sales_year, kind_of_business
order by 1, 2
;

select distinct kind_of_business from us_retail_sales

-- Adding more filters and components with apostrophe

select b.sales_year, b.kind_of_business, sum(b.sales) as total_sales from
(
SELECT datepart(year,a.sales_month) as sales_year , a.kind_of_business ,a.sales
FROM us_retail_sales as a 
WHERE kind_of_business in ('Men''s clothing stores',
'Women''s clothing stores')
) as b
group by sales_year, kind_of_business
order by 1, 2
;

--- Case when ---
--- When sales type is given convert it using two columns based 
-- on mens and womens sales ---
select b.sales_year, sum(b.womens_sales) as women_sales_total, 
sum(b.mens_sales) as mens_sales_total from
(
        SELECT datepart(year,a.sales_month) as sales_year
        ,sum(case when a.kind_of_business = 'Women''s clothing stores' 
		then sales end) as womens_sales

        ,sum(case when a.kind_of_business = 'Men''s clothing stores' 
		then sales end) as mens_sales
        
		FROM us_retail_sales as a 
        WHERE a.kind_of_business in ('Men''s clothing stores','Women''s clothing stores')
        GROUP BY sales_month
) as b
group by sales_year

;

-- Creating a table using a query
-- The SELECT INTO statement creates a new table and populates it with the result set of the SELECT statement. 
-- SELECT INTO can be used to combine data from several tables or views into one table. 
-- It can also be used to create a new table that contains data selected from a linked server.
-- https://stackoverflow.com/questions/51983381/sql-create-table-does-not-work-in-sql-server-management-studio-ssms

select * into  #t_men_women  from (
select b.sales_year, sum(b.womens_sales) as women_sales_total, 
sum(b.mens_sales) as mens_sales_total from (
        SELECT datepart(year,a.sales_month) as sales_year
        ,sum(case when a.kind_of_business = 'Women''s clothing stores' 
		then sales end) as womens_sales
        ,sum(case when a.kind_of_business = 'Men''s clothing stores' 
		then sales end) as mens_sales
        FROM us_retail_sales as a 
        WHERE a.kind_of_business in ('Men''s clothing stores',
		'Women''s clothing stores')
        GROUP BY sales_month
) as b
group by sales_year
) as newtable

select * from #t_men_women


-- Where clauses with time
select b.sales_year, sum(b.womens_sales) as women_sales_total, 
sum(b.mens_sales) as mens_sales_total from (
        SELECT datepart(year,a.sales_month) as sales_year
        ,sum(case when a.kind_of_business = 'Women''s clothing stores' 
		then sales end) as womens_sales
        ,sum(case when a.kind_of_business = 'Men''s clothing stores' 
		then sales end) as mens_sales
        FROM us_retail_sales as a 
        WHERE a.kind_of_business in ('Men''s clothing stores',
		'Women''s clothing stores') and sales_month < '2015-01-01'
        GROUP BY sales_month
) as b
group by sales_year

-- Time between two ranges 

select b.sales_year, sum(b.womens_sales) as women_sales_total, sum(b.mens_sales) as mens_sales_total from (
        SELECT datepart(year,a.sales_month) as sales_year
        ,sum(case when a.kind_of_business = 'Women''s clothing stores' 
		then sales end) as womens_sales
        ,sum(case when a.kind_of_business = 'Men''s clothing stores' 
		then sales end) as mens_sales
        FROM us_retail_sales as a 
        WHERE a.kind_of_business in ('Men''s clothing stores',
		'Women''s clothing stores') and 
		sales_month between '2007-01-01' and '2014-12-31'
        GROUP BY sales_month
) as b
group by sales_year

-- Percent of total calculations (using self join)
-- Group by on each month ()

SELECT a.sales_month
        ,a.kind_of_business
        ,a.sales as total_sales
        FROM us_retail_sales as a

SELECT sales_month, kind_of_business, sales * 100.0 / total_sales as pct_total_sales, sales, total_sales
FROM
(
        SELECT a.sales_month
        ,a.kind_of_business
        ,a.sales
        ,sum(b.sales) as total_sales
        FROM us_retail_sales a
        JOIN us_retail_sales b on a.sales_month = b.sales_month
        and b.kind_of_business in ('Men''s clothing stores'
         ,'Women''s clothing stores')
        WHERE a.kind_of_business in ('Men''s clothing stores',
		'Women''s clothing stores')
        GROUP BY a.sales_month, a.kind_of_business,a.sales
		--order by sales_month
) aa
ORDER BY 1,2
;


-- Alternate solution -----

SELECT sales_month
,kind_of_business
,sales
,sum(sales) over (partition by sales_month) as total_sales
,sales * 100 / sum(sales) over (partition by sales_month) as pct_total
FROM us_retail_sales 
WHERE kind_of_business in ('Men''s clothing stores','Women''s clothing stores')
ORDER BY 1
;

--- Yearly sales , sales divided by yearly sales

SELECT sales_month
,kind_of_business,sales, yearly_sales
,sales * 100.0 / yearly_sales as pct_yearly
FROM
(
        SELECT a.sales_month
        ,a.kind_of_business
        ,a.sales
        ,sum(b.sales) as yearly_sales
        FROM us_retail_sales a
        JOIN us_retail_sales b on datepart(year,a.sales_month) = datepart(year,b.sales_month)
        and a.kind_of_business = b.kind_of_business
        and b.kind_of_business in ('Men''s clothing stores','Women''s clothing stores')
        WHERE a.kind_of_business in ('Men''s clothing stores','Women''s clothing stores')
        GROUP BY a.sales_month, a.kind_of_business, a.sales
) aa
ORDER BY 1,2
;

--- Yearly sales, using partition by and over clause

SELECT sales_month, kind_of_business, sales
,sum(sales) over (partition by datepart(year,sales_month), kind_of_business) as yearly_sales
,sales * 100.0 / sum(sales) over (partition by datepart(year,sales_month), kind_of_business) as pct_yearly
FROM us_retail_sales 
WHERE kind_of_business in ('Men''s clothing stores','Women''s clothing stores')
ORDER BY 1,2
;


-- Rolling mean from previous 12 months -- this is amazing as it counts window with 11 months gap
-- Keep calculating the rolling mean for every month as the data progresses
-- Using partition by 
select (1873+1991) / 2

select sales_month, sales from us_retail_sales where
kind_of_business = 'Women''s clothing stores'
order by sales_month

SELECT sales_month, sales, 
avg(sales) over (order by sales_month rows between 11 preceding and current row) as moving_avg
,count(sales) over (order by sales_month rows between 11 preceding and current row) as records_count
FROM us_retail_sales
WHERE kind_of_business = 'Women''s clothing stores'
;

-- Calculating cumulative values (Rolling sum) for sales for every month, Note it breaks when year changes

SELECT sales_month, sales, sum(sales) over 
(partition by datepart(year,sales_month) order by sales_month) 
as sales_ytd
FROM us_retail_sales
WHERE kind_of_business = 'Women''s clothing stores'
;

--- Done ----
------- Analyzing with seasonality
-- Period over period comparisons with breaks on kind of business
SELECT kind_of_business, sales_month, sales, lag(sales_month) 
over (partition by kind_of_business order by sales_month) as prev_month
,lag(sales) over (partition by kind_of_business order by sales_month) as prev_month_sales
FROM  us_retail_sales
-- WHERE kind_of_business = 'Book stores'
;

-- Percentage change over from previous record break on kind_of_business
-- (po - p1) / po
-- 1 - p1/po
SELECT kind_of_business, sales_month, sales
,(1- sales*1.0 / lag(sales) over (partition by kind_of_business 
order by sales_month)) * 100 as pct_growth_from_previous
FROM  us_retail_sales
WHERE kind_of_business = 'Book stores'
;

-- yearly sales and percentage change
-- yoy 
SELECT a.sales_year, a.yearly_sales
,lag(yearly_sales) over (order by sales_year) as prev_year_sales
,(yearly_sales*1.0 / lag(yearly_sales) over (order by sales_year) -1) * 100 as pct_growth_from_previous
FROM
( select sales_year, sum(yearly_sales) as yearly_sales from(
        SELECT datepart(year, sales_month) as sales_year
        ,sum(sales) as yearly_sales
        FROM  us_retail_sales
        WHERE kind_of_business = 'Book stores'
        GROUP BY sales_month
) b group by sales_year
) a
;

-- Period over period comparisons - Same month vs. last year
SELECT sales_month
,datepart(month,sales_month)
FROM us_retail_sales
WHERE kind_of_business = 'Book stores'
;

-- Yaer on year on same month of january change in sales 
-- Different from continous dates , this continuity is based on months on each year rather than months in an year

SELECT sales_month
,sales
,lag(sales_month) over (partition by datepart(month,sales_month) order by sales_month) as prev_year_month
,lag(sales) over (partition by datepart(month,sales_month) order by sales_month) as prev_year_sales
FROM us_retail_sales
WHERE kind_of_business = 'Book stores'
;

-- Percentage change on the same month on every year, again not continous on every month but month on every year
SELECT sales_month, sales
,sales - lag(sales) over (partition by datepart(month,sales_month) order by sales_month) as absolute_diff
,(sales*1.0 / lag(sales) over (partition by datepart(month,sales_month) order by sales_month) - 1) * 100 as pct_diff
FROM us_retail_sales
WHERE kind_of_business = 'Book stores'
;

-- Create columns and transposing data
select top 10 * from us_retail_sales where
kind_of_business = 'Book stores' and sales_month between '1992-01-01' and '1994-12-01'
order by sales_month

select a.month_name, a.month_number, max(sales_1992) as sales_1992, 
max(sales_1993) as sales_1993, 
max(sales_1994) as sales_1994 from (
SELECT datepart(month,sales_month) as month_number
,DATENAME(month, sales_month) as month_name
,(case when datepart(year,sales_month) = 1992 then sales end) as sales_1992
,(case when datepart(year,sales_month) = 1993 then sales end) as sales_1993
,(case when datepart(year,sales_month) = 1994 then sales end) as sales_1994
FROM us_retail_sales
WHERE kind_of_business = 'Book stores' and sales_month between '1992-01-01' and '1994-12-01'
--order BY sales_month 
) as a 
group by month_number, month_name
order by month_number
;

-- Slightly tweaked compared to the video -- 
-- This code is more generic --
SELECT kind_of_business, sales_month, sales
,lag(sales,1) over (partition by datepart(month,sales_month), kind_of_business
order by sales_month) as prev_sales_1
,lag(sales,2) over (partition by datepart(month,sales_month), kind_of_business 
order by sales_month) as prev_sales_2
,lag(sales,3) over (partition by datepart(month,sales_month) , kind_of_business
order by sales_month) as prev_sales_3
FROM us_retail_sales
--WHERE kind_of_business = 'Book stores'
;

-- This is very interesteing , it takes 3 last record(from filtered records not from original data) takes the average
-- divide the data with average
-- In first observation ,there were no three records hence the NULL
-- The second record has only one previous : 998/790 
-- The third rocord has only two previous : 1053/((998+790)/2)


SELECT sales_month, sales
,sales*1.0 / avg(sales) over (
        partition by datepart(month,sales_month) 
        order by sales_month rows between 3 preceding and 1 preceding
        ) as pct_of_prev_3
FROM  us_retail_sales
WHERE kind_of_business = 'Book stores'
;









