
x=5 # this is how you create an object 

# to execute : click on the run button or select the code and run : ctrl/cmd + enter

# shortcut

# for commenting
# lines in your code file = 
# select the lines to be commented and then =>ctrl/cmd + shift + c

x

X

X='something' # character data needs to be in quotes . 

# it doesnt matter if they are single or double quotes

# strings , categorical data might be used in place of character data

x='lalit'

# object name can be as long as you want
# object names can not contain spaces

mynumber=10.2

# object names can have two special characters = _ [underscore], . [dots]

my.number=10.2
my_number=10.2

# why not $,#,%,@ : they have other meanings associated with them

# object names can not start with a number, you can have numbers in the object name
# elsewhere

## ------------------------------------------------------------------------
## naming rules
1.more=2.34 # starts with a number

more1=283

one.more=2.34
onemore object=2.34 # there is a space in the object name
one.more.object$=2.34 # there is $ there in the name

one.more12.object13=56.7 # nothing wrong with this


# you can use dots(.) and underscore ( _ )
# you cannot have other special characters in the name
# you can use numbers also in object , BUT not at the begining

## ------------------------------------------------------------------------


#objects can be reassigned on the fly

x="Hadley Wickham"

# shortcut for clearing console : go to console : and then : ctrl+L

# removing objects from environment

rm(lalit,Lalit,this_is_an_object_that_i_am_going_to_create,thisisanobjectthatiamgoingtocreate)

## ------------------------------------------------------------------------
## logical values true and false, that has to be in caps
x=FALSE
x

y=TRUE


# to remove all the objects : rm(list=ls())
## ------------------------------------------------------------------------
x=T
x

## ------------------------------------------------------------------------
# now we will be looking at class, type of the object


x="bunny"
y=F
z=4.5

class(x)

class(y)

class(z)


## ------------------------------------------------------------------------
# anything within quotes is character for R

v1="23.45"

class(v1)

# you cannot do numeric operation on this

v1+2

## ------------------------------------------------------------------------
# change the type, given it is possible to convert the number
v1
as.numeric(v1)+2

class(v1)

v2=as.numeric(v1)


#function will not change the input, only the output gets changed
class(v2)
class(v1)

v2+2

# if autocomplete is not appearing for you , hit tab

## ------------------------------------------------------------------------

v1="lalit"
class(v1)


v2=as.numeric(v1)

v2 # NA : missing value0

class(v2)

v1+2

as.numeric(v1)+2


## ------------------------------------------------------------------------
# opening documentation for functions in R

?sum


## ------------------------------------------------------------------------
?smu

## ------------------------------------------------------------------------
??smu

## ------------------------------------------------------------------------
# Numeric Operations

x=2
y=8

x+y
x-y
x*y
x/y

## ------------------------------------------------------------------------
x^y
x**y # prefer this for exponent , this is consistent across language

## ------------------------------------------------------------------------
(x+y-(x/y))**(x/10)

z=(x+y-(x/y))**(x/10)
z
z**2
## ------------------------------------------------------------------------
#mathematical functions

tan(10)

log(2^14)

log(2^14,10)

log(2^14,2)

## ------------------------------------------------------------------------
## specific functions in R for string operations

x="Sachin"
y="Tendulkar"
z="Cricket"

paste(x,y,z)

paste(x,y,z,sep = "")

# how to add a newline character while pasting

# how to use different separater for each input , one being the newline

#paste0 : by default separator is empty string

paste0(x,y,z)

## ------------------------------------------------------------------------

address="1612-Lone Tower-Mumbai"

newAd=sub("-","/",address)

# 1st arg :  what to replace 
# 2nd arg :  what to replace it with
# 3rd arg :  where to do this substituion

## ------------------------------------------------------------------------
newAd

## ------------------------------------------------------------------------
newAd1=sub("-","/",newAd)
newAd1

## ------------------------------------------------------------------------


newAd1=gsub("-","/",address)
newAd1


## ------------------------------------------------------------------------

x="Sachi  n12$%^&scsjk"

nchar(x)


## ------------------------------------------------------------------------
ip="492.168.23.134:219"            
nchar(ip)

abc=substr(ip,5,12)
abc

