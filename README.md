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











