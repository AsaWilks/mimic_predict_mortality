rsconnect::setAccountInfo(name='asawilks',
                          token='XXXXX',
                          secret='XXXXX')


setwd("~/UCLA/STAT413/git")



#install.packages("dplyr")
#install.packages("xgboost")
#install.packages("caret")
library(rsconnect)
library(dplyr)
library(xgboost)
library(caret)

rsconnect::deployApp(appDir = "./predict_death_api")

