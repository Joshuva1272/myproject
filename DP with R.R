## ----For detailed comments on code snippets , please refer to reading material----------------------------------------------------------


# for copying path 
# on mac : alt + command+ c

# windows : shift + right click ,and then select copy as path 

file='/Users/lalitsachan/Dropbox/0.0 Data/bank-full.csv'

# windows : change \ to : either / or \\

bd= read.csv(file,stringsAsFactors = F,sep=';')

# what if i want to import/read only first 1000 rows from the file
bd= read.csv(file,stringsAsFactors = F,sep=';',nrows=1000)
# what if i want to skip first 100 rows 
bd= read.csv(file,stringsAsFactors = F,sep=';',nrows=1000,skip=100)

# skip , skips the rows inlucing the top line

# what if my file has no header 
file='/Users/lalitsachan/Dropbox/0.0 Data/namesbystate/IN.TXT'

nd=read.csv(file,stringsAsFactors = F,header = FALSE)

names(nd)=c('State','gender','year','name','freq')

# can i supply my own column names , while header=F ? 

# what if i want "missing" to be read as NA

file='/Users/lalitsachan/Dropbox/0.0 Data/bank-full.csv'

bd= read.csv(file,stringsAsFactors = F,sep=';',nrows=1000,
             na.string='missing')

# excel : xlsx , openxlsx , readxl :: read.xlsx , read_xlsx 

# sas data : sas7bdat :: read.sas7bdat

read.csv('bank-full.csv')

## setwd(" Here/Goes/Path/To/Your/Data/Folder/")

## windows users will need to replace "\" with "/" or "\\" 

getwd()

setwd("/Users/lalitsachan/Dropbox/0.0 Data")

# input to setwd needs to be path to a directory

getwd()

bd=read.csv("bank-full.csv",sep=";",stringsAsFactors = F)

ld=read.csv('loans data.csv',stringsAsFactors = F)




# xlsx : openxlsx , readxl : read.xlsx , read_xls
# sas7bdat : read.sas7bdat


## ------------------------------------------------------------------------
for(i in 1:ncol(mtcars)){
  
  print((mtcars[,i]))

  }


## -----------------------------------------------------------

lapply( mtcars , mean )

sapply(mtcars,mean)

lapply(a,mean)

mydata=data.frame(v1=c(1,2,3,4,NA,5,6,7),
                  v2=sample(1:10,8))
mydata

lapply(mydata, mean )

mean(mydata$v1,na.rm=T)

# lapply(mydata, mean(na.rm=T) )

lapply(mydata, mean,na.rm=T )

sapply(mydata, mean,na.rm=T )

tapply(a$age,a$job,mean)


## --------------------------------------------------------------
## # Before running these codes , you'll have to set your working directory to the folder "namesbystate".
## # You will find this folder inside "Data" folder which you downloaded from LMS
getwd()

setwd("/Users/lalitsachan/Dropbox/0.0 Data/namesbystate")

file_names=list.files()

file_names=list.files(pattern="*.TXT")
file_names



files=lapply( file_names , read.csv ,stringsAsFactors=F,header=F)

# d=rbind(files[[1]],files[[2]],files[[3]])

# rbind(files[[1]],files[[2]],files[[3]],....)

file=do.call(rbind,files)

# write.csv to write a dataframe to your machine




names(file)=c("state","gender","year","name","count")


## ----

## ------------------------------------------------------------------------

apply(mtcars,1,mean)
apply(mtcars,2,mean)

# before applying the function apply converts the data frame to a matrix
# all the values in a matrix should be of same type

## ------------------------------------------------------------------------


tapply( mtcars$mpg , mtcars$am, mean)

tapply(mtcars$mpg, mtcars[,c("am","vs")],mean)



##

# lapply(files,write.csv)

## ----
library(dplyr)
library(hflights)


data(hflights)
## ------------------------------------------------------------------------
flights=tbl_df(hflights)
flights

## ------------------------------------------------------------------------
#note: you can use comma or ampersand to represent AND condition

d1= filter(flights, Month==1 & DayofMonth==1)


# use pipe for OR condition

d2= filter(flights, UniqueCarrier=="AA" | UniqueCarrier=="UA" )


