modOperXferServer = function(mod, id, pnl) {
  ns = NS(id)
  ns2 = NS(mod)
    moduleServer(id, function(input, output, session) {
      
       validate = function() {
          res = FALSE
          if (input$impAmount <= 0) { res = TRUE; yataMsgError(ns2("msg"),"La cantidad debe ser positiva") }
          res 
       }
       reset = function() {
          updateSelectInput(session, "cboTo", selected="GRAL")
          updateNumericInput(session, "impAmount", value = 0)
       }
       updateSelectInput(session, "cboFrom",    choices=c("Externo"="EXT", pnl$cboCameras(full=TRUE)))
       observeEvent(input$cboFrom, {
          yataMsgReset(ns2("msg")) 
          if (input$cboFrom == "EXT") {
              updateSelectInput(session, "cboTo",       choices=pnl$cboCameras(full=TRUE))
              updateSelectInput(session, "cboCurrency", choices=c("EUR - Euro" = "EUR"))
          }
         else {
              updateSelectInput(session, "cboTo",       choices=c("Externo"="EXT", pnl$cboCameras(exclude=input$cboFrom)))
              updateSelectInput(session, "cboCurrency", choices=pnl$cboCurrency(input$cboFrom, available=TRUE))
         }
       }, ignoreInit = TRUE)
       observeEvent(input$btnKO, { output$msg = renderText({""}); reset() })
       observeEvent(input$btnOK, {
          if (validate()) return()
         browser()
          res = pnl$operation(type = YATACodes$oper$xfer, from=input$cboFrom, to=input$cboTo
                                                        , amount=input$impAmount
                                                        , currency=input$cboCurrency)
          if (res) {
              yataMsgErr(ns2("msg"), "Error al realizar la operacion")
              alert = paste(strsplit(mod, "-")[[1]][1], "alert", sep="-")
              yataAlertPanelServer(alert, session)
          }
          else {
              yataMsgSuccess(ns2("msg"), "Operacion realizada")
              reset()
          }
      })
#       observe({
#           shinyjs::toggleState("btnOK", nchar(input$cboFrom) == 0 && 
#                                         nchar(input$cboTo)   == 0 &&
#                                         nchar(input$cboCurrency) == 0 &&
#                                         input$amount <= 0)
#              
# })
    })
}

