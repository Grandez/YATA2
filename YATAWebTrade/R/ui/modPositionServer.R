# Cada modulo lleva asociado un objeto
# es el que gestiona la creacion del objeto y guarda sus variables

modPosServer <- function(id, full, pnlParent, invalidate=FALSE) {
   ns = NS(id)
   PNLPos = R6::R6Class("PNL.OPER"
      ,inherit = YATAPanel
      ,cloneable  = FALSE
      ,lock_class = TRUE
      ,public = list(
          position     = NULL
         ,operations   = NULL
         ,cameras      = NULL
         ,providers    = NULL
         ,session     = NULL
         ,interval     = 5
         ,fiats = c("EUR", "USD", "USDC", "USDT")
         ,plots = c( "Session day"          = "plotDay"
                    ,"Session day (var)"    = "plotDayVar"
                    ,"Session Online"       = "plotTicker"
                    ,"Session Online (Var)" = "plotTickerVar"
                    ,"Best Info"            = "plotBest" 
                    #,"Barras"         ="plotBar")
         )
         ,initialize    = function(id, pnlParent, session) {
             super$initialize(id, pnlParent, session)
             self$position    = self$factory$getObject(self$codes$object$position)
             self$cameras     = self$factory$getObject(self$codes$object$cameras)
             self$providers   = self$factory$getObject(self$codes$object$providers)
             self$operations  = self$factory$getObject(self$codes$object$operation)
             self$session    = self$factory$getObject(self$codes$object$session)
             private$monitors = HashMap$new()
             
             self$vars$plotLeftChanged  = TRUE
             self$vars$plotRightChanged = TRUE
             self$vars$inEvent          = FALSE
             self$vars$inForm           = FALSE
             self$vars$plotShow = list()
             private$applyCookies(session)
         }
         ,setPlotVisible = function(left, right) {
             self$vars$plotShow = list(left, right)
         }
         ,isPlotVisible = function(plotName) {
             sum((self$vars$plotShow == plotName)) > 0
         }
         ,getDFPlot         = function(type) {
             root = self$getRoot()
             if (type == "plotBest")      return (self$getDFHist())
             if (type == "plotTickerVar") return (root$getSessionPrice())
             if (type == "plotTicker")    return (root$getSessionPrice())
             if (type == "plotDay" || type == "plotDayVar")       {
                 counters = self$data$mapSessionDay$keys()
                 if (length(counters) == 0) return (NULL)
                 df = self$data$mapSessionDay$get(counters[1])
                 df = df[, c("tms", "close")]
                 colnames(df) = c("tms", counters[1])
                 idx = 2
                 while (idx <= length(counters)) {
                     df2 = self$data$mapSessionDay$get(counters[idx])
                     df2 = df2[, c("tms", "close")]
                     colnames(df2) = c("tms", counters[idx])
                     df = full_join(df, df2, by="tms")
                     idx = idx + 1
                 }
                 return (df)
             }
           #  stop("TIPO DE PLOT NO IMPLEMENTADO")
         }
         ,getGlobalPosition = function() { self$getRoot()$getGlobalPosition() }
         ,getCurrencies     = function() { self$getRoot()$getCurrencies()     }
         ,getLatestSession  = function() { self$getRoot()$getLatestSession()  }
        
         ,getDFSession   = function() { self$data$dfSession      }
         ,getDFHist      = function() { 
              if (is.null(self$data$dfHist)) return (NULL)
              self$data$dfHist      
          } 
         ,loadSessionDay = function() {
             self$data$mapSessionDay = HashMap$new()
             df = self$getGlobalPosition()
             df = df[df$currency != "EUR",]
             df$since = df$since - as.difftime(7, unit="days")
             to = as.numeric(Sys.time())
             idx = 1
             while (idx <= nrow(df)) {
                 counter = df[idx, "currency"]
                 from    = as.numeric(df[idx, "since"])
                 data    = self$session$getSession("EUR", counter, from, to)
                 self$data$mapSessionDay$put(counter, data)
                 idx = idx + 1
             }
         }
        ,setInterval = function() {
            self$interval = self$parms$getOnlineInterval()
            self$getRoot()$setInterval(self$interval)
        }
         ,getMonitor  = function(name) {
             if (missing(name)) return (private$monitors)
             monitorDef = list(
                 name    = ""
                ,last    = 0
                ,session = 0
                ,day     = 0
                ,week    = 0
                ,price   = 0
             )
             if (is.null(private$monitors$get(name))) {
                 monitorDef$name = name
                 private$monitors$put(name, monitorDef)
             }
             private$monitors$get(name)                 
         }
         ,setMonitor = function(name, monitor) {
             private$monitors$put(name, monitor)                 
         }
      )
     ,private = list(
          opIdx        = list()
         ,selected     = NULL
         ,lastMonitors = NULL
         ,monitors     = NULL 
         ,applyCookies = function(session) {
             cookies = self$vars$cookies
             self$vars$loading = TRUE
             if (!is.null(cookies$best)) {
                 updIntegerInput("numBestTop", cookies$best$top)
                 updCombo("cboBestFrom", selected=cookies$best$interval)
             }
             self$vars$loading = FALSE
         }
       )
    )
    moduleServer(id, function(input, output, session) {
       pnl = YATAWEB$getPanel(id)
       if (is.null(pnl) || invalidate) pnl = YATAWEB$addPanel(PNLPos$new(id, pnlParent, session))
       loadPanel = function() {
          pnl$setInterval()
          updNumericInput("numInterval", pnl$vars$interval)
          loadPosition()
          initMonitors()
          pnl$loadSessionDay()
#          if (!is.null(pnl$lastMonitors)) initMonitor()
          output$dtLast = updLabelDate({Sys.time()})
          updCombo("cboPlotLeft",  choices=pnl$plots, selected=pnl$plots[1])
          updCombo("cboPlotRight", choices=pnl$plots, selected=pnl$plots[3])
          pnl$loaded = TRUE
       }
       
       loadPosition = function() {
          output$tblPosGlobal  = updTablePosition(pnl$getGlobalPosition())
          cameras = pnl$position$getCameras()
          divs = lapply(cameras, function(camera) loadCameraUI(camera))
          insertUI(selector = "#divPosLast", where = "beforeBegin", ui=tagList(divs), immediate=TRUE)
          dfs = lapply(cameras, function(camera) {
                                 sfx = titleCase(camera)
                                 df  = preparePosition(pnl$position$getCameraPosition(camera))
                                 tbl = paste0("tblPos", sfx) 
                                 eval(parse(text=paste0( "output$tblPos", sfx
                                                        ," = updTablePosition(id=ns('"
                                                        ,paste0("pos", sfx), "'),   df)")))
                      })
    #      insertMonitors(pnl$getMonitors())
           pnl$valid = TRUE
       }
       initMonitors = function() {
          ctc = pnl$getCurrencies()
          lapply(ctc, function(item) pnl$getMonitor(item))

          idDiv = paste0("#", ns("monitor"))
          lapply(ctc, function(x) insertUI( selector = idDiv, immediate=TRUE
                                           ,where = "beforeEnd"
                                           ,ui=tagList(yuiYataMonitor(ns(paste0("monitor-",x))))))
          monitors = pnl$getMonitor()
          data     = pnl$getLatestSession()
          df       = pnl$getGlobalPosition()

          for (ctc in monitors$keys()) {
               monitor         = monitors$get(ctc)
               monitor$last    = data[[ctc]]$price
               monitor$session = data[[ctc]]$price
               monitor$hour    = data[[ctc]]$var01
               monitor$day     = data[[ctc]]$var24
               monitor$week    = data[[ctc]]$var07
               monitor$price   = 0
               if (nrow(df) > 0 && nrow(df[df$currency == ctc,]) > 0) {
                  monitor$price = df[df$currency == ctc, "price"]
               }
               pnl$setMonitor(ctc, monitor)
               updYataMonitor(ns(paste0("monitor-",ctc)), monitor) # No poner last
          }
       } 
       loadCameraUI = function(camera) {
          suffix = titleCase(camera)
          camera = pnl$cameras$getCameraName(camera)
          nstable = paste0("tblPos", suffix)
          tags$div(id=paste0("divPos", suffix), yuiBox(ns(nstable), paste("Posicion", camera)
                                                                   , yuiDataTable(ns(nstable))))
       }
       plots = function(type, info) {
           if (!missing(type)) {
               if (input$cboPlotLeft  == type) output$plotLeft  = updPlot({makePlot(type, "plotLeft", info)})
               if (input$cboPlotRight == type) output$plotRight = updPlot({makePlot(type, "plotRight", info)})
               return()
           } 
           if (input$cboPlotLeft != "") {
               output$plotLeft = updPlot({makePlot(input$cboPlotLeft, "plotLeft", info)})
           }
           if (input$cboPlotRight != "") {
               output$plotRight = updPlot({makePlot(input$cboPlotRight, "plotRight", info)})
           }
       }
       makePlot = function(idPlot, uiplot, info) {
           if (missing(info)) info = list(id=ns("plotBar"), ui=uiplot, plot=idPlot)
           title = names(which(pnl$plots == idPlot))
           if (idPlot == "plotBest") {
               df  = pnl$data$dfBest
               row = pnl$vars$best
               title = paste0(df[row, "symbol"], " - ", df[row, "name"])
           }
           df = pnl$getDFPlot(idPlot)
           if (is.null(df)) return (NULL)
           plot = eval(parse(text=paste0(idPlot, "(info, df, title)")))
       }
       
       getBest = function(top, from) {
          from=as.integer(from)
          restdf("best", top=top, from=from) %>%
             then( function(df) {
                   pnl$data$dfBest = df
                   if (from ==  1) lbl = "Hora"
                   if (from ==  7) lbl = "Semana"
                   if (from == 24) lbl = "Dia"
                   if (from == 30) lbl = "Mes"
                   output$lblBest = updLabelText(paste("Mejores", lbl))
                   output$tblBest = updTableBest({
                       df$symbol = YATAWEB$getCTCLabel(df$symbol)
                       prepareTop(df) })
                  },function(err)    { 
                      message("ha ido mal 2"); message(err) }
               )
       } 
       getHistorical = function(id) {
           to = Sys.Date()
           from = to - as.difftime(30, unit="days")
           restdf("hist",id=id,from=from,to=to)  %>%
              then( function(df) { 
                  df$tms = as.Date(df$tms)
                  if (is.null(pnl$data$dfHist)) {
                      pnl$data$dfHist = df
                  }
                  else {
                      symbol = colnames(df)[length(colnames(df))]
                      df1 = pnl$data$dfHist
                      idx = which(colnames(df1) == symbol)
                      if (length(idx) > 0) df1 = df1[,-idx]
                      df1 = df1[,-(2:7)]
                      pnl$data$dfHist = full_join(df, df1, by="tms")
                  }
                   if (pnl$isPlotVisible("plotBest")) plots("plotBest")
                  },function(err)    {  
                      message("ha ido mal 3") ; message(err)})
           
       }

      autoInvalidate = reactiveTimer(pnl$interval * 60000)

      # Antes del observer para que encuentre datos
      
      if (!pnl$loaded) {
          getBest(input$numBestTop, input$cboBestFrom )
          loadPanel()
      }

      observe({
         autoInvalidate()
         output$dtLast = renderText({format.POSIXct(Sys.time(), format="%H:%M:%S")})

         data = pnl$getLatestSession()
         lapply(names(data), function(x) updYataMonitor(ns(paste0("monitor-",x)), pnl$getMonitor(x), data[[x]]$price))
         plots()
         
#         info = list(id="rank", n=5)
#         updRank(info, input,output,session)
     })
     
      observeEvent(input$plotBar, {
          plots(input$plotBar$plot, input$plotBar)
      })
     #################################################
     ### Panel Izquierdo
     #################################################
     
      observeEvent(input$numInterval,  { pnl$interval = input$numInterval }, ignoreInit = TRUE)
      observeEvent(list(input$cboPlotLeft, input$cboPlotRight), { 
          pnl$setPlotVisible(input$cboPlotLeft, input$cboPlotRight)
          plots()
      }, ignoreInit=TRUE)
      # observeEvent(input$numBestTop,   { getBest(input$numBestTop, input$cboBestFrom )}, ignoreInit = TRUE)
      # observeEvent(input$cboBestFrom,  { getBest(input$numBestTop, input$cboBestFrom )}, ignoreInit=TRUE)
      
      observeEvent(input$tblBest_rows_selected, {
          pnl$vars$best = input$tblBest_rows_selected
          id = pnl$data$dfBest[input$tblBest_rows_selected, "id"]
          getHistorical(id)
     })
      observeEvent(input$btnTopOK, {
          pnl$setCookies(best=list(top = input$numBestTop, interval = input$cboBestFrom))
          getBest(input$numBestTop, input$cboBestFrom )
      })
      observeEvent(input$btnTopKO, {
          cookie = pnl$getCookies("best")
          if (!is.null(cookie)) {
              updIntegerInput("numBestTop",  cookie$top)
              updCombo       ("cboBestFrom", cookie$interval)
          }
      })
      
     #################################################
     ### Ejecutar siempre
     #################################################
#      plots()
  })
}    
