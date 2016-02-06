library(shiny)
shinyUI(fluidPage(

  # Application title
  titlePanel("Miklos Kalman  - Home Assignment"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      sliderInput("bins",
                  "Number of bins:",
                  min = 1,
                  max = 16,
                  value = 5),
      
      selectInput('x', 'x', 
                  choices = names(mtcars)),
      
      selectInput('y', 'y', 
                  choices = names(mtcars), selected="hp"),
      
      selectInput('color', 'Color', 
                  choices = c('am','gear','carb'))
    ),

    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot")
    )
  )
))
