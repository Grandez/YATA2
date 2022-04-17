# Panel Raiz
# Mantiene la informacion de la session y de la posicion
APPWEB = R6::R6Class("PNL.TRADE.MAIN"
   ,inherit    = JGGWeb
   ,portable   = TRUE
   ,cloneable  = FALSE
   ,lock_class = TRUE
   ,public = list(
      #  position     = NULL
      # ,operations   = NULL
      # ,cameras      = NULL
      # ,providers    = NULL
       initialize   = function(session) {
          super$initialize(session)
          # self$position   = self$factory$getObject(self$codes$object$position)
          # self$providers  = self$factory$getObject(self$codes$object$providers)
          # self$updateData(TRUE)
      }
   )
   ,private = list(
      commarea     = list( # evitar nulos
        position = FALSE
     )
   )
)
function(input, output, session) {
    cat("main beg\n")
    if (!exists("WEB")) assign("WEB", WEBROOT$new(session), envir = .GlobalEnv)
    observeEvent(input$cookies, {
        WEB$loadCookies(input$cookies) })

   observeEvent(input$jgg,{
      id = str_to_title(input$jgg)
      eval(parse(text=paste0( "mod", id, "Server(input$jgg, WEB, parent=session)")))
    })


   cat("main end\n")
}
