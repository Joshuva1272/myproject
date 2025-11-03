-- Data Definition Language Commands : Create, drop, alter
-- Data Manipulation Language commands : Insert , Update, Delete
--select * from localdb_pk.dbo.Employees
--where ManagerID <> NULL

-- This also works with databases
create database mydb; -- Create
alter database mydb modify name =  mydb1; -- Rename 
drop database mydb1; -- Drop (delete the database)


create database mydb -- Again Create it
-- creating a table
-- Write a database
-- DDL command to create a table
create table mydb.dbo.person ( 
Id int, 
FName varchar(50), 
GenderIdk int,
age int
) 

-- Adding the column
-- DDL for attaching a column
alter table mydb.dbo.person add place varchar(40);
alter table mydb.dbo.person add email varchar(50);

select * from mydb.dbo.person
alter table mydb.dbo.person drop column email ;
select * from mydb.dbo.person

alter table mydb.dbo.person alter column genderidk  varchar(8);
select * from mydb.dbo.person

use mydb;
select * from INFORMATION_SCHEMA.columns

-- drop table person;
create view myview as  select * from mydb.dbo.person
select * from myview
drop view myview;

-- DML
-- Insert / Update / Delete
use mydb;

drop table student;

create table student ( 
Name varchar(50), 
RollNo int, 
Gender varchar(10),
city varchar(10)
) 

select * from student

-- Insert/update/delete

insert into student 
values ('swaroopa singh', 3, 'female', 'mumbai');
-- Provide column names if you need and you can append more than one row as well
insert into student ( name, rollno,  city, gender )
values ('karan singh', 4,'kolkata', 'male' ), 
	 ('sudeep roy', 5, 'kolkata','male' );

select * from student

--- Updating a table with update table
-- use mydb

update student
set name = 'swaroopa shivangi'
where rollno = 3;

select * from dbo.student
-- Comment: Ctrl + K then Ctrl + C
-- Uncomment: Ctrl + K then Ctrl + U

-- Deleting a row
DELETE FROM student WHERE rollno = 3;
select * from dbo.student





-------------- This is validated until here -----------------------

--drop table mydb.dbo.person
--drop table mydb.dbo.gender


-- Creating Constraints
-- NULL
-- NULL -> YOU can't add basically A null value
-- use mydb


create table mydb.dbo.person (Id int not null primary key, 
FName varchar(50), GenderIdk  int not null , 
age int not null) 

-- creating a table
create table mydb.dbo.gender (GenderIdk int , 
Gender VARCHAR(10)) -- creating a table

-- drop table mydb.dbo.gender

insert into person (id, Fname, GenderIdk, age) 
values (1, 'Mohan', 1, 20)
insert into person (id, Fname, GenderIdk, age) 
values (2, 'Garima', 2, 25)
insert into person (id, Fname, GenderIdk, age) 
values (3, 'Reema', 2, 30)
insert into person (id, Fname, GenderIdk, age) 
values (4, 'Faiz', 99, 45)
insert into person (id, Fname, GenderIdk, age) 
values (5, 'Florence', 2, 78)
insert into person (id, Fname, GenderIdk, age) 
values (6, 'Kamala', 3, 65)


insert into gender (GenderIdk, Gender) values (1, 'Male')
insert into gender (GenderIdk, Gender) values (2, 'Female')
insert into gender (GenderIdk, Gender) values (3, 'Other')
insert into gender (GenderIdk, Gender) values (99, 'Unknown')
-- insert into gender (GenderIdk, Gender) values (99, 'Unknown')


-- insert into gender (GenderIdk, Gender) values (NULL, 'Missing')
-- DELETE FROM gender WHERE GenderIdk is  NULL;

select * from person;
select * from gender;

-- Adding null constraint
alter table gender alter column GenderIdk int not null;

insert into mydb.dbo.gender (GenderIdk, Gender) 
values (4, 'Unknown')
-- alter table gender alter column Gender varchar(10) not null;

-- adding unique constraint
ALTER TABLE mydb.dbo.gender ADD UNIQUE (GenderIdk);
delete from mydb.dbo.gender where GenderIdk = 4;
ALTER TABLE mydb.dbo.gender ADD UNIQUE (Gender);

-- insert into mydb.dbo.gender (GenderIdk, Gender) values (1, 'Males')

-- primary key constraint
ALTER TABLE mydb.dbo.gender 
ADD CONSTRAINT pk_constraint_gender 
PRIMARY KEY (GenderIdk);

-- foreign constraint
Alter table mydb.dbo.person add CONSTRAINT 
person_genderidk_fk FOREIGN key (GenderIdk) 
REFERENCES gender(GenderIdk)

select * from person
select * from gender

insert into person (id, Fname, GenderIdk, age) 
values (7, 'Rohan', 1, 65)


select * from mydb.dbo.gender

insert into mydb.dbo.person (id, Fname, GenderIdk, age) 
values (8, 'Kamala', 3, 65)

-- insert into mydb.dbo.person (id, Fname, GenderIdk, age) values (8, 'Kamala', 10, 65)
-- The valid numbers are only 1, 2, 3, 99
-- You can' add any other values now 

-- Having a constraint values such that a default can be passed 
-- Before I use the below constrain 
-- We need to remove the previous constraint 
-- ALTER TABLE mydb.dbo.person drop constraint person_genderidk_fk

Alter table mydb.dbo.person 
ADD CONSTRAINT df_person_GenderIdk
default 99 for GenderIdk

-- default constraint
insert into mydb.dbo.person (id, Fname, age) values (10, 'Mohita', 17)
select top 10 * from mydb.dbo.person

-- Check constraint 
-- Adding an age check constraint 

insert into person (id, Fname, GenderIdk, age) 
values (11, 'Shashi', 2, 789)
select * from person

alter table mydb.dbo.person add  constraint 
ck_person_age check  ( age > 0 and age < 120)

-- delete from mydb.dbo.person where age > 120;

select * from person

insert into mydb.dbo.person (id, Fname, GenderIdk, age) values (12, 'Florence', 2, 79)
-- insert into mydb.dbo.person (id, Fname, GenderIdk, age) values (11, 'Mary', 2, 789)
-- The above will not work as the constraint is added

-- Dropping a constraint 
ALTER TABLE mydb.dbo.person drop CONSTRAINT df_person_GenderIdk
ALTER TABLE mydb.dbo.person drop CONSTRAINT ck_person_age