d3= dplyr::filter(flights, UniqueCarrier %in% c("AA", "UA"))


# select 

d4=select(flights, DepTime, ArrTime, FlightNum)

d5=select(flights, -DepTime, -ArrTime, -FlightNum)

# select(flights, -DepTime, ArrTime, -FlightNum)
# # 
# select(flights, DepTime, -ArrTime, -FlightNum)
# # 
# select(flights, DepTime, -ArrTime, FlightNum)

## ------------------------------------------------------------------------

select(flights,Year,Month,DayofMonth,DayOfWeek,DepTime,TaxiIn,TaxiOut,
       ArrDelay,DepDelay)

d6= select(flights, Year:DepTime,
           contains("Taxi"), 
           contains("Delay"))



## ------------------------------------------------------------------------
# nesting method to select UniqueCarrier and DepDelay columns 
# and filter for delays over 60 minutes

first=select(flights, UniqueCarrier, DepDelay)

second=filter(first,DepDelay > 60)


filter(select(flights, UniqueCarrier, DepDelay), DepDelay > 60)

## ------------------------------------------------------------------------
x=sample(10,6)
x
sum(sin(log(x)))



x %>% 
  log() %>%
  sin() %>% 
  sum()

# ctrl/cmd + shift + M : %>% 

## ------------------------------------------------------------------------
# chaining method
d6=flights %>% 
  select(UniqueCarrier, DepDelay,contains("Time")) %>% 
  filter(DepDelay > 60) %>% 
  select(contains("Dep")) %>% 
  filter(DepDelay>100)
 


## ------------------------------------------------------------------------

d7=flights %>%
  select(UniqueCarrier, DepDelay) %>%
  arrange(UniqueCarrier,desc(DepDelay))


## ------------------------------------------------------------------------

d8=flights %>%
  select(Distance, AirTime,DepDelay,TaxiIn,TaxiOut) %>%
  mutate(speed=Distance/AirTime,
         total_taxi=TaxiIn+TaxiOut) %>% 
  select(-TaxiIn,-TaxiOut) %>% 
  mutate(time_diff=AirTime-total_taxi,
         time_diff=time_diff/60) %>% 
  arrange(time_diff) %>% 
  mutate(DepDelay_high=ifelse(DepDelay>60,1,0))



## ------------------------------------------------------------------------
# create a table grouped by Dest, and then summarise each group by taking the mean of ArrDelay

d8=flights %>%
  group_by(Dest,Month) %>% 
  summarise(avg_delay = mean(ArrDelay,na.rm=T))

## ------------------------------------------------------------------------

# n() : gives number of observation/rows

flights %>%
  group_by(Month, DayofMonth) %>%
  summarise(flight_count = n()) %>% 
  arrange(desc(flight_count) )


# tally
flights %>%
  group_by(Month, DayofMonth) %>%
  tally(sort=TRUE) 



flights %>%
  group_by(Dest) %>%
  summarise(flight_count = n(),
            plane_count = n_distinct(TailNum))


# for each destination, show the number of cancelled and not 
# cancelled flights

flights %>% 
  select(Dest,Cancelled) %>% 
  group_by(Dest,Cancelled) %>% 
  summarise(f_count=n())

flights %>% 
  select(Dest,Cancelled) %>% 
  group_by(Dest) %>% 
  summarise(f_count=n(),
            cancelled_f=sum(Cancelled)) %>% 
  mutate(non_c_f=f_count-cancelled_f)



d9=flights %>%
  mutate(Cancelled=ifelse(Cancelled==1,"A","B")) %>% 
  select(Dest,Cancelled)

d9 %>%   
  group_by(Dest) %>%
  summarize(c1=sum(Cancelled=="A"),
            total=n(),
            c2=total-c1,
            c3=sum(Cancelled=="B")) %>%
  select(-total)



# for each month, calculate the number of flights and the 
# change from the previous month



flights %>%
  group_by(Month) %>%
  summarise(flight_count = n()) %>%
  mutate(lagged_col=lag(flight_count,1),
    change = flight_count - lagged_col)

# filter , select , arrange , mutate , group_by+summarise
# tbl_df , n(): number of obs , n_distinct(col): number of distinct obs
# lag : lagged columns

