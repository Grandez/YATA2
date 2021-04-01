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
         # ,providers   = NULL
         ,session     = NULL
         # ,operations  = NULL 
         ,monitors    = NULL
         ,initialize    = function(id, pnlParent, session) {
             super$initialize(id, pnlParent, session)
             self$position  = self$factory$getObject(self$codes$object$position)
             self$cameras   = self$factory$getObject(self$codes$object$cameras)
             # self$providers = self$factory$getObject(self$codes$object$providers)
             self$session   = self$factory$getObject(self$codes$object$session)
             # 
             # self$data$lstHist    = list()
             # self$data$lstBalance = list(EUR=list(day=0,week=0,month=0))
             # Default values
             self$setInterval()
             self$vars$best = list(top = 10, from = 2)
             self$vars$history = 15
             self$vars$layout = matrix(c("Hist", "Session", "Best", "Position"),2,2,byrow=TRUE)
             self$data$dfHist = list()
             private$applyCookies(session)
             
         }
         ,loadData = function() {
             private$loadPosition()
             self$monitors = BLK.MONITORS$new(ns("monitor"), self, YATAWEB)
             self$updateBest()
             ctc = self$data$dfGlobal$currency
             self$data$dfSession = self$session$getPrices(ctc)
             self$loaded = TRUE
             invisible(self)
         }
         ,updateData = function() {
             self$updateBest()
             data = self$session$getPrices(names(pnl$data$position))
             data = self$monitors$getLast()
             dfp = data[,c("tms", "symbol", "price")]
             dfp$tms = as.POSIXct(dfp$tms, format="%H:%M:%S")
             if (is.null(self$data$dfSession)) {
                 self$data$dfSession = dfp
             } else {
                 self$data$dfSession = rbind(self$data$dfSession, dfp)
             }
         }
         ,updateHistory = function(id, df, symbol) {
             # Para evitar fallos en la fecha, ordenamos en inverso
             df = df[order(df$tms, decreasing=TRUE),]
             updPos = function(dfpos) {
                interval = c(1,7,30)
                col      = c("day", "week", "month")
                row = which(dfpos$currency == symbol)
                if (length(row) != 0) {
                    for (idx in 1:3) {
                         if (nrow(df) >= interval) {
                             var = (dfpos[row, "price"] / df[interval[idx], 2]) - 1
                             dfpos[row, col[idx]] = var
                         }
                    }
                }
                dfpos
              }
              self$data$dfGlobal = updPos(self$data$dfGlobal)
              self$data$position = lapply(self$data$position, function(dfpos) updPos(dfpos))
          }
       #   ,updateHistorical = function(id, df, type) {
       #       df$tms = as.Date(df$tms)
       #       if (type == "Best" && is.null(self$data$dfBestHist)) {
       #           self$data$dfBestHist = df
       #           return()
       #       }
       #       if (type == "Top" && is.null(self$data$dfTopHist)) {
       #           self$data$dfTopHist = df
       #           return()
       #       }
       #       if (type == "Hist") {
       #           cols = colnames(df)
       #           ctc = cols[length(cols)]
       #           self$data$lstHist[[ctc]] = df
       #           return()
       #       }
       #       if (type == "Best") dfb = self$data$dfBestHist
       #       if (type == "Top")  dfb = self$data$dfTopHist
       #       
       #       symbol = colnames(df)[length(colnames(df))]
       #       idx = which(colnames(dfb) == symbol)
       #       if (length(idx) > 0) dfb = dfb[,-idx]
       #       dfb = dfb[,-(2:7)]
       #       df = full_join(df, dfb, by="tms")
       # 
       #       if (type == "Best") self$data$dfBestHist = df
       #       if (type == "Top")  self$data$dfTopHist  = df
       #   }
       #   ,updateBest = function() {
       #       .get = function(df, top, from) {
       #          if (from ==  1) col = "hour"
       #          if (from == 24) col = "day"
       #          if (from ==  7) col = "week"
       #          if (from == 30) col = "month"
       #          df = df[order(df[col], decreasing = TRUE),]
       #          df[1:top,]
       #       }
       #       df = self$session$getLatest()
       #       dft = df[order(df$rank),]
       #       self$data$dfTop = .get(dft[1:25,],top,from)
       #       self$data$dfFav = .get(dft[1:150,],top,from)
       #       self$data$dfBest = get(df,top,from)
       #   } 
         ,getPlotInfo = function(idPlot, uiPlot) {
             # Un mismo plot puede estar en los dos con info diferente
             info = self$vars$info$uiPlot$idPlot
             if (is.null(info)) {
                 info = list()
                 info$observer = ns("modebar")
                 info$id   = ns(idPlot)
                 info$ui   = uiPlot
                 info$plot = idPlot
                 if (idPlot %in% c("plotSession", "plotHist")) {
                     info$src  = "price"
                     info$type = "Linear"
                 }
                 else {
                     info$src  = "session"
                     info$type = "Candlestick"
                 }
                 self$vars$info[[uiPlot]][[idPlot]] = info
             }
             info
         }
        ,setInterval = function(interval=15) {
            self$vars$interval = interval # Local
            self$getRoot()$setInterval(self$vars$interval)      # Global
        }
        # ,getPositionID = function() {
        #     browser()
        #     ids = NULL
        #     syms = self$data$dfGlobal[self$data$dfGlobal$currency != "EUR", "currency"]
        #     if (length(syms) != 0) ids = YATAWEB$getCTCID(syms)
        #     ids
        # }
       # ,loadOperations = function() {
       #     if (!is.null(self$operations)) return()     
       #     self$operations = self$factory$getObject(self$codes$object$operation)
       #     self$data$dfOper = self$operations$getActive()
       #  }
        ,getPlots  = function() { private$plots  }
        ,getTables = function() { private$tables }  
        ,updateBest = function() {
            cols = c("hour", "day", "week", "month")
            df = self$session$getLatest()
            col = cols[self$vars$best$from]
            rows = self$vars$best$top
            df = df[order(df[,col],decreasing=TRUE),]
            self$data$dfBest = df[1:rows,]
            self$data$dfTop  = df[df$rank < 21,][1:self$vars$best$top,]
            self$data$dfFav  = df[df$rank < 101,][1:self$vars$best$top,]
         #    browser()
         #    df = df[order(df$tms, decreasing=TRUE),]
         #    browser()
         # # getBest(input$numBestTop, input$cboBestFrom, TRUE )
         # # getBest(input$numBestTop, input$cboBestFrom, FALSE )
         # pnl$monitors$update()
         # data = pnl$monitors$getLast()
         # dfp = data[,c("tms", "symbol", "price")]
         # dfp$tms = as.POSIXct(dfp$tms, format="%H:%M:%S")
         # if (is.null(pnl$data$dfSession)) {
         #     pnl$data$dfSession = dfp
         # } else {
         #     pnl$data$dfSession = rbind(pnl$data$dfSession, dfp)
         # }
         # pnl$updateBest()
      }
          
      )
     ,private = list(
         #   opIdx      = list()
         #  ,monitor   = NULL 
         plots = c( "Position" = "Hist", "Session" = "Session"
                   ,"Best Info"  = "Best", "Top Info" = "Top"
         )
         ,tables = c( "Position"    = "Position", "Best"              = "Best"
                     ,"Best of Top" = "Top"     , "Best of favorites" = "Fav"
         )
         ,applyCookies = function(session) {
             cookies = self$vars$cookies
             if (length(cookies) == 0) return()
             # self$vars$loading = TRUE
             if (!is.null(cookies$best)) self$vars$best = cookies$best
             if (!is.null(cookies$layout)) {
                 browser()
             }
             if (!is.null(cookies$interval)) pnl$setInterval(cookies$interval)
             if (!is.null(cookies$days))     pnl$vars$history = cookies$days
         }
          ,loadPosition = function() {
             df = self$getRoot()$getGlobalPosition()
             df = cbind(df, day=0, week=0, month=0)
             self$data$dfGlobal = df
             cameras = self$position$getCameras()
             self$data$position = lapply(cameras,
                                         function(camera) {
                                               df = self$position$getCameraPosition(camera)
                                               df = cbind(df, day=0, week=0, month=0)
                                          })
             names(self$data$position) = cameras
          }
       )
    )
   #####################################################################
   ### FUNCTIONS                                                     ###
   #####################################################################   
   preparePosition = function(df) {
      types = list(dat = c("since"), prc = c("day", "week", "month"))
      df =  df %>% select(currency,balance, priceBuy, priceSell, price, day, week, month, since)
      df$since = as.Date(df$since)
      colnames(df) = c("currency", "balance", "cost", "return", "net", "day", "week", "month", "since")
      yataDT(df,types=types,colorize=c("day", "week", "month"))
    }
    prepareBest = function(df) {
       prc = c("hour", "day", "week", "month")
       if (is.null(df)) return (NULL)
       df =  df %>% select(symbol, price, hour, day, week, month)
       df$hour  = df$hour  / 100
       df$day   = df$day   / 100
       df$week  = df$week  / 100
       df$month = df$month / 100
       df$symbol = YATAWEB$getCTCLabels(df$symbol)

       dt = yataDT(df,types=list(prc=prc),colorize=prc)
       dt
    }

    moduleServer(id, function(input, output, session) {
       pnl = YATAWEB$getPanel(id)
       if (is.null(pnl)) pnl = YATAWEB$addPanel(PNLPos$new(id, pnlParent, session))
       makeID = function(tag) { paste0("#", ns(tag)) }
       updateBest = function() {
           pnl$updateBest()
           renderBest()
       }
                   
       updateLeftSide = function() {
          updNumericInput("numInterval", pnl$vars$interval)
          output$dtLast = updLabelDate({Sys.time()})
          updNumericInput("numBestTop", pnl$vars$best$top)
          updCombo("cboBestFrom", selected = pnl$vars$best$from)
          updNumericInput("numInterval", value = pnl$vars$interval)
          updNumericInput("numDays",     value = pnl$vars$history)
          lapply(1:2, function(x) updCombo(paste0("cboPlot",x),choices=pnl$getPlots()
                                                              ,selected=pnl$vars$layout[1,x]))
          lapply(1:2, function(x) updCombo(paste0("cboData",x),choices=pnl$getTables()
                                                              ,selected=pnl$vars$layout[2,x]))
      }
      renderUIPosition = function() {
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
#            cameraData = function(camera, df) {
#               sfx = titleCase(camera)
#               dt = preparePosition(df, camera)
#               lhs = paste0("output$tblPos", sfx)
#               rhs = "yataDTRender({dt}, type='position')"
#               eval(parse(text=paste0(lhs," = ", rhs)))
#            }
#            # if (!is.null(pnl$data$dfGlobal)) {
#            #     insertUI( paste0("#", id, "_block_", row, "_", col, "_content")
#            #              ,where = "afterBegin"
#            #              ,ui=pnl$ui$Position
#            #              ,immediate=TRUE)
#            #     message("Datos globales no estan vacios")
# 
#                dt = preparePosition(pnl$data$dfGlobal, "Global")
#                # plt = yataDTRender({dt}, type="position")
#                output$tblPosGlobal  = yataDTRender({dt}, type="position")
#            #}
            removeUI(makeID("posCameras"), immediate = TRUE)
            cameras = tags$div(id=ns("posCameras"))
            cams =names(pnl$data$position)
            if(length(cams)) {
                for (camera in cams) {
                     suffix  = titleCase(camera)
                     cam     = pnl$cameras$getCameraName(camera)
                     nstable = paste0("tblPos", suffix)
                     divCam = tags$div( id=paste0("divPos", suffix)
                                     ,yuiBoxClosable( ns(nstable), paste("Posicion", cam)
                                     ,yuiDataTable(ns(nstable))
                                   )
                            )
                     cameras = tagAppendChild(cameras, divCam)
                }
            }
            insertUI(paste0("#", ns("Position")), where = "beforeEnd", ui=cameras,  immediate=TRUE)           
            
# #            
# #            divc = tags$div(id=ns("posCameras"))
# #            
#              cameras = names(pnl$data$position)
#             # cameras = pnl$data$position
#              divs = lapply(names(pnl$data$position), function(camera) cameraUI(camera))
              # browser()
              # tagAppendChildren(ns("posCameras"), tagList(divs))
#              insertUI(paste0("#", ns("posCameras")), where = "afterBegin", ui=divs,  immediate=TRUE)           
# 
# #           lapply(names(cameras), function(camera) cameraData(camera, cameras[[camera]]))

      }
      # renderPanel = function() {
      #     pnl$monitors$render() 
      #     output$plot1 = eval(parse(text=paste0("plot", pnl$vars$layout[1,1], "('plot1')")))
      #     output$plot1 = eval(parse(text=paste0("plot", pnl$vars$layout[1,2], "('plot2')")))
      #     renderPosition()
      # }
#       loadHistorical = function() {
#         message("laodHistorical")
#          df = pnl$data$dfGlobal
#          df = df[df$currency != "EUR",]
#          ctc = as.vector(df$currency)
#          # if (length(ctc) < 6) ctc = c(ctc, "ETH", "BTC")
#          # ctc = unique(ctc)
#          ids = YATAWEB$getCTCID(ctc)
#          lapply(ids, function(id) getHistorical(id, "Hist"))
#       }
      renderPosition = function() {
          dt = preparePosition(pnl$data$dfGlobal)
          output$tblPosGlobal  = yataDTRender({dt}, type="position")
          
          cameras = pnl$data$position  
          if (length(cameras) == 0) return()
          lapply(names(pnl$data$position), function(camera) {
              sfx = titleCase(camera)
              dt = preparePosition(pnl$data$position[[camera]])
              lhs = paste0("output$tblPos", sfx)
              rhs = "yataDTRender({dt}, type='position')"
              eval(parse(text=paste0(lhs," = ", rhs)))
          })

#          output$tblPosGlobal  = yataDTRender({dt}, type="position")
#         # No sabemos donde esta, asi que lo quitamos
#         #removeUI(paste0("#", ns("position")), immediate = TRUE)
# 
#         message("renderPosition")
#            cameraUI = function(camera) {
#                suffix  = titleCase(camera)
#                cam     = pnl$cameras$getCameraName(camera)
#                nstable = paste0("tblPos", suffix)
#                tags$div( id=paste0("divPos", suffix)
#                         ,yuiBoxClosable( ns(nstable), paste("Posicion", cam)
#                                 ,yuiDataTable(ns(nstable))
#                                )
#                          )
#            }
#            cameraData = function(camera, df) {
#               sfx = titleCase(camera)
#               dt = preparePosition(df, camera)
#               lhs = paste0("output$tblPos", sfx)
#               rhs = "yataDTRender({dt}, type='position')"
#               eval(parse(text=paste0(lhs," = ", rhs)))
#            }
#            # if (!is.null(pnl$data$dfGlobal)) {
#            #     insertUI( paste0("#", id, "_block_", row, "_", col, "_content")
#            #              ,where = "afterBegin"
#            #              ,ui=pnl$ui$Position
#            #              ,immediate=TRUE)
#            #     message("Datos globales no estan vacios")
# 
#                dt = preparePosition(pnl$data$dfGlobal, "Global")
#                # plt = yataDTRender({dt}, type="position")
#                output$tblPosGlobal  = yataDTRender({dt}, type="position")
#            #}
# #            removeUI(makeID("posCameras"), immediate = TRUE)
# #            
# #            divc = tags$div(id=ns("posCameras"))
# #            
#             # cameras = pnl$data$position
#             # divs = lapply(names(cameras), function(camera) cameraUI(camera))
# #            tagAppendChildren(ns("posC#ameras"), divs)
# #            insertUI(paste0("#", ns("posCameras")), where = "afterBegin", ui=divs,  immediate=TRUE)           
# 
# #           lapply(names(cameras), function(camera) cameraData(camera, cameras[[camera]]))
      }
       renderBest = function() {
          period = c("Hora", "Semana", "Dia", "Mes")
          lbl = period[as.integer(input$cboBestFrom)]
          output$lblBest = updLabelText(paste("Mejores", lbl))
          output$lblTop  = updLabelText(paste("Top:  Mejores", lbl))
          output$lblFav  = updLabelText(paste("Favoritos: Mejores", lbl))
          dt1 = prepareBest(pnl$data$dfBest)
          if (!is.null(dt1)) output$tblBest = yataDTRender({dt1}, type="best")
          dt2 = prepareBest(pnl$data$dfTop)
          if (!is.null(dt2)) output$tblTop = yataDTRender({dt2}, type="best")
          dt3 = prepareBest(pnl$data$dfFav)
          if (!is.null(dt3)) output$tblFav = yataDTRender({dt3}, type="best")


# #         message("renderData ", object)
#            if (object == "Position") {            # Position es especial
#              message("Render Position")
# #               renderPosition(row, col)
#                return()
#            }
#            prfx = ifelse(row == 1, "plot", "table")
#            eval(parse(text=paste0("output$", prfx, col, "=", prfx, object,"('", prfx, col, "')")))
       }
#        renderPlot = function(type) {
#            # Plots son fila 1
#            if (pnl$layout[1,1] == type) output$plot1 = eval(parse(text=paste0("plot", type, "('plot1')")))
#            if (pnl$layout[1,2] == type) output$plot2 = eval(parse(text=paste0("plot", type, "('plot2')")))
#        }
       plotHist = function(uiPlot) {
          df = NULL
          if (length(pnl$data$dfHist) > 0) {
              df = pnl$data$dfHist[[1]][,c(1,8)]
              df$tms = as.Date(df$tms)
              if (length(pnl$data$dfHist) > 1) {
                  for (idx in 2:length(pnl$data$dfHist)) {
                       df2 = pnl$data$dfHist[[idx]][,c(1,8)]
                       df2$tms = as.Date(df2$tms)
                       df = full_join(df, df2, by="tms")
                  }
              }
          }
          info = pnl$getPlotInfo("plotHist", uiPlot)
          plt = yataPlot(info, df, "Open positions")
          updPlot(plt, uiPlot)


#           updPlotNoData()
#            if (length(pnl$data$lstHist) == 0) return (NULL)
#            info = pnl$getPlotInfo("Hist", uiPlot)
#            if (length(pnl$data$lstHist) > 1) {
#                data = lapply(pnl$data$lstHist, function(df) df[,"close"])
#                tms = pnl$data$lstHist[[1]]$tms
#                df = as.data.frame(data)
#                df = cbind(tms, df)
#                info$type = "Linear"
#                info$src  = "price"
#                title = "Historico posicion"
#            } else {
#                df = pnl$data$lstHist[[1]]
#                info$type = "Candlestick"
#                info$src  = "session"
#                title = names(pnl$data$lstHist)[1]
#            }
#            plot = yataPlot(info, df, title)
#            if (input$chkOper && !is.null(pnl$data$dfOper)) {
#                plot = yataPlotXLines(plot, pnl$data$dfOper[,c("counter", "price", "tms")])
#            }
#            updPlot(plot)
       }
       plotBest = function(uiPlot) {
#           df = pnl$data$dfBestHist
#           if (is.null(df)) return (NULL)
#           info = pnl$getPlotInfo("plotBest", uiPlot)
#          plt = yataPlot(info, df, "Title 1")
#          updPlot(plt)
       }
       plotTop = function(uiPlot) {
#           df = pnl$data$dfTopHist
#           if (is.null(df)) return (NULL)
#           info = pnl$getPlotInfo("plotTop", uiPlot)
#           plt = yataPlot(info, df, "Title 2")
#           updPlot(plt)
       }
       plotSession = function(uiPlot) {
          df = pnl$data$dfSession
#          if (!is.null(pnl$data$dfSession)) df = spread(df, symbol, price)
          info = pnl$getPlotInfo("plotSession", uiPlot)
          plt = yataPlot(info, pnl$data$dfSession, "Current Session")
          updPlot(plt, uiPlot)
       }
       plotFav = function(uiPlot) {
       }

      ######################################################
      ### REST                                          ###
      #####################################################

       getHistorical = function(id) {
           if (id == 0) return()
           to = Sys.Date()
           from = to - as.difftime(pnl$vars$history, unit="days")
           restdf("hist",id=id,from=from,to=to)  %>%
              then( function(df) {
                  if (nrow(df) > 0) {
                      cols = colnames(df)
                      pnl$data$dfHist[[cols[length(cols)]]] = df
                  }
                   },function(err)    {
                      message("ha ido mal 3") ; message(err)
                   })
           #  df =  restdf("hist",id=id,from=from,to=to)
           # pnl$updateHistorical(id, df, type)
           # renderPlot(type)
        }
       getHistory = function(id) {
           if (id == 0) return()
           to = Sys.Date()
           from = to - as.difftime(32, unit="days")
           restdf("hist",id=id,from=from,to=to)  %>%
              then( function(df) {
                    if (nrow(df) > 0) {
                        browser()
                        df = df[,c(1, ncol(df))]
                        pnl$updateHistory(id, df, colnames(df)[2])
                        renderPlot("plotSession")
                    }
                   },function(err)    {
                      message("ha ido mal 3") ; message(err)
                   })
           # df =  restdf("hist",id=id,from=from,to=to)
           # df = df[,c(1, ncol(df))]
           # pnl$updateHistory(id, df, colnames(df)[2])
        }

# 
#       if (pnl$isInvalid()) pnl$reset()
#       
#       #####################################################
#       ### Observers                                     ###     
#       #####################################################
# 
#       observeEvent(input$tblBest_rows_selected, {
#           pnl$vars$rowBest = input$tblBest_rows_selected
#           id = pnl$data$dfBest[input$tblBest_rows_selected, "id"]
#           getHistorical(id, "Best")
#       })
#       observeEvent(input$tblTop_rows_selected, {
#           pnl$vars$rowTop = input$tblTop_rows_selected
#           id = pnl$data$dfTop[input$tblTop_rows_selected, "id"]
#           getHistorical(id, "Top")
#       })
#        
#       observeEvent(input$modebar, {
#           info = input$modebar
#           pnl$vars$info[[info$plot]] = info
#           if (info$ui == "plot1")  output$plot1 = updPlot({makePlot(info$plot, "plot1")})
#           if (info$ui == "plot2")  output$plot2 = updPlot({makePlot(info$plot, "plot2")})
#       })
#        makePlot = function(idPlot, uiPlot) {
# #           df = pnl$getPlotDF(idPlot)
#            info = pnl$getPlotInfo(idPlot, uiPlot)
#            
#            title = names(which(pnl$plots == idPlot))
#            # if (idPlot == "plotBest") {
#            #     info$src = "session"
#            #     df  = pnl$data$dfBest
#            #     row = pnl$vars$rowBest
#            #     title = paste0(df[row, "symbol"], " - ", df[row, "name"])
#            # }
#            # else {
#            #   info$src = "price"
#            # }
# 
#            if (is.null(df)) return (NULL)
#            # Tira de widgetsPlot
# #           plot = eval(parse(text=paste0(idPlot, "(info, df, title)")))
#        }
#       
#     #####################################################
#     ### Timers                                        ###     
#     #####################################################
#       
#     observe({ # Se ejecuta una sola vez
#        invalidateLater(pnl$vars$first * 1000, session)
#        if (pnl$vars$first == Inf) return()
#            if (pnl$vars$first > 1) {
#                updateData()
#                loadHistorical()
#                pnl$vars$first = Inf
#            } else {
#                pnl$vars$first = pnl$vars$first + 1            
#            }
#        })
    observe({
       invalidateLater(pnl$vars$interval * 60000)
       if (pnl$vars$first != Inf) return()  # Se ha ejecutado la primera vez
       output$dtLast = renderText({format.POSIXct(Sys.time(), format="%H:%M:%S")})
       pnl$updateData()
       renderPanel()
         #    browser()
         #    df = df[order(df$tms, decreasing=TRUE),]
         #    browser()
         # # getBest(input$numBestTop, input$cboBestFrom, TRUE )
         # # getBest(input$numBestTop, input$cboBestFrom, FALSE )
         # pnl$monitors$update()
         # data = pnl$monitors$getLast()
         # dfp = data[,c("tms", "symbol", "price")]
         # dfp$tms = as.POSIXct(dfp$tms, format="%H:%M:%S")
         # if (is.null(pnl$data$dfSession)) {
         #     pnl$data$dfSession = dfp
         # } else {
         #     pnl$data$dfSession = rbind(pnl$data$dfSession, dfp)
         # }
         # pnl$updateBest()

    })

     #################################################
     ### Panel Izquierdo
     #################################################

      observeEvent(input$chkMonitors,{ shinyjs::toggle("monitor", anim=TRUE) }, ignoreInit = TRUE)
      observeEvent(input$cboPlot1, { 
        output$plot1 = eval(parse(text=paste0("plot", input$cboPlot1, "('plot1')")))
      },ignoreNULL = TRUE, ignoreInit = TRUE)
      observeEvent(input$cboPlot2, {
        output$plot2 = eval(parse(text=paste0("plot", input$cboPlot2, "('plot2')")))
      },ignoreNULL = TRUE, ignoreInit = TRUE)
      observeEvent(input$cboData1, {
        session$sendCustomMessage('yataShowBlock',list(ns=id,row=3,col=1,block=input$cboData1))
      },ignoreNULL = TRUE, ignoreInit = TRUE)
      observeEvent(input$cboData2, {
        session$sendCustomMessage('yataShowBlock',list(ns=id,row=3,col=2,block=input$cboData2))
      },ignoreNULL = TRUE, ignoreInit = TRUE)
      observeEvent(input$cboBestFrom, { 
          if (is.integer(input$cboBestFrom)) { # Evitar datos malos
              pnl$vars$best$from = input$cboBestFrom
              updateBest() 
          }
      },ignoreNULL = TRUE, ignoreInit = TRUE)
      observeEvent(input$numBestTop, { 
          if (is.integer(input$numBestTop)) { # Evitar datos malos
              pnl$vars$best$top = input$numBestTop
              updateBest() 
          }
      },ignoreNULL = TRUE, ignoreInit = TRUE)

#
#       observeEvent(input$btnLayoutOK, {
#           pnl$vars$best$top  = input$numBestTop
#           pnl$vars$best$from = input$cboBestFrom
#           pnl$setInterval(input$numInterval)
#           pnl$vars$history = input$numDays
#           pnl$setCookies( best = pnl$vars$best, layout=pnl$layout
#                          ,days=pnl$vars$history, interval = pnl$vars$interval)
#           session$sendCustomMessage(type = 'closeLeftSide',message = "close")
#       })
#       observeEvent(input$btnLayoutKO, { 
#           session$sendCustomMessage(type = 'closeLeftSide',message = "close")
#           updateLeftSide() 
#        })
      
        if (!pnl$loaded || pnl$isInvalid()) {
            pnl$loadData()
            renderUIPosition()
            renderPosition()
            pnl$monitors$render() 
            lapply(pnl$data$dfGlobal$id, function(id) getHistorical(id))
            updateLeftSide()
            output$plot1 = eval(parse(text=paste0("plot", pnl$vars$layout[1,1], "('plot1')")))
            output$plot2 = eval(parse(text=paste0("plot", pnl$vars$layout[1,2], "('plot2')")))
         }       
      
   })
}    
