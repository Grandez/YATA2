

function(input, output, session) {
    #bs_themer()
    observeEvent(input$mainMenu, {
        message(input$mainMenu)
    })
  output$plot <- renderPlot({
    plot(cars, type=input$plotType)
  })

  output$summary <- renderPrint({
    summary(cars)
  })

  output$table <- DT::renderDataTable({
    DT::datatable(cars)
  })
  observeEvent(input$main, {
      browser()
  })
  observeEvent(input$app_title, {
      browser()
  })
  
}

