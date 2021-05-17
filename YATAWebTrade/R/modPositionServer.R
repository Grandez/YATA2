# Cada modulo lleva asociado un objeto
# es el que gestiona la creacion del objeto y guarda sus variables

modPosServer <- function(id, full, pnlParent, parent=NULL) {
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
             self$vars$sessionChanged = FALSE
             private$loadPosition()
           
             self$monitors = OBJMonitors$new(ns("monitor"), self, YATAWEB)
             if (!is.null(self$data$dfGlobal)) {
                 ctc = self$data$dfGlobal$currency
                 self$data$dfSession = self$session$getSessionPrices(ctc)
                 self$vars$sessionChanged = TRUE
             }
             
             self$updateBest()
             self$loaded = TRUE
             invisible(self)
         }
         ,updateData = function() {
             self$updateBest()
             self$vars$sessionChanged = FALSE
             lastr = nrow(self$data$dfSession)
             lastc = ncol(self$data$dfSession)
             dfLast = self$session$getSessionPrices(self$data$dfGlobal$currency)
             if (is.null(self$data$dfSession) || nrow(self$data$dfSession) == 0) {
                 self$data$dfSession = dfLast
                 self$vars$sessionChanged = ifelse(is.null(dfLast), FALSE, TRUE)
                 return()
             }
             # Por si acaso hay nuevas monedas lo hacemos en dos partes
             dfAux = dfLast[, colnames(dfLast) %in% colnames(self$data$dfSession)]
             if (ncol(dfAux) > 0) self$data$dfSession = rbind(self$data$dfSession, dfAux)
             
             news = which(! colnames(dfLast) %in% colnames(self$data$dfSession))
             if (length(news) > 0) {
                 dfAux = df[,c("tms", colnames(dfLast)[[news]])]
                 self$data$dfSession = full_join(self$data$dfSession, dfAux, "tms")
             }
             if (nrow(self$data$dfSession) == lastr && ncol(self$data$dfSession) == lastc) 
                 self$vars$sessionChanged = FALSE
         }
         ,loadHistory = function(id, symbol, df) {
             if (!is.data.frame(df)) return()
             if (nrow(df) == 0)      return()
             df$tms = as.Date(df$tms)
             self$data$lstHist[[symbol]] = list(id=id,symbol=symbol, df=df)
         }
         ,getHistory = function(symbol) { self$data$lstHist[[symbol]]$df }
         ,getPlots   = function()       { private$cboplots   }
         ,getPlot    = function(plot)   { self$plots[[plot]] }
         ,getTables  = function()       { private$tables }  
         ,getDFTable = function(table)  {
             if (table == "Best") return(self$data$dfBest)
             if (table == "Top")  return(self$data$dfTop)
             if (table == "Fav")  return(self$data$dfFav)
             NULL
         }
          
         ,updateBest = function() {
            df = self$session$getLatest()
            self$data$dfBest = private$sortBest(df,   0)
            self$data$dfTop  = private$sortBest(df,  26)
            self$data$dfFav  = private$sortBest(df, 101)                        
          }
    )
    ,private = list(
        cboplots = c( "Position"  = "Hist", "Session"  = "Session"
                     ,"Best Info" = "Best", "Top Info" = "Top"
        )
        ,tables = c( "Position"    = "Position", "Best"              = "Best"
                    ,"Best of Top" = "Top"     , "Best of favorites" = "Fav"
         )
        ,defaultValues = function() {
             self$cookies$interval = 15
             self$cookies$best = list(top = 10, from = 2)
             self$cookies$history = 15
             self$cookies$layout = matrix(c("plotHist","blkTop","plotSession","Position"),ncol=2)
             self$cookies$position = "Global"
             self$data$dfGlobal = NULL
        }
       ,loadPosition = function() {
           df = self$getGlobalPosition() # (fiat=TRUE)
           if (is.null(df)) return()
           df = cbind(df, day=0, week=0, month=0)
           self$data$dfGlobal = df
           self$vars$selected[["PosGlobal"]] = df$currency
           cameras = self$position$getCameras()
           self$data$position = lapply(cameras,
                     function(camera) {df = self$position$getCameraPosition(camera)
                                       if (nrow(df) == 0) return (NULL) 
                                        df = cbind(df, day=0, week=0, month=0)
                                    })
           names(self$data$position) = cameras
        }
        ,makePlots = function() {
            info  = list(type="Line", observer=ns("modebar"), scale="date")
            plots = c("plotHist","plotTop","plotBest","plotFav")
             
            self$plots[["plotSession"]] = YATAPlot$new("plotSession", info=info, scale="time", title="Current session") 
            for (plt in plots) self$plots[[plt]] = YATAPlot$new(plt, info=info) 
        }
       ,sortBest = function(df, first) {
           cols = c("hour", "day", "week", "month")
           col = cols[as.integer(self$cookies$best$from)]
           rows = self$cookies$best$top
           if (first > 0) df = df[df$rank <  first,]
           dfb = df[order(df[,col],decreasing=TRUE),]
           dfb = dfb[1:rows,]
           # dfb$hour  = dfb$hour  / 100
           # dfb$day   = dfb$day   / 100
           # dfb$week  = dfb$week  / 100
           # dfb$month = dfb$month / 100
           dfb
       }
      )
    )
   #####################################################################
   ### FUNCTIONS                                                     ###
   #####################################################################   
   preparePosition = function(df, table) {
      types = list(dat = c("Since"), pvl = c("Day", "Week", "Month"))
      df =  df %>% select(currency,balance, priceBuy, priceSell, price, day, week, month, since)
      df$since = as.Date(df$since)
      colnames(df) = c("currency", "balance", "cost", "return", "net", "day", "week", "month", "since")
#      yataDT(df,opts=list(types=types,color=list(var=c("Day", "Week", "Month"))))
      data = list(df = df, cols=NULL, info=NULL)
      data$info=list( event=ns("tablePos"), target=table,types=types)
      data
   }
   prepareBest = function(df, table) {
      if (is.null(df)) return (NULL)
      df =  df %>% select(symbol, price, hour, day, week, month)
      df$symbol = YATAWEB$getCTCLabels(df$symbol)
      data = list(df = df, cols=NULL, info=NULL)
      data$info=list( event=ns("tableBest"), target=table
                     ,types=list(pvl = c("Hour", "Day", "Week", "Month"), imp=c("Price"))
                     ,buttons = list(Button_buy=yuiBtnIconBuy("Comprar"))
                    )
      data
    }
    moduleServer(id, function(input, output, session) {
#       YATAWEB$beg("Position Server")
       pnl = YATAWEB$getPanel(id)
       if (is.null(pnl)) pnl = YATAWEB$addPanel(PNLPos$new(session))

       flags = reactiveValues(
            position  = FALSE
           ,best      = FALSE
           ,history   = 15
           ,refresh   = FALSE
           ,update    = FALSE
           ,plotsBest = FALSE
           ,plotPos   = FALSE
           ,table     = FALSE
           ,tablePos  = FALSE
           ,tab       = FALSE
       )
       initPage = function() {
          YATAWEB$beg("initPage")
          renderUIPosition()    # Preparar tabla posiciones
          updNumericInput("numInterval", pnl$cookies$interval)
          output$dtLast = updLabelDate({Sys.time()})
          isolate(updNumericInput("numBestTop", pnl$cookies$best$top))
          updCombo("cboBestFrom", selected = pnl$cookies$best$from)
          updNumericInput("numInterval", value = pnl$cookies$interval)
          updNumericInput("numHistory",  value = pnl$cookies$history)
          updRadio("radPosition",        selected = pnl$cookies$position)
          pnl$monitors$render() 

          # Este es el que tarda por que es Windows
          df = pnl$data$dfGlobal
          if (is.null(df)) return()
          df = df[df$id != 0,]
          
          # Si usamos for, no se evaluan los datos
          if (nrow(df) > 0) {
              dat = paste(df[,"currency"], df[,"id"], sep="-")
              lapply(dat, function(x) getHistorical(x))
          }
          YATAWEB$end("initPage")
       }
       ###########################################################
       ### Reactives
       ###########################################################

       observeEvent(flags$position, ignoreInit = TRUE, {
           YATAWEB$beg("flags$position")
           if (is.null(pnl$data$dfGlobal)) return()
           pnl$cookies$position = flags$position
          if (input$radPosition == "Cameras") {
              shinyjs::hide("posGlobal")
          } else {
              shinyjs::show("posGlobal")

               data = preparePosition(pnl$data$dfGlobal, "PosGlobal")
               if (!is.null(data$df)) {
                   output$tblPosGlobal = updTableMultiple(data)
                   sel = c(which(data$df$currency %in% pnl$vars$selected[["PosGlobal"]]))
                   updTableSelection("tblPosGlobal", sel)
                   #updateReactable("tblPosGlobal", selected = sel)
               }
           }
           cameras = pnl$data$position  
           if (input$radPosition == "Global" || length(cameras) == 0) {
               shinyjs::hide("posCameras")
           } else {
               shinyjs::show("posCameras")
               lapply(names(pnl$data$position), function(camera) {
                      if (!is.null(pnl$data$position[[camera]])) {
                          sfx = titleCase(camera)
                          data  = preparePosition(pnl$data$position[[camera]], paste0("Pos", sfx))
                          eval(parse(text=paste0("output$tblPos", sfx, " = updTable(data)")))
                      }
               })
           }
           YATAWEB$end("flags$position")
       })       
       observeEvent(flags$best, ignoreInit = TRUE, {
           YATAWEB$beg("flags$best")
          from = as.numeric(input$cboBestFrom)
          if (is.na(from)) return() 
          if (pnl$cookies$best$from == from && pnl$cookies$best$top == input$numBestTop) return()
          pnl$cookies$best$from = from
          pnl$cookies$best$top  = input$numBestTop
          pnl$updateBest()
          renderBestTables()
          YATAWEB$end("flags$best")
       })
       observeEvent(flags$refresh, ignoreInit = TRUE, { 
          YATAWEB$beg("refresh")
          pnl$monitors$update() 
          flags$position = isolate(!flags$position)
          renderBestTables()
          renderPlotSession()
          YATAWEB$end("refresh")
       })
       observeEvent(flags$update, ignoreInit = TRUE, { 
          YATAWEB$beg("update")
          pnl$updateData()
          flags$refresh = isolate(!flags$refresh)
          YATAWEB$end("update")
       })
       observeEvent(flags$history, ignoreInit = TRUE, ignoreNULL = TRUE, {
           YATAWEB$beg("history")
          if (is.na(flags$history)) return()
          if (flags$history != pnl$cookies$history) {
              pnl$cookies$history = flags$history
          }
           YATAWEB$end("history")
       })
       observeEvent(flags$table, ignoreInit = TRUE, {
           table = pnl$vars$table$target
           row   = pnl$vars$table$row
           df    = pnl$getDFTable(table)

           # Update table
           symbol = df[row,"symbol"]
           id     = df[row,"id"]
           sel = pnl$vars$selected[[table]]
           if (!is.null(sel)) {
               idx = which(sel == symbol)
               if (length(idx) > 0) sel = sel[-idx]
               else                 sel = c(sel, symbol)
           } else {
               sel = c(symbol)
           }
           pnl$vars$selected[[table]] = sel               
           updateReactable(paste0("tbl", table), selected = c(which(df$symbol == sel)))

           # Update plot
           df = pnl$getHistory(symbol)
           pnl$vars$table$symbol = symbol
           if (is.null(df)) {
               getHistorical(paste(symbol, id, sep="-"), table)
           } else {
               flags$plotsBest = isolate(!flags$plotsBest)
           }       
       })
       observeEvent(flags$tablePos, ignoreInit = TRUE, {
           table = "PosGlobal"
           row   = pnl$vars$table$row
           df    = pnl$data$dfGlobal

           # Update table
           symbol = df[row,"currency"]
           id     = df[row,"id"]
           sel = pnl$vars$selected[[table]]
           if (!is.null(sel)) {
               idx = which(sel == symbol)
               if (length(idx) > 0) sel = sel[-idx]
               else                 sel = c(sel, symbol)
           } else {
               sel = c(symbol)
           }
           pnl$vars$selected[[table]] = sel               
           updTableSelection(paste0("tbl", table),c(which(df$currency %in% sel)))

           # Update plots
           plot = pnl$plots[["plotSession"]]
           data = plot$getSourceNames()
           names = plot$getColumnNames(data)
           plot$selectColumns("session", pnl$vars$selected[["PosGlobal"]])
           renderPlotSession()
           plot = pnl$plots[["plotHist"]]
           plot$setSourceNames(pnl$vars$selected[["PosGlobal"]])
           output$plotHist = plot$render()
       })
       
       observeEvent(flags$tab, ignoreInit = TRUE, {
           table = pnl$vars$table$target
           row   = pnl$vars$table$row
           df    = pnl$getDFTable(table)

           action = strsplit(pnl$vars$table$colName, "_")[[1]][2]
           
           if (action == "buy") {
               carea = pnl$getCommarea()
               carea$action = action
               carea$pending = TRUE
               carea$data = list(id=df[row,"id"], symbol=df[row,"symbol"], price=df[row,"price"])
               pnl$setCommarea(carea)
               updateTabsetPanel(parent, inputId="mainMenu", selected=panel$oper)
           }
       })
       observeEvent(flags$plotsBest, ignoreInit = TRUE, {
           YATAWEB$beg("plotsBest")
           table = pnl$vars$table
           plot = pnl$getPlot(paste0("plot", table$table))
           sym = table$symbol
           plotted = plot$hasSource(sym)
           if (!plotted) {
               data =  pnl$data$lstHist[[sym]]
               plot$addData(data$df, sym)
           } else {
               plot$removeData(sym)
           }
           if (table$table == "Best") output$plotBest = plot$render()
           if (table$table == "Top")  output$plotTop  = plot$render()
           if (table$table == "Fav")  output$plotFav  = plot$render()
           YATAWEB$end("plotsBest")
       })
       observeEvent(flags$plotPos, ignoreInit = TRUE, {
           YATAWEB$beg("plotPos")
           plot = pnl$plots[["plotHist"]]
           plot$setTitle(pnl$MSG$get("PLOT.TIT.HISTORY"))
           name = flags$plotPos
           if(!plot$hasSource(flags$plotPos)) {
               df = pnl$getHistory(name)
               if (!is.null(df)) {
                   plot$addData(df, name, "pepe")
               }
           }
           output$plotHist = plot$render("plotHist")    
           YATAWEB$end("plotPos")
       })

       ###########################################################
       ### END Reactives
       ###########################################################

       renderUIPosition = function() {
           YATAWEB$beg("renderUIPosition")
          cameraUI = function(camera) {
             suffix  = titleCase(camera)
             cam     = pnl$cameras$getCameraName(camera)
             nstable = paste0("tblPos", suffix)
             tags$div( id=paste0("divPos", suffix)
                      ,yuiBoxClosable( ns(nstable), paste("Posicion", cam)
                                      ,yuiTable(ns(nstable))
                                     )
                  )
          }
          removeUI(paste0("#", ns("posCameras")), immediate = TRUE)
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
          YATAWEB$end("renderUIPosition")
      }
       renderBestTables = function() {
          YATAWEB$beg("renderBest")
          period = c("Hora", "Dia", "Semana", "Mes")
          lbl = period[as.integer(input$cboBestFrom)]

          output$lblBest = updLabelText(paste("Mejores", lbl))
          output$lblTop  = updLabelText(paste("Top:  Mejores", lbl))
          output$lblFav  = updLabelText(paste("Favoritos: Mejores", lbl))
          # WATCH Lazy evaluation
          data1 = prepareBest(pnl$data$dfBest, "Best")
          if (!is.null(data1$df)) output$tblBest = updTableMultiple(data1)
          data2 = prepareBest(pnl$data$dfTop, "Top")
          if (!is.null(data2$df)) output$tblTop = updTableMultiple(data2)
          data3 = prepareBest(pnl$data$dfFav, "Fav")
          if (!is.null(data3$df)) output$tblFav = updTableMultiple(data3)
          YATAWEB$end("renderBest")
       }
       renderPlotSession = function(uiPlot) {
#          if (pnl$vars$sessionChanged) {
              plot = pnl$plots[["plotSession"]]
              plot$setType("Marker")
              plot$setData(pnl$data$dfSession, "session", TRUE)
              output$plotSession = plot$render()
#          }
       }
       
      #####################################################
      ### REST                                          ###
      #####################################################

       getHistorical = function(data, plot=NULL) {
           toks = strsplit(data, "-")[[1]]
           id = as.integer(toks[2])
           symbol = toks[1]
           if (id == 0) return()
           to = Sys.Date()
           from = to - as.difftime(pnl$cookies$history, unit="days")
           restdf("hist",id=id,from=from,to=to)  %>% then(
                  function(df) {
                     pnl$loadHistory(id, symbol, df)
                     if (is.null(plot))  flags$plotPos = isolate(symbol)
                     if (!is.null(plot)) flags$plotsBest = isolate(!flags$plotsBest)
                  }, function(err) { })
      } 

      #####################################################
      ### Observers                                     ###
      #####################################################

      observeEvent(input$tableBest, ignoreInit = TRUE, {
           pnl$vars$table = input$tableBest
           if (!startsWith(input$tableBest$colName, "Button")) {
               flags$table = isolate(!flags$table)
           } else {
               flags$tab = isolate(!flags$tab)
           }
       })
      observeEvent(input$tablePos, {
           pnl$vars$table = input$tablePos
           if (!startsWith(input$tablePos$colName, "Button")) {
               flags$tablePos = isolate(!flags$tablePos)
           } else {
               flags$tab = isolate(!flags$tab)
           }
       })
       
      observeEvent(input$modebar, {
          info = input$modebar
          pnl$vars$info[[info$render]] = info
          eval(parse(text=paste0("output$", info$ui, "=", info$render, "('", info$ui, "', info)")))
      })

     #################################################
     ### Panel Izquierdo
     #################################################

      observeEvent(input$radPosition, ignoreInit = TRUE, { flags$position = isolate(!flags$position) })
      observeEvent(input$cboBestFrom, ignoreInit = TRUE, { flags$best = isolate(!flags$best)         })
      observeEvent(input$numBestTop,  ignoreInit = TRUE, { flags$best = isolate(!flags$best)         })
      observeEvent(input$numInterval, ignoreInit = TRUE, { 
          if (is.numeric(input$numInterval)) {
          pnl$cookies$interval = input$numInterval              
          }
      })
      observeEvent(input$numHistory,  ignoreInit = TRUE, { flags$history = isolate(input$numHistory) })
      observeEvent(input$chkMonitors, ignoreInit = TRUE, { 
         pnl$cookies$monitor = input$chkMonitors
         shinyjs::toggle("monitor", anim=TRUE) 
      })
      observeEvent(input$btnLayoutOK, {
          pnl$setCookies()
          session$sendCustomMessage(type = 'closeLeftSide',message = "close")
      })
      observeEvent(input$btnLayoutKO, { 
         session$sendCustomMessage(type = 'closeLeftSide',message = "close") 
      })

     #####################################################
     ### Timers                                        ###
     #####################################################

     carea = pnl$getCommarea()  
     if (!pnl$loaded || carea$position) {
          yuiLoading()
          pnl$loadData()
          initPage()
          if (carea$position) {
              carea$position = FALSE
              pnl$setCommarea(carea)
          }
          yuiLoaded()
     }       

     # Despues de cargar SIEMPRE      
     observe({
       invalidateLater(pnl$cookies$interval * 60000)
       flags$update = isolate(!flags$update)   
     })

      
      # YATAWEB$end("Position Server")
   })
}    
