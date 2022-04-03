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
      ,history     = NULL
      ,currencies  = NULL
      ,monitors    = NULL
      ,plots = list()
      ,initialize    = function(id, pnlParent, session, ns) {
          super$initialize(id, pnlParent, session, ns)
          private$defaultValues(ns)
          self$position  = Factory$getObject(self$codes$object$position)
          self$cameras   = Factory$getObject(self$codes$object$cameras)
          self$currencies= Factory$getObject(self$codes$object$currencies)
          self$session   = Factory$getObject(self$codes$object$session)
          self$history   = Factory$getObject(self$codes$object$history)
          self$data$lstHist = list()
          private$makePlots()
      }
      ,loadData = function() {
          self$vars$sessionChanged = FALSE
          private$loadPosition()
          self$monitors = WDGMonitor$new(private$ns("monitor"), self, WEB)
          if (!is.null(self$data$dfGlobal)) {
              ids = self$data$dfGlobal$id
              self$data$dfSession = self$session$getSessionPrices(ids)
              self$vars$sessionChanged = TRUE
          }
          self$monitors$render()
          self$updateBest()
          js$yata_set_layout(id)
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
              self$data$dfSession = dplyr::full_join(self$data$dfSession, dfAux, "tms")
          }
          if (nrow(self$data$dfSession) == lastr && ncol(self$data$dfSession) == lastc)
              self$vars$sessionChanged = FALSE
          invisible(self)
      }
      ,loadHistory = function(id, symbol) {
          to = Sys.Date()
          from = to - as.difftime(self$cookies$history, unit="days")
          df = self$history$getHistory(id, from, to)
          self$data$lstHist[[symbol]] = list(id=id,symbol=symbol, df=df)
          invisible(self)
      }
      ,getGlobalPosition = function() {
          df = self$position$getGlobalPosition(full = TRUE)
          if (nrow(df) > 0) {
              dfID = self$currencies$getID(df$currency)
              df = dplyr::left_join(df, dfID, by=c("currency"="symbol"))
          }
          df[df$id > 0,]
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
          #JGG 0,26,101 son numeros de rango
          #JGG 0 - todos
          #JGG 26 Serian los de mejor rango
          #JGG 101 Pendiente de favoritoss
         df = self$session$getLatest(self$cookies$selective)
         self$data$dfBest = private$sortBest(df,   0)
         self$data$dfTop  = private$sortBest(df,  26)
         self$data$dfFav  = private$sortBest(df, 101)
         invisible(self)
      }
      ,storeTrending = function (df) {
         if (!is.null(self$data$dfTrending) && (Sys.time() - self$vars$trendig) < 30) return(FALSE)
         df = WEB$REST$trending(TRUE)
         if (!is.null(df)) {
             self$vars$trending = Sys.time()
             self$data$dfTrending = df
         }
         TRUE
      }
 )
 ,private = list(
      ns = NULL
     ,cboplots = c( "Position"  = "Hist", "Session"  = "Session"
                  ,"Best Info" = "Best", "Top Info" = "Top"
     )
     ,tables = c( "Position"    = "Position", "Best"              = "Best"
                 ,"Best of Top" = "Top"     , "Best of favorites" = "Fav"
      )
     ,definition = list(id = "", left=-1, right=0, son=NULL, submodule=FALSE)
     ,defaultValues = function(ns) {
          self$cookies$interval = 15
          self$cookies$best = list(top = 10, from = 2)
          self$cookies$history = 15
          self$cookies$selective = 0
          # Default widgets
          widgets = c("plotHist","blkTop","plotSession","Position")
          self$cookies$layout = matrix(widgets,ncol=2)
          self$cookies$position = "Global"
          self$data$dfGlobal = NULL
          self$vars$trending = Sys.time() - (60 * 60) # subtract one hour
          private$ns = ns

     }
    ,loadPosition = function() {
        df = self$getGlobalPosition()
        if (is.null(df) || nrow(df) == 0) return()
        df = private$appendVariations(df)

        self$data$dfGlobal = df
        self$vars$selected[["PosGlobal"]] = df$currency
        cameras = self$position$getCameras()
        self$data$position = lapply(cameras,
             function(camera) {
                 df = self$position$getCameraPosition(camera)
                 if (nrow(df) == 0) return (NULL)
                 ids = self$currencies$getCurrencyID(df$currency, asList=FALSE)
                 df = dplyr::inner_join(df, ids, by="currency")
                 private$appendVariations(df)
                 })
        names(self$data$position) = cameras
    }
    ,appendVariations = function (df) {
        periods = c(1, 7, 30)
        dfp = self$history$getPrices(df$id, periods)
        dfp = cbind(dfp, df$value)
        j = ncol(dfp)
        for (idx in 1:length(periods)) {
            dfp[,idx] = dfp[,j] / dfp[,idx]
            dfp[,idx] = ifelse (dfp[,idx] < 1, (1 - dfp[,idx]) * -1, dfp[,idx] - 1)
        }
        dfp = dfp[-ncol(dfp)]
        colnames(dfp) = c("day", "week", "month", "id")
        dplyr::inner_join(df, dfp, by="id")
    }
     ,makePlots = function() {
         info  = list(type="Line", observer=ns("modebar"), scale="date")
         plots = c("plotHist","plotTop","plotBest","plotFav")

         self$plots[["plotSession"]] = YATAPlot$new("plotSession"
                                                    ,info=info
                                                    ,scale="time"
                                                    ,title="Current session"
                                                    ,width = WEB$window$width)
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

 moduleServer(id, function(input, output, session) {
            showNotification("Entra en POSITION")
    pnl = WEB$getPanel(id)
    if (is.null(pnl)) pnl = WEB$addPanel(PNLPos$new(id, pnlParent, session, NS(id)))
    flags = reactiveValues(
         position  = FALSE
        ,best      = FALSE
        ,history   = 15
        ,refresh   = FALSE
        ,plotsBest = FALSE
        ,plotPos   = FALSE
        ,table     = FALSE
        ,tablePos  = FALSE
        ,tab       = FALSE
        ,trending  = FALSE
    )

#####################################################################
### FUNCTIONS                                                     ###
#####################################################################

preparePosition = function(df, table) {
   if (nrow(df) == 0) return()
   types = list( imp = c("balance", "value","profit")
                ,prc = c("day", "week", "month")
                ,dat = c("since")
           )

   df = df %>% select(currency, balance, value, profit, day, week, month, last)
   df$last = as.Date(df$last)
   colnames(df) = c("currency", "balance", "value", "profit", "day", "week", "month", "since")

   data = list(df = df, cols=NULL, info=NULL)
   data$info=list( event=ns("tablePos"), target=table,types=types)
   data
}
prepareBest = function(df, table) {
   if (is.null(df)) return (NULL)

   df =  df %>% select(symbol, price, hour, day, week, month)
   df$symbol = WEB$getCTCLabels(df$symbol)
   data = list(df = df, cols=NULL, info=NULL)
   buttons = list( Button_buy=yuiBtnIconBuy("Comprar"))
   if (table == "Fav") buttons$Button_fav = yuiBtnIconFavDel("Eliminar")
   if (table != "Fav") buttons$Button_fav = yuiBtnIconFavAdd("Favorito")

   data$info=list( event=ns("tableBest"), target=table
                  ,types=list(pvl = c("Hour", "Day", "Week", "Month"), imp=c("Price"))
                  ,buttons = buttons # list(Button_buy=yuiBtnIconBuy("Comprar"))
                 )
   data
}
initPage = function() {
   renderUIPosition()    # Preparar tabla posiciones
   updNumericInput("numInterval", pnl$cookies$interval)
   output$dtLast = updLabelDate({Sys.time()})
   isolate(updNumericInput("numBestTop", pnl$cookies$best$top))
   updCombo("cboBestFrom", selected = pnl$cookies$best$from)
   updNumericInput("numInterval", value = pnl$cookies$interval)
   updNumericInput("numHistory",  value = pnl$cookies$history)
   updRadio("radPosition",        selected = pnl$cookies$position)

   df = pnl$data$dfGlobal
   if (is.null(df)) return()

   if (nrow(df) > 0) {
       dat = paste(df[,"currency"], df[,"id"], sep="-")
       lapply(dat, function(x) getHistorical(x))
   }
}
getHistorical = function(data, plot=NULL) {
   toks = strsplit(data, "-")[[1]]
   id = as.integer(toks[2])
   symbol = toks[1]
   if (id == 0) return()

   pnl$loadHistory(id, symbol)
   if (is.null(plot))  {
       pnl$vars$symbol = symbol
       flags$plotPos   = isolate(!flags$plotPos)
   }
   if (!is.null(plot)) flags$plotsBest = isolate(!flags$plotsBest)
}

renderUIPosition = function() {
   cameraUI = function(camera) {
      suffix  = str_to_title(camera)
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
           suffix  = str_to_title(camera)
           cam     = pnl$cameras$getCameraName(camera)
           nstable = paste0("tblPos", suffix)
           divCam = tags$div( id=paste0("divPos", suffix)
                             ,yuiBoxClosable( ns(nstable), paste("Posicion", cam)
                             ,yuiTable(ns(nstable))
                            )
                     )
           cameras = tagAppendChild(cameras, divCam)
      }
   }
   insertUI(paste0("#", ns("Position")), where = "beforeEnd", ui=cameras,  immediate=TRUE)
}
renderBestTables = function() {
   period = pnl$MSG$getBlockAsVector(2)
   lbl = period[as.integer(input$cboBestFrom)]

   output$lblBest = updLabelText(paste("Mejores", lbl))
   output$lblTop  = updLabelText(paste("Top:  Mejores", lbl))
   output$lblFav  = updLabelText(paste("Favoritos: Mejores", lbl))

   data1 = prepareBest(pnl$data$dfBest, "Best")
   if (!is.null(data1$df)) output$tblBest = updTableMultiple(data1)
   data2 = prepareBest(pnl$data$dfTop, "Top")
   if (!is.null(data2$df)) output$tblTop = updTableMultiple(data2)
   data3 = prepareBest(pnl$data$dfFav, "Fav")
   if (!is.null(data3$df)) output$tblFav = updTableMultiple(data3)
}
renderTrendingTable = function() {
   # period = pnl$MSG$getBlockAsVector(2)
   # lbl = period[as.integer(input$cboBestFrom)]
   #
   # output$lblBest = updLabelText(paste("Mejores", lbl))
   # output$lblTop  = updLabelText(paste("Top:  Mejores", lbl))
   # output$lblFav  = updLabelText(paste("Favoritos: Mejores", lbl))
   #
   # data1 = prepareBest(pnl$data$dfBest, "Best")
   # if (!is.null(data1$df)) output$tblBest = updTableMultiple(data1)
   # data2 = prepareBest(pnl$data$dfTop, "Top")
   # if (!is.null(data2$df)) output$tblTop = updTableMultiple(data2)
   # data3 = prepareBest(pnl$data$dfFav, "Fav")
   # if (!is.null(data3$df)) output$tblFav = updTableMultiple(data3)
}

renderPlotSession = function(uiPlot) {
    if (is.null(pnl$data$dfSession)) return()
##          if (pnl$vars$sessionChanged) {
       plot = pnl$plots[["plotSession"]]
       plot$setType("Marker")
       plot$setData(pnl$data$dfSession[,c("last", "price")], "session", TRUE)
       output$plotSession = plot$render()
 ##          }
}

###########################################################
### REACTIVES
###########################################################

observeEvent(flags$position, ignoreInit = TRUE, {
    if (is.null(pnl$data$dfGlobal)) return()
    pnl$cookies$position = flags$position
    # if (input$radPosition == "Cameras") {
    #     shinyjs::hide("posGlobal")
    # } else {
          shinyjs::show("posGlobal")
shinyjs::show("posGlobalFull")
        data = preparePosition(pnl$data$dfGlobal, "PosGlobal")
        output$tblPosGlobalFull = updTableMultiple(data)
        sel = c(which(data$df$currency %in% pnl$vars$selected[["PosGlobal"]]))
        updTableSelection("tblPosGlobalFull", sel)

        df = data$df
        data$df = df[df$balance > 0,]

        output$tblPosGlobal = updTableMultiple(data)
        sel = c(which(data$df$currency %in% pnl$vars$selected[["PosGlobal"]]))
        updTableSelection("tblPosGlobal", sel)
    # }

    #cameras = pnl$data$position
    #JGG Pendiente el tema de detalle por camaras
    # shinyjs::hide("posCameras")
    #
    # if (input$radPosition == "Global" || length(cameras) == 0) {
    #     shinyjs::hide("posCameras")
    # } else {
    #     shinyjs::show("posCameras")
    #     lapply(names(pnl$data$position), function(camera) {
    #            if (!is.null(pnl$data$position[[camera]])) {
    #                sfx = str_to_title(camera)
    #                data  = preparePosition(pnl$data$position[[camera]], paste0("Pos", sfx))
    #                eval(parse(text=paste0("output$tblPos", sfx, " = updTable(data)")))
    #            }
    #     })
    # }
})
observeEvent(flags$best, ignoreInit = TRUE, {
   from = as.numeric(input$cboBestFrom)
   if (is.na(from)) return()
   if (pnl$cookies$best$from == from && pnl$cookies$best$top == input$numBestTop) return()
   pnl$cookies$best$from      = from
   pnl$cookies$best$top       = input$numBestTop
   pnl$updateBest()
   renderBestTables()
})
observeEvent(flags$refresh, ignoreInit = TRUE, {
   pnl$monitors$update()
   flags$position = isolate(!flags$position)
   renderBestTables()
   renderPlotSession()
})
observeEvent(flags$history, ignoreInit = TRUE, ignoreNULL = TRUE, {
   if (is.na(flags$history)) return()

   if (flags$history != pnl$cookies$history) {
       pnl$cookies$history = flags$history
   }
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
       browser()
       carea = pnl$getCommarea()
       carea$action = action
       carea$pending = TRUE
       carea$data = list(id=df[row,"id"], symbol=df[row,"symbol"], price=df[row,"price"])
       pnl$setCommarea(carea)
       updateTabsetPanel(parent, inputId="mainMenu", selected=panel$oper)
   }
})
observeEvent(flags$plotsBest, ignoreInit = TRUE, {
   table = pnl$vars$table
   plot = pnl$getPlot(paste0("plot", table$target))
   sym = table$symbol
   plotted = plot$hasSource(sym)
   if (!plotted) {
       data =  pnl$data$lstHist[[sym]]
       plot$addData(data$df, sym)
   } else {
       plot$removeData(sym)
   }
   if (table$target == "Best") output$plotBest = plot$render()
   if (table$target == "Top")  output$plotTop  = plot$render()
   if (table$target == "Fav")  output$plotFav  = plot$render()
})
observeEvent(flags$plotPos, {
   #JGG SUELE FALLAR
   plot = pnl$plots[["plotHist"]]
   plot$setTitle(pnl$MSG$get("PLOT.TIT.HISTORY"))
   name = pnl$vars$symbol
   if (!is.null(name)) {
      if(!plot$hasSource(name)) {
         df = pnl$getHistory(name)
         if (!is.null(df)) plot$addData(df, name, "parm ui")
      }
   }
   output$plotHist = plot$render("plotHist")
})
observeEvent(flags$trending, { if (pnl$storeTrending()) renderTrendingTable() })

###########################################################
### OBSERVERS
###########################################################

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

###########################################################
### LEFT PANEL
###########################################################

observeEvent(input$radPosition, ignoreInit = TRUE, { flags$position = isolate(!flags$position) })
observeEvent(input$cboBestFrom, ignoreInit = TRUE, { flags$best = isolate(!flags$best)         })
observeEvent(input$numBestTop,  ignoreInit = TRUE, { flags$best = isolate(!flags$best)         })
observeEvent(input$numInterval, ignoreInit = TRUE, {
   if (is.numeric(input$numInterval)) {
       pnl$cookies$interval = input$numInterval
   }
})
observeEvent(input$numHistory,   ignoreInit = TRUE, { flags$history = isolate(input$numHistory) })
observeEvent(input$numSelective, ignoreInit = TRUE, { flags$refresh = isolate(!flags$refresh)   })
observeEvent(input$chkMonitors, ignoreInit = TRUE, {
   pnl$cookies$monitor = input$chkMonitors
   #JGGshinyjs::toggle("monitor", anim=TRUE)
})
observeEvent(input$btnLayoutOK, {
   pnl$setCookies()
   session$sendCustomMessage(type = 'closeLeftSide',message = "close")
})
observeEvent(input$btnLayoutKO, {
   session$sendCustomMessage(type = 'closeLeftSide',message = "close")
})

carea = pnl$getCommarea()
if (!pnl$loaded || carea$position) {
    if (!pnl$loaded) flags$trending = isolate(!flags$trending)
    pnl$loadData()
    if (!carea$position) initPage()
    pnl$setCommarea(position=FALSE)
    flags$refresh = isolate(!flags$refresh)
}

#####################################################
### Timers                                        ###
###  Despues de cargar SIEMPRE
#####################################################

observe({
  #JGG Pending invalidateLater(pnl$cookies$interval * 60000) # update page each interval minutes
    invalidateLater(5 * 60000)
   pnl$updateData()
   flags$refresh = isolate(!flags$refresh)
})
})   # END MODULE
}    # END SOURCE
