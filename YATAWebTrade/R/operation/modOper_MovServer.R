modOperMovServer = function(id, full, pnlParent, parent) {
   ns  = NS(id)
   ns2 = NS(full)   
   PNLOperMov = R6::R6Class("PNL.OPER.MOV"
        ,inherit    = YATAPanel
        ,cloneable  = FALSE
        ,lock_class = TRUE
        ,public = list(
            session      = NULL
           ,initialize    = function(id, pnlParent, session) {
               super$initialize(id, pnlParent, session)
               self$session    = self$factory$getObject(self$codes$object$session)
               private$oper    = self$factory$getObject(self$codes$object$operation)
               private$pos     = self$factory$getObject(self$codes$object$position)
               self$vars$price = 0
           }
           ,cboReasons    = function(type)      { self$makeCombo(private$oper$getReasons(type)) } 
           ,getPosition   = function(camera)    { private$pos$getCameraPosition(camera)         }
           ,operation     = function(data)      {
               tryCatch({private$oper$add(data$type, data)
                         FALSE
               }
               ,error = function(cond) {
                   browser()
                   return (yataErrGeneral(0, WEB$txtError, input, output, session))
                   TRUE
                 }
               )
           } 
        # Inherit
           ,getCounters   = function()          { self$parent$getCounters() }            
           ,getCboCameras = function (currency) { self$parent$getCboCameras(currency)           }            
        )
       ,private = list(
           oper = NULL
          ,pos  = NULL
        )
   )   
   

   moduleServer(id, function(input, output, session) {
        pnl = WEB$getPanel(id)
        if (is.null(pnl)) pnl = WEB$addPanel(PNLOperMov$new(id, pnlParent, session))

      validate = function() {
          if (is.null(input$cboOper)     || nchar(trimws(input$cboOper)) == 0)
              return (yataMsgError(ns2("msg"),pnl$MSG$get("ERR.NO.OPER")))
          if (is.null(input$cboCurrency) || nchar(trimws(input$cboCurrency)) == 0)
              return (yataMsgError(ns2("msg"),pnl$MSG$get("ERR.NO.CURRENCY")))
          if (is.null(input$cboCamera)   || nchar(trimws(input$cboCamera)) == 0)
              return (yataMsgError(ns2("msg"),pnl$MSG$get("ERR.NO.CAMERA")))
          
          if (input$impAmount <= 0) 
              return (yataMsgError(ns2("msg"),pnl$MSG$get("ERR.NO.AMOUNT")))
          if (input$impPrice  <= 0) 
              return (yataMsgError(ns2("msg"),pnl$MSG$get("ERR.NO.PRICE")))
          if (input$impFee    <  0) 
              return (yataMsgError(ns2("msg"),pnl$MSG$get("ERR.NEG.FEE")))
          if (input$impGas    <  0) 
              return (yataMsgError(ns2("msg"),pnl$MSG$get("ERR.NEG.GAS")))

          if (pnl$vars$buy) {
              total = input$impValue
              if (total == 0) total = input$impAmount * input$impPrice
              if (total > pnl$vars$available) {
                  return (yataMsgError(ns2("msg"),pnl$MSG$get("ERR.NO.AVAILABLE")))
              }
          }
          FALSE          
      }
      xlateCode = function (code) {
          code = as.integer(code)
          if (code == 10) return (pnl$codes$oper$bid)
          if (code == 11) return (pnl$codes$oper$ask)
          if (code == 20) return (pnl$codes$oper$buy)
          if (code == 21) return (pnl$codes$oper$sell)
          pnl$codes$oper$oepr
      }
      resetValues = function() {
          updNumericInput("impAmount", value=0)
          updNumericInput("impPrice" , value=0)
          updNumericInput("impValue" , value=0)
          updNumericInput("impFee"   , value=0)
          updNumericInput("impGas"   , value=0)
          updTextArea("comment", "")
#          yataMsgReset()#
      }
      
      updatecboCurrency = function() {
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
             updCombo("cboCurrency", choices=data, selected=selc)    
         } else {
             updCombo("cboCurrency", selected=selc)
         }
         
         updCombo("cboReasons", choices = pnl$cboReasons(input$cboOper), selected=selr)
         processCommarea(1)
          
      }
      updateSummary = function() {
          if (is.null(pnl$vars$price))  pnl$vars$price  = 0
          if (is.null(pnl$vars$amount)) pnl$vars$amount = 0
          if (is.null(pnl$vars$fee))    pnl$vars$fee    = 0
          if (is.null(pnl$vars$gas))    pnl$vars$gas    = 0
          if (pnl$vars$oper == 3) {
              ctc  = pnl$vars$ctc - pnl$vars$amount
              fiat = pnl$vars$fiat + pnl$vars$value
          } else {
              ctc  = pnl$vars$ctc  + pnl$vars$amount
              fiat = pnl$vars$fiat - pnl$vars$value
          }
          output$lblTotCtc  = updLabelNumber(ctc)           
          output$lblTotFiat = updLabelNumber(round(fiat, 0))
          output$lblAmount  = updLabelNumber(pnl$vars$amount)
          output$lblFee     = updLabelNumber(round(pnl$vars$fee, 0))
          output$lblGas     = updLabelNumber(pnl$vars$gas)
      }
      # df = pnl$getCounters()
      # updCombo("cboCurrency",    choices=pnl$makeCombo(df))

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
                  updatecboCurrency()
              }
          }
          if (index == 1 && !is.null(carea$pending)) {
              pnl$setCommarea(list())
          }
      }
      observeEvent(input$cboOper, { 
          pnl$vars$oper = input$cboOper
          pnl$vars$buy = ifelse((as.integer(input$cboOper) %% 2) == 0, TRUE, FALSE)
          updatecboCurrency()
      }, ignoreNULL = TRUE)

      observeEvent(input$cboCurrency, {
          op = as.integer(input$cboOper) %% 2 # Impar es venta
          currency = ifelse(op == 1, input$cboCurrency, "FIAT")
          updCombo("cboCamera", choices=pnl$getCboCameras())
          updNumericInput("impPrice", pnl$session$getPrice(input$cboCurrency))
      }, ignoreInit = TRUE)      
      observeEvent(input$cboCamera, {
          if (is.null(input$cboOper)) return()
          
          dfPos = pnl$getPosition(input$cboCamera)
          pnl$vars$fiat = dfPos[dfPos$currency == "FIAT","balance"]
          pnl$vars$ctc  = dfPos[dfPos$currency == input$cboCurrency,"balance"]
          if (length(pnl$vars$fiat) == 0) pnl$vars$fiat = 0
          if (length(pnl$vars$ctc)  == 0) pnl$vars$ctc  = 0

          currency = ifelse(pnl$vars$buy, "FIAT", input$cboCurrency)
          pnl$vars$available = dfPos[dfPos$currency == currency,"available"]

          output$lblAvailable = updLabelNumber(pnl$vars$available)
      },ignoreInit = TRUE)   
      observeEvent(input$cboBase, {
         pnl$vars$inEvent = FALSE
         pnl$vars$available = 0
         df = pnl$position$getPosition(input$cboCamera, input$cboBase)
         if (nrow(df) != 0) pnl$vars$available = df[1,"available"]
         updateSummary()
      })
      observeEvent(input$impAmount | input$impPrice, {
          pnl$vars$inEvent = FALSE
          updateSummary()
      },ignoreInit = TRUE, ignoreNULL = TRUE)
      ##################################################
      # Buttons to calculate values
      ##################################################
      
      observeEvent(input$btnCalcAmount, {
          if (input$impAmount == 0 || input$impPrice == 0) return()
          pnl$vars$value  = input$impAmount * input$impPrice
          pnl$vars$amount = input$impAmount
          updNumericInput("impValue", pnl$vars$value)
          updateSummary()
      })
      observeEvent(input$btnCalcPrice, {
          if (input$impPrice == 0) return()
          if (input$impAmount == 0 && input$impValue == 0) return()
          pnl$vars$price = input$impPrice
          if (input$impAmount > 0) {
              pnl$vars$value = input$impAmount * input$impPrice
              updNumericInput("impValue", pnl$vars$value)    
          } else {
              #pnl$vars$amount = ceiling(input$impValue / input$impPrice)
              pnl$vars$amount = input$impValue / input$impPrice
              updNumericInput("impAmount", pnl$vars$amount)
          }
          updateSummary()
      })
      
      observeEvent(input$btnCalcValue, {
          if (input$impValue == 0 || input$impPrice == 0) return()
          pnl$vars$value = input$impValue
          #pnl$vars$amount = ceiling(input$impValue / input$impPrice)
          pnl$vars$amount = input$impValue / input$impPrice
          updNumericInput("impAmount", pnl$vars$amount)
          updateSummary()
      })
      
      observeEvent(input$btnOK, {
        # A veces se generan dos triggers (debe ser por los renderUI)
         pnl$vars$inEvent = !pnl$vars$inEvent
         if (!pnl$vars$inEvent) {
             pnl$vars$inEvent = !pnl$vars$inEvent
             return()
         }
         if (validate()) return()

         data = list(
             type    = xlateCode(input$cboOper)
            ,camera  = input$cboCamera
            ,amount  = input$impAmount
            ,price   = input$impPrice
            ,reason  = input$cboReasons
            ,alert   = input$alert
         )

         # Pares son compras
         if ((as.integer(input$cboOper) %% 2) == 0) { 
             data$amount  = input$impAmount * input$impPrice
             data$value   = input$impAmount
             data$base    = "FIAT"
             data$counter = input$cboCurrency
         } else {
             data$amount  = input$impAmount
             data$value   = input$impAmount * input$impPrice
             data$base    = input$cboCurrency
             data$counter = "FIAT"
         }

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
             # msgKey = paste0("OPER.MAKE.", txtType[as.integer(input$cboOper)])
             # yataMsgSuccess(ns2("operMsg"), pnl$MSG$get(msgKey))
             # carea = pnl$getCommarea()
             # carea$position = TRUE
             # pnl$setCommarea(carea)
             # 
             resetValues()
          }
      }, ignoreInit = TRUE)
      #observeEvent(input$btnKO, { resetValues() })

    #   carea = pnl$getCommarea()
    #   if (!is.null(carea$action)) {
    #       if (carea$action %in% c("buy", "sell")) processCommarea(0)
    #   }
     })
}

