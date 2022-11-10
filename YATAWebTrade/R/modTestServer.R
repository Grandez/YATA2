modTestServer <- function(id, parent, session) {
ns = NS(id)
PNLTest = R6::R6Class("YATA.TRADE.PNL.TEST"
  ,inherit    = JGGPanel
  ,cloneable  = FALSE
  ,lock_class = TRUE
  ,public = list(
      nada     = NULL
     ,wdgPos   = NULL
     ,initialize     = function(id, parent, session) {
         super$initialize(id, parent, session)
         private$createObjects()
     }
   )
  ,private = list(
      position   = NULL
     ,session    = NULL
     ,currencies = NULL
  )
)
moduleServer(id, function(input, output, session) {
      pnl = WEB$getPanel(id, PNLTest, parent, session)
#
#     flags = reactiveValues(
#         commarea  = FALSE
#     )
#
#    ###########################################################
#    ### Reactives
#    ###########################################################
#
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
#      output$lblGlobal = updLabel("Posicion global")
#      output$tblGlobal = pnl$wdgPos$render(df, type="long", global=TRUE)
# }

})
}
