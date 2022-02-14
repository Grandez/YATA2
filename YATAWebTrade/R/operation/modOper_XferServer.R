modOperXferServer = function(id, full, pnl, parent) {
   ns = NS(id)
   ns2 = NS(full)
   moduleServer(id, function(input, output, session) {
      browser()
       validate = function() {
          res = FALSE
          if (input$impAmount <= 0) { res = TRUE; yataMsgError(ns2("msg"),"La cantidad debe ser positiva") }
          res 
       }
       reset = function() {
          updCombo("cboTo", selected="GRAL")
          updNumericInput("impAmount", value = 0)
       }
       updCombo("cboFrom",    choices=pnl$cboCameras(full=TRUE))
       updCombo("cboTo",      choices=pnl$cboCameras(full=TRUE))
       observeEvent(input$cboFrom, {
#          yataMsgReset(ns2("msg")) 
         #  if (input$cboFrom == "EXT") {
         #      updCombo("cboTo",       choices=pnl$cboCameras())
         #      updCombo("cboCurrency", choices=c("EUR - Euro" = "EUR"))
         #  }
         # else {
         #      updCombo("cboTo",       choices=c("Externo"="EXT", pnl$cboCameras(exclude=input$cboFrom)))
               updCombo("cboCurrency", choices=pnl$cboCurrency(input$cboFrom, available=TRUE))
         # }
       }, ignoreInit = TRUE)
       observeEvent(input$operBtnKO, { 
          output$msg = renderText({""}); reset() })
       observeEvent(input$operBtnOK, {
          if (validate()) return()
           browser()
          res = pnl$operations$xfer( from=input$cboFrom, to=input$cboTo
                                    ,amount=input$impAmount
                                    ,currency=input$cboCurrency)
          
          if (res) output$msg = updMessageKO(full, YATAWEB$MSG$get("XFER.KO"))
          if (!res) {
              yataMsgSuccess(ns2("operMsg"), pnl$MSG$get("XFER.OK"))
             reset()
          }
      })
  })
}

