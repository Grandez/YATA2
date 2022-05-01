function(input, output, session) {
   cat("main beg\n")

#   pnl = WEB$getPanel(YATAWebRoot, "root", NULL, session)
   observeEvent(input$dashboard,{
      mod = paste0( "mod",str_to_title(input$dashboard),"Server")
      eval(parse(text=paste0( mod, "(input$dashboard, '', pnl, session)")))
   })
  observeEvent(input$dash, {
      browser()
  })
   cat("main end\n")
}

# function(input, output, session) {
#
# renderLabel = function(item, target) {
# browser()
#     if (target == 1) output$prueba_data_1  = renderUI({renderText({paste("Texto", target)})})
#     if (target == 2) output$prueba_data_2  = renderUI({renderText({paste("Texto", target)})})
#     if (target == 3) output$prueba_data_3  = renderUI({renderText({paste("Texto", target)})})
#     if (target == 4) output$prueba_data_4  = renderUI({renderText({paste("Texto", target)})})
#
# }
#
# renderTable = function(item, target) {
#     data = reactable(iris)
# output$nombre_table = renderUI({renderReactable(data) })
# #output$nombre_table = ({ renderReactable(data) })
# eval(parse(text=paste0("output$prueba_data_", target, " = renderUI({renderReactable(data) })")))
#     # if (target == 1) output$prueba_data_1 = renderUI({renderReactable(data) })
#     # if (target == 2) output$prueba_data_2 = renderUI({renderReactable(data) })
#     # if (target == 3) output$prueba_data_3 = renderUI({renderReactable(data) })
#     # if (target == 4) output$prueba_data_4 = renderUI({renderReactable(data) })
#
#     # if (target == 1) output$nombre_tbl_1 = renderReactable({ reactable(iris) })
#     # if (target == 2) output$nombre_tbl_2 = renderReactable({ reactable(iris) })
#     # if (target == 3) output$nombre_tbl_3 = renderReactable({ reactable(iris) })
#     # if (target == 4) output$nombre_tbl_4 = renderReactable({ reactable(iris) })
#
# }
# renderPlot = function(item, target) {
#
# data(mtcars)
# cars <- mtcars
# p <- plot_ly(cars, x=cars$wt, y=cars$mpg,
#         mode="markers", color=cars$hp, size=cars$qsec) %>%
#   layout(xaxis = list(title = "Weight (1000 lbs)"),
#          yaxis = list(title = "miles per gallon") )
#     # output$nombre_table_1  = renderUI({plot_ly(iris)})
#     # output$plot1 = renderUI({plot_ly(iris)})
#     # if (target == 1) output$prueba_data_1 = renderPlotly(p )
#     # if (target == 2) output$prueba_data_2 = renderPlotly(p )
#     # if (target == 3) output$prueba_data_3 = renderPlotly(p )
#     # if (target == 4) output$prueba_data_4 = renderPlotly(p )
#
#     # if (target == 1) output$prueba_data_1 = renderUI(p )
#     # if (target == 2) output$prueba_data_2 = renderUI(p )
#     # if (target == 3) output$prueba_data_3 = renderUI(p )
#     # if (target == 4) output$prueba_data_4 = renderUI(p )
# eval(parse(text=paste0("output$prueba_data_", target, " = renderUI({p })")))
# }
#
# #session$sendCustomMessage("jgg_init_layout", "prueba")
#
#   processChange = function(block, value) {
#       browser()
#      toks = strsplit(value, "_")
#      toks = type = toks[[1]]
#      type = toks[1]
#
#      if (type == "lbl") renderLabel(toks[2], block)
#      if (type == "tbl") renderTable(toks[2], block)
#      if (type == "plot") renderPlot(toks[2], block)
#   }
#   observeEvent(input$prueba, {
#       browser()
#       evt = input$prueba
#       if (evt$type == "init") {
#           items = unlist(evt$value)
#           for (idx in 1:length(items)) processChange(idx, items[idx])
#       }
#       if (evt$type == "changed") processChange(evt$block, evt$value)
#   })
# }
#
#