#1st arg : which string to get the substring from
#2nd arg : starting position
#3rd arg : stopping position

# what happens if i pass a value for ending position 
# which is more than the number of characters in the string
# do other such experiments

## ------------------------------------------------------------------------
# Logical Operations, Writing Conditions

x=7
y=9

x>y

x<y

x==y # why dont we use single = for checking equality


x!=y

x>=y

x<=y

## ------------------------------------------------------------------------
x=10

x>=1 # True 
x<=19 # True

x>=19 | x<=9

y="Sachin"

y=="Sachin" | y=="SACHIN"

y=="SAchin" | y=="SACHIN"

y=="Sachin" & y=="SACHIN"

(x>=5 & x<=100) & (x>=11 | x<=14)

###

'lalit'>'abc'

'la'>'abc'

'lalit'>'x'

'lalit'>1

# shortcut for comments : select the lines : ctrl/cmd+shift+c


## ------------------------------------------------------------------------
# writing a vector, holding multiple values
# vector : avoid drawing parralals with mathematical vector

x=c(2,4,89,-10,70,945) # upper case will throw an error


y=c(2,3,4,'2')

y

# if one of the element is character, the entire vector is of character type

x=c(2,4,89,-10,67,73)

## ------------------------------------------------------------------------
class(x)
# vectors cannot contain mixed values, like both numeric and charater
## ------------------------------------------------------------------------
class(y)
# Accessing vector elements
x

x[3] # square brackets are used for position, small brackets=> () are use for function calls

x[-3]

a=c(56,78,999,34,-2,4,678,90)

r1=a[4]

r2=a[-2]

r3=a[10]

r4=a[0]

# access multiple values
#x[1,2,5] : this does not work


x

x[1,2,5]


## ------------------------------------------------------------------------
p=c(1,2,5)


x[p]

x[c(1,2,5)]

x[-c(1,2,5)]



## ------------------------------------------------------------------------

## ------------------------------------------------------------------------
x[c(2,3,8,10,5,2,2,4,9)]


# they need not be in order
# need not be unique
# need not be less than the length of vector



## ------------------------------------------------------------------------
x=c(12,34,56,78,99,0,12,10,17,18)
x[-2]

## ------------------------------------------------------------------------
x[-c(2,3,6)]

x[c(-2,-3,-6)]

x[c(2,3,-1)]

x[c(0,2,2,0,1)]

## ------------------------------------------------------------------------
# conditional access of vector

x=c(2,-10,5,6,1,5)
x>4

L=x>4
L

# compare with each element of x, wherever it is true,it gives the value
## ------------------------------------------------------------------------
x[L]

## ------------------------------------------------------------------------
x[x>4]
# within square brackets you can pass condition also

x
x[c(F,F,F,F,T,T)]

## ------------------------------------------------------------------------
x
L
!L
x[!L]
x[!(x>4)]


y=c("a","a","b","c","d","b","a")
x=c(34,56,12,-90,34,4,8)

# conditions can be based on another vector

x[y=="a"]

## ------------------------------------------------------------------------
#Creating vectors with handy functions and operators

# a:b creates a sequence from a to b intremental or decremental

x=2:10
x

4:-1

-5:5

2.3:7.9

## ------------------------------------------------------------------------

x=seq(1,5,by=0.3)

# 5 may or may not be included
## ------------------------------------------------------------------------

seq(1,5,0.4)
seq(1,5,-0.4)
seq(5,1,-0.4)

## ------------------------------------------------------------------------
x=seq(1,10,length=20)

x

#creates AP
# start and stop are included when length option is used
## ------------------------------------------------------------------------
x=1:5
y=seq(2,3,length=7)

z=c(x,y,2,3,6)


## ------------------------------------------------------------------------
## what to repeat and how many times

rep(2,10)

rep("a",5)


## ------------------------------------------------------------------------
rep(c(1,5,6),4)


## ------------------------------------------------------------------------
rep(c("a","b","c","b"),4)


#vector repeated 4 times


rep(c("a","c","b"),4)

rep(c("a","c","b"),each=4)


# if each=4 it repeats individual elements 4 times


## ------------------------------------------------------------------------
# vector operations

