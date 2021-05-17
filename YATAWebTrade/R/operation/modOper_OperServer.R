modOperOperServer = function(id, full, pnl, parent) {
   ns = NS(id)
   ns2 = NS(full)
   dfPos        = NULL
   dfCamera     = NULL
   fee          = 0
   moduleServer(id, function(input, output, session) {
      txtType = c("OPER", "BUY", "SELL") 
      pnl$vars$inEvent = FALSE 
      validate = function() {
          res = FALSE
          # if (input$impAmount <= 0) res = pnl$setMsg("MSG.AMOUNT.ERR")
          # if (input$impPrice  <= 0) res = pnl$setMsg("MSG.PRICE.ERR")
          res
       }
      activeButtons = function() {
         if (input$cboOper == "") {
             shinyjs::disable("btnOK")
         }
         else {
             shinyjs::enable("btnOK")
         }
         yataMsgReset(ns2("operMsg"))
      }
      resetValues = function() {
          updNumericInput("impAmount", value=0)
          updNumericInput("impPrice" , value=0)
          updTextArea("comment", "")
      }
      updateCboCounter = function() {
         pnl$vars$reloadCounter = FALSE 
         if (input$cboOper != pnl$codes$oper$sell) {
             data = pnl$makeCombo(pnl$getCounters())
             tmp = pnl$vars$counter
             if (is.null(tmp) || tmp == "sell") pnl$vars$reloadCounter = TRUE
             pnl$vars$counter = "buy"
         }
         else {
             df = pnl$getCurrenciesSell()
             if (nrow(df) == 0) {
                 data = c("No hay posiciones"="")
             } else {
                 data=pnl$makeCombo(df)
             }
             tmp = pnl$vars$counter
             if (is.null(tmp) || tmp == "buy") pnl$vars$reloadCounter = TRUE
             pnl$vars$counter = "sell"
         }
         carea = pnl$getCommarea()
         selc = NULL
         selr = 0
         if (!is.null(carea$pending)) {
             selc = carea$data$symbol
             selr = 15
         }
         if (pnl$vars$reloadCounter) {
             updCombo("cboCounter", choices=data, selected=selc)    
         } else {
             updCombo("cboCounter", selected=selc)
         }
         
         updCombo("cboReasons", choices = pnl$cboReasons(input$cboOper), selected=selr)
         activeButtons()
         processCommarea(1)
          
      }
      updateSummary = function() {
         output$lblAvailable = updLabelNumber(round(pnl$vars$available)) 
         if (is.na(input$impAmount) || is.na(input$impPrice)) return()
         imp  = input$impAmount * input$impPrice
         iFee = imp * fee / 100
         iTotal = imp + iFee
         output$lblImp     = updLabelNumber(round(imp))
         output$lblFee     = updLabelNumber(iFee)
         output$lblTotBase = updLabelNumber(round(iTotal))
         output$lblFeeImp  = updLabelNumber(0)
         output$lblGas     = updLabelNumber(0)
         output$lblTotCounter   = updLabelNumber(input$impAmount)
         output$lblNewAvailable = updLabelNumber(round(pnl$vars$available - iTotal))
      }
      # df = pnl$getCounters()
      # updCombo("cboCounter",    choices=pnl$makeCombo(df))

      processCommarea = function(index) {
          # 0 - Usa, 1 - Limpia
          carea = pnl$getCommarea()
          if (index == 0) {
              op = 0
              if (carea$action == "buy" ) op = 1
              if (carea$action == "sell") op = 3
              updNumericInput("impPrice", value=carea$data$price)
              cant = 1000 / carea$data$price
              rnd =  ifelse(carea$data$price > 1000, 3, 0)
              updNumericInput("impAmount", value=round(cant, rnd))
              if (op != 0) {
                 updCombo("cboOper", selected=op)
                  updateCboCounter()
              }
          }
          if (index == 1 && !is.null(carea$pending)) {
              pnl$setCommarea(list())
          }
      }
      observeEvent(input$cboOper, {
          YATAWEB$beg("cboOper")
          updateCboCounter()
         YATAWEB$end("cboOper")
      }, ignoreInit = TRUE)

      observeEvent(input$cboCounter, {
          YATAWEB$beg("cboCounter")
          pnl$vars$inEvent = FALSE
          data = pnl$cboCamerasCounter(input$cboCounter)
          updCombo("cboCamera", choices=pnl$cboCamerasCounter(input$cboCounter))
          YATAWEB$end("cboCounter")
      }, ignoreInit = TRUE)      
      observeEvent(input$cboCamera, {
          YATAWEB$beg("cboCamera")
          pnl$vars$inEvent = FALSE
          dfPos = pnl$position$getCameraPosition(input$cboCamera, available = TRUE) 
          # SI es compra, necesito un fiat,  Si es venta, no es fiat
          updCombo("cboBase", choices=pnl$cboCurrency(input$cboCamera, TRUE))
          pnl$cameras$select(input$cboCamera)
          fee = pnl$cameras$current$taker
          output$lblFee = updLabelPercentage(fee)
          YATAWEB$end("cboCamera")
      },ignoreInit = TRUE)   
      observeEvent(input$cboBase, {
         YATAWEB$beg("cboBase")
         pnl$vars$inEvent = FALSE
         pnl$vars$available = 0
         df = pnl$position$getPosition(input$cboCamera, input$cboBase)
         if (nrow(df) != 0) pnl$vars$available = df[1,"available"]
         updateSummary()
         YATAWEB$end("cboBase")
      })
      observeEvent(input$impAmount | input$impPrice, {
          YATAWEB$beg("cboImp")
          pnl$vars$inEvent = FALSE
          updateSummary()
          YATAWEB$end("cboImp")
      },ignoreInit = TRUE, ignoreNULL = TRUE)
      observeEvent(input$operBtnOK, {
          YATAWEB$beg("btnOK")
        # A veces se generan dos triggers (debe ser por los renderUI)
         pnl$vars$inEvent = !pnl$vars$inEvent
         if (!pnl$vars$inEvent) {
             pnl$vars$inEvent = !pnl$vars$inEvent
             return()
         }
         if (validate()) return()

         data = list()
         data$type     = input$cboOper
         data$camera   = input$cboCamera
         data$base     = input$cboBase
         data$counter  = input$cboCounter
         data$amount   = input$impAmount
         data$price    = input$impPrice
         data$reason   = input$cboReasons
         data$alert    = input$alert

         if (input$target   > 0) {
             data$target   = input$target
             if (input$swTarget) data$target = data$price * (1 + (data$target / 100)) 
         }
         if (input$deadline > 0) data$deadline = input$deadline
         if (input$stop    != 0) {
             data$stop     = input$stop
             if (input$swStop) {
                 if (data$stop < 0) data$stop = data$stop * -1
                 data$stop = data$price * (1 - (data$stop / 100)) 
             }
         }     
         if (input$limit    > 0) data$limit    = input$limit
         
         cmt = trimws(input$comment)
         if (nchar(cmt) > 0) {
             data$comment = cmt
             data$idLog   = getID()
         }     

         res = pnl$operation(data)
         if (res) {
             yataMsgErr(ns2("msg"), pnl$MSG$get("OPER.MAKE.ERR"))
         } else {
             pnl$valid = FALSE
             msgKey = paste0("OPER.MAKE.", txtType[as.integer(input$cboOper)])
             yataMsgSuccess(ns2("operMsg"), pnl$MSG$get(msgKey))
             carea = pnl$getCommarea()
             carea$position = TRUE
             pnl$setCommarea(carea)

             resetValues()
          }
      }, ignoreInit = TRUE)
      observeEvent(input$operBtnKO, { 
          YATAWEB$beg("btnKO")
          resetValues() })

      carea = pnl$getCommarea()
      if (!is.null(carea$action)) {
          if (carea$action %in% c("buy", "sell")) processCommarea(0)
      }
    })
}

