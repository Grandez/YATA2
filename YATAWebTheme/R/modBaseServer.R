modBaseServer <- function(id, full) {
   ns = NS(id)
   moduleServer(id, function(input, output, session) {
      observeEvent(input$btnLbl01, {output$lbl01 = renderText("Actualizado")})
      observeEvent(input$btnDt01, {output$dt01 = updTextDate()})
  })
}    