x=1:10
y=seq(3,13,length=10)

x+y
x*y
x-y
x/y


# operation is done element by element(on each element) on
#vectors and the result is also vector
## ------------------------------------------------------------------------

log(x)

2**x

## ------------------------------------------------------------------------
paste0(1,"a")

x=1:10

y=rep("a",10)

paste0(x,y)

#concatenation will happen on individual elements
## ------------------------------------------------------------------------
# collapse option in paste function
z=paste0(y,x)
paste(z,collapse="-")
# collapses into a single string using "+" as separator


## ------------------------------------------------------------------------
z
f=round(runif(10),2)
f
#generate 10 numbers between 0 to 1 with two decimal places

paste(f,z,sep="*",collapse="+")

## ------------------------------------------------------------------------

# vector operations when lengths do not match
x=1:11
y=c(1,2,3)


## ------------------------------------------------------------------------
#you'll get a result but with a warning for length mismatch
# However you will not get this warning if smaller vector's length is
# a multiple of larger vector

z= x+y



## ------------------------------------------------------------------------
x=c("a","b")
y=1:6
z=c('l','m','n','p')

paste0(x,y,z)

## ------------------------------------------------------------------------
# Special utility functions for vectors

x=c("k","j","$","1","f")
y=letters

match(x,y)

match(y,x)

#####



## ------------------------------------------------------------------------

x %in% y

y %in% x


## ------------------------------------------------------------------------

100 %% 32
30 %% 12
30 %% 15


## ------------------------------------------------------------------------
x=sample(1:100,20)
x

which(x%%5==0)

which(c(F,T,F,T))

# gives the indices where the condition is true
## ------------------------------------------------------------------------

## ------------------------------------------------------------------------

x=c(3,4,5,-10,1,2,0)
sort(x)
x=sort(x)

y=c("art","ant","Bat",'12abc','Zes')
sort(y) #sorts in dictionary order

## ------------------------------------------------------------------------
sort(x,decreasing=T )

sort(y,decreasing = T)


## ------------------------------------------------------------------------
rev(y)

rev(x)

## ------------------------------------------------------------------------
x=c(34,45,56,76,90,89,100,0,-10,4,999)

sample(x,3)

## ------------------------------------------------------------------------
# reproducible

set.seed(2)
sample(x,3)

#####

x=1:10

set.seed(3)
sample(x,7)

## ------------------------------------------------------------------------
x=rep(2,20)

sample(x,7)

sample(x,9,replace=T)


## ------------------------------------------------------------------------
set.seed(567)
x=sample(c("Failed","Functioning","NeedRepair"),1000,replace=T,
         prob=c(0.05,0.8,0.15))

prop.table(table(x))

## ------------------------------------------------------------------------


## ------------------------------------------------------------------------

unique(x)

sum(1:10)

length(x)

# finding missing values, operations with missing value

x=c(F,T,F,T,T,T,F,F,F)

class(x)

as.numeric(x)

x=c(1,2,3,NA,NA,3,4,5)

is.na(x)

sum(is.na(x))

#####

1+NA+4

mean(x)

mean(x,na.rm=T)


#a vector can not be of mixed type,it is unidimensional
## ------------------------------------------------------------------------
# list are versatile, it can store vector,dataframe etc

x=sample(1:100,10)
y=sample(c("a","b","c"),6,replace=T)
z=4.56

list1=list(x,y,z)
list1

## ------------------------------------------------------------------------

list1[[2]]

## ------------------------------------------------------------------------
v=list1[[1]]

v[3]


list1[[1]][3]

#####

list1[[2]]

list1[2]
####

list1[[2]][3]

list1[2][3]#single bracket will give the output as list

#########

list1
list1[[1]]

list1[1]

list1[[1]][4]

list1[2][[1]][3]

list1[[2]][3]

## ------------------------------------------------------------------------
list2=list(a=x,b=y,c=z)
list2

##

## ------------------------------------------------------------------------
list2$b

list2$b[3]

list2[[2]][3]


## ------------------------------------------------------------------------
set.seed(2)
x=sample(1:100,30)
y=sample(c("a","b","c"),30,replace = T)

