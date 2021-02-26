modOperSell2Server = function(id, full, pnl) {
   ns = NS(id)
   dfPos        = NULL
   dfCamera     = NULL
   fee          = 0
   moduleServer(id, function(input, output, session) {
      validate = function() {
         FALSE
      }
      activeButtons = function() {
         if (input$cboOper == "") {
             shinyjs::disable("btnOK")
         }
         else {
             shinyjs::enable("btnOK")
         }
      }
      resetValues = function() {
          updNumericInput("impAmount", value=0)
          updNumericInput("impPrice" , value=0)
      }
      # df = pnl$getCounters()
      # updCombo("cboCounter",    choices=pnl$makeCombo(df))

      observeEvent(input$cboOper, {
         if (input$cboOper != YATACodes$oper$sell) {
             data = pnl$makeCombo(pnl$getCounters())
         }
         else {
             df = pnl$getCurrenciesSell()
             if (nrow(df) == 0) {
                 data = c("No hay posiciones"="")
             } else {
                 data=pnl$makeCombo(df)
             }
         }     
         updCombo("cboCounter", choices=data)
         activeButtons()
      })

      observeEvent(input$cboCounter, {
          updCombo("cboCamera", choices=pnl$cboCamerasCounter(input$cboCounter))
      }, ignoreInit = TRUE)      
      observeEvent(input$cboCamera, {
          dfPos = pnl$position$getCameraPosition(input$cboCamera, available = TRUE) 
          updCombo("cboBase", choices=pnl$cboCurrency(input$cboCamera, TRUE))
          pnl$cameras$select(input$cboCamera)
          fee = pnl$cameras$current$taker
          output$lblFee = updLabelPercentage(fee)
      },ignoreInit = TRUE)   
      observeEvent(input$cboBase, {
         pnl$vars$available = 0
         df = pnl$position$getPosition(input$cboCamera, input$cboBase) 
         if (nrow(df) != 0) pnl$vars$available = df[1,"available"]
         output$lblAvailable = updLabelNumeric(pnl$vars$available)
         output$lblNew       = updLabelNumeric(pnl$vars$available)
      })
      observeEvent(input$impAmount | input$impPrice, {
          if (!is.na(input$impAmount) && !is.na(input$impPrice)) {
             if (input$impAmount != 0 && input$impPrice != 0) {
                 imp  = input$impAmount * input$impPrice
                 iFee = imp * fee / 100
                 iTotal = imp + iFee
                 output$lblImp     = updLabelNumeric(imp)
                 output$lblFeeImp  = updLabelNumeric(iFee)
                 output$lblTotBase = updLabelNumeric(iTotal)
                 output$lblNew     = updLabelNumeric(pnl$vars$available - iTotal)
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
         tt = ifelse(pnl$panel == "oper-open", YATACodes$oper$oper, YATACodes$oper$buy) 
         res = pnl$operation(type = tt, data)
          if (res) {
#              yataMsgErr(ns2("msg"), "Error al realizar la operacion")
              alert = paste(strsplit(mod, "-")[[1]][1], "alert", sep="-")
              yataAlertPanelServer(alert, session)
          }
          else {
#              browser()
 #             yataMsgSuccess(ns2("msg"), "Operacion realizada")
               resetValues()
          }
         
      })
      observeEvent(input$btnKO, { resetValues() })
      
    })
}

