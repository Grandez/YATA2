function(input, output, session) {
  colors = c("red", "blue", "green", "purple")
  # output$plot <- renderPlot({
  #   plot(cars, type=input$plotType)
  # })
  #
  # output$summary <- renderPrint({
  #   summary(cars)
  # })
  #
  # output$table <- DT::renderDataTable({
  #   DT::datatable(cars)
  # })

  printPlots = function() {
     n = length(model$plots)
     if (n >= 1) output$plot1 <- renderPlot({model$plots[[1]]$plot })
     if (n >= 2) output$plot2 <- renderPlot({model$plots[[2]]$plot })
     if (n >= 3) output$plot3 <- renderPlot({model$plots[[3]]$plot })
     if (n >= 4) output$plot4 <- renderPlot({model$plots[[4]]$plot })
     if (n >= 5) output$plot5 <- renderPlot({model$plots[[5]]$plot })
     if (n >= 6) output$plot6 <- renderPlot({model$plots[[6]]$plot })
     if (n >= 1) output$eq1 = renderUI({withMathJax(helpText(model$plots[[1]]$getEquation())) })
     if (n >= 2) output$eq2 = renderUI({withMathJax(helpText(model$plots[[2]]$getEquation())) })
     if (n >= 3) output$eq3 = renderUI({withMathJax(helpText(model$plots[[3]]$getEquation())) })
     if (n >= 4) output$eq4 = renderUI({withMathJax(helpText(model$plots[[4]]$getEquation())) })
     if (n >= 5) output$eq5 = renderUI({withMathJax(helpText(model$plots[[5]]$getEquation())) })
     if (n >= 6) output$eq6 = renderUI({withMathJax(helpText(model$plots[[6]]$getEquation())) })
     if (n >= 1) output$alpha1 = renderText(model$plots[[1]]$tg)
     if (n >= 2) output$alpha2 = renderText(model$plots[[2]]$tg)
     if (n >= 3) output$alpha3 = renderText(model$plots[[3]]$tg)
     if (n >= 4) output$alpha4 = renderText(model$plots[[4]]$tg)
     if (n >= 5) output$alpha5 = renderText(model$plots[[5]]$tg)
     if (n >= 6) output$alpha6 = renderText(model$plots[[6]]$tg)

  }
  observeEvent(input$btnStart, {
     df = makePoints(input$numPoints)
     model$plots[[1]] = makePlot(df, colors[1])
     printPlots()
  })
  observeEvent(input$btnNext, {
      browser()
      idx = model$step + 1
      data = model$plots[[idx]]
      df = data$df
      model$plots[[idx + 1]] = makePlot(df, colors[idx + 2])
      printPlots()

     # if (model$step == 0) {
     #     model$dfw = model$df
     #     addSegment (model)
     # }
     # if (model$step == 1) {
     #     model$dfw = model$df
     #     model$dfw$y = model$dfw$y - model$equs[[2]]$b
     #     model$plots[[3]] = ggplot(data=model$dfw) + geom_point(aes(x,y)) + theme_bw()
     #     model$equs[[3]] = NULL
     # }

     # if (n >= 1 && !is.null(model$equs[[1]])) output$eq1 <- renderUI({withMathJax(helpText(eqRect(1))) })
     # if (n >= 2 && !is.null(model$equs[[2]])) output$eq2 <- renderUI({withMathJax(helpText(eqRect(2))) })
     # if (n >= 3 && !is.null(model$equs[[3]])) output$eq3 <- renderUI({withMathJax(helpText(eqRect(3))) })
     # if (n >= 4 && !is.null(model$equs[[4]])) output$eq4 <- renderUI({withMathJax(helpText(eqRect(4))) })
     # if (n >= 5 && !is.null(model$equs[[5]])) output$eq5 <- renderUI({withMathJax(helpText(eqRect(5))) })
     # if (n >= 6 && !is.null(model$equs[[6]])) output$eq6 <- renderUI({withMathJax(helpText(eqRect(6))) })

     model$step = model$step + 1
     if (model$step > model$numplots) {
         model$plots[1] = NULL
         model$equs [1] = NULL
         model$step = model$step - 1
     }

  })

}

# ggplot(data=val) + geom_point(aes(x,y))
# ggplot(data=val) + geom_point(aes(x,y)) +
#                    geom_segment(aes(x=1, y=val[1,2], xend=nrow(val), yend=val[nrow(val),2]))
