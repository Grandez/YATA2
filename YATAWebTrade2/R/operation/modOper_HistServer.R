modOperHistServer = function(id, full, pnlParent, parent) {
ns = NS(id)
ns2 = NS(full)
PNLOperHist = R6::R6Class("PNL.OPER.HIST"
   ,inherit    = YATAPanel
   ,cloneable  = FALSE
   ,lock_class = TRUE
   ,public = list(
       available  = 0
      ,balance    = 0
      ,initialize = function(id, pnlParent, session) {
          super$initialize(id, pnlParent, session)
          private$oper     = self$factory$getObject(self$codes$object$operation)
      }
      ,reload = function() {
          self$data$dfOpers = private$oper$getActive()
      }
      ,prepareTable = function(df) {
         if (nrow(df) == 0) return()
         include = c("camera", "base", "counter", "amount", "value", "price", "fee", "gas")
         exclude =  c("id", "parent", "priceIn", "priceOut", "alive", "rank")
         exclude = c(exclude, "acive", "status")
         exclude = c(exclude, "acive", "status")
         #df[exclude] = list(NULL)
         df = df[,include]
         types = list( imp = c("amount", "value","price")
           )
         data = list(df = df, cols=NULL, info=NULL)
         data$info=list( types=types) #event=ns("tablePos"), target=table,types=types)
         data
      }

            # ,cboCamerasFrom = function ()       { self$parent$cboCameras()  }
            # ,cboCamerasTo   = function (from)   { self$parent$cboCameras(exclude = from) }
            # ,cboCurrencies  = function (camera) {
            #     df = private$position$getCameraPosition(camera, available = TRUE)
            #     private$cameraIn = df
            #     WEB$getCTCLabels(as.vector(df$currency), invert = TRUE)
            # }
            # ,getAvailable = function (currency) {
            #     df = private$cameraIn[private$cameraIn$currency == currency,]
            #     self$available = ifelse (nrow(df) > 0, df[1,"available"], 0)
            #     self$available
            # }
            # ,getBalance = function (camera, currency) {
            #     df = private$position$getCameraPosition(camera)
            #     df = df[df$currency == currency,]
            #     self$balance = ifelse (nrow(df) > 0, df[1,"balance"], 0)
            #     self$balance
            # }
            # ,transfer = function (from, to, amount, currency) {
            #     tryCatch({
            #         private$oper$xfer(from=from, to=to, amount=amount, currency=currency)
            #         FALSE
            #     }, error = function(e) {
            #         TRUE
            #     })
            #
            # }
        )
        ,private = list(
             oper      = NULL
        )
   )
   moduleServer(id, function(input, output, session) {
      pnl = WEB$getPanel(id)
      if (is.null(pnl)) pnl = WEB$addPanel(PNLOperHist$new(id, pnlParent, session))
      flags = reactiveValues(
         refresh  = FALSE
      )

      observeEvent(flags$refresh, {
          data = pnl$prepareTable(pnl$data$dfOpers)
          output$tblHistory = updTable(data)
      })
#
#       initPage = function() {
#
#       }
#       validate = function() {
#           if (input$impAmount <= 0)
#               return (yataMsgError(ns2("msg"),WEB$MSG$get("MSG.AMOUNT.NEGATIVE")))
#
#           if (input$impAmount > pnl$available)
#               return (yataMsgError(ns2("msg"),WEB$MSG$get("MSG.AMOUNT.EXCESS")))
#           FALSE
#       }
#        updCombo("cboFrom",    choices=pnl$cboCamerasFrom())
#
#        observeEvent(input$cboFrom, {
#            yataMsgReset(ns2("msg"))
#            if (!pnl$inEvent) {
#                data = pnl$cboCurrencies(input$cboFrom)
#                updCombo("cboCurrency", choices=data)
#            }
#            updCombo("cboTo",      choices=pnl$cboCamerasTo(input$cboFrom))
#            pnl$inEvent = FALSE
#        }, ignoreInit = TRUE, ignoreNULL = TRUE)
#
#        observeEvent(input$cboTo, {
#           yataMsgReset(ns2("msg"))
#           output$lblTo = updLabelText(pnl$getBalance(input$cboTo, input$cboCurrency))
#        }, ignoreInit = TRUE, ignoreNULL = TRUE)
#
#        observeEvent(input$cboCurrency, {
#            yataMsgReset(ns2("msg"))
#            output$lblFrom = updLabelText(pnl$getAvailable(input$cboCurrency))
#        }, ignoreInit = TRUE, ignoreNULL = TRUE)
#
#        observeEvent(input$btnKO, {
#           output$msg = renderText({""})
#           updNumericInput("impAmount", value = 0)
#         })
#
#        observeEvent(input$btnOK, {
#            browser()
#           if (validate()) return()
#           res = pnl$transfer(input$cboFrom, input$cboTo, input$impAmount, input$cboCurrency)
#
#           if (res) {
#               yataMsgError(ns2("msg"), pnl$MSG$get("XFER.KO"))
#           } else {
#               yataMsgSuccess(ns2("msg"), pnl$MSG$get("XFER.OK"))
#               updNumericInput("impAmount", value = 0)
#               output$lblFrom = updLabelText(pnl$available - input$impAmount)
#               output$lblTo   = updLabelText(pnl$balance   + input$impAmount)
#           }
#       })

      if (!pnl$loaded) {
          pnl$loaded = TRUE
          pnl$reload()
#          initPage()
      }
  })
}

