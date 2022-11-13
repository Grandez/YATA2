modOperXferServer = function(id, parent, session) {
ns = NS(id)
#ns2 = NS(full)
PNLOperXfer = R6::R6Class("PNL.OPER.XFER"
  ,inherit    = JGGPanel
  ,cloneable  = FALSE
  ,portable   = TRUE
  ,lock_class = TRUE
  ,public = list(
           initialize    = function(id, parent, session) {
               super$initialize(id, parent, session)
          #      private$position   = self$factory$getObject(self$codes$object$position)
          #      private$cameras    = self$factory$getObject(self$codes$object$cameras)
          #      private$operations = self$factory$getObject(self$codes$object$operation)
             }
          #  ,update = function(){
          #      private$dfPos = private$position$getGlobalPosition()
          #  }
          #  ,cboAllCameras   = function(exclude) {
          #     data = private$cameras$getAllCameras()
          #     if (!missing(exclude)) data = data[!data$camera %in% exclude,]
          #     data = data[,c("camera", "desc")]
          #     colnames(data) = c("id", "name")
          #     self$parent$makeCombo(data)
          #  }
          #  ,cboCurrencies = function() {
          #      df = private$dfPos
          #      df = df[df$available > 0, ]
          #      ctc = df$currency
          #      data = WEB$combo$currencies(id=FALSE, set = ctc)
          #      JGGTools::jgg_list_merge(list("FIAT"="__FIAT__"), data)
          #  }
          # ,cboFrom = function(ctc) {
          #     df = private$position$getByCurrency(ctc)
          #     data = df$camera
          #     if (ctc == "__FIAT__") data = c("CASH", data)
          #     names(data) = data
          #     data
          # }
          # ,cboTo = function(camera, currency) {
          #     df = private$cameras$getAllCameras()
          #     df = df[df$camera != camera,]
          #     data = df$camera
          #     names(data) = paste(df$camera, df$desc, sep = " - ")
          #     if (currency == "__FIAT__") data = c("CASH" = "CASH", data)
          #     data
          # }
  )
       ,private = list(
           #  cameras    = NULL
           # ,operations = NULL
           # ,position   = NULL
           # ,dfPos      = NULL
        )

  # ,public = list(
  #     available  = 0
  #    ,balance    = 0
  #    ,initialize = function(id, pnlParent, session) {
  #        super$initialize(id, pnlParent, session)
  #        objs = self$codes$object
  #        private$objPos   = self$factory$getObject(objs$position)
  #        private$objCam   = self$factory$getObject(objs$cameras)
  #        private$oper     = self$factory$getObject(objs$operation)
  #        private$cameras  = private$objCam$getAllCameras()
  #     }
  #    ,loadPosition   = function ()       {
  #        private$position = private$objPos$getFullPosition()
  #     }
  #    ,cboCamerasFrom = function ()       {
  #        dfp = private$position[private$position$available > 0, ]
  #        WEB$combo$cameras(set=unique(dfp$camera))
  #     }
  #    ,cboCurrencies = function (fromcam) {
  #        df = private$position %>% filter(camera == fromcam & available > 0)
  #        WEB$combo$currencies(id=FALSE, set = df$currency)
  #     }
  #    ,getAvailable = function (fromcam, ctc) {
  #        df = private$position %>% filter(camera == fromcam & currency == ctc)
  #        df[1,"available"]
  #     }
  #    ,transfer = function (from, to, amount, currency) {
  #        tryCatch({
  #           private$oper$xfer(from=from, to=to, amount=amount, currency=currency)
  #           FALSE
  #        }, error = function(e) {
  #           TRUE
  #        })
  #    }
  # )
  # ,private = list(
  #     objPos   = NULL
  #    ,objCam   = NULL
  #    ,oper     = NULL
  #    ,position = NULL
  #    ,cameras  = NULL
  # )
)

moduleServer(id, function(input, output, session) {
    browser()
   pnl = WEB$getPanel(id, PNLOperXfer, parent, session)

   # pnl$update()
   # updCombo("cboCurrency",    choices=pnl$cboCurrencies())
   #
   # observeEvent(input$cboCurrency, {
   #     updCombo("cboFrom", choices=pnl$cboFrom(input$cboCurrency))
   # }, ignoreInit = TRUE, ignoreNULL = TRUE)
   # observeEvent(input$cboFrom, {
   #     updCombo("cboTo",      choices=pnl$cboTo(input$cboFrom, input$cboCurrency))
   # }, ignoreInit = TRUE, ignoreNULL = TRUE)
   # observeEvent(input$btnKO, {
   #     output$msg = renderText({""})
   #     reset()
   # })
   # #
   # #
   # # validate = function() {
   # #    if (input$impAmount <= 0)
   # #        return (yataMsgError(ns2("msg"),WEB$MSG$get("MSG.AMOUNT.NEGATIVE")))
   # #    if (input$impAmount > pnl$available)
   # #        return (yataMsgError(ns2("msg"),WEB$MSG$get("MSG.AMOUNT.EXCESS")))
   # #    FALSE
   # # }
   # # updCombo("cboFrom",    choices=pnl$cboCamerasFrom())
   # #
   # # observeEvent(input$cboFrom, {
   # #    yataMsgReset(ns2("msg"))
   # #    updCombo("cboTo", choices=WEB$combo$cameras(inactive=TRUE, exclude=input$cboFrom))
   # #    updCombo("cboCurrency", choices=pnl$cboCurrencies(input$cboFrom))
   # # }, ignoreInit = TRUE, ignoreNULL = TRUE)
   # #
   # # observeEvent(input$cboCurrency, {
   # #    yataMsgReset(ns2("msg"))
   # #    output$lblFrom = updLabelText(pnl$getAvailable(input$cboFrom, input$cboCurrency))
   # # }, ignoreInit = TRUE, ignoreNULL = TRUE)
   # #
   # # observeEvent(input$btnKO, {
   # #    output$msg = renderText({""})
   # #    updNumericInput("impAmount", value = 0)
   # # })
   observeEvent(input$btnOK, {
      if (validate()) return()
      tryCatch({
          pnl$transfer(input$cboFrom, input$cboTo, input$impAmount, input$cboCurrency)
          yataMsgSuccess(ns2("msg"), pnl$MSG$get("XFER.OK"))
          updNumericInput("impAmount", value = 0)
          output$lblFrom = updLabelText(pnl$available - input$impAmount)
          output$lblTo   = updLabelText(pnl$balance   + input$impAmount)
      }, LOGICAL = function (cond) {
          yataMsgError(ns2("msg"), pnl$MSG$get("XFER.KO"))
      })
   })
})
}

