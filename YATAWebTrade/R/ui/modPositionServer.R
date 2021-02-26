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
         ,interval     = 5
         ,fiats = c("EUR", "USD", "USDC", "USDT")
         ,plots = c( "Session day"          = "plotDay"
                    ,"Session day (var)"    = "plotDayVar"
                    ,"Session Online"       = "plotTicker"
                    ,"Session Online (Var)" = "plotTickerVar"
                    #,"Barras"         ="plotBar")
         )
         ,initialize    = function(id, pnlParent, session) {
             super$initialize(id, pnlParent, session)
             self$position   = YATAFactory$getObject(YATACodes$object$position)
             self$cameras    = YATAFactory$getObject(YATACodes$object$cameras)
             self$providers  = YATAFactory$getObject(YATACodes$object$providers)
             self$operations = YATAFactory$getObject(YATACodes$object$operation)
             private$monitors   = HashMap$new()
             self$vars$plotLeftChanged = TRUE
             self$vars$plotRightChanged = TRUE
         }
         ,getDF         = function(type) {
             root = self$getRoot()
             if (type == "plotTickerVar") return (root$getDFSession())
             if (type == "plotTicker")    return (root$getDFSession())
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
                 data    = self$providers$getSessionDays("EUR", counter, from, to) 
                 self$data$mapSessionDay$put(counter, data)
                 idx = idx + 1
             }
         }
        ,setInterval = function() {
            self$interval = self$parms$getOnlineInterval()
            self$getRoot()$setInterval(self$interval)
        }
         # ,makeDFSession  = function(data, init=FALSE) {
         #     df0 = data.frame(tms=Sys.time())
         #     df1 = as.data.frame(lapply(data, function(x) x$last))
         #     df  = cbind(df0, df1)
         #     df$tms = as.ITime(df$tms)
         #     if (init) {
         #         self$data$dfSession = df
         #     } else {     
         #         self$data$dfSession = rbind(self$data$dfSession, df)
         #     }
         # }
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
         ,monitors = NULL 
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
#          insertMonitors(pnl$getMonitors())
          # pnl$valid = TRUE
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
          
          # pnl$makeDFSession(data, TRUE)
          # 
          for (ctc in monitors$keys()) {
               monitor         = monitors$get(ctc)
               monitor$last    = data[[ctc]]$last
               monitor$session = data[[ctc]]$last
               monitor$day     = data[[ctc]]$day
               monitor$week    = data[[ctc]]$week
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
       # initMonitors2 = function() {
       #     browser()
       #    # Aqui ponemos los valores medio, dia, semana y session
       #    data = pnl$providers$getMonitors("EUR", pnl$lastMonitors)
       #    df = pnl$data$dfPosGlobal
       #    pnl$makeDFSession(data, TRUE)
       #    for (ctc in pnl$monitors$keys()) {
       #         monitor = pnl$monitors$get(ctc)
       #         monitor$last    = data[[ctc]]$last
       #         monitor$session = data[[ctc]]$last
       #         monitor$day     = data[[ctc]]$day
       #         monitor$week    = data[[ctc]]$week
       #         monitor$price   = 0
       #         if (nrow(df) > 0 && nrow(df[df$currency == ctc,]) > 0) {
       #            monitor$price = df[df$currency == ctc, "price"] 
       #         }  
       #         pnl$monitors$put(ctc, monitor)
       #         updYataMonitor(ns(paste0("monitor-",ctc)), monitor) # No poner last
       #    }
       # }
       plots = function() {
          if (input$cboPlotLeft != "") 
              output$plotLeft = updPlot({makePlot(input$cboPlotLeft)})
          if (input$cboPlotRight != "") 
              output$plotRight = updPlot({makePlot(input$cboPlotRight)})
       }
       makePlot = function(idPlot) {
           title = names(which(pnl$plots == idPlot))
           df = pnl$getDF(idPlot)
           if (is.null(df)) return (NULL)
           plot = eval(parse(text=paste0(idPlot, "(df, title)")))
       }
      autoInvalidate = reactiveTimer(pnl$interval * 60000)

      # Antes del observer para que encuentre datos
      if (!pnl$loaded) loadPanel()
      observe({
         autoInvalidate()
         output$dtLast = renderText({format.POSIXct(Sys.time(), format="%H:%M:%S")})

         data = pnl$getLatestSession()
         lapply(names(data), function(x) updYataMonitor(ns(paste0("monitor-",x)), pnl$getMonitor(x), data[[x]]$last))
         plots()
         
         info = list(id="rank", n=5)
         updRank(info, input,output,session)
     })
     
     #################################################
     ### Panel derecho
     #################################################
     
      observeEvent(input$numInterval,  { pnl$interval = input$numInterval }, ignoreInit = TRUE)
      observeEvent(input$cboPlotLeft,  { plots()} , ignoreInit=TRUE)
      observeEvent(input$cboPlotRight, { plots()}, ignoreInit=TRUE)

     #################################################
     ### Ejecutar siempre
     #################################################
      message("Ejecuta Posicion")
      plots()
  })
}    
