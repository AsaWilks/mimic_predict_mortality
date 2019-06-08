## deploy_mortality_api.r

rsconnect::setAccountInfo(name='asawilks',
                          token='C379DE2157F66143EFAF9BDD2B024DC0',
                          secret='m40sXO+Z3Ocz0HWnnAwLRI8XgtqkAhf/O0DEbVhF')

install.packages("xgboost")
library(xgboost)

setwd("~/UCLA/STAT413")


rsconnect::deployApp(appDir = "./mortality_predict_app", appName = "mortality_predict_app")
