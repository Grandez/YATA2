modModelServer <- function(id, full, pnlParent, parent=NULL) {
   ns = NS(id)
   PNLModel = R6::R6Class("PNL.MODEL.MODEL"
      ,inherit = YATAPanel
      ,cloneable  = FALSE
      ,lock_class = TRUE
      ,public = list(
          initialize    = function(session) {
             super$initialize(id, pnlParent, session, ns)
          }
    )
   )
    moduleServer(id, function(input, output, session) {
       pnl = YATAWEB$getPanel(id)
       if (is.null(pnl)) pnl = YATAWEB$addPanel(PNLModel$new(session))

   })
}
