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
      ,root        = function() { TRUE }
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
          self$data$dfPosGlobal = inner_join(data.frame(currency=names(ids), id=ids),df,by="currency")
          
          # df = self$providers$getLatests ("EUR", ctc)
          # self$data$lstLast = list()
          # if (nrow(df) > 0) {
          #     for (row in 1:nrow(df)) {
          #         self$data$lstLast[[df[row,"symbol"]]] = as.list(df[row,])
          #     }
          # }
          # 
          # if (init) {
          #     self$data$dfSession = df
          # } else {
          #     self$data$dfSession = rbind(self$data$dfSession, df)
          # }
          invisible(self)
      }
      ,getGlobalPosition = function() { self$data$dfPosGlobal }
      ,getDFSession      = function() { self$data$dfSession   } 
#      #,getLatestSession  = function() { self$data$lstLast     }
      ,getLatestPrice    = function() { lapply(self$data$lstLast, function(x) x$price) }
      ,getSessionPrice   = function() { 
         df = self$data$dfSession
         if (is.null(df) || nrow(df) == 0) return(NULL)
         df = df[,c("symbol", "price","tms")]
         spread(df, symbol, price)
       }
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
        eval(parse(text=paste0("mod", titleCase(input$mainMenu), "Server(input$mainMenu, '', pnl)")))
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
      eval(parse(text=paste0("mod", titleCase(input$mainMenu), "Server(input$mainMenu, '', pnl, TRUE)")))
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
