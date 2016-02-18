library(shiny)
library(shinydashboard)
library(ggplot2)
library(data.table)

shinyUI(fluidPage(

  # Application title
  titlePanel("Miklos Kalman  - Home Assignment"),
  
  hr(), 
  dateRangeInput("daterange", label = h3("Date Range"),
                 start = "2013-01-01",
                 end   = "2013-12-31",
                 min = "2013-01-01",
                 max   = "2013-12-31"
                 ),
  
  fluidRow(
   
    column(4,
           
           sliderInput("range", label = h3("Distance Range (km)"), min = 120, 
                       max = 8020, value = c(2000, 5000))
    )
  ),
  
  hr(),
  tabsetPanel(
    tabPanel("*Flights", 
        fluidRow(
          dataTableOutput("flighttable")
        )
    ),
    tabPanel("*Count by Carrier",
      fluidRow(
        dataTableOutput("carriertable")
      )
  
    ),
    tabPanel("*Count by Airport",
             fluidRow(
               dataTableOutput("airporttable")
             )
             
    ),
    tabPanel("*Avg Delay by Destination",
             fluidRow(
               plotOutput("destinationplot")
             )
             
    ),
    
    tabPanel("*Avg Delay by Carrier",
             fluidRow(
               plotOutput("carrierplot")
             )
             
    ),
    
    tabPanel("*On Time Ratio by Carrier",
             fluidRow(
               dataTableOutput("ontimecarriertable")
             )
             
    ),
    
    tabPanel("*Total Flights Per Weekday",
             fluidRow(
               plotOutput("weekdayplot")
             )
             
    )
    
  ))

)