d=data.frame('x'=c('a','a','b','b','a','b'),'y'=sample(100,6),stringsAsFactors = F)

d %>% 
  summarise(y_avg=mean(y))

d %>% 
  mutate(y_avg=mean(y))

d %>% 
  group_by(x) %>% 
  summarise(y_avg=mean(y))

d %>% 
  group_by(x) %>% 
  mutate(y_avg=mean(y))


# for each dest , every month 
# find out which month has highest count of flights , 
# second and 5th highest count of flights and least count of flight
# post the solution on qa forum

## summarise all, summarise at , summarise if

flights %>% 
  select(Dest,DepDelay,ArrDelay,AirTime,Distance) %>% 
  group_by(Dest) %>% 
  summarise(depdelay_avg=mean(DepDelay,na.rm=T),
            arrdelay_avg=mean(ArrDelay,na.rm=T),
            airtime_avg=mean(AirTime,na.rm=T),
            distance_avg=mean(Distance,na.rm=T))

flights %>% 
  select(Dest,DepDelay,ArrDelay,AirTime,Distance) %>% 
  group_by(Dest) %>% 
  summarise_all(mean,na.rm=T)

flights %>% 
  select(Dest,DepDelay,ArrDelay,AirTime,Distance) %>% 
  group_by(Dest) %>% 
  summarise(depdelay_avg=mean(DepDelay,na.rm=T),
            arrdelay_avg=mean(ArrDelay,na.rm=T),
            )

flights %>% 
  select(Dest,DepDelay,ArrDelay,AirTime,Distance) %>% 
  group_by(Dest) %>% 
  summarise_at(vars(DepDelay,ArrDelay),mean)

flights %>% 
  select(Dest,DepDelay,ArrDelay,AirTime,Distance) %>% 
  summarise_all(mean,na.rm=T)

flights %>% 
  select(Dest,DepDelay,ArrDelay,AirTime,Distance) %>% 
  summarise_if(is.numeric,mean,na.rm=T)

## joins 

df1 = data.frame(id=c(1,2,3,4,5,6),
                 Product=c(rep("Toaster",3),rep("Radio",3)))

df2 = data.frame(id=c(5,6,7,8),
                 State=c(rep("Alabama",2),rep("Ohio",2)))

inner=inner_join(df1,df2,by='id')
inner

left=left_join(df1,df2,by="id")
left

right=right_join(df1,df2,by="id")
right

full=full_join(df1,df2,by="id")
full

semi=semi_join(df1,df2,by="id")
semi

anti=anti_join(df1,df2,by="id")
anti

# dplyr approach: better formatting, and adapts to your screen width
str(flights)
glimpse(flights)


## tidyr and lubridate
## ----
library(tidyr)

wide= data.frame(
  name = c("Wilbur", "Petunia", "Gregory"),
  a = c(67, 80, 64),
  b = c(56, 90, 50),
  c=c(10,20,30),
  d=c(0,1,2),
  e=c(-3,5,6)
)
wide

wide %>% 
  gather(drug,measurement,a:e)

# what if i do not want to reshape all of a,b,c,d,e



## ----
set.seed(10)
wide= data.frame(
  id = 1:4,
  trt = rep(c('control', 'treatment'), each = 2),
  work.T1 = runif(4),
  home.T1 = runif(4),
  work.T2 = runif(4),
  home.T2 = runif(4)
)

wide



## ------------------------------------------------------------------------
long = wide %>%
  gather(key,time,work.T1:home.T2)
long

## ------------------------------------------------------------------------
long1=long %>% 
  separate(key,into=c("key1","key2"),sep="\\.") 

# why \\. but not . : this will be completely answered when we discuss regular expressions

long1

## ------------------------------------------------------------------------
step1= long1 %>%
  unite(untkey,key1,key2,sep="-")

step1
step2=step1 %>%
  spread(untkey,time)
step2

## ----
library(lubridate)

ymd("20110604")
mdy("06-04-2011")
dmy("04/06/2011")

# y : year
# m : month
# d : day


## ------------------------------------------------------------------------


arrive = ymd_hms("2011-06-04 12:00:00", tz = "Pacific/Auckland")

leave = ymd_hms("2011-08-10 14:00:00", tz = "Pacific/Auckland")

