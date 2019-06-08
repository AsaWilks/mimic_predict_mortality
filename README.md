# mimic_predict_mortality

This project uses data from the MIMIC-III clinical database of ICU events to predict patient-level mortality based on attributes of the admission and ICD9 diagnosis codes.

This repo includes:
  - Instructions and a shell script for obtaining and setting up the MIMIC-III data.
  - Code implementing implementing an extreme gradient boosting algorithm to predict death.
  - A stand-alone R function that takes simple inputs and returns a prediction.  This is valuable in that the model itself uses one hot encoding for the diagnoses.
  - A plumber.r file and associated rsconnect script which was used to deploy the model as an API to shinyapps.io

## The MIMIC-III Data

The MIMIC-III database contains deidentified data on 40k patients at Beth Israel Deaconess Medical Center in Boston between 2001 and 2012. 
It includes standard demographics, diagnosis, and procedure codes as well as time-varying lab result and bedside monitor trends and waveforms.
The data is available to the public but requires a formal Data Use Agreement and a certificate of complettion from a CITI Data Security course.  Full detials are at https://mimic.physionet.org/

The mimic_docker_postgres_extract.sh script downloads data from the MIMIC website, unzips the contents, and starts a docker container which reads the raw data from a local machine and returns at PostgreSQL database.

## Predicting mortality with xgboost

Death in the hospital was predicted using basic information available at the time of admission and diagnoses that were made throughout the course of the admission.  The base rate of the death was 11 percent.  The script xgb_predict.r processes the data by joining the diagnosis-level file with the admissions file based on patient and stay identifiers.  The top 5 diagnoses were retained per admission and binary flags were created for diagnoses orrucring at least 25 time int he data. Combined with basic patient level data the model included 1,232 predictors.

The 58,976 events were split 90/10 into training and test sets.  A 5-fold cross validation was used with the training data to select an appropriate number of trees without overfitting. While the training rate (red) declines throughout, the test rate (blue) had a minimum at iteration 102.

![alt text](https://github.com/AsaWilks/mimic_predict_mortality/blob/master/xgb.cv.June1.png)

The base rate of death was 11 percent and the accuracy of the final model was 91.0 percent. The final model had a crossvalidation test error of 9.0 percent with a slightly better 8.55 percent error on the 10 percent test sample that was held out entirely.  No grid search for parameter tuning was implemented because a more fruitful next step would be to add additional information to increase performance.

A variable importance plot highlights mostly intuitive predictors.  The top spot was the diagnosis code for Acute respiratry failure, followed by an indicator for emergency admissions.  The next two correspond to Unspecified Septicemia and Coronary Atherosclerosis of the Native Coronary Artery.  An indicator for missing language presumably flags unresponsive patients and Medicare insurance functions as a stand-in for age, which was not included.

![alt text](https://github.com/AsaWilks/mimic_predict_mortality/blob/master/importance.xgb.June1.png)

The final model object is included in this repo as xgboost.model.1JUN2019.

## Function for returning prediction based on user inputs

To allow predictions from the model to be shared, a the return_pred_api.r defines a function which allows relatively few user inputs to be translated into a prediction.  The following parameters can be specified by the user

```r
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
```

The model was deployed as both a Shiny App and API.  The app is the easiest way to test predictions, allowing for user inputs in a browser.  It is located at https://asawilks.shinyapps.io/mortality_predict_app/.


![alt text](https://github.com/AsaWilks/mimic_predict_mortality/blob/master/app_inputs.png)


The plummer.r script packages the above R function such that it can be run as an API and deploydeathscript.r script deploys the API to shinyapps.io, where it accepts predictor parameters as JSON and returns a prediction value.















