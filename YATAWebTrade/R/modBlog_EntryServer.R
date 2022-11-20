modBlogEntryServer = function(id, parent, session) {
ns = NS(id)
PNLBlogEntry = R6::R6Class("PNL.BLOG.ENTRY"
  ,inherit    = JGGPanel
  ,cloneable  = FALSE
  ,portable   = TRUE
  ,lock_class = TRUE
  ,public = list(
      initialize    = function(id, parent, session) {
         super$initialize(id, parent, session)
         private$objBlog = self$factory$getObject("Blog")
         # private$objCam = self$factory$getObject("Cameras")
         # private$objOpe = self$factory$getObject("Operation")
         # private$dfPos  = private$objPos$getFullPosition()
         # private$dfCam  = private$objCam$getCameras()
      }
     ,add = function (data) { private$objBlog$add(data) }
     # ,cboCurrencies = function ()       {
     #     df = private$dfPos
     #     df = df[df$available > 0,]
     #     if (nrow(df) == 0) return()
     #
     #     ctc   = unique(df$currency)
     #     dfCTC = WEB$getCurrencyNames(ctc)
     #     if (nrow(dfCTC[dfCTC$id == YATACODE$CTCFIAT,]) == 0) {
     #         dfCTC = rbind(data.frame(id=YATACODE$CTCFIAT, symbol="FIAT", name="Euro"), dfCTC)
     #     }
     #     lst = as.list(dfCTC$id)
     #     names(lst) = dfCTC$name
     #     lst
     #  }
     # ,cboCameraFrom = function (ctc)       {
     #     dfc = data.frame(camera=YATACODE$CAMEXT, name=YATACODE$CAMEXT)
     #     df = private$dfPos
     #     df = df[df$currency == ctc & df$available > 0,]
     #     if (nrow(df) > 0) {
     #         cams = unique(df$camera)
     #         df = private$dfCam[private$dfCam$camera %in% cams,]
     #         dfc = rbind(dfc, df[,c("camera", "name")])
     #     }
     #     if (ctc != YATACODE$CTCFIAT) {
     #         dfc = dfc[-1,]                              # Quitar camara exterior
     #         #dfc = dfc[dfc$camera != YATACODE$CAMFIAT, ] # Quitar camara control
     #     }
     #     lst = as.list(dfc$camera)
     #     names(lst) = dfc$name
     #     lst
     #  }
     # ,cboCameraTo   = function (camera)       {
     #     if (camera == YATACODE$CAMEXT) {
     #         dfc = private$dfCam[private$dfCam$camera == YATACODE$CAMFIAT,]
     #         dfc = dfc[,c("camera", "name")]
     #     } else {
     #         dfc = private$dfCam[private$dfCam$active == 1,]
     #         dfc = dfc[dfc$camera != camera,]
     #         if (self$vars$currency != YATACODE$CTCFIAT)
     #             dfc = dfc[dfc$camera != YATACODE$CAMFIAT,]
     #     }
     #     lst = as.list(dfc$camera)
     #     names(lst) = dfc$name
     #     lst
     #  }
     # ,transfer      = function (data) {
     #     tryCatch({
     #        private$objOpe$xfer(data)
     #        NULL
     #     }, LOGICAL = function (cond) {
     #        cond$message
     #     }, error = function(cond) {
     #        cond$message
     #     })
     # }
  )
  ,private = list(
      objBlog  = NULL
     # ,objPos  = NULL
     # ,objOpe  = NULL
     # ,dfPos   = NULL
     # ,dfCam   = NULL
#     ,rest    = NULL
   )
)

moduleServer(id, function(input, output, session) {
   pnl = WEB$getPanel(id, PNLBlogEntry, parent, session)
   # validate = function() {
   #     if (is.null(input$cboTo)) {
   #         output$msg  = updLabelText(WEB$msg$get("MSG.NO.CAM.TO"))
   #         return (TRUE)
   #     }
   #    if (input$impAmount <= 0) {
   #         output$msg  = updLabelText(WEB$msg$get("MSG.AMOUNT.NEGATIVE"))
   #         return (TRUE)
   #    }
   #    if (input$impFeeOut < 0) {
   #         output$msg  = updLabelText(WEB$msg$get("MSG.AMOUNT.NEGATIVE"))
   #         return (TRUE)
   #     }
   #    if (input$impFeeIn < 0) {
   #         output$msg  = updLabelText(WEB$msg$get("MSG.AMOUNT.NEGATIVE"))
   #         return (TRUE)
   #     }
   #
   #    FALSE
   # }
   # updCombo("cboCurrency",    choices=pnl$cboCurrencies())
   observeEvent(input$txtNote, {
       output$mdNote = renderUI(HTML(markdown::markdownToHTML(text = input$txtNote)))
   }, ignoreInit = TRUE, ignoreNULL = TRUE)
   observeEvent(input$btnOK,       {
       browser()
      if (validate()) return()
      data = list( type=as.integer(input$cboType), title=trimws(input$txtTitle), data=input$txtNote)
      # Inserar el target
      # data$target =
      pnl$add(data)
   })

   # observeEvent(input$cboFrom,     {
   #    updCombo("cboTo",    choices=pnl$cboCameraTo(input$cboFrom))
   # }, ignoreInit = TRUE, ignoreNULL = TRUE)
   # observeEvent(input$btnKO,       {
   #    output$msg  = updLabelText("")
   #    updNumericInput("impAmount", value = 0)
   # })
}) # End Module Server
}  # End module