d=data.frame(x,y,stringsAsFactors = F)

d

## ------------------------------------------------------------------------
View(d)

## ------------------------------------------------------------------------
names(d)
colnames(d)

# names is a generic function 
## ------------------------------------------------------------------------
## ------------------------------------------------------------------------

rownames(d)

rownames(d)=sample(c(letters,LETTERS),30)
rownames(d)

## ------------------------------------------------------------------------
dim(d)
nrow(d)
ncol(d)

## ------------------------------------------------------------------------
str(d)

## ------------------------------------------------------------------------

d1=mtcars
dim(d1)

## ------------------------------------------------------------------------
d1[4,6]

## ------------------------------------------------------------------------
#3rd row , all columns
d1[3,]

# all rows, 6 th colunmn
d1[,6]


class(d1[,6])

class(d1[3,])

#

x=d1[,6]

y=d1[3,]
#

d1[,6][4]

d1[3,][1,4] # y[1,4]

d1[3,4]

# multiple rows, multiple column

d1[c(3,4,20),c(1,4,6)]

d1[-(3:17),-c(1,4,6,7)]

d1[d1$mpg>20,]

d1[!(d1$mpg>20 & d1$am==1),]

# Selecting column by their names

d1[,c(1,4,6)]

d1[,c("wt","mpg")]


# Excluding columns by their names [ this is a little tricky because simple negative sign doesn't work]

names(d1)

names(d1) %in% c("wt","mpg")

!(names(d1) %in% c("wt","mpg"))

d1[,!(names(d1) %in% c("wt","mpg"))]



## ------------------------------------------------------------------------
d1[order(d1$vs,d1$wt),c("vs","wt","mpg","gear")]


## ------------------------------------------------------------------------
d1[order(d1$vs,-d1$wt),c("vs","wt","mpg","gear")]

##

d2=d1[,c("mpg","cyl","am","gear")]

## adding a new column

d2$color=40

d2$rainbow=sample(1:100,32)

d2[,"abc"]=d2$mpg+d2$cyl

d2[,8]=d2$mpg/d2$cyl


d2$cond_column=ifelse(d2$mpg>20,d2$gear,d2$rainbow*d2$am)

d2=d2[,-9]

d2=d2[,!(names(d2) %in% c("mpg","color"))]

names(d2)[1]="cylinder"

#merging dataframes
#merging done by ID 

## 
## ------------------------------------------------------------------------
##Explaination of joins: left ,right, inner, full
# https://www.guru99.com/r-dplyr-tutorial.html -example of joins
library(dplyr)

df1 = data.frame(id=c(1,2,3,4,5,6),
                 Product=c(rep("Toaster",3),rep("Radio",3)))

