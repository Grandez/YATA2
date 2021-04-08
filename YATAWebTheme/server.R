PNLTradeMain = R6::R6Class("PNL.TRADE.MAIN"
   ,inherit = YATAPanel
   ,cloneable  = FALSE
   ,lock_class = TRUE
   ,public = list(
       position     = NULL
      ,operations   = NULL
      ,cameras      = NULL
      ,providers    = NULL
      ,interval     = 15
      ,initialize    = function(id, parent, session) {
          super$initialize(id, parent, session)
      }
      ,root        = function() { TRUE }
   )
)

function(input, output, session) {
   pnl = YATAWEB$getPanel("tradeMain")
   if (is.null(pnl)) pnl = YATAWEB$addPanel(PNLTradeMain$new("tradeMain", NULL, session))

#    window_height <- JS('window.innerHeight')
# window_width <- JS('window.innerWidth')
   output$appTitle <- renderText({ 
      name = YATAFactory$getDBName()
      if (is.null(name)) name = "Sin conexion"
      paste("YATA", name, sep = "-")
   })
   observeEvent(input$mainMenu,{
        eval(parse(text=paste0("mod", titleCase(input$mainMenu), "Server(input$mainMenu, '', pnl)")))
    })
}
