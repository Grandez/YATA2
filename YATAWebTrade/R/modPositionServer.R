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
         ,session     = NULL
         ,monitors    = NULL
         ,plots = list()
         ,initialize    = function(session) {
             private$defaultValues()
             super$initialize(id, pnlParent, session, ns)
             self$position  = self$factory$getObject(self$codes$object$position)
             self$cameras   = self$factory$getObject(self$codes$object$cameras)
             self$session   = self$factory$getObject(self$codes$object$session)
             self$data$lstHist = list()
             private$makePlots()
         }
         ,loadData = function() {
             private$loadPosition()
             self$monitors = BLK.MONITORS$new(ns("monitor"), self, YATAWEB)
             ctc = self$data$dfGlobal$currency
             self$data$dfSession = self$session$getPrices(ctc)
             self$updateBest()
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
         ,loadHistory = function(id, symbol, df) {
             if (!is.data.frame(df)) return()
             if (nrow(df) == 0)      return()
             df$tms = as.Date(df$tms)
             self$data$lstHist[[symbol]] = list(id=id,symbol=symbol, df=df)
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
         ,getHistory = function(symbol) { self$data$lstHist[[symbol]]$df }
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
                 info$render = idPlot
                 info$datavalue = "Value" 
                 if (idPlot %in% c("plotSession", "plotHist")) {
                     info$datasource  = "value"
                     info$plot = "Line"
                     info$type = "Line"
                 }
                 else {
                     info$datasource  = "session"
                     info$plot = "Candlestick"
                     info$type = "Candlestick"
                 }
                 self$vars$info[[uiPlot]][[idPlot]] = info
             }
             info
         }
        # ,getPositionID = function() {
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
        ,getPlots  = function() { private$cboplots  }
        ,getTables = function() { private$tables }  
        ,updateBest = function() {
            df = self$session$getLatest()
            self$data$dfBest = private$sortBest(df,   0)
            self$data$dfTop  = private$sortBest(df,  26)
            self$data$dfFav  = private$sortBest(df, 101)                        
      }
          
    )
    ,private = list(
         #   opIdx      = list()
         #  ,monitor   = NULL 
         cboplots = c( "Position" = "Hist", "Session" = "Session"
                   ,"Best Info"  = "Best", "Top Info" = "Top"
         )
         ,tables = c( "Position"    = "Position", "Best"              = "Best"
                     ,"Best of Top" = "Top"     , "Best of favorites" = "Fav"
         )
        ,defaultValues = function() {
             self$cookies$interval = 15
             self$cookies$best = list(top = 10, from = 2)
             self$cookies$history = 15
             self$cookies$layout = matrix(c("plotHist","blkTop","plotSession","Position"),ncol=2)
             self$cookies$position = "All"
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
         ,makePlots = function() {
             info  = list(type="Line", observer=ns("modebar"), scale="date")
             plots = c("plotHist","plotTop","plotBest","plotFav")
             
             self$plots[["plotSession"]] = OBJPlot$new("plotSession", info=info, scale="time") 
             for (plt in plots) self$plots[[plt]] = OBJPlot$new(plt, info=info) 
          }
         ,sortBest = function(df, first) {
             cols = c("hour", "day", "week", "month")
             col = cols[as.integer(self$cookies$best$from)]
             rows = self$cookies$best$top
             if (first > 0) df = df[df$rank <  first,]
             dfb = df[order(df[,col],decreasing=TRUE),]
             dfb[1:rows,]
          }
       )
    )
   #####################################################################
   ### FUNCTIONS                                                     ###
   #####################################################################   
   preparePosition = function(df) {
      types = list(dat = c("Since"), prc = c("Day", "Week", "Month"))
      df =  df %>% select(currency,balance, priceBuy, priceSell, price, day, week, month, since)
      df$since = as.Date(df$since)
      colnames(df) = c("currency", "balance", "cost", "return", "net", "day", "week", "month", "since")
      yataDT(df,opts=list(types=types,color=list(var=c("Day", "Week", "Month"))))
    }
    prepareBest = function(df) {
       prc = c("Hour", "Day", "Week", "Month")
       if (is.null(df)) return (NULL)
       df =  df %>% select(symbol, price, hour, day, week, month)
       df$symbol = YATAWEB$getCTCLabels(df$symbol)

       dt = yataDT(df,opts=list(types=list(prc=prc),color=list(var=prc)))
       dt
    }

    moduleServer(id, function(input, output, session) {
       YATAWEB$beg("Position Server")
       pnl = YATAWEB$getPanel(id)
       if (is.null(pnl)) pnl = YATAWEB$addPanel(PNLPos$new(session))
       flags = reactiveValues(
            position  = FALSE
           ,best      = FALSE
           ,history   = 15
           ,refresh   = FALSE
           ,plotsBest = FALSE
           ,plotPos   = ""
           ,table     = ""
       )
       initPage = function() {
          renderUIPosition()    # Preparar tabla posiciones
          updNumericInput("numInterval", pnl$cookies$interval)
          output$dtLast = updLabelDate({Sys.time()})
          isolate(updNumericInput("numBestTop", pnl$cookies$best$top))
          updCombo("cboBestFrom", selected = pnl$cookies$best$from)
          updNumericInput("numInterval", value = pnl$cookies$interval)
          updNumericInput("numHistory",  value = pnl$cookies$history)

#          pnl$monitors$render() 
          # Este es el que tarda por que es Windows
          df = pnl$data$dfGlobal
          df = df[df$id != 0,]
          if (nrow(df) > 0) for (row in 1:nrow(df)) getHistorical(df[row,"id"], df[row,"currency"])
       }
       ###########################################################
       ### Reactives
       ###########################################################
       observeEvent(flags$position, ignoreInit = TRUE, {
           pnl$cookies$position = flags$position
           if (input$radPosition == "Cameras") {
               shinyjs::hide("posGlobal")
           } else {
               shinyjs::show("posGlobal")
               dt = preparePosition(pnl$data$dfGlobal)
               output$tblPosGlobal  = yataDTRender({dt}, type="position")
           }
           cameras = pnl$data$position  
           if (input$radPosition == "Global" || length(cameras) == 0) {
               shinyjs::hide("posCameras")
           } else {
               shinyjs::show("posCameras")
               lapply(names(pnl$data$position), function(camera) {
                      sfx = titleCase(camera)
                      dt = preparePosition(pnl$data$position[[camera]])
                      lhs = paste0("output$tblPos", sfx)
                      rhs = "yataDTRender({dt}, type='position')"
                      eval(parse(text=paste0(lhs," = ", rhs)))
               })
           }
       })       
       observeEvent(flags$best, ignoreInit = TRUE, {
          from = as.numeric(input$cboBestFrom)
          if (is.na(from)) return() 
          if (pnl$cookies$best$from == from && pnl$cookies$best$top == input$numBestTop) return()
          pnl$cookies$best$from = from
          pnl$cookies$best$top  = input$numBestTop
          pnl$updateBest()
          renderBest()
       })
       observeEvent(flags$refresh, { 
            pnl$monitors$render() 
            flags$position = isolate(!flags$position)
            renderBest()
       })
       observeEvent(flags$history, ignoreInit = TRUE, ignoreNULL = TRUE, {
          if (is.na(flags$history)) return()
          if (flags$history != pnl$cookies$history) {
              pnl$cookies$history = flags$history
          }
       })
       observeEvent(flags$table, ignoreInit = TRUE, {
           if (flags$table == "best") {df = pnl$data$dfBest; row = input$tblBest_rows_selected  }
           if (flags$table == "top")  {df = pnl$data$dfTop;  row = input$tblTop_rows_selected   }
           if (flags$table == "fav")  {df = pnl$data$dfFav;  row = input$tblFav_rows_selected   }
           sym = df[row,"symbol"]
           df = pnl$getHistory(sym)
           if (is.null(df)) {
               getHistorical(df[row, "id"], sym, FALSE)
           } else {
               flags$plotsBest = isolate(!flags$plotsBest)
           }       
       })
       observeEvent(flags$plotsBest, ignoreInit = TRUE, {
           output$plotHist = updPlot(plot1, "plot12", plot1$getInfo())
           if (flags$table == "best") {df = pnl$data$dfBest; row = input$tblBest_rows_selected  }
           if (flags$table == "top")  {df = pnl$data$dfTop;  row = input$tblTop_rows_selected   }
           if (flags$table == "fav")  {df = pnl$data$dfFav;  row = input$tblFav_rows_selected   }
           sym = df[row,"symbol"]
           if (is.null(pnl$data$lstHist[[sym]])) {
               getHistory(df[row, "id"], sym)
           } else {
               flags$plotsBest = isolate(!flags$plotsBest)
           }       
       })
       observeEvent(flags$plotPos, ignoreInit = TRUE, {
           plot = pnl$plots[["plotHist"]]
           name = flags$plotPos
           if(!plot$hasSource(flags$plotPos)) {
               output$plotHist = plot$addData(pnl$getHistory(name), name, "pepe")
           }
       })

       ###########################################################
       ### END Reactives
       ###########################################################

       makeID = function(tag) { paste0("#", ns(tag)) }
       # updateBest = function() {
       #     browser()
       #     pnl$updateBest()
       #     renderBest()
       # }
                   
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
      
      renderBest = function() {
           YATAWEB$beg("renderBest")
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

          YATAWEB$end("renderBest")

       }
       plotHist = function(uiPlot, info) {
           if (length(pnl$data$dfHist) == 0) return()
           lapply(names(pnl$data$dfHist), function(name) pnl$plots[["plotHist"]]$addData(pnl$data$dfHist[[name]], name))
#             pltHist = OBJPlot$new("pltHist", plot="Line", observer=ns("modebar")
#                                   , data = pnl$data$dfHist, scale = "date")

          # df = NULL
          # if (length(pnl$data$dfHist) > 0) {
          #     df = pnl$data$dfHist[[1]][,c(1,8)]
          #     df$tms = as.Date(df$tms)
          #     if (length(pnl$data$dfHist) > 1) {
          #         for (idx in 2:length(pnl$data$dfHist)) {
          #              df2 = pnl$data$dfHist[[idx]][,c(1,8)]
          #              df2$tms = as.Date(df2$tms)
          #              df = full_join(df, df2, by="tms")
          #         }
          #     }
          # }
          # if (missing(info)) {
          #     info = pnl$getPlotInfo("plotHist", uiPlot)
          #     info$title = "Open positions"
          # }
          # plt = yataPlot(info, df)
          updPlot(pnl$plots[["plotHist"]], uiPlot)
       }
       plotBest = function(uiPlot) {
#           df = pnl$data$dfBestHist
#           if (is.null(df)) return (NULL)
#           info = pnl$getPlotInfo("plotBest", uiPlot)
#          plt = yataPlot(info, df, "Title 1")
#          updPlot(plt, info)
       }
       plotTop = function(uiPlot) {
#           df = pnl$data$dfTopHist
#           if (is.null(df)) return (NULL)
#           info = pnl$getPlotInfo("plotTop", uiPlot)
#           plt = yataPlot(info, df, "Title 2")
#           updPlot(plt, info)
       }
       plotSession = function(uiPlot) {
           pnl$plots[["plotSession"]]$addData(pnl$data$dfSession, "session", uiPlot)

#           df = pnl$data$dfSession
# #          if (!is.null(pnl$data$dfSession)) df = spread(df, symbol, price)
#           info = pnl$getPlotInfo("plotSession", uiPlot)
#           info$title = "Current Session"
#           plt = yataPlot(info, pnl$data$dfSession)
#          updPlot(pnl$plots[["plotSession"]], uiPlot)
       }
       plotFav = function(uiPlot) {
       }

      #####################################################
      ### REST                                          ###
      #####################################################

       getHistorical = function(id, symbol, position = TRUE) {
           if (id == 0) return()
           to = Sys.Date()
           from = to - as.difftime(pnl$cookies$history, unit="days")
           restdf("hist",id=id,from=from,to=to)  %>% then(
               function(df) {
                  pnl$loadHistory(id, symbol, df)
                  if (position) flags$plotPos = isolate(symbol)
               }, function(err) { })
      } 

      #####################################################
      ### Observers                                     ###
      #####################################################

      observeEvent(input$tblBest_rows_selected, { flags$table = isolate("best") })
      observeEvent(input$tblTop_rows_selected,  { flags$table = isolate("top") })
      observeEvent(input$tblFav_rows_selected,  { flags$table = isolate("fav") })

      observeEvent(input$modebar, {
          info = input$modebar
          pnl$vars$info[[info$render]] = info
          eval(parse(text=paste0("output$", info$ui, "=", info$render, "('", info$ui, "', info)")))
      })
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
       invalidateLater(pnl$cookies$interval * 60000)
#       if (pnl$vars$first != Inf) return()  # Se ha ejecutado la primera vez
     #  output$dtLast = renderText({format.POSIXct(Sys.time(), format="%H:%M:%S")})
     #  pnl$updateData()
     #  renderPanel()
         #    df = df[order(df$tms, decreasing=TRUE),]
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

      observeEvent(input$radPosition, ignoreInit = TRUE, { flags$position = isolate(!flags$position) })
      observeEvent(input$cboBestFrom, ignoreInit = TRUE, { flags$best = isolate(!flags$best)         })
      observeEvent(input$numBestTop,  ignoreInit = TRUE, { flags$best = isolate(!flags$best)         })
      observeEvent(input$numInterval, ignoreInit = TRUE, { pnl$cookies$interval = input$numInterval  })
      observeEvent(input$numHistory,  ignoreInit = TRUE, { flags$history = isolate(input$numHistory) })
      observeEvent(input$chkMonitors, ignoreInit = TRUE, { 
        pnl$cookies$monitor = input$chkMonitors
        shinyjs::toggle("monitor", anim=TRUE) 
      })

      observeEvent(input$btnLayoutOK, {
          pnl$setCookies()
          session$sendCustomMessage(type = 'closeLeftSide',message = "close")
      })
      observeEvent(input$btnLayoutKO, { session$sendCustomMessage(type = 'closeLeftSide',message = "close") })

      if (!pnl$loaded || pnl$isInvalid(pnl$id)) {
          show_modal_spinner(spin="dots") # show the modal window
          pnl$loadData()
          initPage()
          flags$refresh = isolate(!flags$refresh)
          remove_modal_spinner()
      }       
      YATAWEB$end("Position Server")
   })
}    
