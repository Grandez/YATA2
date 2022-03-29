# Panel Raiz
# Mantiene la informacion de la session y de la posicion
PNLTradeMain = R6::R6Class("PNL.TRADE.MAIN"
   ,inherit    = YATAPanel
   ,portable   = TRUE
   ,cloneable  = FALSE
   ,lock_class = TRUE

   ,public = list(
       position     = NULL
      ,operations   = NULL
      ,cameras      = NULL
      ,providers    = NULL
      ,initialize   = function(id, parent, session) {
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
      ,updateData  = function (init = FALSE) {
          df = self$position$getGlobalPosition()
          ids = WEB$getCTCID(df$currency)
          if (!is.null(ids)) {
              self$data$dfPosGlobal = dplyr::inner_join(data.frame(currency=names(ids), id=ids),df,by="currency")
          }
          invisible(self)
      }
      #########################################################
      ### Exported
      #########################################################
      ,getGlobalPosition = function(fiat=FALSE) {
         if (fiat) return (self$data$dfPosGlobal)
         df = self$data$dfPosGlobal
         df[df$id != 0,]
      }
      ,getOpenCurrencies = function() {
          error("NO SE QUE HACE ESTA FUNCION: SERVER getOpenCurrencies")
         # df = self$data$dfPosGlobal
         # df = df[!df$currency %in% private$fiats, c("currency", "id")]
         # labels = unlist(WEB$getCTCLabels(df$currency))
         # df$label = labels[df$currency]
         # df
      }
      # common commarea across panels
      ,getCommarea       = function(item=NULL, default=NULL)     {
          if (is.null(item)) return (private$commarea)
          val = private$commarea[[item]]
          if (is.null(val)) val = default
          val
       }
      ,setCommarea       = function(...) {
          items = list(...)
          if (is.list(items[[1]])) {
              private$commarea = items[[1]]
          } else {
             for (idx in 1:length(items)) {
                  private$commarea[[names(items)[idx]]] = items[[idx]]
             }
          }
          invisible(self)
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
      commarea     = list( # evitar nulos
        position = FALSE
     )
   )
)
function(input, output, session) {
   WEB$setSession(session)
   if (WEB$errorLevel > 0) {
       if (WEB$errorLevel == 99)
           return (yataErrGeneral(0, WEB$getMsg("ERR.REST.DOWN"),  input, output, session))
       return (yataErrGeneral(0, WEB$txtError, input, output, session))
   }
   pnl = WEB$getPanel("server")
   if (is.null(pnl)) pnl = WEB$addPanel(PNLTradeMain$new("server", NULL, session))

   js$request_cookies()
   observeEvent(input$cookies, {
       WEB$setWindow(input$cookies)
   })
   observeEvent(input$resize, {
       WEB$setWindow(input$resize)
   })

   closePanel = function() { shinyjs::hide("yata-main-err") }
   output$app_title = renderText({
      name = pnl$factory$getDBName()
      if (is.null(name)) name = "Sin conexion"
      paste("YATA", name, sep = "-")
   })
   observeEvent(input$mainMenu,{
      eval(parse(text=paste0( "mod"
                             ,str_to_title(input$mainMenu)
                             ,"Server(input$mainMenu
                             ,''
                             ,pnl, parent=session)")))
    })
   observeEvent(input$btnKO, { closePanel() })
   observeEvent(input$btnDBChanged, {
      oldDB = factory$getDBID()
      if (input$lstDB != oldDB) {
          factory$changeDB(input$lstDB)
          output$appTitle = updLabelText(factory$getDBName())
      }
      message(factory$getDBName())
      closePanel()
      eval(parse(text=paste0( "mod", YATABase$str$titleCase(input$mainMenu)
                             ,"Server(input$mainMenu, '', pnl, TRUE, parent=session)")))
   })
   observeEvent(input$connected,    {
              showNotification("Connected")
       browser()
       PUT("begin")
    })
   observeEvent(input$disconnected, {
              showNotification("Disconnected")
       PUT("end")   })
   observeEvent(input$initialized,  {
       showNotification("Initialized")
       browser()
       PUT("begin") })
   observeEvent(input$app_title,    {
      data = frmChangeDBInput()
      output$form = renderUI({data})
      output$lblDBCurrent    = updLabelText(factory$getDBName())
      shinyjs::show("yata-main-err")
   })
   onclick("appTitle"     , changeDB()  )
   onStop(function() {
      # cat("Shiny Session stopped\n")
      # pnl$factory$finalize()
      })
}
