# Cada modulo lleva asociado un objeto
# es el que gestiona la creacion del objeto y guarda sus variables

modPosServer <- function(id, full, pnlParent, invalidate=FALSE) {
   ns = NS(id)
   PNLPos = R6::R6Class("PNL.OPER"
      ,inherit = YATAPanel
      ,cloneable  = FALSE
      ,lock_class = TRUE
      ,public = list(
          position    = NULL
         ,cameras     = NULL
         ,providers   = NULL
         ,session     = NULL
         ,monitor    = NULL
         ,fiats = c("EUR", "USD", "USDC", "USDT")
         ,plots = c( "Historical" = "Hist"
                    ,"Session"    = "Session"
                    ,"Best Info"  = "Best"
                    ,"Top Info"   = "Top"
         )
         ,tables = c( "Position"     = "Position"
                     ,"Best"         = "Best"
                     ,"Best of Top"  = "Top"
         )
         ,ui = list(
              Best = {yuiBox(ns('boxBest'), yuiLabelText(ns('lblBest')),yuiDataTable(ns('tblBest')))}
             ,Top  = {yuiBox(ns('boxTop'),  yuiLabelText(ns('lblTop')), yuiDataTable(ns('tblTop' )))}
             ,Position  = {tagList(fluidRow(id=ns("position"), yuiBoxClosable(ns('tblPosGlobal'), 'Posicion Global'
                               , yuiDataTable(ns('tblPosGlobal'))))
                           ,fluidRow(id=ns("posCameras")))
                     }
           )
         ,initialize    = function(id, pnlParent, session) {
             super$initialize(id, pnlParent, session)
             self$position   = self$factory$getObject(self$codes$object$position)
             self$cameras    = self$factory$getObject(self$codes$object$cameras)
             self$providers  = self$factory$getObject(self$codes$object$providers)

             self$data$lstHist = list()
             self$setInterval()   
             self$vars$best = list(top = 10, from = 7)
             self$vars$history = 15
             private$applyCookies(session)
             self$layoutInit(private$playout)
         }
         ,loadData = function() {
             self$data$dfGlobal = self$getRoot()$getGlobalPosition() 
             cameras = self$position$getCameras()
             self$data$position = lapply(cameras, function(camera) self$position$getCameraPosition(camera))
             names(self$data$position) = cameras
             self$monitor = BLK.MONITORS$new(ns("monitor"), self, YATAWEB)
             self$loaded = TRUE
         }
         ,updateHistorical = function(id, df, type) {
             df$tms = as.Date(df$tms)
             if (type == "Best" && is.null(self$data$dfBestHist)) {
                 self$data$dfBestHist = df
                 return()
             }
             if (type == "Top" && is.null(self$data$dfTopHist)) {
                 self$data$dfTopHist = df
                 return()
             }
             if (type == "Hist") {
                 if      (id == 1) self$data$lstHist[["BTC"]] = df
                 else if (id == 2) self$data$lstHist[["ETH"]] = df
                 else              self$data$lstHist[[self$data$dfGlobal[self$data$dfGlobal$id == id, "currency"]]]
                 return()
             }
             if (type == "Best") dfb = self$data$dfBestHist
             if (type == "Top")  dfb = self$data$dfTopHist
             
             symbol = colnames(df)[length(colnames(df))]
             idx = which(colnames(dfb) == symbol)
             if (length(idx) > 0) dfb = dfb[,-idx]
             dfb = dfb[,-(2:7)]
             df = full_join(df, dfb, by="tms")

             if (type == "Best") self$data$dfBestHist = df
             if (type == "Top")  self$data$dfTopHist  = df
         }
         ,getPlotInfo = function(idPlot, uiPlot) {
             # Un mismo plot puede estar en los dos con info diferente
             info = self$vars$info$uiPlot$idPlot
             if (is.null(info)) {
                 info = list()
                 info$observer = ns("modebar")
                 info$id   = ns(idPlot) 
                 info$ui   = uiPlot
                 info$plot = idPlot
                 info$src  = ifelse(idPlot == "Session", "price", "session")
                 info$type = ifelse(idPlot == "Session", "Candlestick", "Linear")
                 self$vars$info[[uiPlot]][[idPlot]] = info
             }
             info
         }
        ,setInterval = function(interval) {
            if (missing(interval)) interval = self$parms$getOnlineInterval()
            self$vars$interval = interval # Local
            self$getRoot()$setInterval(self$vars$interval)      # Global
        }
        ,getPeriodLabel = function (from) {
            if (from ==   1) return("Hora")
            if (from ==   7) return("Semana")
            if (from ==  24) return("Dia")
            if (from ==  30) return("Mes")
        }
      )
     ,private = list(
          opIdx      = list()
         ,monitors   = NULL 
         ,playout    = matrix(c("Hist", "Best", "Best", "Position"),2,2,byrow=TRUE)
         ,applyCookies = function(session) {
             cookies = self$vars$cookies
             self$vars$loading = TRUE
             if (!is.null(cookies$best)) self$vars$best = cookies$best
             if (!is.null(cookies$layout)) {
                 browser()
             }
             if (!is.null(cookies$interval)) pnl$setInterval(cookies$interval)
             if (!is.null(cookies$days))     pnl$vars$history = cookies$days
         }
       )
    )
    moduleServer(id, function(input, output, session) {
      pnl = YATAWEB$getPanel(id)
      if (is.null(pnl)) pnl = YATAWEB$addPanel(PNLPos$new(id, pnlParent, session))
      
      makeID = function(tag) { paste0("#", ns(tag)) }

      updateLeftSide = function() {
          updNumericInput("numInterval", pnl$vars$interval)
          output$dtLast = updLabelDate({Sys.time()})
          updNumericInput("numBestTop", pnl$vars$best$top)
          updCombo("cboBestFrom", selected = pnl$vars$best$from)
          updNumericInput("numInterval", value = pnl$vars$interval)
          updNumericInput("numDays",     value = pnl$vars$history)
          lapply(1:2, function(x) updCombo(paste0("cboPlot",x),choices=pnl$plots, selected=pnl$layout[1,x]))
          lapply(1:2, function(x) updCombo(paste0("cboData",x),choices=pnl$tables,selected=pnl$layout[2,x]))
      }
      updateData = function() {
         getBest(input$numBestTop, input$cboBestFrom, TRUE )
         getBest(input$numBestTop, input$cboBestFrom, FALSE )
         pnl$monitor$update() 

      }
      loadHistorical = function() {
         df = pnl$data$dfGlobal
         df = df[df$currency != "EUR",]
         ctc = as.vector(df$currency)
         if (length(ctc) < 6) ctc = c(ctc, "ETH", "BTC")
         ctc = unique(ctc)
         lapply(ctc, function(x) {
             if (x == "BTC") id = 1
             else if (x == "ETH") id = 2
             else id = df[df$currency == x, "id"]
             getHistorical(id, "Hist")
             })
      }
      loadPosition = function() {
           cameraUI = function(camera) {
               suffix  = titleCase(camera)
               cam     = pnl$cameras$getCameraName(camera)
               nstable = paste0("tblPos", suffix)
               tags$div( id=paste0("divPos", suffix)
                        ,yuiBoxClosable( ns(nstable), paste("Posicion", cam)
                                ,yuiDataTable(ns(nstable))
                               )
                         )
           }
           cameraData = function(camera, df) {
              sfx = titleCase(camera)
              df  = preparePosition(df)
              tbl = paste0("tblPos", sfx)
              eval(parse(text=paste0( "output$tblPos", sfx
                                     ," = updTablePosition(id=ns('"
                                     ,paste0("pos", sfx), "'),   df)")))
           }
           if (!is.null(pnl$data$dfGlobal)) {
               output$tblPosGlobal  = updTablePosition(preparePosition(pnl$data$dfGlobal))     
           }
           removeUI(makeID("posCameras"), immediate = TRUE)
           cameras = pnl$data$position
           insertUI(makeID("position"), where = "beforeEnd", ui=tags$div(id=ns("posCameras"),  immediate=TRUE))
           divs = lapply(names(cameras), function(camera) cameraUI(camera))
           insertUI(makeID("posCameras"), where = "afterBegin", ui=divs[[1]], immediate=TRUE)
           lapply(names(cameras), function(camera) cameraData(camera, cameras[[camera]]))
       }
       tableBest = function(...) {
           if (is.null(pnl$data$dfBest)) return()
           lbl = pnl$getPeriodLabel(input$cboBestFrom)
           output$lblBest = updLabelText(paste("Mejores", lbl))
           df = pnl$data$dfBest
           df$symbol = YATAWEB$getCTCLabels(df$symbol)
           output$tblBest = updTableBest({ prepareTop(df) })
       }
       tableTop = function(...) {
           if (is.null(pnl$data$dfTop)) return()
           lbl = pnl$getPeriodLabel(input$cboBestFrom)           
           output$lblTop = updLabelText(paste("Mejores", lbl, "(TOP)"))
           df = pnl$data$dfTop
           df$symbol = YATAWEB$getCTCLabels(df$symbol)
           output$tblTop = updTableBest({ prepareTop(df) })
       }
       renderData = function(row, col, object) {
           # Position es especial
           if (object == "Position") {
               loadPosition()
               return()
           }
           prfx = ifelse(row == 1, "plot", "table") 
           eval(parse(text=paste0("output$", prfx, col, "=", prfx, object,"('", prfx, col, "')")))
       }
       renderPanel = function() {
           diff = pnl$layoutChanges()
           for (row in 1:2) {
                for (col in 1:2) {
                    obj = NULL
                    if (row == 2) obj = pnl$ui[[pnl$layout[row,col]]]
                    if (diff[row,col] && !is.null(obj)) updBlock(id, row, col, obj)
                    renderData(row, col, pnl$layout[row,col])    
                }
           }
       }
       renderPlot = function(type) {
           # Plots son fila 1
           if (pnl$layout[1,1] == type) output$plot1 = eval(parse(text=paste0("plot", type, "('plot1')")))
           if (pnl$layout[1,2] == type) output$plot2 = eval(parse(text=paste0("plot", type, "('plot2')")))
       }
       plotHist = function(uiPlot) {
           if (length(pnl$data$lstHist) == 0) return (NULL)
           info = pnl$getPlotInfo("Hist", uiPlot)
           if (length(pnl$data$lstHist) > 1) {
               data = lapply(pnl$data$lstHist, function(df) df[,"close"])
               tms = pnl$data$lstHist[[1]]$tms
               df = as.data.frame(data)
               df = cbind(tms, df)
               info$type = "Linear"
               info$src  = "price"
               title = "Historico posicion"
           } else {
               df = pnl$data$lstHist[[1]]
               info$type = "Candlestick"
               info$src  = "session"
               title = names(pnl$data$lstHist)[1]
           }
           updPlot(yataPlot(info, df, title))
       }
       plotBest = function(uiPlot) {
          df = pnl$data$dfBestHist
          if (is.null(df)) return (NULL)
          info = pnl$getPlotInfo("plotBest", uiPlot)
          plt = yataPlot(info, df, "Title 1")
          updPlot(plt)
       }
       plotTop = function(uiPlot) {
          df = pnl$data$dfTopHist
          if (is.null(df)) return (NULL)
          info = pnl$getPlotInfo("plotTop", uiPlot)
          plt = yataPlot(info, df, "Title 2")
          updPlot(plt)
       }
       plotSession = function(uiPlot) {
          # df = self$data$dfTopHist
          # info = pnl$getPlotInfo("plotSession", uiPlot)
          # plt = yataPlot(info, df, "Title 2")
          # updPlot(plt)
           NULL
       }
       makePlot = function(idPlot, uiPlot) {
           browser()
#           df = pnl$getPlotDF(idPlot)
           info = pnl$getPlotInfo(idPlot, uiPlot)
           
           title = names(which(pnl$plots == idPlot))
           # if (idPlot == "plotBest") {
           #     info$src = "session"
           #     df  = pnl$data$dfBest
           #     row = pnl$vars$rowBest
           #     title = paste0(df[row, "symbol"], " - ", df[row, "name"])
           # }
           # else {
           #   info$src = "price"
           # }

           if (is.null(df)) return (NULL)
           # Tira de widgetsPlot
           plot = eval(parse(text=paste0(idPlot, "(info, df, title)")))
       }

      #####################################################
      ### REST                                          ###     
      #####################################################
       
       getBest = function(top, from, best) {
          from=as.integer(from)
          rest = ifelse(best, "top", "best")
          restdf(rest, top=top, from=from) %>%
             then( function(df) {
                  if (best) {
                      pnl$data$dfBest = df
                      tableBest()
                  } else {
                      pnl$data$dfTop = df
                      tableTop()
                  }
                  },function(err)    {
                      message("ha ido mal 2"); message(err) }
               )
       } 
       getHistorical = function(id, type) {
           to = Sys.Date()
           from = to - as.difftime(pnl$vars$history, unit="days")
           restdf("hist",id=id,from=from,to=to)  %>%
              then( function(df) {
                      pnl$updateHistorical(id, df, type)
                      renderPlot(type)
                   },function(err)    {
                      message("ha ido mal 3") ; message(err)})
       }

      if (!pnl$loaded || pnl$isInvalid()) {
          pnl$loadData()
          updateLeftSide()
          renderPanel()
          pnl$monitor$render()
       }       

      if (pnl$isInvalid()) pnl$reset()
      
      #####################################################
      ### Observers                                     ###     
      #####################################################

      observeEvent(input$tblBest_rows_selected, {
          pnl$vars$rowBest = input$tblBest_rows_selected
          id = pnl$data$dfBest[input$tblBest_rows_selected, "id"]
          getHistorical(id, "Best")
      })
      observeEvent(input$tblTop_rows_selected, {
          pnl$vars$rowTop = input$tblTop_rows_selected
          id = pnl$data$dfTop[input$tblTop_rows_selected, "id"]
          getHistorical(id, "Top")
      })
       
      observeEvent(input$modebar, {
          info = input$modebar
          pnl$vars$info[[info$plot]] = info
          if (info$ui == "plot1")  output$plot1 = updPlot({makePlot(info$plot, "plot1")})
          if (info$ui == "plot2")  output$plot2 = updPlot({makePlot(info$plot, "plot2")})
      })

      #####################################################
      ### Timers                                        ###     
      #####################################################
      
      observe({ # Se ejecuta una sola vez
         invalidateLater(pnl$vars$first * 1000, session)
         if (pnl$vars$first == Inf) return()
         if (pnl$vars$first > 1) {
             updateData()
             loadHistorical()
             pnl$vars$first = Inf
         } else {
            pnl$vars$first = pnl$vars$first + 1            
         }
      })
      observe({
          invalidateLater(pnl$vars$interval * 60000)
          if (pnl$vars$first != Inf) return()  # Se ha ejecutado la primera vez
          output$dtLast = renderText({format.POSIXct(Sys.time(), format="%H:%M:%S")})
          updateData()
          renderPanel()
     })
     
     #################################################
     ### Panel Izquierdo
     #################################################
     
      observeEvent(input$btnLayoutOK, {
          chng = FALSE
          # Gestion cambios
          if (pnl$vars$best$top  != input$numBestTop)  chng = TRUE
          if (pnl$vars$best$from != input$cboBestFrom) chng = TRUE
          pnl$vars$best$top  = input$numBestTop
          pnl$vars$best$from = input$cboBestFrom
          
          if (chng) updateData()
          
          layout = matrix(c(input$cboPlot1,input$cboPlot2,input$cboData1,input$cboData2),nrow=2,ncol=2,byrow = TRUE)
          pnl$layoutSet(layout)
          
          pnl$setInterval(input$numInterval)
          pnl$vars$history = input$numDays
          pnl$setCookies( best = pnl$vars$best, layout=pnl$layout
                         ,days=pnl$vars$history, interval = pnl$vars$interval)
          renderPanel()
          session$sendCustomMessage("closeLeftSide", "OK")
      })
      observeEvent(input$btnLayoutKO, { updateLeftSide() })
  })
}    
