# Panel Raiz
# Mantiene la informacion de la session y de la posicion
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
         
          self$position   = self$factory$getObject(self$codes$object$position)
          self$providers  = self$factory$getObject(self$codes$object$providers)
          self$updateData(TRUE)
      }
      ,isRoot      = function() { TRUE }
      ,invalidate  = function(panel) {
         private$invalid = c(private$invalid, panel)
         invisible(self)
      } 
      ,isInvalid   = function(panel) {
         pos = which(private$invalid == panel)
         ifelse (length(pos) > 0, TRUE, FALSE)
      }
      ,reset       = function(panel) {
          pos = which(private$invalid == panel)
          if (length(pos) > 0) private$invalid = private$invalid[-pos]
          invisible(self)
      }
      ,setInterval = function (interval) { self$interval = interval }
      ,updateData  = function (init = FALSE) {
          df = self$position$getGlobalPosition()
          ids = YATAWEB$getCTCID(df$currency)
          if (!is.null(ids)) {
              self$data$dfPosGlobal = inner_join(data.frame(currency=names(ids), id=ids),df,by="currency")    
          }
          invisible(self)
      }
      #########################################################
      ### Exported 
      #########################################################
      ,getGlobalPosition = function(fiat=FALSE) { 
         if (fiat) return (self$data$dfPosGlobal)
         df = self$data$dfPosGlobal
         df[! df$currency %in% private$fiats,]
      }
      ,getOpenCurrencies = function() {
         df = self$data$dfPosGlobal
         df = df[!df$currency %in% private$fiats, c("currency", "id")]
         labels = unlist(YATAWEB$getCTCLabels(df$currency))
         df$label = labels[df$currency]
         df
      }
      ,getCommarea       = function()     { private$commarea      }
      ,setCommarea       = function(data) { 
          private$commarea = data  
          invisible(self)
      }
      ,setCommareaItem  = function(name, value) { private$commarea[[name]] = value }
      ,setCommareaItems = function(...)         { private$commarea = list.merge(private$commarea, list(...)) }
      ,getCommareaItem  = function(item, default=NULL) {
         val = private$commarea[[item]]
         if (is.null(val)) val = default
         val
      }
      
      ,getDFSession      = function() { self$data$dfSession   } 
      ,getLatestPrice    = function() { lapply(self$data$lstLast, function(x) x$price) }
      ,getSessionPrice   = function() { 
         df = self$data$dfSession
         if (is.null(df) || nrow(df) == 0) return(NULL)
         df = df[,c("symbol", "price","tms")]
         spread(df, symbol, price)
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
   YATAWEB$beg("Server")
   if (YATAWEB$inError) return (yataErrGeneral(0, YATAWEB$txtError, input, output, session))
   if (restCheck())     return (yataErrGeneral(0, YATAWEB$getMsg("ERR.REST.DOWN"),  input, output, session))

   YATAWEB$setSession(session)
   pnl = YATAWEB$getPanel("tradeMain")
   if (is.null(pnl)) pnl = YATAWEB$addPanel(PNLTradeMain$new("tradeMain", NULL, session))
   factory = pnl$factory
   changeDB= function() {
      data = frmChangeDBInput()
      output$form = renderUI({data})
      output$lblDBCurrent    = updLabelText(self$factory$getDBName())
      shinyjs::show("yata-main-err")
   }
   closePanel = function() { shinyjs::hide("yata-main-err") }
   output$appTitle <- renderText({ 
      name = factory$getDBName()
      if (is.null(name)) name = "Sin conexion"
      paste("YATA", name, sep = "-")
   })
   # Vamos a usar req para evitar cargar todo
   # "test"
   observeEvent(input$mainMenu,{
        eval(parse(text=paste0("mod", titleCase(input$mainMenu), "Server(input$mainMenu, '', pnl, parent=session)")))
    })
   observeEvent(input$btnKO, { closePanel() })
   observeEvent(input$btnDBChanged, { 
      oldDB = factory$getDBID()
      if (input$lstDB != oldDB) {
          factory$changeDB(input$lstDB)
          output$appTitle = updLabelText(self$factory$getDBName())
      }
      message(factory$getDBName())
      closePanel()
      eval(parse(text=paste0("mod", titleCase(input$mainMenu), "Server(input$mainMenu, '', pnl, TRUE, parent=session)")))
   })
   
   # En este observer, cargamos la posicion y las cotizaciones
    observe({
       message("SERVER Update")
#       pnl$updateData()
       PUT("update")
       invalidateLater(pnl$interval * 60000)       
    })
   onclick("appTitle"     , changeDB()  )
   onStop(function() {
      cat("Shiny Session stopped\n")
      pnl$factory$finalize()
      })
   YATAWEB$end("Server")
}
