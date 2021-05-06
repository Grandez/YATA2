modPnlServer <- function(id, full, pnlParent, invalidate=FALSE) {
   ns = NS(id)
   moduleServer(id, function(input, output, session) {
      cnt = reactiveValues(count = 9)
       observeEvent(input$tabClose, {
          output$salida = renderText(paste("close", input$tabClose))
          YATATabRemove(ns("tab"), input$tabClose)
       })
       observeEvent(input$tabClick, {
          output$salida = renderText(paste("click", input$tabClick))
       })
       observeEvent(input$add, {
          cnt$count = isolate(cnt$count + 1)
          YATATabAppend(ns("tab"), paste("Tab", cnt$count), paste0("Tab", cnt$count))
       })
      
      # observeEvent(input$btnDt01, {output$dt01 = updTextDate()})
#       sel = matrix(c("block1","block2","block3","block4","block5","block6","block7","block8"), ncol=2, byrow = TRUE)
#       objLayout = OBJLayout$new(ns)$update(session, sel)
#       observeEvent(input$layout, {
# #         browser()
#       })
  })
}    
