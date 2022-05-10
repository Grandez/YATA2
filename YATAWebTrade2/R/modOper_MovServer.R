modOperMovServer = function(id, full, parent, session) {
   ns  = NS(id)
   ns2 = NS(full)
   PNLOperMov = R6::R6Class("PNL.OPER.MOV"
        ,inherit    = WEBPanel
        ,cloneable  = FALSE
        ,lock_class = TRUE
        ,public = list(
            session      = NULL
           ,fiat = "__FIAT__"
           ,initialize    = function(id, parent, session) {
               super$initialize(id, parent, session)
               self$session    = self$factory$getObject(self$codes$object$session)
               private$oper    = self$factory$getObject(self$codes$object$operation)
               private$pos     = self$factory$getObject(self$codes$object$position)
               # self$fiat       = pnlParent$factory$fiat
               private$initVars()
           }
           ,getPosition   = function(camera)    { private$pos$getCameraPosition(camera)         }
           ,operation     = function(data)      {
               tryCatch({
                   private$oper$add(data$type, data)
               },error = function(cond) {
                   yataErrGeneral(10, WEB$txtError, cond, input, output, session, web=WEB)
                   0
               })
           }
        # Inherit
          ,getCurrenciesBuy  = function()          { self$parent$getCurrenciesBuy() }
          ,getCurrenciesSell = function(currency)  { self$parent$getCurrenciesSell() }
          ,getCboCameras     = function (currency) { self$parent$getCboCameras(currency) }

        )
       ,private = list(
           oper = NULL
          ,pos  = NULL
          ,initVars = function() {
              # Sirve de memoria
              self$vars$price = 0
              self$vars$cboOper  = 0
          }
        )
   )


moduleServer(id, function(input, output, session) {
   pnl = WEB$getPanel(PNLOperMov, id, parent, session)

      validate = function(data) {
          if (is.null(input$cboOper)     || nchar(trimws(input$cboOper)) == 0)
              return (yataMsgError(ns2("msg"),pnl$msg$get("ERR.NO.OPER")))
          if (is.null(input$cboCurrency) || nchar(trimws(input$cboCurrency)) == 0)
              return (yataMsgError(ns2("msg"),pnl$msg$get("ERR.NO.CURRENCY")))
          if (is.null(input$cboCamera)   || nchar(trimws(input$cboCamera)) == 0)
              return (yataMsgError(ns2("msg"),pnl$msg$get("ERR.NO.CAMERA")))

          if (data$price  <= 0)
              return (yataMsgError(ns2("msg"),pnl$msg$get("ERR.NO.PRICE")))
          if (data$amount <= 0)
              return (yataMsgError(ns2("msg"),pnl$msg$get("ERR.NO.AMOUNT")))
          if (data$value  <= 0)
              return (yataMsgError(ns2("msg"),pnl$msg$get("ERR.NO.AMOUNT")))

          if (input$impFee    <  0)
              return (yataMsgError(ns2("msg"),pnl$msg$get("ERR.NEG.FEE")))
          if (input$impGas    <  0)
              return (yataMsgError(ns2("msg"),pnl$msg$get("ERR.NEG.GAS")))

          if (pnl$vars$buy && data$value > pnl$vars$available) {
              return (yataMsgError(ns2("msg"),pnl$msg$get("ERR.NO.AVAILABLE")))
          }
          data
      }
      xlateCode = function (code) {
          code = as.integer(code)
          if (code == 10) return (pnl$codes$oper$bid)
          if (code == 11) return (pnl$codes$oper$ask)
          if (code == 20) return (pnl$codes$oper$buy)
          if (code == 21) return (pnl$codes$oper$sell)
          pnl$codes$oper$oepr
      }
      updatecboCurrency = function() {
         if (!pnl$vars$reload) return()
         if (pnl$vars$buy) {
             data = WEB$combo$currencies(id = FALSE)
         }
         else {
             df = pnl$getCurrenciesSell()
             if (nrow(df) == 0) {
                 data = c("No hay posiciones"="")
             } else {
                 data = WEB$combo$currencies(id=FALSE, set=df$id)
             }
         }
         # Esto es por si se ha clickado en otro panel para comprar
         # JGG Revisar, si es asi no cargar el combo Y HACERLO ANTES
         carea = pnl$getCommarea()
         selc = NULL
         selr = 0
         if (!is.null(carea$pending)) {
             selc = carea$data$symbol
             selr = 15
         }
         # if (pnl$vars$reloadCounter) {
         #     updCombo("cboCurrency", choices=data, selected=selc)
         # } else {
         #     updCombo("cboCurrency", selected=selc)
         # }
         updCombo("cboCurrency", choices=data, selected=selc)
         type = ifelse(pnl$vars$buy, 1, 2)
         pp = WEB$combo$reasons(type=type)
         updCombo("cboReasons", choices = WEB$combo$reasons(type=type), selected=selr)
         processCommarea(1)
      }
      resetValues = function() {
          updNumericInput("impAmount", value=0)
          updNumericInput("impPrice" , value=0)
          updNumericInput("impValue" , value=0)
          updNumericInput("impFee"   , value=0)
          updNumericInput("impGas"   , value=0)
          updTextArea("comment", "")
          # Si es una venta puede ser que no queden monedas
          if (!pnl$vars$buy) updateCboCurrency()
#          yataMsgReset()#
      }
      updateSummary = function() {
          if (is.null(pnl$vars$price))  pnl$vars$price  = 0
          if (is.null(pnl$vars$amount)) pnl$vars$amount = 0
          if (is.null(pnl$vars$fee))    pnl$vars$fee    = 0
          if (is.null(pnl$vars$gas))    pnl$vars$gas    = 0
          if (pnl$vars$buy) {
              ctc  = pnl$vars$ctc  + pnl$vars$amount
              fiat = pnl$vars$fiat - pnl$vars$value
          } else {
              ctc  = pnl$vars$ctc - pnl$vars$amount
              fiat = pnl$vars$fiat + pnl$vars$value
          }
          output$lblTotCtc  = updLabelNumber(ctc)
          output$lblTotFiat = updLabelNumber(round(fiat, 0))
          output$lblAmount  = updLabelNumber(pnl$vars$amount)
          output$lblFee     = updLabelNumber(round(pnl$vars$fee, 0))
          output$lblGas     = updLabelNumber(pnl$vars$gas)
      }
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
      processCommarea = function(index) {
          # browser()
          # # 0 - Usa, 1 - Limpia
          # carea = pnl$getCommarea()
          # if (index == 0) {
          #     op = 0
          #     if (carea$action == "buy" ) op = 1
          #     if (carea$action == "sell") op = 3
          #     updNumericInput("impPrice", value=carea$data$price)
          #     cant = 1000 / carea$data$price
          #     rnd =  ifelse(carea$data$price > 1000, 3, 0)
          #     updNumericInput("impAmount", value=round(cant, rnd))
          #     if (op != 0) {
          #        updCombo("cboOper", selected=op)
          #         updatecboCurrency()
          #     }
          # }
          # if (index == 1 && !is.null(carea$pending)) {
          #     pnl$setCommarea(list())
          # }
      }
      observeEvent(input$cboOper, {
          # Punto de control de tabs (memoria)
          if (pnl$vars$cboOper == input$cboOper) return()
          pnl$vars$cboOper = input$cboOper
          enable("cboCurrency")
          pnl$vars$soper = input$cboOper
          pnl$vars$reload = FALSE # Recargar el combo de monedas? Para compras es costoso
          if (is.null(pnl$vars$buy) || !pnl$vars$buy) pnl$vars$reload = TRUE
          pnl$vars$buy = ifelse((as.integer(input$cboOper) %% 2) == 0, TRUE, FALSE)
          if (!pnl$vars$buy) pnl$vars$reload = TRUE
          updatecboCurrency()
      }, ignoreNULL = TRUE)

      observeEvent(input$cboCurrency, {
          enable("cboCamera")
          currency = ifelse(pnl$vars$buy, pnl$fiat, input$cboCurrency)
          updCombo("cboCamera", choices=pnl$getCboCameras(currency))
          updNumericInput("impPrice", pnl$session$getPrice(input$cboCurrency))
      }, ignoreInit = TRUE)
      observeEvent(input$cboCamera, {
          dfPos = pnl$getPosition(input$cboCamera)
          pnl$vars$fiat = dfPos[dfPos$currency == pnl$fiat,"balance"]
          pnl$vars$ctc  = dfPos[dfPos$currency == input$cboCurrency,"available"]
#          updNumericInput("impAmount", pnl$vars$ctc)
          if (!pnl$vars$buy) {
              updNumericInput("impAmount", pnl$vars$ctc)
              updNumericInput("impValue",  round(pnl$vars$ctc * input$impPrice, 0))
          }
          currency = ifelse(pnl$vars$buy, pnl$factory$fiat, input$cboCurrency)
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
        # Amount es lo que se mueve (compro o vendo)
        # Value es el fiat
          # Ejemplo compro 1 - BTC (amount) por un valor de x
          #         vendo  1 - BTC (amount) por un valor de x
        # Luego en funcion de compra o venta
        # in - entra
        # out sale
        # A veces se generan dos triggers (debe ser por los renderUI)

         if (pnl$vars$inEvent) return()
         pnl$vars$inEvent = TRUE

         data = list(
             type    = as.integer(input$cboOper) # xlateCode(input$cboOper)
            ,amount  = input$impAmount
            ,price   = input$impPrice
            ,value   = input$impValue
            ,camera  = input$cboCamera
            ,reason  = as.integer(input$cboReasons)
            ,alert   = input$alert
         )
         if (data$amount == 0) data$amount = input$impValue  / input$impPrice
         if (data$value  == 0) data$value  = input$impAmount * input$impPrice

         if (pnl$vars$buy) {
             data$base      = pnl$fiat
             data$counter   = input$cboCurrency
             data$ctcIn     = data$amount
             data$ctcOut    = data$value
         } else {
             data$base      = input$cboCurrency
             data$counter   = pnl$factory$fiat
             data$ctcIn     = data$value
             data$ctcOut    = data$amount
         }

         data = validate(data)
         if (is.logical(data)) return() # Ha devuelto un error

         data = updateInfo(data)
         id = pnl$operation(data)
         if (id > 0) {
             resetValues()
             #JGG Pendiente
             # msgKey = paste0("OPER.MAKE.", txtType[as.integer(input$cboOper)])
             # yataMsgSuccess(ns2("operMsg"), sprintf(pnl$msg$get(msgKey), id)
             pnl$setCommarea(position=TRUE)
         }
         pnl$vars$inEvent = FALSE
      }, ignoreInit = TRUE)
   observeEvent(input$btnErrorSevere, {
       browser()
   })

      #observeEvent(input$btnKO, { resetValues() })

    #   carea = pnl$getCommarea()
    #   if (!is.null(carea$action)) {
    #       if (carea$action %in% c("buy", "sell")) processCommarea(0)
    #   }

#    if (!pnl$loaded) pnl$loaded = TRUE

     })
}

