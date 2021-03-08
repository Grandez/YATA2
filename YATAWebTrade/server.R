PNLTradeMain = R6::R6Class("PNL.TRADE.MAIN"
   ,inherit = YATAPanel
   ,cloneable  = FALSE
   ,lock_class = TRUE
   ,public = list(
       position     = NULL
      ,operations   = NULL
      ,cameras      = NULL
      ,providers    = NULL
      ,interval     = 5
      ,initialize    = function(id, parent, session) {
          super$initialize(id, parent, session)
          self$position   = YATAFactory$getObject(YATACodes$object$position)
          self$providers  = YATAFactory$getObject(YATACodes$object$providers)
          self$updateData(TRUE)
      }
      ,setInterval = function (interval) { self$interval = interval }
      ,updateData  = function (init = FALSE) {
          self$data$dfPosGlobal = self$position$getGlobalPosition()
          ctc = self$getCurrencies()
          if (init) self$data$lstLast = self$providers$getMonitors("EUR", ctc)
          else      self$data$lstLast = self$providers$getLatests ("EUR", ctc)

          data              = self$data$lstLast

          df0 = data.frame(tms=Sys.time())
          df1 = as.data.frame(lapply(data, function(x) x$last))
          df  = cbind(df0, df1)
          df$tms = as.ITime(df$tms)

          if (init) {
              self$data$dfSession = df
          } else {
              self$data$dfSession = rbind(self$data$dfSession, df)
          }
          invisible(self)
      }
      ,getGlobalPosition = function() { self$data$dfPosGlobal }
      ,getDFSession      = function() { self$data$dfSession   } 
      ,getLatestSession  = function() { self$data$lstLast     }
      ,getCurrencies = function() {
          df = self$data$dfPosGlobal
          df = df[df$currency != "EUR",]
          df = df[order(df$balance, decreasing=TRUE),]
          ctc = df$currency
          if (length(ctc) < 6 && !("BTC" %in% ctc)) ctc = c("BTC", ctc) 
          if (length(ctc) < 6 && !("ETH" %in% ctc)) ctc = c("ETH", ctc) 
          if (length(ctc) > 6) ctc = ctc[1:6]
          ctc
      }
   )
)
function(input, output, session) {
   pnl = YATAWEB$getPanel("tradeMain")
   if (is.null(pnl)) pnl = YATAWEB$addPanel(PNLTradeMain$new("tradeMain", NULL, session))

   changeDB= function() {
      data = frmChangeDBInput()
      output$form = renderUI({data})
      output$lblDBCurrent    = updLabelText(YATAFactory$getDBName())
      shinyjs::show("yata-main-err")
   }
   closePanel = function() { shinyjs::hide("yata-main-err") }
   output$appTitle <- renderText({ 
      name = YATAFactory$getDBName()
      if (is.null(name)) name = "Sin conexion"
      paste("YATA", name, sep = "-")
   })
   observeEvent(input$mainMenu,{
        eval(parse(text=paste0("mod", titleCase(input$mainMenu), "Server(input$mainMenu, '', pnl)")))
    })
   observeEvent(input$btnKO, { closePanel() })
   observeEvent(input$btnDBChanged, { 
      oldDB = YATAFactory$getDBID()
      if (input$lstDB != oldDB) {
          YATAFactory$changeDB(input$lstDB)
          output$appTitle = updLabelText(YATAFactory$getDBName())
      }
      message(YATAFactory$getDBName())
      closePanel()
      eval(parse(text=paste0("mod", titleCase(input$mainMenu), "Server(input$mainMenu, '', pnl, TRUE)")))
   })
   
   # En este observer, cargamos la posicion y las cotizaciones
    observe({
         #invalidateLater(pnl$interval * 60000)
        invalidateLater(60000)
#         message("Timer lanzado en server")
        pnl$updateData()
    })
   onclick("appTitle"     , changeDB()  )
   onStop(function() {
      cat("Session stopped\n")
      YATAFactory$finalize()
      })
}
