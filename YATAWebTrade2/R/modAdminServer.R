modAdminServer <- function(id, full, parent, session) {
ns = NS(id)
PNLAdmin = R6::R6Class("PNL.ADMIN"
  ,inherit    = WEBPanel
  ,cloneable  = FALSE
  ,lock_class = TRUE
  ,public = list(
      initialize     = function(id, parent, session) {
         super$initialize(id, parent, session)
      }
   )
  ,private = list(
   )
)

moduleServer(id, function(input, output, session) {
   pnl = WEB$root$getPanel(PNLAdmin, id, parent, session)

   observeEvent(input$mnuAdmin, {
       act = yataActiveNS(input$mnuAdmin)
       module = paste0("modAdmin", str_to_title(act),"Server")
       eval(parse(text=paste0(module, "(act, input$mnuAdmin, pnl, session)")))
   })

})
}
