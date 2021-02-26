modOperXferServer = function(id, full, pnl) {
   ns = NS(id)
   moduleServer(id, function(input, output, session) {
       validate = function() {
          res = FALSE
          if (input$impAmount <= 0) { res = TRUE; yataMsgError(ns2("msg"),"La cantidad debe ser positiva") }
          res 
       }
       reset = function() {
          updCombo("cboTo", selected="GRAL")
          updNumericInput("impAmount", value = 0)
       }
       updCombo("cboFrom",    choices=c("Externo"="EXT", pnl$cboCameras(full=TRUE)))
       observeEvent(input$cboFrom, {
#          yataMsgReset(ns2("msg")) 
          if (input$cboFrom == "EXT") {
              updCombo("cboTo",       choices=pnl$cboCameras())
              updCombo("cboCurrency", choices=c("EUR - Euro" = "EUR"))
          }
         else {
              updCombo("cboTo",       choices=c("Externo"="EXT", pnl$cboCameras(exclude=input$cboFrom)))
              updCombo("cboCurrency", choices=pnl$cboCurrency(input$cboFrom, available=TRUE))
         }
       }, ignoreInit = TRUE)
       observeEvent(input$btnKO, { output$msg = renderText({""}); reset() })
       observeEvent(input$btnOK, {
          if (validate()) return()
          res = pnl$operation(type = YATACodes$oper$xfer, from=input$cboFrom, to=input$cboTo
                                                        , amount=input$impAmount
                                                        , currency=input$cboCurrency)
          if (res) {
               output$msg = updMessageKO(id, pnl$MSG$get("XFER.KO"))
          }
          else {
              output$msg = updMessageOK(id, pnl$MSG$get("XFER.OK"))
              reset()
          }
      })
       updMessageOK(full, "Mensaje a mostrar")
#       observe({
#           shinyjs::toggleState("btnOK", nchar(input$cboFrom) == 0 && 
#                                         nchar(input$cboTo)   == 0 &&
#                                         nchar(input$cboCurrency) == 0 &&
#                                         input$amount <= 0)
#              
# })
    })
}

