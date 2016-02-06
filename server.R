library(shiny)
shinyServer(function(input, output) {

  output$distPlot <- renderPlot({

    plot(mtcars[, input$x], mtcars[, input$y], col=mtcars[,input$color])
    
    fit <- lm(mtcars[,input$y] ~ mtcars[,input$x])
  
    abline(fit, col = 'red')

  })

})
