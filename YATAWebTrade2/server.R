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
          ids = WEB$combo$getCurrenciesKey(id=FALSE, df$currency)
          if (length(ids) > 0) {
              browser()
              self$data$dfPosGlobal = dplyr::inner_join(data.frame(currency=names(ids), id=ids),df,by="currency")
          }
          invisible(self)
      }
      ,changeDB = function(id) {
          oldDB = self$factory$parms$lastOpen()
          if (oldDB$id == id) return()
          self$factory$changeDB(id)
          WEB$DBID = id
          invisible (self)
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
      ,setCommarea      = function(..., block=NULL) {
          data = list()
          items = list(...)
          if (is.list(items[[1]])) {
              data = items[[1]]
          } else {
             for (idx in 1:length(items)) data[[names(items)[idx]]] = items[[idx]]
          }
          if (is.null(block)) {
              private$commarea = list.merge(private$commarea, data)
          } else {
              private$commarea[[block]] = list.merge(private$commarea[[block]], data)
          }
          invisible(self)
      }
      ,getCommareaBlock       = function(block, item=NULL, default=NULL)     {
          if (is.null(item)) return (private$commarea[[block]])
          val = private$commarea[[item]]
          if (is.null(val)) val = default
          val
      }
      ,setCommareaBlock      = function(block, ...) {
          items = list(...)
          if (is.list(items[[1]])) items = items[[1]]
          if (is.null(block)) {
              private$commarea = list.merge(private$commarea, items)
          } else {
              if (is.null(private$commarea[[block]]))
                  private$commarea[[block]] = items
              else
                  private$commarea[[block]] = list.merge(private$commarea[[block]], items)
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
    cat("main beg\n")
   WEB$setSession(session)
   if (WEB$errorLevel > 0) {
       if (WEB$errorLevel == 99)
           return (yataErrGeneral(0, WEB$getMsg("ERR.REST.DOWN"),  NULL, input, output, session))
       return (yataErrGeneral(0, WEB$txtError, NULL, input, output, session))
   }
   pnl = WEB$getPanel("server")
   if (is.null(pnl)) pnl = WEB$addPanel(PNLTradeMain$new("server", NULL, session))

   observeEvent(input$cookies, {
       WEB$loadCookies(input$cookies)
#       WEB$setWindow(input$cookies)
   })
   # observeEvent(input$resize, {
   #     WEB$setWindow(input$resize)
   # })
   observeEvent(input$mainMenu,{
      eval(parse(text=paste0( "mod"
                             ,str_to_title(input$mainMenu)
                             ,"Server(input$mainMenu
                             ,''
                             ,pnl, parent=session)")))
    })
   observeEvent(input$connected,    {
       showNotification("Connected")
       browser()
       PUT("begin")
    })
   observeEvent(input$disconnected, {
       browser()
              showNotification("Disconnected")
       PUT("end")   })
   observeEvent(input$initialized,  {
       browser()
       showNotification("Initialized")
       browser()
       PUT("begin") })
   observeEvent(input$app_title,    {
      showModal(frmChangeDB(pnl$factory))
   })
   observeEvent(input$dbOK,    {
      pnl$changeDB(input$radDB)
      pp = pnl$factory$getDBName()
      output$appTitle = updLabelText(pnl$factory$getDBName())
      eval(parse(text=paste0( "mod"
                             ,str_to_title(input$mainMenu)
                             ,"Server(input$mainMenu
                             ,''
                             ,pnl, parent=session)")))
      removeModal()
   })
   observeEvent(input$btnErrorSevere, {
       browser()
   })

   closePanel = function() { shinyjs::hide("yata-main-err") }

   onStop(function() {
       #JGG Se lanza desde el navegador

      # cat("Shiny Session stopped\n")
      # pnl$factory$finalize()
      })

   if (!pnl$loaded) {

       pnl$loaded = TRUE
       pname = pnl$factory$getDBName()
       name = ifelse (is.null(pname), "YATA", pname)
       output$appTitle = renderText({ name })
       if (is.null(pname)) showModal(frmChangeDB(pnl$factory))
   }
#   js$yata_req_cookies()
   cat("main end\n")
}
