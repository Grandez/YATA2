# Panel Raiz
# Mantiene la informacion de la session y de la posicion
YATAWebRoot = R6::R6Class("PNL.TRADE.MAIN"
   ,inherit    = JGGWEBROOT
   ,portable   = TRUE
   ,cloneable  = FALSE
   ,lock_class = TRUE

   ,public = list(
       factory      = NULL
      ,position     = NULL
      ,operations   = NULL
#      ,cameras      = NULL
      ,providers    = NULL
      ,loaded       = FALSE
      ,initialize   = function(id, parent, session, dashboard) {
          super$initialize()
          self$factory = WEB$factory
          #self$factory =
          # self$position   = self$factory$getObject(self$codes$object$position)
          # self$providers  = self$factory$getObject(self$codes$object$providers)
          # self$updateData(TRUE)
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
              self$data$dfPosGlobal = dplyr::inner_join(data.frame(currency=names(ids), id=ids),df,by="currency")
          }
          invisible(self)
      }
      ,changeDB = function(id) {
          oldDB = self$factory$parms$getLastPortfolio()
          if (oldDB$id == id) return()
          self$factory$changePortfolio(id)
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

   if (WEB$errorLevel > 0) {
       msg = WEB$getMsg(as.character(WEB$errorLevel))
       yataErrGeneral(99, msg, NULL, input, output, session)
       return ()
   }


   pnl = WEB$getPanel(YATAWebRoot, "root", NULL, session)
   if (is.null(WEB$root)) WEB$root = pnl


   flags = reactiveValues(
         db = NULL
   )

   observeEvent(flags$df, {
      pnl$changeDB(input$radDB)
      pp = pnl$factory$getDBName()
      output$appTitle = updLabelText(pnl$factory$getDBName())
      eval(parse(text=paste0( "mod"
                             ,str_to_title(input$mainMenu)
                             ,"Server(input$mainMenu
                             ,''
                             ,pnl, parent=session)")))
      removeModal()

   }, ignoreInit = TRUE)

   if (pnl$factory$hasPortfolio()) {
       message("tiene portfolio")
   } else {
       showModal(frmChangeDB(pnl$factory))
   }
   observeEvent(input$cookies, {
       WEB$loadCookies(input$cookies)
   })
   observeEvent(input$mainMenu,{
      mod = paste0( "mod",str_to_title(input$mainMenu),"Server")
      eval(parse(text=paste0( mod, "(input$mainMenu, '', pnl, session)")))
   })
   observeEvent(input$connected,    {
       showNotification("Connected")
       #PUT("begin")
    })
   observeEvent(input$disconnected, {
      showNotification("Disconnected")
       #PUT("end")
    })
   observeEvent(input$initialized,  {
       showNotification("Initialized")
       #PUT("begin")
   })
   observeEvent(input$app_title,    {
       browser()
      showModal(frmPortfolioChange(pnl$factory))
   })
   observeEvent(input$dbOK,    {
       browser()
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
   # observeEvent(input$btnErrorSevere, {
   #     browser()
   # })
   #
   # closePanel = function() { shinyjs::hide("yata-main-err") }
   #
   # onStop(function() {
   #     #JGG Se lanza desde el navegador
   #
   #    # cat("Shiny Session stopped\n")
   #    # pnl$factory$finalize()
   #    })
   #
   if (!pnl$loaded) {

       pnl$loaded = TRUE
       pname = pnl$factory$portfolio$title
       name = ifelse (is.null(pname), "YATA", pname)
       output$appTitle = renderText({ name })
       if (is.null(pname)) showModal(frmChangeDB(pnl$factory))
   }
###   js$yata_req_cookies()
   cat("main end\n")
}
