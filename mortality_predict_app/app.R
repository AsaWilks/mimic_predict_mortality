#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("ICU Mortality Prediction"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            
            textInput("MARITAL_STATUS", "Marital Status", value="SINGLE", placeholder = "SINGLE/MARRIED/DIVORCED"),
            textInput("ADMISSION_TYPE", "Admission Type", value="EMERGENCY", placeholder = "EMERGENCY/ELECTIVE/URGENT"),
            textInput("ADMISSION_LOCATION", "Admission Location", value="UNK", placeholder = "UNK/EMERGENCY_ROOM/TRANSFER_WITHIN"),
            textInput("INSURANCE", "Insurance", value="PRIVATE", placeholder = "PRIVATE/MEDICARE/MEDICAID"),
            textInput("LANGUAGE", "Language", value="SPANISH", placeholder="ENGLISH/SPANISH/KOREAN"),
            textInput("RELIGION", "Religion", value="CATHOLIC", placeholder = "UNK/CATHOLIC/MUSLIM/JEWISH"),
            textInput("ETHNICITY", "Ethnicity", value="LATINO", placeholder = "WHITE/BLACK/ASIAN/LATINO"),
            numericInput("HAS_CHARTEVENTS_DATA", "Chart Events Data (0/1)", value=1),
            textInput("DX1", "Diagnosis 1", value="DX51881"),
            textInput("DX2", "Diagnosis 2", value="DX0389"),
            textInput("DX3", "Diagnosis 3", value="DX00000"),
            textInput("DX4", "Diagnosis 5", value="DX00000"),
            textInput("DX5", "Diagnosis 5", value="DX00000")
        ),
        
      # Show a plot of the generated distribution
        mainPanel(
           textOutput("pred", inline=F),
           tags$head(tags$style("#pred{color: red;
                                 font-size: 20px;
                                 }"
           )
           )
        )
        )
    )


# Define server logic required to draw a histogram
server <- function(input, output) {

  # load model
    library(xgboost)
    xgbfit <- xgb.load("xgboost.model.1JUN2019")
    
  # call function to process inputs and return prediction
    source("return_pred.R")
    
    output$pred <- reactive({
      (predict.death.rate(
                       HAS_CHARTEVENTS_DATA = input$HAS_CHARTEVENTS_DATA,
                       MARITAL_STATUS = input$MARITAL_STATUS,
                       ADMISSION_TYPE = input$ADMISSION_TYPE,
                       ADMISSION_LOCATION = input$ADMISSION_LOCATION,
                       INSURANCE = input$INSURANCE,
                       LANGUAGE = input$LANGUAGE,
                       RELIGION = input$RELIGION,
                       ETHNICITY = input$ETHNICITY,
                       DX1=input$DX1,
                       DX2=input$DX2,
                       DX3=input$DX3,
                       DX4=input$DX4,
                       DX5=input$DX5
    ))
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