OlsonNames()


## please find out documentation for list of time zones , what all options i can give to tz

## ------------------------------------------------------------------------
second(arrive)

second(arrive) = 25

arrive

second(arrive) = 0
arrive

wday(arrive)

wday(arrive, label = TRUE)

quarter(arrive)

day(arrive)

day(arrive)=32

arrive

month(arrive)

## can we have datetime data with microseconds in R

## ------------------------------------------------------------------------
meeting = ymd_hms("2011-07-01 09:00:00", tz = "Pacific/Auckland")

## ------------------------------------------------------------------------
with_tz(meeting, "Asia/Kolkata")

OlsonNames() # gives time zone keyword

## ------------------------------------------------------------------------
leap_year(2011)

ymd(20110101) + dyears(1)

ymd(20110101) + years(1)

## ------------------------------------------------------------------------
 
leap_year(2020)

ymd(20110101) + dyears(12) #adding exactly 365 days 

ymd(20110101) + years(12) # this explicitly add one year

# ymd(20120101) + months(3)

## Find out how to take difference of two dates 
## how to get the output of difference in 
## different units : minutes , days, months

d1=ymd(20110101)
d2=ymd(20110101) + dyears(12)


## ------------------------------------------------------------------------
# d= two digit date
# y = two digit year
# b = abbreviated month name
# Y= 4 digit year
# B = complete month name
# p = for  am pm
# m = month in numbers
# %H:%M = time is in 24 hrs format
# %I:%M = time is in 12 hr format , this needs to be accompanied by p

parse_date_time("01-12-Jan","%d-%y-%b")

z=parse_date_time("2012-01-January 10:05 PM","%Y-%d-%B %I:%M %p")

# how do i covert unix time stamp to R datetime format

# extracting date time in specfic format from POSIXt object 

format(z,"%Y-%b")

# January/1/12

format(z,"%B/%d/%y")




#Function can be used seamlessely for vectors as well

x = c("09-01-01", "09-01-02", "09-01-03")
parse_date_time(x, "ymd")
parse_date_time(x, "%y%m%d")
parse_date_time(x, "%y %m %d")


#######

setwd("/Users/lalitsachan/Dropbox/March onwards/CBAP with R/Data/")

ci=read.csv("census_income.csv",stringsAsFactors = F)

# how many unique : 42
length(unique(ci$native.country))
# what all categories have frequency higher than or equal 100 ( with in native.country)
t=table(ci$native.country)

## 
names(t)

t[t>=100]
names(t[t>=100])

sort(t[t>=100])

sub_t=sort(t[t>=100])

names(sub_t[-1])



CreateDummies=function(data,var,freq_cutoff=100){
t=table(data[,var])
t=t[t>freq_cutoff]
t=sort(t)
categories=names(t)[-1]

for( cat in categories){
  name=paste(var,cat,sep="_")
  name=gsub(" ","",name)
  name=gsub("-","_",name)
  name=gsub("\\?","Q",name)
  
  data[,name]=as.numeric(data[,var]==cat)
}

data[,var]=NULL
return(data)
}

ci=CreateDummies(ci,'marital.status',100)

ci=CreateDummies(ci,'native.country',100)

##### Regular Expressions #######

# 1 : we know how to match by providing exact letters or digit

myvec=c("a7bc123xyz","1define456","789sth","379tut26")

gsub("123","MATCH",myvec)

# substitute all the strings having digits
# \\d stands for a digit in regular expression

gsub("\\d","MATCH",myvec)



gsub("\\d\\d\\d","MATCH",myvec)


gsub("\\d\\d9","MATCH",myvec)


## \\w : means any character including numbers except special charactaers


# 2 : . means any single character, for symbol . use \\. 

myvec=c("ab@c","123#","$qwe.123","...","1 2")

gsub(".","MATCH",myvec)

gsub("\\.","MATCH",myvec)

#exercise : substitute first two members only with a single MATCH

myvec=c("8.c6","?Q+.","abc1")

# "MATCH","MATCH","abc1"

gsub(".\\...","Match",myvec)

# 3 : replacing multiple characters at once

myvec=c("<#abc","#abc","abc<%#","dhgt%<#")

