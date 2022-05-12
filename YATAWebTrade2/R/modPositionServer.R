modPosServer <- function(id, full, parent, session) {
ns = NS(id)
PNLPos = R6::R6Class("PNL.WEB.POS"
  ,inherit    = WEBPanel
  ,cloneable  = FALSE
  ,lock_class = TRUE
  ,public = list(
      nada     = NULL
     ,wdgPos   = NULL
     ,initialize     = function(id, parent, session) {
         super$initialize(id, parent, session)
         private$createObjects()
     }
     ,loadData = function() {
         df = private$position$getGlobalPosition()
         self$data$dfPos  = df[df$balance > 0,]
         self$data$dfLast = private$session$getLatest()
     }
   )
  ,private = list(
      position   = NULL
     ,session    = NULL
     ,currencies = NULL
     ,createObjects = function() {
         private$position   = self$factory$getObject(self$codes$object$position)
         private$currencies = self$factory$getObject(self$codes$object$currencies)
         private$session    = self$factory$getObject(self$codes$object$session)
         self$wdgPos        = WDGTablePosition$new(id="position", self$factory)
   }

  )
)
moduleServer(id, function(input, output, session) {
    pnl = WEB$getPanel(PNLPos, id, parent, session)

    flags = reactiveValues(
        commarea  = FALSE
    )

   ###########################################################
   ### Reactives
   ###########################################################

if (!pnl$loaded || pnl$getCommarea(item="position")) {
     pnl$loadData()
     pnl$loaded = TRUE
     pnl$setCommarea(position=FALSE)
     df = pnl$data$dfPos

     if (nrow(df) > 0) {
         data = WEB$combo$currencies(id=FALSE, set=df$currency, invert=TRUE)
         df$currency = data
     }

     output$lblGlobal = updLabel("Posicion global")
     output$tblGlobal = pnl$wdgPos$render(df, type="long", global=TRUE)
}

})
}
