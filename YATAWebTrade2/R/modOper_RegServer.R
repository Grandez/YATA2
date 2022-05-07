modOperRegServer = function(id, full, parent, session) {
   ns  = NS(id)
   ns2 = NS(full)
   PNLOperReg = R6::R6Class("PNL.OPER.REGULARIZE"
        ,inherit    = WEBPanel
        ,cloneable  = FALSE
        ,lock_class = TRUE
        ,public = list(
           initialize    = function(id, parent, session) {
               super$initialize(id, parent, session)
               private$position   = self$factory$getObject(self$codes$object$position)
               private$cameras    = self$factory$getObject(self$codes$object$cameras)
               private$operations = self$factory$getObject(self$codes$object$operation)
           }
           ,update = function(){
               private$dfPos = private$position$getGlobalPosition()
           }
           ,cboAllCameras   = function(exclude) {
              data = private$cameras$getAllCameras()
              if (!missing(exclude)) data = data[!data$camera %in% exclude,]
              data = data[,c("camera", "desc")]
              colnames(data) = c("id", "name")
              self$parent$makeCombo(data)
           }
           ,cboCurrencies = function() {
               df = private$dfPos
               df = df[df$available > 0, ]
               ctc = df$currency
               data = WEB$combo$currencies(id=FALSE, set = ctc)
               JGGTools::jgg_list_merge(list("FIAT"="__FIAT__"), data)
           }
          ,cboFrom = function(ctc) {
              df = private$position$getByCurrency(ctc)
              data = df$camera
              if (ctc == "__FIAT__") data = c("CASH", data)
              names(data) = data
              data
          }
          ,cboTo = function(camera, currency) {
              df = private$cameras$getAllCameras()
              df = df[df$camera != camera,]
              data = df$camera
              names(data) = paste(df$camera, df$desc, sep = " - ")
              if (currency == "__FIAT__") data = c("CASH" = "CASH", data)
              data
          }

          ,regularize = function(from, to, amount, currency) {
              private$operations$regularize(from, currency)
#              private$operations$xfer(from=from, to=to, amount=amount, currency=currency)
          }
        )
       ,private = list(
            cameras    = NULL
           ,operations = NULL
           ,position   = NULL
           ,dfPos      = NULL
        )
   )
moduleServer(id, function(input, output, session) {
   pnl = WEB$getPanel(PNLOperReg, id, pnlParent, session)
   pnl$update()
   updCombo("cboCurrency",    choices=pnl$cboCurrencies())

   validate = function() {
          if (input$impAmount <= 0)
              return (yataMsgError(ns2("msg"),pnl$MSG$get("ERR.NO.AMOUNT")))
          FALSE
       }
       reset = function() {
          updCombo("cboTo", selected="GRAL")
          updNumericInput("impAmount", value = 0)
       }

   observeEvent(input$cboCurrency, {
       updCombo("cboFrom", choices=pnl$cboFrom(input$cboCurrency))
   }, ignoreInit = TRUE, ignoreNULL = TRUE)
   observeEvent(input$cboFrom, {
       updCombo("cboTo",      choices=pnl$cboTo(input$cboFrom, input$cboCurrency))
   }, ignoreInit = TRUE, ignoreNULL = TRUE)
   observeEvent(input$btnKO, {
       output$msg = renderText({""})
       reset()
   })
   observeEvent(input$btnOK, {
      browser()
      if (validate()) return()
      res = pnl$regularize(input$cboFrom, input$cboTo,input$impAmount,input$cboCurrency)
          if (res == 0) {
              output$msg = updMessageKO(full, WEB$MSG$get("XFER.KO"))
          } else {
              yataMsgSuccess(ns2("operMsg"), pnl$MSG$get("XFER.OK"))
             reset()
          }
      })
  })
}