gsub("<","Match",myvec)
gsub("#","Match",myvec)
gsub("%","Match",myvec)

gsub("<%#","Match",myvec)

gsub("[<#%]","MATCH",myvec)

# gsub("<#%|<%#","MATCH",myvec)


#"<#abc","#abc","abcMATCH","dhgtMATCH")

gsub("[<#%][<#%][<#%]","MATCH",myvec)


# 4 : excluding a pattern with metacharacter ^

myvec=c("<abc","#1abc","bca%","ajdba@@$ghbc")


gsub("[^abc]","MATCH",myvec)



# 5 : character ranges with -

myvec=c("<ab:c","#def","zghi%","aMz")

gsub("[^a-z]","MATCH",myvec)


gsub("[a-z]","MATCH",myvec)


# 6 : more compact way for repetition

myvec=c("abc123xyz","define456","789sth","379tut6","3798tut6")

gsub("\\d\\d\\d","MATCH",myvec)

gsub("\\d{3}","MATCH",myvec)

gsub("\\d{3,}","MATCH",myvec)

myvec=c("abc123xy1234z12345","def456754ine456","789sth","379tut6")

gsub("\\d{3,5}","MATCH",myvec)




#input
myvec=c("abc123xy1234z12345","def4567ine456","789sth","379tut6")

#output
myvec=c("abcMATCHxy1234z12345","def4567ineMATCH","MATCHsth","MATCHtut6")



gsub("\\d{1,}","MATCH",myvec)


# 7 : Kleene Plus and Kleene Star

# * means it matches zero or more character
# + means it matches atleast one or more character

# people names
people = c("rori", "emmilia", "matteo", "mehmemt", "filipe", "anna", 
           "tyler",
           "rasmus", "mt jacob", "youna", "flora", "adi mmt")

# match m zero or more times, and t
gsub("m*t","MATCH",people)

# match m atleast one or more times
gsub("m+t","MATCH",people) # mt , mmt, mmmt, mmmmt......

# 8 : metacharacter or with ?

myvec=c("ac","abc","ab?c","12ac")

gsub("abc","MATCH",myvec)

gsub("ab?c","MATCH",myvec)

gsub("ab?\\??c","MATCH",myvec) # ab?c , a?c , abc , ac


# 9 : \\s stands for any white space : " " , \\t , \\n

# 10 : ^ start and $ end

myvec=c("abc456","456abc","abc456abc")


gsub("abc$","MATCH",myvec)


myvec=c("file_record_transcript.pdf","file_07241999.pdf",
        "fileabcpdf","file.pdf","test_fileabc.pdf","file_fake.pdf.tmp",
        "file_record_transcript.pdff","fileabc.pdf")

# MATCH , MATCH, "fileabcpdf","file.pdf",MATCH,"file_fake.pdf.tmp","file_record_transcript.pdff",MATCH

gsub("^file[a-zA-Z0-9_]+\\.pdf$","MATCH",myvec)


myvec=c("abc","askdabc575","abc23784bsd","34723abc23894abc")

gsub("abc$","-",myvec)


# 11 : groups with ()

myvec=c("ac","abc","aQAc","12ac")

gsub("ab?Q?A?c","MATCH",myvec) # ac , abc ,aQC, aAc , abQc , ...

gsub("ab?QA?c","MATCH",myvec) # abQAc , aQc , aQAc , abQc 

gsub("ab?(QA)?c","MATCH",myvec)

# try to come up with a regular expression for email ids
# think about an email id , which will not be captured by 
# the expression that you just camp up with

# write a regex date
# write a regex phone numbers


# anonymous function

mycustom_func=function(x){
  max_val=max(x)
  min_val=min(x)
  
  return(min_val+max_val)
}

apply(mtcars,2,mycustom_func)

apply(mtcars,2,function(x) min(x)+max(x))
library(dplyr)

mtcars %>% 
  group_by(am) %>% 
  summarise(mpg_avg=mean(mpg))

tapply(mtcars$mpg,mtcars$am,mean)













### discussion on grep and grepl

x=c("lalit","lalit sachan","ankit sharma","lalti kumar")

grep("lalit",x)

grep("lalit",x,value = T)

grep("janardhan",x)

grepl("lalit",x)

grepl("janardhan",x)


