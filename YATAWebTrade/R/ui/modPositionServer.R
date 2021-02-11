# Cada modulo lleva asociado un objeto
# es el que gestiona la creacion del objeto y guarda sus variables

modPosServer <- function(id, full) {
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
         ,dates        = NULL # Fechas de inicio
         ,lastMonitors = NULL
         ,df = NULL
         ,monitors = NULL            
         ,fiats = c("EUR", "USD", "USDC", "USDT")
         ,plots = c( "Session day"    = "plotDay"
                    ,"Session Online" = "plotTickerVar"
                    ,"Barras"         ="plotBar")
         ,initialize    = function(id, session) {
             super$initialize(id, session)
             self$position   = YATAFactory$getObject(YATACodes$object$position)
             self$cameras    = YATAFactory$getObject(YATACodes$object$cameras)
             self$providers  = YATAFactory$getObject(YATACodes$object$providers)
             self$operations = YATAFactory$getObject(YATACodes$object$operation)
             self$monitors   = HashMap$new()
             self$vars$interval = 100
             self$vars$plotLeftChanged = TRUE
             self$vars$plotRightChanged = TRUE
         }
         ,getDF         = function(type) {
             if (type == "plotTickerVar") return (data$dfSession)
         } 
         ,getDFSession  = function() { self$data$dfSession      } 
         ,getSessionDay = function() { return (private$sessDay) }
         ,loadDataDay   = function() {
            now = Sys.time()    
            if (is.null(self$dates$tms)) return()
            self$dates$tms = self$dates$tms - as.difftime(7, unit="days")
            idx = 1
            while (idx <= nrow(self$dates)) {
                data = self$providers$getSessionDays("EUR", self$dates[idx, "counter"]
                                                          , self$dates[idx, "tms"]
                                                          , now)
                private$sessDay$put(self$dates[1,"counter"], data)
                idx = idx + 1
            }
         }
         ,makeDFSession = function(data, init=FALSE) {
             df0 = data.frame(tms=Sys.time())
             df1 = as.data.frame(lapply(data, function(x) x$last))
             df  = cbind(df0, df1)
             if (init) {
                 self$data$dfSession = df
             } else {     
                 self$data$dfSession = rbind(self$data$dfSession, df)
             }
         }
      )
     ,private = list(
           opIdx     = list()
           ,selected = NULL
           ,sessDay = HashMap$new()
       )
    )
    moduleServer(id, function(input, output, session) {
       pnl = YATAWEB$panel(id)
       if (is.null(pnl)) pnl = YATAWEB$addPanel(PNLPos$new(id, session))
       loadPanel = function() {
          pnl$vars$interval = pnl$parms$getOnlineInterval()
          updNumericInput("numInterval", pnl$vars$interval)
          loadPosition()
          pnl$loadDataDay()
          if (!is.null(pnl$lastMonitors)) initMonitor()
          output$dtLast = updLabelDate({Sys.time()})
          updCombo("cboPlotLeft",  choices=pnl$plots, selected=pnl$plots[2])
          updCombo("cboPlotRight", choices=pnl$plots, selected=pnl$plots[2])
          pnl$loaded = TRUE
       }
       insertMonitors       = function(act) {
           toDel = !pnl$lastMonitors %in% act
           # Quitar los viejos
           if (length(toDel) > 0) {
               toDel = pnl$lastMonitors[toDel]
               for (old in toDel) pnl$monitors$remove(old)
           }
           act = act[!act %in% pnl$fiats]
           # Poner los nuevos
           if (length(act) < 6 && ! ("BTC" %in% act)) act = c("BTC", act)
#           if (length(act) < 6 && ! ("ETH" %in% act)) act = c("ETH", act)
           lapply(act, function(item) if (is.null(pnl$monitors$get(item))) pnl$monitors$put(item, list()))
           idDiv = paste0("#", ns("monitor"))

           lapply(act, function(x) {
                if (!(x %in% pnl$lastMonitors)) 
                    insertUI(selector = idDiv, where = "beforeEnd", immediate=TRUE,
                             ui=tagList(yuiYataMonitor(ns(paste0("monitor-",x)))))
           })
           pnl$lastMonitors = act
       }
       loadCameraUI = function(camera) {
          suffix = titleCase(camera)
          camera = pnl$cameras$getCameraName(camera)
          nstable = paste0("tblPos", suffix)
          tags$div(id=paste0("divPos", suffix), yuiBox(ns(nstable), paste("Posicion", camera)
                                                                   , DT::dataTableOutput(ns(nstable))))
       }
       initMonitor = function() {
          # Aqui ponemos los valores medio, dia, semana y session
          data = pnl$providers$getMonitors("EUR", pnl$lastMonitors)
          df = pnl$data$dfPosGlobal
          pnl$makeDFSession(data, TRUE)
          for (ctc in pnl$monitors$keys()) {
               monitor = pnl$monitors$get(ctc)
               monitor$last    = data[[ctc]]$last
               monitor$session = data[[ctc]]$last
               monitor$day     = data[[ctc]]$day
               monitor$week    = data[[ctc]]$week
               monitor$price   = 0
               if (nrow(df) > 0) monitor$price = df[df$currency == ctc, "price"]
               pnl$monitors$put(ctc, monitor)
               updYataMonitor(ns(paste0("monitor-",ctc)), monitor) # No poner last
          }
       }
       loadPosition = function() {
          pnl$data$dfPosGlobal = pnl$position$getGlobalPosition()
          output$tblPosGlobal  = updTablePosition(id=ns("posGlobal"), pnl$data$dfPosGlobal)
           
          cameras = pnl$position$getCameras()
          divs = lapply(cameras, function(camera) loadCameraUI(camera))
           
          insertUI(selector = "#divPosLast", where = "beforeBegin", ui=tagList(divs), immediate=TRUE)
          dfs = lapply(cameras, function(camera) {
                                 sfx = titleCase(camera)
                                 df  = pnl$position$getCameraPosition(camera)
                                 tbl = paste0("tblPos", sfx) 
                                 eval(parse(text=paste0( "output$tblPos", sfx
                                                        ," = yataTablePosition(id=ns('"
                                                        ,paste0("pos", sfx), "'),   df)")))
                      })
          insertMonitors(unique(pnl$data$global$currency))
          pnl$valid = TRUE
      }
       plots = function() {
           plotLeft()
           plotRight()
       }
       plotLeft = function() {
          #  if (input$cboPlotLeft != "") {
          # plot = eval(parse(text=paste0(input$cboPlotLeft, "(pnl$getDF(input$cboPlotLeft))")))
          # output$plotLeft = renderPlotly({plot})
          #      
          #  }
       }
       plotRight = function() {
           # if (!is.null(pnl$df) && input$cboPlotLeft != "") {
           #     plot = eval(parse(text=paste0(input$cboPlotRight, "(pnl$getDF(input$cboPlotRight))")))
           #     output$plotRight = renderPlotly({plot})
           # }
       }
      autoInvalidate = reactiveTimer(60000)

      # Antes del observer paraque encuentre datos
      if (!pnl$loaded)  loadPanel()
      
      observe({
#         autoInvalidate()
          invalidateLater(pnl$vars$interval * 60000)
#         output$lastUpdate = renderText({paste("Last update: ", format.POSIXct(Sys.time(), format="%H:%M:%S"))})
         data = pnl$providers$getLatests("EUR", pnl$lastMonitors)
         pnl$makeDFSession(data)

         df = pnl$data$dfPosGlobal
         lapply(names(data), function(x) updYataMonitor(ns(paste0("monitor-",x)), pnl$monitors$get(x), data[[x]]$last))
         bars = lapply(names(data), function(x) {
                             row = df[df$currency == x, ]
                             list( prc = ((data[[x]]$last / row[1, "price"])-1) * 100
                                  ,delta=(row[1,"balance"] * data[[x]]$last) - (row[1,"balance"] * row[1,"price"]))
                })
         df = as.data.frame(bars)
         df = cbind(symbol=names(data),df)
         pnl$df = df
#         output$plotDelta = renderPlotly({plotBars(df, x="symbol",y="prc")})
         output$dtLast = updLabelDate({Sys.time()})
         plots()
     })
     
     #################################################
     ### Panel derecho
     #################################################
     
      observeEvent(input$numInterval,  { pnl$vars$interval = input$numInterval })
      observeEvent(input$cboPlotLeft,  {plotLeft()} , ignoreInit=TRUE)
      observeEvent(input$cboPlotRight, {plotRight()}, ignoreInit=TRUE)

      plots()
  })
}    