df2 = data.frame(serial=c(5,6,7,8),
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


# now reverse the data frame and look at the result
## ------------------------------------------------------------------------
inner

## ------------------------------------------------------------------------
left

## ------------------------------------------------------------------------
right

## ------------------------------------------------------------------------
full

## ------------------------------------------------------------------------
semi

## ------------------------------------------------------------------------
anti

## ------------------------------------------------------------------------

x=c("delhi","pune","mumbai",
    "bangalore","hyderabad","lucknow","chennai")

print(nchar(x[1]))
print(nchar(x[2]))
print(nchar(x[3]))
print(nchar(x[4]))
print(nchar(x[5]))
print(nchar(x[6]))
print(nchar(x[7]))

# for values of position in c(1:100)
# do this =>print(nchar(x[position]))

for(i in 1:7){
  print(nchar(x[i]))
}

# i is index , it takes values from a value vector 1:7
# body of the code is within { }

# index can be named anything 
# value vector can take whatever values in it
# you dont have to make use of index inside the body of the code

a=1
for(abc in x){
  a=a+1
}


names=c('lalit','lokesh','nitesh','hema')

if(names=='lalit'){
  print('instructor')
}else{
  print('not instructor')
}

# if can not handle multiple logical values at once
# if doesn't work by default like a for loop
# else is not necessary, but else in itself can not exist without an if

for(name in names){
  if(name=='lalit'){
    print('instructor')
  }
  else{
    print('not instructor')
  }
}

# [] : will be used to subset , position, conditions
# () : will be used with functions to pass arguments to them
# {} : for body of the code : for , while , if-else, functions


ctr=0

while(ctr<10){
  print(ctr)
  ctr=ctr+1
}

####### writing functions

a=1000
b=90

s1=a+b
s2=a-b

outcome=s1/s2
outcome

sum_diff_ratio=function(arg1=10,arg2=20,arg3=30){
  s1=arg1+arg2
  s2=arg1-arg2
  
  result=s1/s2
 
  return(result+arg3)
}

sum_diff_ratio(34,56,45)

sum_diff_ratio(34,45)

sum_diff_ratio(34)

sum_diff_ratio()

sum_diff_ratio(arg3=0)


#####


##### 
# its not always necessary to write a for loop, 
# use vector operations
# Vectorization in R
set.seed(3)
x=sample(1:100,20)
x
for(i in 1:length(x)){
  
  if(x[i]%%5==0){
    x[i]=-999
  }
}

x[x%%5==0]=-999
# can we do this without writing this loop



## ------------------------------------------------------------------------
# writing efficient for loops / function / code

x=1:12

## ------------------------------------------------------------------------
matrix(x,4,4)

## ------------------------------------------------------------------------
n=1000000

myvec=sample(1:10, n*9, replace=TRUE)

X = as.data.frame(matrix(myvec, n, 9))


f1 = function(temp){
  
  for(i in 1:nrow(temp)){
    if(i==1){
      temp[i,10]=temp[i,9]
    }else{
      if(temp[i,3]==temp[i-1,3] & temp[i,6]==temp[i-1,6]){
        temp[i,10]=temp[i,9]+temp[i-1,10]
      }else{
        temp[i,10]=temp[i,9]
      }
    }
  }
  return(temp)
}

(t1=system.time(f1(X)))

# avoid accessing dataframes 
# we create new column as a vector and later add it to dataframe
f2 = function(temp){
  
  a=numeric(nrow(temp))
  
  for(i in 1:nrow(temp)){
    if(i==1){
      a[i]=temp[i,9]
    }else{
      if(temp[i,3]==temp[i-1,3] & temp[i,6]==temp[i-1,6]){
        a[i]=temp[i,9]+a[i-1]
      }else{
        a[i]=temp[i,9]
      }
    }
  }
  temp[,10]=a
  return(temp)
}

(t2=system.time(f2(X)))

# be clever , look for problem specific exploits
# here we do that by setting the vector at the begining to 9th column
# and make changes whenever the condition is true
f3 = function(temp){
  a=temp[,9]
  for(i in 1:nrow(temp)){
    if(i>1){
      if(temp[i,3]==temp[i-1,3] & temp[i,6]==temp[i-1,6]){
        a[i]=temp[i,9]+a[i-1]
      }
    }
  }
  temp[,10]=a
  return(temp)
}

(t3=system.time(f3(X)))

y=c(3,3,4,5,6,6,6,7,8)

# F,T,F,F,F,T,T,F,F

for(i in 2:length(y)){
  print(y[i]==y[i-1])
}

c(F,y[-1]==y[-length(y)])


# use vector operations instead of doing things inside a for loop
# here we use the trick shown above to do comparison with previous 
# occurrence using vector operations
f4 = function(temp){
  a=temp[,9]
  
  cond=c(F,(temp[-1,3]==temp[-nrow(temp),3] & temp[-1,6]==temp[-nrow(temp),6]))
  
  for(i in 1:nrow(temp)){
    
      if(cond[i]){
        a[i]=temp[i,9]+a[i-1]
    }
  }
  temp[,10]=a
  return(temp)
}

(t4=system.time(f4(X)))

# Instead of using condition check inside the for loop subset the indices

f5 = function(temp){
  a=temp[,9]
  
  cond=c(F,(temp[-1,3]==temp[-nrow(temp),3] & temp[-1,6]==temp[-nrow(temp),6]))
  
  k=1:nrow(temp)
  
  k_new=k[cond]
  
  for(i in k_new){
    
    a[i]=temp[i,9]+a[i-1]
  }
  temp[,10]=a
  return(temp)
}

(t5=system.time(f5(X)))

