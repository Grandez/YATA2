modPnl1Server <- function(id, full, pnlParent, invalidate=FALSE) {
   ns = NS(id)
   moduleServer(id, function(input, output, session) {
      # observeEvent(input$btnLbl01, {output$lbl01 = renderText("Actualizado")})
      # observeEvent(input$btnDt01, {output$dt01 = updTextDate()})
      sel = matrix(c("block1","block2","block3","block4","block5","block6","block7","block8"), ncol=2, byrow = TRUE)
      objLayout = OBJLayout$new(ns)$update(session, sel)
      observeEvent(input$layout, {
#         browser()
      })
  })
}    
