# Panel Raiz
# Mantiene la informacion de la session y de la posicion
PNLModels = R6::R6Class("PNL.MODELS"
   ,inherit = YATAPanel
   ,cloneable  = FALSE
   ,lock_class = TRUE
   ,public = list(
       position     = NULL
      ,operations   = NULL
      ,cameras      = NULL
      ,providers    = NULL
      ,interval     = 15
      ,model        = NULL
      ,initialize    = function(id, parent, session) {
          super$initialize(id, parent, session)
         message("Creado root")
      }
     ,setData = function(df) {
        self$data$df = df
        invisible(self)
     }
     ,getData = function() {
        self$data$df
     }
     ,getModel = function() {
        self$data$model
     }
   )
   ,private = list(
      fiats = c("EUR", "USD")
     ,commarea     = list(
        position = FALSE
     )
   )
)
function(input, output, session) {
   YATAWEB$setSession(session)
   pnl = YATAWEB$getPanel("Models")
   if (is.null(pnl)) pnl = YATAWEB$addPanel(PNLModels$new("Models", NULL, session))

   observeEvent(input$mainMenu,{
        eval(parse(text=paste0("mod", titleCase(input$mainMenu), "Server(input$mainMenu, input$mainMenu, pnl, parent=session)")))
    })

   onStop(function() {
      cat("Shiny Session stopped\n")
      pnl$factory$finalize()
      })
   YATAWEB$end("Server")
}
