modOperRegServer = function(id, full, pnlParent, parent) {
   ns  = NS(id)
   ns2 = NS(full)
   PNLOperReg = R6::R6Class("PNL.OPER.REGULARIZE"
        ,inherit    = WEBPanel
        ,cloneable  = FALSE
        ,lock_class = TRUE
        ,public = list(
           initialize    = function(id, pnlParent, session) {
               super$initialize(id, pnlParent, session)
               private$cameras    = self$factory$getObject(self$codes$object$cameras)
               private$operations = self$factory$getObject(self$codes$object$operation)
           }
           ,cboAllCameras   = function(exclude) {
              data = private$cameras$getAllCameras()
              if (!missing(exclude)) data = data[!data$camera %in% exclude,]
              data = data[,c("camera", "desc")]
              colnames(data) = c("id", "name")
              self$parent$makeCombo(data)
           }
           ,cboCurrency = function(camera, available) {
               self$parent$cboCurrency(camera, available)
           }
          ,regularize = function(from, to, amount, currency) {
              private$operations$regularize(from, currency)
#              private$operations$xfer(from=from, to=to, amount=amount, currency=currency)
          }
        )
       ,private = list(
            cameras    = NULL
           ,operations = NULL
        )
   )
   moduleServer(id, function(input, output, session) {
        pnl = WEB$getPanel(id)
        if (is.null(pnl)) pnl = WEB$addPanel(PNLOperReg$new(id, pnlParent, session))

       validate = function() {
          if (input$impAmount <= 0)
              return (yataMsgError(ns2("msg"),pnl$MSG$get("ERR.NO.AMOUNT")))
          FALSE
       }
       reset = function() {
          updCombo("cboTo", selected="GRAL")
          updNumericInput("impAmount", value = 0)
       }
       updCombo("cboFrom",    choices=pnl$cboAllCameras(exclude=pnl$factory$camera))

       observeEvent(input$cboFrom, {
           updCombo("cboTo",      choices=pnl$cboAllCameras(exclude=c(input$cboFrom)))
           updCombo("cboCurrency", choices=pnl$cboCurrency(input$cboFrom, available=TRUE))
       }, ignoreInit = TRUE)
       observeEvent(input$btnKO, {
          output$msg = renderText({""}); reset() })
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

