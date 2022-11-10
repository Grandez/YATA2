modPosServer <- function(id, parent, session) {
ns = NS(id)
PNLPos = R6::R6Class("YATA.TRADE.PNL.POS"
  ,inherit    = JGGPanel
  ,cloneable  = FALSE
  ,lock_class = TRUE
  ,public = list(
      wdgPos   = NULL
     ,initialize     = function(id, parent, session, ...) {
         super$initialize(id, parent, session)
         private$createObjects()
     }
     ,loadData = function() {
         private$loadPosition()
#         self$data$dfLast = private$session$getLatest()
     }
   )
  ,private = list(
      position = NULL
     ,session  = NULL
     # ,currencies = NULL
     ,createObjects = function() {
         private$position   = self$factory$getObject("Position")
         # private$currencies = self$factory$getObject(self$codes$object$currencies)
         private$session    = self$factory$getObject("Session")
         self$wdgPos     = WDGTablePosition$new(self$factory)
     }
    ,loadPosition = function () {
        df = private$position$getGlobalPosition()
        nm = private$session$getNames(df$currency)
        # id, symbol and name will be first
        df = dplyr::left_join(nm, df, by=c("id"="currency"))
        self$data$dfPos  = df[df$balance > 0,]
        self$wdgPos$set(self$data$dfPos)
         # df = future_promise(private$session$getNames(df$currency)) %...>%
         #                    (function (nm) {
         #                        df = dplyr::left_join(df, nm, by=c("currency"="id"))
         #                        self$data$dfPos  = df[df$balance > 0,]
         #                    })
         # browser()
    }

  )
)
moduleServer(id, function(input, output, session) {
   pnl = WEB$getPanel(id, PNLPos, parent, session=session) # , session)
#
#     flags = reactiveValues(
#         commarea  = FALSE
#     )
#
#    ###########################################################
#    ### Reactives
#    ###########################################################
#
     if (pnl$invalid()) {
         pnl$loadData()
     }
# if (!pnl$loaded || pnl$getCommarea(item="position")) {
#      pnl$loadData()
#      pnl$loaded = TRUE
#      pnl$setCommarea(position=FALSE)
#      df = pnl$data$dfPos
#
#      if (nrow(df) > 0) {
#          data = WEB$combo$currencies(id=FALSE, set=df$currency, invert=TRUE)
#          df$currency = data
#      }
#
      output$lblPosition = updLabelText("Posicion global")
      output$tblPosition = pnl$wdgPos$render(type="long", global=TRUE)
# }

})
}
