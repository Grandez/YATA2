modOperOpenServer = function(mod, id, pnl) {
   ns = NS(id)
   dfPos        = NULL
   dfCamera     = NULL
   fee          = 0
   
   validate = function() {
      FALSE
   }
   moduleServer(id, function(input, output, session) {

      updateSelectInput(session, "cboCounter",    choices=pnl$cboOpen())

      observeEvent(input$cboCounter, {
          updateSelectInput(session, "cboCamera",    choices=pnl$cboCamerasCounter(input$cboCounter))
      }, ignoreInit = TRUE)      
      observeEvent(input$cboCamera, {
          dfPos = pnl$position$getCameraPosition(input$cboCamera, available = TRUE) 
          pnl$vars$available = dfPos$available
          output$lblAvailable  = renderUI({HTML(yataTextNumeric(pnl$vars$available))})
          
          updateSelectInput(session, "cboBase",     choices=pnl$cboCurrency(input$cboCamera, TRUE))
          
          pnl$cameras$select(input$cboCamera)
          fee = pnl$cameras$current$taker
          output$lblFee = renderUI({HTML(yataTextPercent(fee))})
      },ignoreInit = TRUE)      
      observeEvent(input$impAmount | input$impPrice, {
          if (!is.na(input$impAmount) && !is.na(input$impPrice)) {
             if (input$impAmount != 0 && input$impPrice != 0) {
                 imp  = input$impAmount * input$impPrice
                 iFee = imp * fee / 100
                 iTotal = imp + iFee
                 output$lblImp     = renderUI({HTML(yataTextNumeric(imp))})
                 output$lblFeeImp  = renderUI({HTML(yataTextNumeric(iFee))})
                 output$lblTotBase = renderUI({HTML(yataTextNumeric(iTotal))})
                 output$lblNew     = renderUI({HTML(yataTextNumeric(pnl$vars$available - iTotal))})
             } 
          }
      },ignoreInit = TRUE, ignoreNULL = TRUE)
      observeEvent(input$btnOK, {
         if (validate()) return()
         data = list()
         data$camera   = input$cboCamera
         data$base     = input$cboBase
         data$counter  = input$cboCounter
         data$amount   = input$impAmount
         data$price    = input$impPrice
         
         data$alert    = input$alert
         
         if (input$target   > 0) data$target   = input$target
         if (input$deadline > 0) data$deadline = input$deadline
         if (input$stop     > 0) data$stop     = input$stop
         if (input$limit    > 0) data$limit    = input$limit
         
         cmt = trimws(input$comment)
         if (nchar(cmt) > 0) data$comment = cmt

         res = pnl$operation(type = YATACodes$oper$oper, data)
          if (res) {
#              yataMsgErr(ns2("msg"), "Error al realizar la operacion")
              alert = paste(strsplit(mod, "-")[[1]][1], "alert", sep="-")
              yataAlertPanelServer(alert, session)
          }
          else {
 #             yataMsgSuccess(ns2("msg"), "Operacion realizada")
              reset()
          }
         
      })
      
    })
}

