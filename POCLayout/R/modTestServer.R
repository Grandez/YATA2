# Cada modulo lleva asociado un objeto
# es el que gestiona la creacion del objeto y guarda sus variables
modTestServer <- function(id, full, parent, session) {
ns = NS(id)
PNLTest = R6::R6Class("PNL.OPER"
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
    cat("entra en test server\n")
    pnl = WEB$getPanel(PNLTest, id, NULL, session)
    cat("sale test server\n")
})
}
