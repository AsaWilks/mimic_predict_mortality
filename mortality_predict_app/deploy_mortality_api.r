## deploy_mortality_api.r

rsconnect::setAccountInfo(name='asawilks',
                          token='XXXX',
                          secret='XXXX')

install.packages("xgboost")
library(xgboost)

setwd("~/UCLA/STAT413")


rsconnect::deployApp(appDir = "./mortality_predict_app", appName = "mortality_predict_app")
