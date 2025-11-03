## -----------------------------------------------------------
library(ggplot2)

p=ggplot(mtcars,aes(x=wt,y=mpg))

p

## ------------------------------------------------------------------------

p+geom_point()

## -------------------------------------------------------------

p+geom_line()

p+geom_smooth()

p+geom_point()+geom_smooth()
  
p+geom_rect()


d=data.frame(a=sample(1:20,6),
            b=sample(1:20,6),
            c=sample(1:20,6),
            d=sample(1:20,6)
            )
ggplot(d,aes(xmin=a,xmax=b,ymin=c,ymax=d))+
  geom_rect(color='blue',fill='white',size=2)


## ------------------------------------------------------------------------

p=ggplot(mtcars,aes(x=wt,y=mpg))

p+geom_point()+geom_line()+geom_smooth()
##-----------

p=ggplot(mtcars,aes(x=wt,y=mpg))

p+geom_point()

## ------------------------------------------------------------------------
p=ggplot(mtcars,aes(x=wt,y=mpg,color=vs))

p+geom_point()





## ------------------------------------------------------------------------
mtcars$vs=as.factor(mtcars$vs)

p=ggplot(mtcars,aes(x=wt,y=mpg,color=vs))

p+geom_point()


## ------------------------------------------------------------------------
mtcars$am=as.factor(mtcars$am)

p=ggplot(mtcars,aes(x=wt,y=mpg,color=vs,shape=am,size=cyl))

p+geom_point()

## V type is vs=0 , S type is vs=1
## automatic is am=0 , manual am=1


## -----------------------------------------------------------
p=ggplot(mtcars,aes(x=wt,y=mpg,color=am))

p+geom_point()+geom_smooth()+geom_line()

## -----------------------------------------------------------
p=ggplot(mtcars,aes(x=wt,y=mpg))

p+geom_point(aes(color=am))+geom_smooth()

## ----------------------------------
library(vcd)
library(hflights)
library(dplyr)

## ------------------------------------------------------------------------
## single numeric variable

# histogram
f_sub=filter(hflights,DepDelay<100)

# f_sub=hflights[hflights$DepDelay<100,]


ggplot(f_sub,aes(x=DepDelay))+
  geom_histogram(bins = 200)


# use option bins/binwidth to make finer classes

# density 

ggplot(f_sub,aes(x=DepDelay))+geom_density()


# boxplots

ggplot(f_sub,aes(x=DepDelay))+geom_boxplot()

# counting number of extreme values on the higher side
# IQR(f_sub$DepDelay)
# 
# quantile(f_sub$DepDelay)
# 
# # 8+1.5*11
# 
# sum(f_sub$DepDelay>24.5)
#

ggplot(f_sub,aes(x="DepDelay",y=DepDelay))+geom_violin()+coord_flip()

# comparing density with normal

ggplot(f_sub,aes(x=DepDelay))+geom_density(color="red")+
  stat_function(fun=dnorm,
                args=list(mean=mean(f_sub$DepDelay),
                          sd=sd(f_sub$DepDelay)),
                color="green")

###### single categorical variable

# f_sub=hflights %>% filter(UniqueCarrier %in% c("UA","AA","XE","WN"))
unique(hflights$UniqueCarrier)
length(unique(hflights$UniqueCarrier))

f_sub=hflights[hflights$UniqueCarrier %in% c("UA","AA","XE","WN"), ]


ggplot(f_sub,aes(x=UniqueCarrier))+
  geom_bar(fill='white',color='blue',width = 0.5)+
  coord_flip()+
  xlab("Carrier Name")+
  ylab(" Frequency")+
  ggtitle("Carrier Frequencies")

ggplot(f_sub,aes(x=UniqueCarrier))+
  geom_bar(fill='white',color='blue',width=0.5)+
  coord_flip()+
  xlab("Carrier Name")+
  ylab(" Frequency")+
  ggtitle("Carrier Frequencies")


#coord_polar , coord_fixed : explore these

### num-num
# we already covered these above
### num-cat

ggplot(mtcars,aes(x=am,y=mpg))+geom_boxplot()

# how to plot density curves of two categories in the same visualisation

## bar charts without frequency on y axis

df = data.frame(Months=c("Jan","Feb","Mar","Apr"),
                Sales=c(4.2, 10, 29.5,15))

ggplot(df, aes(x=Months, y=Sales)) +
  geom_bar(stat='identity')

ggplot(df, aes(x=Months, y=Sales)) +
  geom_bar(stat='identity',aes(fill=Months))+
  geom_text(aes(label=Sales),vjust=-0.5)

### how to give a predefined order to values on the x axis ?

ggplot(data=df, aes(x=Months, y=Sales)) +
  geom_bar(stat="identity",aes(color=Sales))+
  geom_text(aes(label=Sales,vjust=Sales/2),size=3.5)

##### bar plots with labels

# Outside bars
ggplot(df,aes(x=Months,y=Sales))+
  geom_bar(stat='identity')

ggplot(df,aes(x=Months,y=Sales))+
  geom_bar(stat='identity',color='blue',fill='white')

ggplot(df,aes(x=Months,y=Sales))+
  geom_bar(stat='identity',color='blue',aes(fill=Months))

# how to make the text labels appear in the middle of the bar

# Change barplot line colors by groups
p=ggplot(df, aes(x=Months, y=Sales, color=Months))+
  geom_bar(stat="identity", fill=c("#999999", "#E69F00", "#56B4E9","#800000"))

p

# Change legend position
p + theme(legend.position="top")
p + theme(legend.position="bottom")


# Remove legend
p + theme(legend.position="none")

# The allowed values for the arguments legend.position are : “left”,“top”, “right”, “bottom”.
# Explore theme function for changing gridlines , background colors

#add trend lines
p=ggplot(df, aes(x=Months, y=Sales, fill=Months)) +
  geom_bar(stat="identity")

p+geom_line(aes(y=Sales),group=1,size=2,color='steelblue')+
  geom_text(aes(label=Sales),vjust=-.5,size=3.5)

### cat-cat

ggplot(Arthritis,aes(x=Treatment,fill=Improved))+
  geom_bar()

### go through the reading material and see usage of coord_polar


