modOperOpenServer = function(id, full, pnl) { tplOperBuyServer(id, full, pnl) }
#    ns = NS(id)
#    dfPos        = NULL
#    dfCamera     = NULL
#    fee          = 0
#    browser()
#    moduleServer(id, function(input, output, session) {
#       validate = function() {
#          FALSE
#       }
#       resetValues = function() {
#           updateNumericInput(session, "impAmount", value=0)
#           updateNumericInput(session, "impPrice" , value=0)
#       }
#       df = pnl$getCounters()
#       updateSelectInput(session, "cboCounter",    choices=pnl$makeCombo(df))
# 
#       observeEvent(input$cboCounter, {
#           updateSelectInput(session, "cboCamera",    choices=pnl$cboCamerasCounter(input$cboCounter))
#       }, ignoreInit = TRUE)
#       observeEvent(input$cboCamera, {
#           dfPos = pnl$position$getCameraPosition(input$cboCamera, available = TRUE)
#           updateSelectInput(session, "cboBase",     choices=pnl$cboCurrency(input$cboCamera, TRUE))
#           pnl$cameras$select(input$cboCamera)
#           fee = pnl$cameras$current$taker
#           output$lblFee = renderUI({HTML(yataTextPercent(fee))})
#       },ignoreInit = TRUE)
#       observeEvent(input$cboBase, {
#          pnl$vars$available = 0
#          df = pnl$position$getPosition(input$cboCamera, input$cboBase)
#          if (nrow(df) != 0) pnl$vars$available = df[1,"available"]
#          output$lblAvailable = renderUI({HTML(yataTextNumeric(pnl$vars$available))})
#          output$lblNew       = renderUI({HTML(yataTextNumeric(pnl$vars$available))})
#       })
#       observeEvent(input$impAmount | input$impPrice, {
#           if (!is.na(input$impAmount) && !is.na(input$impPrice)) {
#              if (input$impAmount != 0 && input$impPrice != 0) {
#                  imp  = input$impAmount * input$impPrice
#                  iFee = imp * fee / 100
#                  iTotal = imp + iFee
#                  output$lblImp     = renderUI({HTML(yataTextNumeric(imp))})
#                  output$lblFeeImp  = renderUI({HTML(yataTextNumeric(iFee))})
#                  output$lblTotBase = renderUI({HTML(yataTextNumeric(iTotal))})
#                  output$lblNew     = renderUI({HTML(yataTextNumeric(pnl$vars$available - iTotal))})
#              }
#           }
#       },ignoreInit = TRUE, ignoreNULL = TRUE)
#       observeEvent(input$btnOK, {
#          if (validate()) return()
#          data = list()
#          data$camera   = input$cboCamera
#          data$base     = input$cboBase
#          data$counter  = input$cboCounter
#          data$amount   = input$impAmount
#          data$price    = input$impPrice
# 
#          data$alert    = input$alert
# 
#          if (input$target   > 0) data$target   = input$target
#          if (input$deadline > 0) data$deadline = input$deadline
#          if (input$stop     > 0) data$stop     = input$stop
#          if (input$limit    > 0) data$limit    = input$limit
# 
#          cmt = trimws(input$comment)
#          if (nchar(cmt) > 0) data$comment = cmt
#          tt = ifelse(pnl$panel == "open", YATACodes$oper$oper, YATACodes$oper$buy)
#          res = pnl$operation(type = tt, data)
#           if (res) {
# #              yataMsgErr(ns2("msg"), "Error al realizar la operacion")
#               alert = paste(strsplit(mod, "-")[[1]][1], "alert", sep="-")
#               yataAlertPanelServer(alert, session)
#           }
#           else {
# #              browser()
#  #             yataMsgSuccess(ns2("msg"), "Operacion realizada")
#                resetValues()
#           }
# 
#       })
# 
#     })
# }
# 
