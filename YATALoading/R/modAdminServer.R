modAdminServer <- function(id, full, pnlParent, session) {
ns = NS(id)
PNLAdmin = R6::R6Class("PNL.ADMIN"
  ,inherit    = WEBPanel
  ,cloneable  = FALSE
  ,lock_class = TRUE
  ,public = list(
      initialize     = function(id, pnlParent, session) {
         super$initialize(id, pnlParent, session)
      }
   )
  ,private = list(
   )
)

moduleServer(id, function(input, output, session) {
   pnl = WEB$root$getPanel(PNLAdmin, id, pnlParent, session)

   observeEvent(input$mnuAdmin, {
       act = yataActiveNS(input$mnuAdmin)
       module = paste0("modAdmin", str_to_title(act),"Server")
       eval(parse(text=paste0(module, "(act, input$mnuAdmin, pnlParent, session)")))
   })

})
}
