library(forecast)
library(fpp)

setwd("/Users/lalitsachan/Dropbox/March onwards/CBAP with R/Data/")

rain=read.csv("rain.csv")

# converting to a time series data format

raints=ts(rain,start=c(1900))

plot(raints)

rainforecast=HoltWinters(raints,beta=F,gamma=F)


rainforecast

plot(rainforecast)

# components of model object
names(rainforecast)  
rainforecast$fitted

r2=HoltWinters(raints,alpha=0.9,beta=F,gamma=F)
plot(r2)

#making forecasts
library(forecast)

rainfuture=forecast:::forecast.HoltWinters(rainforecast,h=80)

rainfuture
plot(rainfuture)

#The in-sample forecast errors are stored in the named element -residuals
#of the list variable returned by forecast.HoltWinters(). 
#If the predictive model cannot be improved upon, there should be 
#no correlations between forecast errors for successive predictions. 
#In other words, if there are correlations between forecast errors for 
#successive predictions, it is likely that the simple exponential 
#smoothing forecasts could be improved upon by another 
#forecasting technique.

# to figure that out we'd use auto correlation function to generate plots
plot(rainfuture$residuals)

hist(rainfuture$residuals)

acf(na.omit(rainfuture$residuals),lag.max=20)

#If you have a time series that can be described using an additive model with 
#increasing or decreasing trend and no seasonality, you can use Holts exponential
# smoothing to make short-term forecasts.

skirts=read.csv("skirts.csv")
skirts=ts(skirts,start=c(1866))
plot(skirts)


#as you can see this time series has trend and a simple "level" forecast will not be enough.

skirtforecast=HoltWinters(skirts,gamma=F)

plot(skirtforecast)


skirtforecast
skirtfuture=forecast:::forecast.HoltWinters(skirtforecast,h=20)

plot(skirtfuture)

#Also we are not discussing in this session about variance of the residuals
#those who are interested can read up on ARCH/GARCH models. Here our
#assumption is that error variance does not change with time 

souvenir=read.csv("souvenir.csv")

souvenirts = ts(souvenir, frequency=12, start=c(1987,1))


plot(souvenirts)


souvenirts=log(souvenirts)

plot(souvenirts)


souvenirforecast=HoltWinters(souvenirts)

souvenirforecast

plot(souvenirforecast)


plot(souvenirforecast)

souvenirfuture=forecast:::forecast.HoltWinters(souvenirforecast,h=100)

plot(souvenirfuture)


#ARIMA models have 3 parameters  and is generally written as ARIMA(p,d,q)

auto.arima(souvenirts)

#ARIMA(2,0,0)(0,1,1)[12]

#p=2 ,d=0, q=0 | P=1 , D=1 , Q=0 | m=12

arimafit=arima(souvenirts,order=c(2,0,0),seasonal=c(0,1,1))

arimafuture=forecast:::forecast.Arima(arimafit,h=48)
plot(arimafuture)


## Dynamic Regression 

library(fpp)

plot(usconsumption, xlab="Year",
     main="Quarterly changes in US consumption and personal income")

fit = auto.arima(usconsumption[,1], xreg=usconsumption[,2])
fit

#ARIMAX = arima with X vars 


## lagged variable

plot(insurance, main="Insurance advertising and quotations", xlab="Year")

Advert = cbind(insurance[,2],
                c(NA,insurance[1:39,2]),
                c(NA,NA,insurance[1:38,2]),
                c(NA,NA,NA,insurance[1:37,2]))


colnames(Advert) = paste("AdLag",0:3,sep="")

fit1 = auto.arima(insurance[4:40,1], xreg=Advert[4:40,1], d=0)
fit2 = auto.arima(insurance[4:40,1], xreg=Advert[4:40,1:2], d=0)
fit3 = auto.arima(insurance[4:40,1], xreg=Advert[4:40,1:3], d=0)
fit4 = auto.arima(insurance[4:40,1], xreg=Advert[4:40,1:4], d=0)

fit1$aic;fit2$aic;fit3$aic;fit4$aic


fit = auto.arima(insurance[,1], xreg=Advert[,1:2], d=0)



# for forecasting we either need to know the future values of xregs or assume

fc = forecast(fit, xreg=cbind(rep(8,20),c(Advert[40,1],rep(8,19))), h=20)


plot(fc, main="Forecast quotes with advertising set to 8", ylab="Quotes")


### Handling missing values and outliers in timeseries data

library(fpp)
plot(melsyd[,3], main="Economy class passengers: Melbourne-Sydney")

# cleaned data

tsoutliers(melsyd[,3])

plot(melsyd[,3], main="Economy class passengers: Melbourne-Sydney")
lines(tsclean(melsyd[,3]), col='red')




