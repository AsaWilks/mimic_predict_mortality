rsconnect::setAccountInfo(name='asawilks',
                          token='C379DE2157F66143EFAF9BDD2B024DC0',
                          secret='m40sXO+Z3Ocz0HWnnAwLRI8XgtqkAhf/O0DEbVhF')


setwd("~/UCLA/STAT413/git")



#install.packages("dplyr")
#install.packages("xgboost")
#install.packages("caret")
library(rsconnect)
library(dplyr)
library(xgboost)
library(caret)

rsconnect::deployApp(appDir = "./predict_death_api")
