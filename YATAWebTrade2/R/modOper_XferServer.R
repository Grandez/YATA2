modOperXferServer = function(id, full, pnlParent, parent) {
ns = NS(id)
ns2 = NS(full)
PNLOperXfer = R6::R6Class("PNL.OPER.XFER"
  ,inherit    = WEBPanel
  ,cloneable  = FALSE
  ,portable   = TRUE
  ,lock_class = TRUE
  ,public = list(
      available  = 0
     ,balance    = 0
     ,initialize = function(id, pnlParent, session) {
         super$initialize(id, pnlParent, session)
         objs = self$codes$object
         private$objPos   = self$factory$getObject(objs$position)
         private$objCam   = self$factory$getObject(objs$cameras)
         private$oper     = self$factory$getObject(objs$operation)
         private$cameras  = private$objCam$getAllCameras()
      }
     ,loadPosition   = function ()       {
         private$position = private$objPos$getFullPosition()
      }
     ,cboCamerasFrom = function ()       {
         dfp = private$position[private$position$available > 0, ]
         WEB$combo$cameras(set=unique(dfp$camera))
      }
     ,cboCurrencies = function (fromcam) {
         df = private$position %>% filter(camera == fromcam & available > 0)
         WEB$combo$currencies(id=FALSE, set = df$currency)
      }
     ,getAvailable = function (fromcam, ctc) {
         df = private$position %>% filter(camera == fromcam & currency == ctc)
         df[1,"available"]
      }
     ,transfer = function (from, to, amount, currency) {
         tryCatch({
            private$oper$xfer(from=from, to=to, amount=amount, currency=currency)
            FALSE
         }, error = function(e) {
            TRUE
         })
     }
  )
  ,private = list(
      objPos   = NULL
     ,objCam   = NULL
     ,oper     = NULL
     ,position = NULL
     ,cameras  = NULL
  )
)

moduleServer(id, function(input, output, session) {
   pnl = WEB$getPanel(PNLOperXfer, id, pnlParent, session)
   pnl$loadPosition()

   validate = function() {
      if (input$impAmount <= 0)
          return (yataMsgError(ns2("msg"),WEB$MSG$get("MSG.AMOUNT.NEGATIVE")))
      if (input$impAmount > pnl$available)
          return (yataMsgError(ns2("msg"),WEB$MSG$get("MSG.AMOUNT.EXCESS")))
      FALSE
   }
   updCombo("cboFrom",    choices=pnl$cboCamerasFrom())

   observeEvent(input$cboFrom, {
      yataMsgReset(ns2("msg"))
      updCombo("cboTo", choices=WEB$combo$cameras(inactive=TRUE, exclude=input$cboFrom))
      updCombo("cboCurrency", choices=pnl$cboCurrencies(input$cboFrom))
   }, ignoreInit = TRUE, ignoreNULL = TRUE)

   observeEvent(input$cboCurrency, {
      yataMsgReset(ns2("msg"))
      output$lblFrom = updLabelText(pnl$getAvailable(input$cboFrom, input$cboCurrency))
   }, ignoreInit = TRUE, ignoreNULL = TRUE)

   observeEvent(input$btnKO, {
      output$msg = renderText({""})
      updNumericInput("impAmount", value = 0)
   })
   observeEvent(input$btnOK, {
      if (validate()) return()
      res = pnl$transfer(input$cboFrom, input$cboTo, input$impAmount, input$cboCurrency)

      if (res) {
          yataMsgError(ns2("msg"), pnl$MSG$get("XFER.KO"))
      } else {
          yataMsgSuccess(ns2("msg"), pnl$MSG$get("XFER.OK"))
          updNumericInput("impAmount", value = 0)
          output$lblFrom = updLabelText(pnl$available - input$impAmount)
          output$lblTo   = updLabelText(pnl$balance   + input$impAmount)
      }
   })
})
}

