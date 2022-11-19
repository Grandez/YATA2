modOperMovServer = function(id, parent, session) {
   ns  = YATANS(id)
   # ns2 = NS(full)
   PNLOperMov = R6::R6Class("PNL.OPER.MOV"
        ,inherit    = JGGPanel
        ,cloneable  = FALSE
        ,lock_class = TRUE
        ,public = list(
   #          session      = NULL
   #         ,fiat = "__FIAT__"
           initialize    = function(id, parent, session) {
               super$initialize(id, parent, session)
               # self$session    = self$factory$getObject(self$codes$object$session)
               private$oper    = self$factory$getObject("Operation")
               private$pos     = self$factory$getObject("Position")
               private$initVars()
           }
          ,getPosition   = function(camera)    { private$pos$getCameraPosition(camera)         }
          ,addOperation  = function(data)      {
              private$oper$add(data$type, data)
           }
   #      # Inherit
   #        ,getCurrenciesBuy  = function()          { self$parent$getCurrenciesBuy() }
          ,getCurrenciesSell = function(currency)  { self$parent$getCurrenciesSell() }
          ,getCboCameras     = function (currency) {
#              if (nchar(currency) > 0) self$parent$getCboCameras(currency)
              self$parent$getCboCameras(currency)
           }
        )
       ,private = list(
           oper = NULL
          ,pos  = NULL
          ,initVars = function() { # temporales para memoria de cache
              self$vars$price = 0
              self$vars$cboOper  = 0
          }
        )
   )


moduleServer(id, function(input, output, session) {
    pnl = WEB$getPanel(id, PNLOperMov, parent, session)

    showMessage = function (text) {
        output$msg = updTextArea(text)
        TRUE
    }
    validate = function(data) {
        if (is.null(data$type))   return (showMessage(WEB$msg$get("ERR.NO.OPER")))
        if (is.null(data$camera)) return (showMessage(WEB$msg$get("ERR.NO.CAMERA")))
        if (data$price  <= 0)     return (showMessage(WEB$msg$get("ERR.NO.PRICE")))
        if (data$amount <= 0)     return (showMessage(WEB$msg$get("ERR.NO.AMOUNT")))
        if (data$fee    <  0)     return (showMessage(WEB$msg$get("ERR.NEG.FEE")))
        if (data$gas    <  0)     return (showMessage(WEB$msg$get("ERR.NEG.GAS")))
        FALSE
      }
#       xlateCode = function (code) {
#           code = as.integer(code)
#           if (code == 10) return (pnl$codes$oper$bid)
#           if (code == 11) return (pnl$codes$oper$ask)
#           if (code == 20) return (pnl$codes$oper$buy)
#           if (code == 21) return (pnl$codes$oper$sell)
#           pnl$codes$oper$oepr
#       }
      updateCboCurrencies = function() {
         if (!pnl$vars$reload) return()
         if (pnl$vars$buy) {
             data = WEB$combo$currencies()
         }
         else {
             data = pnl$getCurrenciesSell()
         }

         # # Esto es por si se ha clickado en otro panel para comprar
         # # JGG Revisar, si es asi no cargar el combo Y HACERLO ANTES
         # carea = pnl$getCommarea()
         selc = NULL
         # selr = 0
         # if (!is.null(carea$pending)) {
         #     selc = carea$data$symbol
         #     selr = 15
         # }
         # # if (pnl$vars$reloadCounter) {
         # #     updCombo("cboCurrency", choices=data, selected=selc)
         # # } else {
         # #     updCombo("cboCurrency", selected=selc)
         # # }
         updComboSelect("cboCurrencies", choices=data, selected=selc)
         # type = ifelse(pnl$vars$buy, 1, 2)
         # pp = WEB$combo$reasons(type=type)
         # updCombo("cboReasons", choices = WEB$combo$reasons(type=type), selected=selr)
         # processCommarea(1)
      }
      updateCboReasons    = function() {
         type = ifelse(pnl$vars$buy, "buy", "sell")
         pp = WEB$combo$reasons(type=type)
         updCombo("cboReasons", choices = WEB$combo$reasons(type=type))
      }
      resetValues = function(data) {
          updNumericInput("impAmount", value=0)
          updNumericInput("impPrice" , value=0)
          updNumericInput("impValue" , value=0)
          updNumericInput("impFee"   , value=0)
          updNumericInput("impGas"   , value=0)
          browser()
          #updTextArea("comment", "")

          # # When Sell check currency is still available
          # #      Buy  update available
          # if (pnl$vars$buy) {
          #     output$lblAvailable = updLabelNumber(pnl$vars$available - data$value)
          # } else {
          #     updateCboCurrency()
          # }
#          yataMsgReset()#
      }
#       updateSummary = function() {
#           if (is.null(pnl$vars$price))  pnl$vars$price  = 0
#           if (is.null(pnl$vars$amount)) pnl$vars$amount = 0
#           if (is.null(pnl$vars$fee))    pnl$vars$fee    = 0
#           if (is.null(pnl$vars$gas))    pnl$vars$gas    = 0
#           if (pnl$vars$buy) {
#               ctc  = pnl$vars$ctc  + pnl$vars$amount
#               fiat = pnl$vars$fiat - pnl$vars$value
#           } else {
#               ctc  = pnl$vars$ctc - pnl$vars$amount
#               fiat = pnl$vars$fiat + pnl$vars$value
#           }
#           output$lblTotCtc  = updLabelNumber(ctc)
#           output$lblTotFiat = updLabelNumber(round(fiat, 0))
#           output$lblAmount  = updLabelNumber(pnl$vars$amount)
#           output$lblFee     = updLabelNumber(round(pnl$vars$fee, 0))
#           output$lblGas     = updLabelNumber(pnl$vars$gas)
#       }
      updateInfo = function(data) {
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
         if (nchar(cmt) > 0 || data$reason > 0) {
             data$comment = cmt
             data$idLog   = pnl$factory$getID()
         }
         data
      }
#       processCommarea = function(index) {
#           # browser()
#           # # 0 - Usa, 1 - Limpia
#           # carea = pnl$getCommarea()
#           # if (index == 0) {
#           #     op = 0
#           #     if (carea$action == "buy" ) op = 1
#           #     if (carea$action == "sell") op = 3
#           #     updNumericInput("impPrice", value=carea$data$price)
#           #     cant = 1000 / carea$data$price
#           #     rnd =  ifelse(carea$data$price > 1000, 3, 0)
#           #     updNumericInput("impAmount", value=round(cant, rnd))
#           #     if (op != 0) {
#           #        updCombo("cboOper", selected=op)
#           #         updatecboCurrency()
#           #     }
#           # }
#           # if (index == 1 && !is.null(carea$pending)) {
#           #     pnl$setCommarea(list())
#           # }
#       }
      observeEvent(input$cboOper,       {
         if (pnl$vars$cboOper == input$cboOper) return() # No ha cambiado
         pnl$vars$cboOper = as.integer(input$cboOper)
         shinyjs::enable("cboCurrencies")
         pnl$vars$reload = FALSE # Recargar el combo de monedas? Para compras es costoso
         if (is.null(pnl$vars$buy) || !pnl$vars$buy) pnl$vars$reload = TRUE
         pnl$vars$buy = ifelse((pnl$vars$cboOper %% 2) == 0, TRUE, FALSE)
         pnl$vars$major = pnl$vars$cboOper %/% 10
         if (!pnl$vars$buy) pnl$vars$reload = TRUE
         if (pnl$vars$major == 1) {
             shinyjs::enable("impGas")
         } else {
             shinyjs::disable("impGas")
         }
         updateCboCurrencies()
         updateCboReasons()
      }, ignoreNULL = TRUE)
      observeEvent(input$cboCurrencies, {
          # Se generan dos eventos y no se porque
          isolate(shinyjs::enable("cboCameras"))
          currency = ifelse(pnl$vars$buy, YATACODE$CTCFIAT, input$cboCurrencies)
          data = pnl$getCboCameras(currency)
          updCombo("cboCameras", choices=data)
      }, ignoreInit = TRUE, ignoreNULL = TRUE)
      observeEvent(input$cboCameras,    {
          dfPos              = pnl$getPosition(input$cboCameras)
          pnl$vars$fiat      = dfPos[dfPos$currency == 0,"available"]
          pnl$vars$ctc       = dfPos[dfPos$currency == input$cboCurrencies,"available"]
          pnl$vars$available = ifelse(pnl$vars$buy, pnl$vars$fiat, pnl$vars$ctc)
          updNumericInput("impAmount", pnl$vars$available)
          #     updNumericInput("impValue",  round(pnl$vars$ctc * input$impPrice, 0))
          # }
          # pnl$vars$available = ifelse(pnl$vars$buy, pnl$vars$fiat, pnl$vars$ctc)
          output$lblAvailable = updLabelNumber(pnl$vars$available)
      },ignoreInit = TRUE)
      observeEvent(input$impAmount,     {
          if (is.na(input$impAmount) || input$impPrice <= 0) return()
          updNumericInput("impValue", input$impPrice * input$impAmount)
      }, ignoreInit = TRUE, ignoreNULL = TRUE)
      observeEvent(input$impPrice,      {
          if (is.na(input$impPrice) || input$impAmount <= 0) return()
          updNumericInput("impValue", input$impPrice * input$impAmount)
      }, ignoreInit = TRUE, ignoreNULL = TRUE)
      observeEvent(input$impValue,      {
          if (is.na(input$impValue) || input$impPrice <= 0) return()
          updNumericInput("impAmount", input$impValue / input$impPrice)
      }, ignoreInit = TRUE, ignoreNULL = TRUE)

#       observeEvent(input$cboBase, {
#          pnl$vars$inEvent = FALSE
#          pnl$vars$available = 0
#          df = pnl$position$getPosition(input$cboCamera, input$cboBase)
#          if (nrow(df) != 0) pnl$vars$available = df[1,"available"]
#          updateSummary()
#       })
#       observeEvent(input$impAmount | input$impPrice, {
#           pnl$vars$inEvent = FALSE
#           updateSummary()
#       },ignoreInit = TRUE, ignoreNULL = TRUE)
#
#       ##################################################
#       # Buttons to calculate values
#       ##################################################
#
#       observeEvent(input$btnCalcAmount, {
#           if (input$impAmount == 0 || input$impPrice == 0) return()
#           pnl$vars$value  = input$impAmount * input$impPrice
#           pnl$vars$amount = input$impAmount
#           updNumericInput("impValue", pnl$vars$value)
#           updateSummary()
#       })
#       observeEvent(input$btnCalcPrice, {
#           if (input$impPrice == 0) return()
#           if (input$impAmount == 0 && input$impValue == 0) return()
#           pnl$vars$price = input$impPrice
#           if (input$impAmount > 0) {
#               pnl$vars$value = input$impAmount * input$impPrice
#               updNumericInput("impValue", pnl$vars$value)
#           } else {
#               #pnl$vars$amount = ceiling(input$impValue / input$impPrice)
#               pnl$vars$amount = input$impValue / input$impPrice
#               updNumericInput("impAmount", pnl$vars$amount)
#           }
#           updateSummary()
#       })
#
#       observeEvent(input$btnCalcValue, {
#           if (input$impValue == 0 || input$impPrice == 0) return()
#           pnl$vars$value = input$impValue
#           #pnl$vars$amount = ceiling(input$impValue / input$impPrice)
#           pnl$vars$amount = input$impValue / input$impPrice
#           updNumericInput("impAmount", pnl$vars$amount)
#           updateSummary()
#       })
#
      observeEvent(input$btnOK, {
         if (pnl$inEvent) return() # A veces se generan dos triggers (debe ser por los renderUI)

         data = list(
             type    = as.integer(input$cboOper) # xlateCode(input$cboOper)
            ,amount  = input$impAmount
            ,price   = input$impPrice
            ,fee     = input$impFee
            ,gas     = input$impGas
            ,camera  = input$cboCameras
            ,reason  = as.integer(input$cboReasons)
#            ,alert   = input$alert
         )

         cmt = trimws(input$comment)
         if (nchar(cmt) > 0) data$comment = cmt

         if (validate(data)) return()

         pnl$inEvent = TRUE

         ctc = as.integer(input$cboCurrencies)
         data$base    = ifelse(pnl$vars$buy, YATACODE$CTCFIAT, ctc)
         data$counter = ifelse(pnl$vars$buy, ctc, YATACODE$CTCFIAT)

#         data = updateInfo(data)
         tryCatch({
            pnl$addOperation(data)
            resetValues(data)
            showMessage(WEB$msg$get("OK.OPER"))
         }, LOGICAL = function(cond) {
             showMessage(cond$message)
         }, error = function(cond) {
             showMessage(cond$message)
         }, finally = {
            pnl$vars$inEvent = FALSE
         })
      }, ignoreInit = TRUE)
#    observeEvent(input$btnErrorSevere, {
#        stop("observeEvent(input$btnErrorSevere en modOper_MovServer")
#    })
#
#       #observeEvent(input$btnKO, { resetValues() })
#
#     #   carea = pnl$getCommarea()
#     #   if (!is.null(carea$action)) {
#     #       if (carea$action %in% c("buy", "sell")) processCommarea(0)
#     #   }
#
      if (pnl$invalid()) {
          updateSelectizeInput(session, 'cboCurrencies', server = TRUE)
      }
  })
}

