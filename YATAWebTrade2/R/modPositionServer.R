modPosServer <- function(id, full, parent, session) {
ns = NS(id)
PNLPos = R6::R6Class("PNL.POS"
  ,inherit    = YATAPanel
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
         browser()
         self$data$dfPos  = private$position$getGlobalPosition(full = TRUE)
         self$data$dfLast = private$session$getLatest()
     }
   )
  ,private = list(
      position = NULL
     ,session  = NULL
     ,createObjects = function() {
         private$position = self$factory$getObject(self$codes$object$position)
         private$session  = self$factory$getObject(self$codes$object$session)
         self$wdgPos      = WDGTablePosition$new(self$factory)
   }

  )
)
moduleServer(id, function(input, output, session) {
    browser()
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
     browser()
     output$tblGlobal = pnl$wdgPos$render(pnl$data$dfPos)
}

})
}
