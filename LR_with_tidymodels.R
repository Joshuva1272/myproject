## New Code with tidy models

library(tidymodels)
library(visdat)
library(tidyr)
library(car)

setwd("/Users/lalitsachan/Dropbox/March onwards/CBAP with R/Data/")

ld_train=read.csv("loan_data_train.csv",stringsAsFactors = F)

ld_test= read.csv("loan_data_test.csv",stringsAsFactors = F)

vis_dat(ld_train)

fico_func=function(x){
  
  temp=data.frame(fico=x)
  
  temp=temp %>% 
    separate(fico,into=c("f1","f2")) %>% 
    mutate(f1=as.numeric(f1),
           f2=as.numeric(f2),
           fico=0.5*(f1+f2)) %>% 
    select(-f1,-f2)
  
  return(temp[,"fico"])
  
}


emp_len_func=function(x){
  
  x=ifelse(x=="< 1 year",0,x)
  x=gsub("years","",x)
  x=gsub("year","",x)
  x=gsub("+","",x,fixed=T)
  x=as.numeric(x)
  return(x)
}

percent_to_numeric_func=function(x){
  
  x=gsub("%","",x)
  x=as.numeric(x)
  return(x)
}

dp_pipe=recipe(Interest.Rate ~ .,data=ld_train) %>% 
  update_role(ID,Amount.Funded.By.Investors,new_role = "drop_vars") %>% 
  update_role(Amount.Requested,
              Open.CREDIT.Lines,
              Revolving.CREDIT.Balance,new_role="to_numeric") %>% 
  update_role(Home.Ownership,State,Loan.Length,Loan.Purpose,new_role="to_dummies") %>% 
  step_rm(has_role("drop_vars")) %>% 
  
  step_mutate_at(FICO.Range,fn=fico_func) %>% 
  step_mutate_at(Employment.Length,fn=emp_len_func) %>%
  
  step_unknown(has_role("to_dummies"),new_level="__missing__") %>% 
  step_other(has_role("to_dummies"),threshold =0.02,other="__other__") %>% 
  step_dummy(has_role("to_dummies")) %>% 
  step_mutate_at(Debt.To.Income.Ratio,fn=percent_to_numeric_func) %>% 
  step_mutate_at(Interest.Rate,fn=percent_to_numeric_func,skip=TRUE) %>% 
  step_mutate_at(has_role("to_numeric"),fn=as.numeric) %>% 
  step_impute_median(all_numeric(),-all_outcomes())



dp_pipe=prep(dp_pipe)

train=bake(dp_pipe,new_data = NULL)
test=bake(dp_pipe,new_data=ld_test)

vis_dat(train)
vis_dat(ld_train)

####

set.seed(2)
s=sample(1:nrow(train),0.8*nrow(train))
t1=train[s,]
t2=train[-s,]

fit=lm(Interest.Rate~.,data=t1)


# we'll take vif cutoff as 5

fit=lm(Interest.Rate~.-Loan.Purpose_debt_consolidation
       -State_X__other__,data=t1)
sort(vif(fit),decreasing = T)



# p-value take the cutoff 0.1

summary(fit)

fit=stats::step(fit)

## AIC score 

summary(fit)

formula(fit)

fit=lm(Interest.Rate ~ Monthly.Income + FICO.Range + Inquiries.in.the.Last.6.Months + 
         Loan.Length_X60.months + 
         Loan.Purpose_small_business + 
         State_IL  + State_TX   +
         Home.Ownership_X__other__,
       data=t1)

summary(fit)

###

t2.pred=predict(fit,newdata=t2)

errors=t2$Interest.Rate-t2.pred

rmse=errors**2 %>% mean() %>% sqrt()
mae=mean(abs(errors))


### model for predcition on the entire data

fit.final=lm(Interest.Rate ~ .-Loan.Purpose_debt_consolidation
             -State_X__other__,data=train)

sort(vif(fit.final),decreasing = T)

fit.final=stats::step(fit.final)

summary(fit.final)

formula(fit.final)

fit.final=lm(Interest.Rate ~ Monthly.Income + FICO.Range + Revolving.CREDIT.Balance + 
               Inquiries.in.the.Last.6.Months + Loan.Length_X60.months + 
               Loan.Purpose_credit_card + Loan.Purpose_major_purchase + 
                State_NC  + State_TX + Home.Ownership_OWN + 
               Home.Ownership_RENT + Home.Ownership_X__other__,
             data=train)

summary(fit.final)

test.pred=predict(fit.final,newdata=test)

write.csv(test.pred,"submision1.csv",row.names = F)

### 

plot(fit.final,1) # residual vs fitted values => non-linearity in the data exists or not

plot(fit.final,2) # errors are normal or not

plot(fit.final,3) # variance is constant or not

plot(fit.final,4) # outliers in the data if cook's distance >1

### In addition to data processing recipes , tidymodels also 
## has modelling and complete workflows functionality 
## we'll learn that while building a lasso regression model

## steps till data processing will be same 

ld_split=initial_split(ld_train,prop=0.8)

t1=training(ld_split)
t2=testing(ld_split)

## define cross validation for parameter tuning

# folds = vfold_cv(t1, v = 10, strata = Interest.Rate, nbreaks = 5)
# we have small data for stratified sampling

folds = vfold_cv(t1, v = 10)

# define parameter grid to be tuned

my_grid = tibble(penalty = 10^seq(-2, -1, length.out = 10))

# define lass model

lasso_mod = linear_reg(mode = "regression",
                        penalty = tune(),
                        mixture = 1) %>% 
  set_engine("glmnet")

# add everything to a workflow

wf = workflow() %>%
  add_model(lasso_mod) %>%
  add_recipe(dp_pipe)

# tune the workflow

my_res <- wf %>% 
  tune_grid(resamples = folds,
            grid = my_grid,
            control = control_grid(verbose = FALSE, save_pred = TRUE),
            metrics = metric_set(rmse))

