# Cada modulo lleva asociado un objeto
# es el que gestiona la creacion del objeto y guarda sus variables

modAdminPortfolioServer <- function(id, full, pnlParent, parent=NULL) {
   ns = NS(id)
   PNLAdmin = R6::R6Class("PNL.ADMIN"
      ,inherit = YATAPanel
      ,cloneable  = FALSE
      ,lock_class = TRUE
      ,public = list(
          initialize    = function(id, pnlParent, session) {
             super$initialize(id, pnlParent, session)
             private$definition$id = id
          }
      )
      ,private = list(
         definition = list(id = "",left = 0, right=0)
      )

   )
    moduleServer(id, function(input, output, session) {
       message("Ejecutando server para Admin")
      pnl = WEB$getPanel(id)
      if (is.null(pnl)) pnl = WEB$addPanel(PNLAdmin$new(id, pnlParent, session))

  })
}
