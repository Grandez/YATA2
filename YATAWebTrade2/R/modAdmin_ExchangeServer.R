modAdminExchServer = function(id, full, parent, session) {
   ns  = NS(id)
   ns2 = NS(full)
   PNLAdmExch = R6::R6Class("PNL.ADMIN.EXCHANGE"
        ,inherit    = WEBPanel
        ,cloneable  = FALSE
        ,lock_class = TRUE
        ,public = list(
            cameras   = NULL
           ,exchanges = NULL
           ,initialize    = function(id, parent, session) {
               super$initialize(id, parent, session)
               objExch    = self$factory$getObject(self$factory$codes$object$exchanges)
               self$exchanges     = objExch$getExchanges()
               private$objCameras = self$factory$getObject(self$factory$codes$object$cameras)
               self$update()
           }
          ,update = function() {
               self$cameras   = private$objCameras$getAllCameras()
          }
          ,comboExchanges = function() {
              df = self$exchanges[!(self$exchanges$id %in% self$cameras$exchange),]
              df = df[,c("id", "symbol", "name")]
              df$name = paste(df$symbol, df$name, sep=" - ")
              setorderv(df, "name", 1)
              data = as.list(df$id)
              names(data) = df$name
              data
          }
         ,addCamera = function(id) {
             browser()
            df = as.list(self$exchanges[self$exchanges$id == id,])
            data = list(camera = df$symbol, desc = df$name, exchange=id, active = 1)
            private$objCameras$add(data)
            self$update()
         }
        )
       ,private = list(
           objCameras = NULL
        )
   )


moduleServer(id, function(input, output, session) {
   pnl = WEB$root$getPanel(PNLAdmExch, id, parent, session)

   refresh = function() {
      updListbox("lstExchanges", choices=pnl$comboExchanges())
      output$tbl_cameras = renderReactable({ reactable(pnl$cameras) })
   }

   observeEvent(input$btn_add, {
       pnl$addCamera(as.integer(input$lstExchanges))
       refresh()
   })
   if (!pnl$loaded) {
       refresh()
       pnl$loaded = TRUE
   }

})
}

