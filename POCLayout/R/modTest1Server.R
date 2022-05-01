# Cada modulo lleva asociado un objeto
# es el que gestiona la creacion del objeto y guarda sus variables

modTest1Server <- function(id, full, parent, session) {
ns = NS(id)
ns = NS(id)
PNLTest1 = R6::R6Class("PNL.OPER"
  ,inherit = WEBPanel
  ,cloneable  = FALSE
  ,lock_class = TRUE
  ,public = list(
      position    = NULL
     ,initialize    = function(id, parent, session, dashboard=FALSE) {
         super$initialize(id, parent, session, dashboard)
      }
 )
 ,private = list()
)

moduleServer(id, function(input, output, session) {
    cat("entra en test1 server")
pnl = WEB$getPanel(PNLTest1, id, NULL, session)
})
}
