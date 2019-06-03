### xgb_predict.sas
### predict in hospital death using admissions data
### asa wilks 6.1.2019

setwd("~/UCLA/STAT413/git/mimic/csv")

install.packages("dplyr")
install.packages("xgboost")
install.packages("caret")

library(dplyr)
library(caret)
library(xgboost)

# read and prep data
# admissions
d <- read.csv("ADMISSIONS.csv")

d$ENGLISH <- 0
d$ENGLISH[d$LANGUAGE == "ENGL"] <- 1

# limit diagnoses to those occuring more than 5 times
#dx <- d %>% group_by(DIAGNOSIS) %>% summarise( numdx = n())
#dxj <-  left_join(d, dx, by="DIAGNOSIS")
#dxj$DX <- as.character(dxj$DIAGNOSIS)
#dxj$DX[dxj$numdx <= 5] <- "CENSORED"


# one hot encoding for categorical variables

dmy <- dummyVars("HOSPITAL_EXPIRE_FLAG ~ MARITAL_STATUS + ADMISSION_TYPE + ADMISSION_LOCATION + INSURANCE +
                 RELIGION + ETHNICITY + LANGUAGE ", data = d)

onehot <- data.frame(predict(dmy, newdata = d))

d_lim <- d[c("HOSPITAL_EXPIRE_FLAG", "HAS_CHARTEVENTS_DATA", "SUBJECT_ID", "HADM_ID")]
d_full <- cbind(d_lim, onehot)


###
# diagnoses
##

dx <- read.csv("DIAGNOSES_ICD.CSV")

# keep only top three dx per admit
dx <- subset(dx, SEQ_NUM <= 5)

# keep only diagnosis codes where at least 25 found in data
dxcnt <- dx %>% group_by(ICD9_CODE) %>% summarise( numdx = n())
dxj <-  left_join(dx, dxcnt, by="ICD9_CODE")
dxj$DX <- as.character(dxj$ICD9_CODE)
dxj$DX[dxj$numdx <= 25] <- "99999"

# create onehot diagnosis code variables
dmy <- dummyVars(" ~  DX ", data = dxj)
onehot <- data.frame(predict(dmy, newdata = dxj))

dxvars <- dxj[c("SUBJECT_ID", "HADM_ID")]
alldx <- cbind(dxvars, onehot)

## aggregate to admit level, counting diag codes
dx_agg <- alldx %>%
            group_by(SUBJECT_ID, HADM_ID) %>%
              summarize_if(is.numeric, sum)

###
# combine diagnosis and main dfs
###

data_full <- inner_join(d_full, dx_agg, by=c("SUBJECT_ID", "HADM_ID"))
data_full <- subset(data_full, select = -c(SUBJECT_ID, HADM_ID))

###
# subset to training and test
###

smp_size <- floor(0.90 * nrow(data_full))
set.seed(917)
train_ind <- sample(seq_len(nrow(data_full)), size = smp_size)
train <- data_full[train_ind, ]
test <- data_full[-train_ind, ]

train_features <- subset(train, select = -c(HOSPITAL_EXPIRE_FLAG))
train_labels   <- subset(train, select = c(HOSPITAL_EXPIRE_FLAG))

test_features <- subset(test, select = -c(HOSPITAL_EXPIRE_FLAG))
test_labels   <- subset(test, select = c(HOSPITAL_EXPIRE_FLAG))


###
# drop everything from memory except features and labels
###

rm(list=setdiff(ls(), c("train_features", "test_features", "train_labels", "test_labels")))


###
# fit xgboost classifier
###

train_features_mx <- as.matrix(train_features)
train_labels_mx <- as.matrix(train_labels)
test_features_mx <- as.matrix(test_features)
test_labels_mx <- as.matrix(test_labels)

set.seed(917)

xgb.fit1 <- xgb.cv(
  data = train_features_mx,
  label = train_labels_mx,
  nrounds = 5000,
  nfold = 5,
  objective = "binary:logistic",
  verbose = 1 ,
  early_stopping_rounds = 100
)

# plot error vs number trees
ggplot(xgb.fit1$evaluation_log) +
  geom_line(aes(iter, train_error_mean), color = "red") +
  geom_line(aes(iter, test_error_mean), color = "blue")


# best iteration was 102, train model
xgb.fit2 <- xgboost(  data = train_features_mx,
                      label = train_labels_mx,
                      nrounds = 102,
                      objective = "binary:logistic",
                      verbose = 1 )

# predict and evaluate
pred <- predict(xgb.fit2, newdata=test_features_mx, label = test_labels_mx)
prediction <- as.numeric(pred > 0.5)
err <- mean(as.numeric(pred > 0.5) != test_labels_mx)
print(paste("test-error=", err))

# look at feature importance
importance_matrix <- xgb.importance(model = xgb.fit2)
print(importance_matrix)
xgb.plot.importance(importance_matrix = importance_matrix[1:6], cex=.65)

# look at confusion matrix
install.packages("e1071")
library(e1071)
confusionMatrix(as.factor(prediction), as.factor(test_labels_mx))

## save model for deployment
xgb.save(xgb.fit2, "xgboost.model.1JUN2019")
