-- index allow us to find data quickly
-- index improves searches
-- we create index
-- only one clustered index is possible in a table
-- primary key contraint always create a clustered index (unique)
-- But combination of columns can be used for creating clustered index
-- There are other kinds of indexes like hash, filtered, spatial etc
-- cluster index determines physical order of data

exec sp_helpindex employees

use localdb_pk
Create index ix_employee_salary on employees (FirstName asc)


select * from Employees

drop index ix_employee_salary on employees

-- nonclustered index and clustered index
drop table Employees2

create table employees2 
(id int primary key, 
names varchar(50),
salary  int,
gender varchar(10),
city varchar(20)
)

exec sp_helpindex employees2

insert into employees2 values (10, 'kumar', 10000, 'male', 'delhi')
insert into employees2 values (2, 'samar', 20000, 'male', 'chennai')
insert into employees2 values (7, 'sujata', 30000, 'female', 'mumbai')
insert into employees2 values (3, 'kartik', 50000, 'male', 'chennai')

Create clustered index ix_employee_salary2 on employees2 (id asc)
select * from employees2

Create nonclustered index ix_employee_salary3 on employees2 (names asc)
Create nonclustered index ix_employee_salary4 on employees2 (salary asc, gender asc) -- composite index


drop table employees3
create table employees3
(id int, 
names varchar(50),
salary  int,
gender varchar(10),
city varchar(20)
)

exec sp_helpindex employees3

insert into employees3 values (10, 'kumar', 10000, 'male', 'delhi')
insert into employees3 values (2, 'samar', 20000, 'male', 'chennai')
insert into employees3 values (7, 'sujata', 30000, 'female', 'mumbai')
insert into employees3 values (3, 'kartik', 50000, 'male', 'chennai')

select * from employees3

alter table employees3
add constraint uq_employee_id
unique clustered(id)

-- slower update/delete/insert
-- takes up space and memory