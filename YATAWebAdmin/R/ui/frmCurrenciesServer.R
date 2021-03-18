frmCurrenciesServer = function(id, ...) {
   
   ns = NS(id)
   args = list(...)
   pnl = args$pnl
   moduleServer(id, function(input, output, session) {
       observeEvent(input$OK, {
           browser()
       })
       observeEvent(input$jggADD, {
           browser()
       })
       
  })
}

