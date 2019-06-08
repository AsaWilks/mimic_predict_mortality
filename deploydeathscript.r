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

predict.death.rate <- function(
  HAS_CHARTEVENTS_DATA=NA, #1/0
  ADMISSION_TYPE=NA,       #ELECTIVE / EMERGENCY / NEWBORN / URGENT
  MARITAL_STATUS=NA,       #UNK / DIVORCED / LIFE.PARTNER / MARRIED / SEPARATED / SINGLE / WIDOWED
  ADMISSION_LOCATION=NA,   #UNK / EMERGENCY_ROOM /TRANSFER_WITHIN
  INSURANCE=NA,            #GOVERNMENT / MEDICAID / MEDICARE / PRIVATE / SELFPAY
  ETHNICITY=NA,            #WHITE / BLACK / ASIAN / LATINO
  LANGUAGE=NA,             #UNK / ENGLISH / SPANISH / KOREAN
  RELIGION=NA,             #UNK / CATHOLIC / JEWISH / MUSLIM
  DX1=NA,                  #"DX___"
  DX2=NA,                  #"DX___"
  DX3=NA,                  #"DX___"
  DX4=NA,                  #"DX___"
  DX5=NA                   #"DX___"
)