modPosServer <- function(id, full, pnlParent, parent=NULL) {
ns = NS(id)
PNLPos = R6::R6Class("PNL.OPER"
  ,inherit = WEBPanel
  ,cloneable  = FALSE
  ,lock_class = TRUE
  ,public = list(
      position    = NULL
     ,cameras     = NULL
     ,session     = NULL
     ,history     = NULL
     ,currencies  = NULL
     ,favorites   = NULL
     ,monitors    = NULL
     ,server      = NULL
     ,plots = list()
     ,bests = c("Top", "Best", "Fav", "Trend")
     ,initialize    = function(id, pnlParent, session, ns, DBChanged) {
         cat("initialize beg\n")
         super$initialize(id, pnlParent, session, ns)
         private$DBChanged = DBChanged
         private$defaultValues(ns)
         private$createObjects()
         self$data$lstHist = list()
         private$makePlots()
         cat("initialize end\n")
      }
     ,loadData = function() {
       self$data$dfPos  = self$position$getGlobalPosition(full = TRUE)
       self$data$dfFav  = self$favorites$get()

       data = self$data$dfPos %>% filter(balance > 0)

       self$monitors = WDGMonitor$new(private$ns("monitor"), self, data)

       js$yata_set_layout(id)

        # private$loadPosition()
        #
        # self$monitors = WDGMonitor$new(private$ns("monitor"), self)
        # if (!is.null(self$data$dfGlobal)) {
        #     ids = self$data$dfGlobal$id
        #     self$data$dfSession = self$session$getData(id=ids) # self$session$getSessionPrices(ids)
        #     self$vars$sessionChanged = TRUE
        # }
if ( private$DBChanged) self$monitors$update()
if (!private$DBChanged) self$monitors$render()
#        self$updateBest()
        invisible(self)
     }
     ,updateData = function() {
        dfTrend = WEB$REST$trending(TRUE)
        lstID = WEB$combo$getCurrenciesKey(id=FALSE, dfTrend$symbol)
        dfid = as.data.frame(unlist(lstID))
        dfid$symbol = names(lstID)
        colnames(dfid) = c("id", "symbol")
        self$data$dfTrending  = inner_join(dfTrend, dfid, by="symbol")

        currencies = unique(self$data$dfPos$currency)
        symbols    = unique(self$data$dfTrending$symbol)
        currencies = unique(c(currencies, symbols, self$data$dfFav$symbol))

        self$data$lstID = WEB$combo$getCurrenciesKey(id=FALSE, currencies)

        self$data$dfLast     = self$session$getLatest(self$cookies$selective) # currencies=self$data$lstID)
        self$data$dfSession  = self$session$getData  (id=self$data$lstID)

        self$monitors$update()

        # cat("updateData beg\n")
        # self$updateBest()
        # self$vars$sessionChanged = FALSE
        # lastr = nrow(self$data$dfSession)
        # lastc = ncol(self$data$dfSession)
        # dfLast = self$session$getSessionPrices(self$data$dfGlobal$currency)
        #   # if (is.null(self$data$dfSession) || nrow(self$data$dfSession) == 0) {
        #   #     self$data$dfSession = dfLast
        #   #     self$vars$sessionChanged = ifelse(is.null(dfLast), FALSE, TRUE)
        #   #     return()
        #   # }
        #   # # Por si acaso hay nuevas monedas lo hacemos en dos partes
        #   # dfAux = dfLast[, colnames(dfLast) %in% colnames(self$data$dfSession)]
        #   # if (ncol(dfAux) > 0) self$data$dfSession = rbind(self$data$dfSession, dfAux)
        #   #
        #   # news = which(! colnames(dfLast) %in% colnames(self$data$dfSession))
        #   # if (length(news) > 0) {
        #   #     dfAux = df[,c("tms", colnames(dfLast)[[news]])]
        #   #     self$data$dfSession = dplyr::full_join(self$data$dfSession, dfAux, "tms")
        #   # }
        #   # if (nrow(self$data$dfSession) == lastr && ncol(self$data$dfSession) == lastc)
        #   #     self$vars$sessionChanged = FALSE
        # cat("updateData end\n")
       invisible(self)
    }
     ,getPosition = function (full=FALSE) {
        if (is.null(self$data$dfPos)) return (NULL)
        df = self$data$dfPos
        if (!full) df = df %>% filter(balance > 0)
        if (nrow(df) == 0) return (NULL)

        df = private$appendVariations(df)
      }
     # ,loadHistory = function(id, symbol) {
     #    to = Sys.Date()
     #    from = to - as.difftime(self$cookies$history, unit="days")
     #    df = self$history$getHistory(id, from, to)
     #    self$data$lstHist[[symbol]] = list(id=id,symbol=symbol, df=df)
     #    invisible(self)
     # }
     ,getGlobalPosition = function() {
        df = self$position$getGlobalPosition(full = TRUE)
        if (nrow(df) > 0) {
            dfID = self$currencies$getID(df$currency)
            df = dplyr::left_join(df, dfID, by=c("currency"="symbol"))
        }
        df[df$id > 0,]
     }
    # ,getHistory = function(symbol) { self$data$lstHist[[symbol]]$df }
    # ,getPlots   = function()       { private$cboplots   }
    # ,getPlot    = function(plot)   { self$plots[[plot]] }
    # ,getTables  = function()       { private$tables }
    # ,getDFTable = function(table)  {
    #     if (table == "Best") return(self$data$dfBest)
    #     if (table == "Top")  return(self$data$dfTop)
    #     if (table == "Fav")  return(self$data$dfFav)
    #     NULL
    # }
     ,getLabelPeriods = function() {
         self$getLabels(self$codes$labels$periods)
      }
     ,updateLatest = function(df) {
        if (missing(df)) { # Error
            self$vars$start = self$vars$start + self$vars$limit
            return()
        }
        self$data$dfLast[match(df$id, self$data$dfLast$id), ] = df
        news = df[!match(df$id, self$data$dfLast$id), ]
        if (nrow(new) > 0) self$data$dfLast= rbind(self$data$dfLast, news)
        self$vars$start = self$vars$start + nrow(df)
        pnl$vars$tickers = ifelse(nrow(df) == pnl$vars$limit, FALSE, TRUE)
        invisible(self)
    }
    # ,updateBest = function() {
    #       #JGG 0,26,101 son numeros de rango
    #       #JGG 0 - todos
    #       #JGG 26 Serian los de mejor rango
    #       #JGG 101 Pendiente de favoritoss
    #      df = self$session$getLatest(self$cookies$selective)
    #      self$data$dfBest = private$sortBest(df,   0)
    #      self$data$dfTop  = private$sortBest(df,  26)
    #      self$data$dfFav  = private$sortBest(df, 101)
    #      invisible(self)
    #   }
      ,storeTrending = function (df) {
         if ( !is.null(self$data$dfTrending) &&
             (Sys.time() - self$vars$trendig) < 30) {
             return(FALSE)
         }

         df = WEB$REST$trending(TRUE)
         if (!is.null(df)) {
             self$vars$trending = Sys.time()
             self$data$dfTrending = df
         }
         TRUE
      }
     ,selectDataBest = function() {
         empty = data.frame(id=integer(), symbol=character())
         info  = self$cookies$best

         self$data$select$Top   = empty
         self$data$select$Best  = empty
         self$data$select$Trend = empty
         self$data$select$Fav   = empty

         df  = self$data$dfLast %>% filter(price > 0 & volume > 0) # clean data
         if (nrow(df) == 0) return()

         idx = which(colnames(df) == "hour") - 1 + info$period
         df  = data.table::setorderv(df,colnames(df)[idx], -1)

         self$data$select$Top = rbind(empty, df[df$rank <= info$top, c("id", "symbol")])

         rows = ifelse(nrow(df) > info$top, info$top, nrow(df))
         self$data$select$Best = rbind(empty, df[1:rows, c("id", "symbol")])

         dft = df[df$id %in% self$data$dfTrend$id,]
         rows = ifelse(nrow(dft) > info$top, info$top, nrow(dft))
         self$data$select$Trend = rbind(empty, df[1:rows, c("id", "symbol")])

         if (nrow(self$data$dfFav) > 0) {
             dff  = self$data$dfFav[,"id"]
             df   = dplyr::left_join(dff, df, by="id")
             df   = df[order(colnames(df)[idx], decreasing = TRUE),]
             rows = ifelse(nrow(df) > info$top, info$top, nrow(df))
             self$data$select$Fav = rbind(empty, df[1:rows, c("id", "symbol")])
         }
         invisible(self)
      }
,prepareTableBest = function(lbl) {
   df = self$data$dfLast %>% filter(id %in% self$data$select[[lbl]][,"id"])
   if (is.null(df) || nrow(df) == 0) return (NULL)

   labels = WEB$combo$currencies(set=df$id, merge=FALSE, invert=TRUE)

   # Hay veces que falta alguna moneda
   dfl = as.data.frame(unlist(labels))
   dfl$id = as.integer(row.names(dfl))
   colnames(dfl) = c("name", "id")
   df = left_join(df, dfl, by="id")
   df = na.omit(df)
   df$symbol = paste(df$symbol,df$name,sep=" - ")

   df =  df %>% select(symbol, price, hour, day, week, month)

   data = list(df = df, cols=NULL, info=NULL)
   buttons = list( Button_buy=yuiBtnIconBuy(WEB$MSG$get("WORD.BUY")))
   if (lbl == "Fav") buttons$Button_fav = yuiBtnIconFavDel(WEB$MSG$get("WORD.DELETE"))
   if (lbl != "Fav") buttons$Button_fav = yuiBtnIconFavAdd(WEB$MSG$get("WORD.FAV"))

   data$info=list( event=ns(paste0("table", lbl)), target=lbl
                  ,types=list(pvl = c("hour", "day", "week", "month"), imp=c("price"))
                  ,buttons = buttons # list(Button_buy=yuiBtnIconBuy("Comprar"))
                 )
   data
}
,createPlots = function(per) {
   WORD  = self$MSG$getWords()
   period = self$getLabelPeriods()
   lbl    = period[per]
   lbls = c("Pos", self$bests)

   titles = list()
   titles$Pos   = WORD$POSITION
   titles$Best  = paste(WORD$BEST, lbl)
   titles$Top   = paste(paste0(WORD$TOP,":"),   WORD$BEST, lbl)
   titles$Fav   = paste(paste0(WORD$FAV,":"),   WORD$BEST, lbl)
   titles$Trend = paste(paste0(WORD$TREND,":"), WORD$BEST, lbl)


    self$data$plots = lapply(lbls, function(lbl) {
        YATAPlotHistory$new(paste0("table", lbl), title=titles[[lbl]])
    })
    names(self$data$plots) = lbls

    p = list("Session" = YATAPlotSession$new(paste0("tableSession")))
    self$data$plots = list.merge(self$data$plots, p)
}
 )
 ,private = list(
      ns = NULL
     ,DBChanged = FALSE
     #,plots = c("plotPos","plotTop","plotBest","plotFav")
     ,cboplots = c( "Position"  = "Hist", "Session"  = "Session"
                  ,"Best Info" = "Best", "Top Info" = "Top"
     )
     ,tables = c( "Position"    = "Position", "Best"              = "Best"
                 ,"Best of Top" = "Top"     , "Best of favorites" = "Fav"
      )
     ,definition = list(id = "", left=-1, right=0, son=NULL, submodule=FALSE)
     ,defaultValues = function(ns) {
          self$cookies$interval = 15
          self$cookies$best = list(top = 10, period = 2)
          self$cookies$history = 15
          self$cookies$selective = 0
          # Default widgets
          widgets = c("plotPos","blkTop","plotSession","Position")
          self$cookies$layout = matrix(widgets,ncol=2)
          self$cookies$position = "Global"
          self$vars$trending = Sys.time() - (60 * 60) # subtract one hour
          private$ns = ns

     }
     ,loadPosition = function() {
        cat("loadPosition beg\n")
        df = self$getGlobalPosition()
        if (nrow(df) == 0) {
            cat("loadPosition end NODATA\n")
            return()
        }
        df = private$appendVariations(df)
        df[is.na(df)] = 0

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
        cat("loadPosition end\n")
    }
     ,appendVariations = function (df) {
        dfLast   = self$data$dfLast
        dfLast   = dfLast[dfLast$id %in% df$id,]
        dfPeriod = self$history$getPrices(df$id, c(1, 7, 30))
        periods = c(1, 7, 30)

        dfp = cbind(dfp, df$value)
        j = ncol(dfp)
        for (idx in 1:length(periods)) {
            dfp[,idx] = dfp[,j] / dfp[,idx]
            if (dfp[,idx] != 0) {
                dfp[,idx] = ifelse (dfp[,idx] < 1, (1 - dfp[,idx]) * -1, dfp[,idx] - 1)
            }
        }
        dfp = dfp[-ncol(dfp)]
        colnames(dfp) = c("day", "week", "month", "id")
        dplyr::inner_join(df, dfp, by="id")
    }
     ,makePlots = function() {
         self$plots[["history"]] = YATAPlotHistory$new("plotHistory")
                                                # ,scale="date"
                                                # ,type = "Line"
                                                # ,observer=ns("modebar")
                                                # ,width = WEB$window$width)

         self$plots[["session"]] = YATAPlotSession$new("plotSession")
                                                # ,scale="time"
                                                # ,title="Current session"
                                                # ,width = WEB$window$width)
     }
    ,sortBest = function(df, first) {
        cols = c("hour", "day", "week", "month")
        col = cols[as.integer(self$cookies$best$period)]
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
   ,createObjects = function() {
       self$position   = Factory$getObject(self$codes$object$position)
       self$cameras    = Factory$getObject(self$codes$object$cameras)
       self$currencies = Factory$getObject(self$codes$object$currencies)
       self$session    = Factory$getObject(self$codes$object$session)
       self$history    = Factory$getObject(self$codes$object$history)
       self$favorites  = Factory$getObject(self$codes$object$favorites)
       self$server     = YATAServer$new("REST")
   }
  )
 )

tryCatch({
 moduleServer(id, function(input, output, session) {
     cat("moduleServer beg\n")
    showNotification("Entra en POSITION")
    pnl = WEB$getPanel(id)
    if (is.null(pnl) || pnl$DBID != WEB$DBID) { # first time or DB Changed
        DBChanged = ifelse(is.null(pnl), FALSE, TRUE)
        pnl = WEB$addPanel(PNLPos$new(id, pnlParent, session, NS(id), DBChanged))
    }
    flags = reactiveValues(

         update    = FALSE
        ,refresh   = FALSE
        #,rest      = FALSE
        ,position  = FALSE
        ,plots     = FALSE
        ,best      = FALSE
        ,history   = 15
        ,plotBest  = FALSE
        ,plotPos   = FALSE
        ,table     = FALSE
        ,tablePos  = FALSE
        ,tab       = FALSE
        ,trending  = FALSE
    )

#####################################################################
### FUNCTIONS                                                     ###
#####################################################################

getTickers = function() {
   # future_promise ({
   #    pnl$server$GET("latest", from=pnl$vars$start, limit=pnl$vars$limit)
   # }) %>% then (
   # onFulfilled = function(df) {
   #    pnl$updateLatest(df)
   #    flags$refresh = isolate(!flags$refresh)  # Actualiza
   #    flags$rest    = isolate(!flags$rest)     # Chequea si debe seguir
   # },onRejected = function(err) {
   #    pnl$updateLatest(df)
   #    flags$refresh = isolate(!flags$refresh)  # Actualiza
   #    flags$rest    = isolate(!flags$rest)     # Chequea si debe seguir
   # })
}
# preparePosition = function(full, table) {
#    df = pnl$data$dfGlobal
#    if (!full) df = df[df$balance >0, ]
#    if (nrow(df) == 0) return(NULL)
#    types = list( imp = c("balance", "value","profit")
#                 ,prc = c("day", "week", "month")
#                 ,dat = c("since")
#            )
#
#    df = df %>% select(currency, balance, value, profit, day, week, month, last)
#    df$last = as.Date(df$last)
#    colnames(df) = c("currency", "balance", "value", "profit", "day", "week", "month", "since")
#
#    data = list(df = df, cols=NULL, info=NULL)
#    data$info=list( event=ns("tablePos"), target=table,types=types)
#    data
# }

# prepareTrending = function(df, table) {
#    if (is.null(df)) return (NULL)
#
#    df$symbol = paste(df$symbol, df$name,sep=" - ")
#    df =  df %>% select(symbol, price, day, week, month)
#    df$symbol = paste0(df$symbol, " - ", df$name)
#    df = df[1:pnl$cookies$best$top,]
#
#    data = list(df = df, cols=NULL, info=NULL)
#
#    data$info=list( event=ns("tableTrending"), target=table
#                   ,types=list(pvl = c("day", "week", "month"), imp=c("price"))
#                   ,buttons = NULL # list(Button_buy=yuiBtnIconBuy("Comprar"))
#                  )
#    data
# }
# initPage = function() {
#    renderUIPosition()    # Preparar tabla posiciones
#    updNumericInput("numInterval", pnl$cookies$interval)
#    output$dtLast = updLabelDate({Sys.time()})
#    isolate(updNumericInput("numBestTop", pnl$cookies$best$top))
#    updCombo("cboBestFrom", selected = pnl$cookies$best$from)
#    updNumericInput("numInterval", value = pnl$cookies$interval)
#    updNumericInput("numHistory",  value = pnl$cookies$history)
#    updRadio("radPosition",        selected = pnl$cookies$position)
#
#    df = pnl$data$dfGlobal
#    if (is.null(df)) return()
#
#    if (nrow(df) > 0) {
#        dat = paste(df[,"currency"], df[,"id"], sep="-")
#        lapply(dat, function(x) getHistorical(x))
#    }
# }
# getHistorical = function(data, plot=NULL) {
#    toks = strsplit(data, "-")[[1]]
#    id = as.integer(toks[2])
#    symbol = toks[1]
#    if (id == 0) return()
#
#    pnl$loadHistory(id, symbol)
#    if (is.null(plot))  {
#        pnl$vars$symbol = symbol
#        flags$plotPos   = isolate(!flags$plotPos)
#    }
#    if (!is.null(plot)) flags$plotBest = isolate(!flags$plotBest)
# }
#
# renderUIPosition = function() {
#    cameraUI = function(camera) {
#       suffix  = str_to_title(camera)
#       cam     = pnl$cameras$getCameraName(camera)
#       nstable = paste0("tblPos", suffix)
#       tags$div( id=paste0("divPos", suffix)
#                ,yuiBoxClosable( ns(nstable), paste("Posicion", cam)
#                                ,yuiTable(ns(nstable))
#                               )
#            )
#    }
#    removeUI(paste0("#", ns("posCameras")), immediate = TRUE)
#    cameras = tags$div(id=ns("posCameras"))
#    cams =names(pnl$data$position)
#    if(length(cams)) {
#       for (camera in cams) {
#            suffix  = str_to_title(camera)
#            cam     = pnl$cameras$getCameraName(camera)
#            nstable = paste0("tblPos", suffix)
#            divCam = tags$div( id=paste0("divPos", suffix)
#                              ,yuiBoxClosable( ns(nstable), paste("Posicion", cam)
#                              ,yuiTable(ns(nstable))
#                             )
#                      )
#            cameras = tagAppendChild(cameras, divCam)
#       }
#    }
#    insertUI(paste0("#", ns("Position")), where = "beforeEnd", ui=cameras,  immediate=TRUE)
# }
renderTablesBest = function() {
   WORDS  = pnl$MSG$getWords()
   period = pnl$getLabelPeriods()
   lbl    = period[as.integer(input$cboBestPeriod)]

   output$lblBest  = updLabelText(paste(WORDS$BEST, lbl))
   output$lblTop   = updLabelText(paste(paste0(WORDS$TOP,":"),   WORDS$BEST, lbl))
   output$lblFav   = updLabelText(paste(paste0(WORDS$FAV,":"),   WORDS$BEST, lbl))
   output$lblTrend = updLabelText(paste(paste0(WORDS$TREND,":"), WORDS$BEST, lbl))

   info = pnl$cookies$best
   pnl$selectDataBest()
   lapply(pnl$bests, function(lbl) {
       data = pnl$prepareTableBest(lbl)
      if (!is.null(data$df)) eval(parse(text=paste0("output$tbl", lbl, "=updTableMultiple(data)")))
   })
}
renderTablesPos = function() {
   df = pnl$getPosition(TRUE)
   types = list( imp = c("balance", "value","profit")
                ,prc = c("day", "week", "month")
                ,dat = c("since")
           )

   df = pnl$data$dfPos
   colnames(df) = c("currency", "balance", "value", "profit", "day", "week", "month", "since")
   if (nrow(df) == 0) return(NULL)
   if (!full) df = df[df$balance > 0, ]

   df = df %>% select(currency, balance, value, profit, day, week, month, last)
   df$last = as.Date(df$last)


   data = list(df = df, cols=NULL, info=NULL)
   data$info=list( event=ns("tablePos"), target=table,types=types)
   data
}
renderPlot = function(id, df) {
   items = pnl$data$select
   lapply(names(items), function(item) {
      dfc = items[[item]]
      if (nrow(dfc[dfc$id == id,]) == 1) {
          plot = pnl$data$plots[[item]]
          plot$addData(df[1,2], df, source="session")
          eval(parse(text=paste0("output$plot", item, "=plot$render()")))
      }
   })

}
renderPlotsBest = function() {
    items = pnl$data$select
    data = unique(unlist(lapply(pnl$bests, function(x) pnl$data$select[[x]]$id)))

    lapply(data, function(id) {
       df = pnl$history$getHistory(id, periods=pnl$cookies$history)
       renderPlot(id, df)
    })
   # lapply(c("Top", "Best", "Fav", "trend"), function(lbl) {
   #     data = preparePlotBest(lbl)
   #    if (!is.null(data$df)) eval(parse(text=paste0("output$plot", lbl, "=plot$render()")))
   # })
}
renderPlotsHistory = function() {

   # lapply(c("Top", "Best", "Fav", "trend"), function(lbl) {
   #     data = preparePlotBest(lbl)
   #    if (!is.null(data$df)) eval(parse(text=paste0("output$plot", lbl, "=plot$render()")))
   # })
}

# renderTrendingTable = function() {
#    data1 = prepareTrending(pnl$data$dfTrending, "Trend")
#    if (!is.null(data1$df)) output$tblTrend = updTableMultiple(data1)
# }
# renderPlotSession = function(uiPlot) {
#     cat("renderplotsession beg\n")
#     if (is.null(pnl$data$dfSession)) {
#         cat("renderplotsession end NULL\n")
#         return()
#     }
#     browser()
#     plot = pnl$plots[["plotSession"]]
#     plot$setType("Marker")
#     plot$setData(pnl$data$dfSession[,c("last", "price")], "session", TRUE)
#     output$plotSession = plot$render()
# cat("renderplotsession end\n")
# }

###########################################################
### REACTIVES
###########################################################

observeEvent(flags$position2, ignoreInit = TRUE, {
    browser()
   colnames(df) = c("currency", "balance", "value", "profit", "day", "week", "month", "since")
   types = list( imp = c("balance", "value","profit")
                ,prc = c("day", "week", "month")
                ,dat = c("since")
           )

   df = pnl$data$dfGlobal

   if (!full) df = df[df$balance >0, ]
   if (nrow(df) == 0) return(NULL)

   df = df %>% select(currency, balance, value, profit, day, week, month, last)
   df$last = as.Date(df$last)


   data = list(df = df, cols=NULL, info=NULL)
   data$info=list( event=ns("tablePos"), target=table,types=types)
   data


    data = preparePosition(TRUE, "PosGlobalFull")
    if (!is.null(data)) output$tblPosGlobalFull = updTableMultiple(data)
    data = preparePosition(FALSE, "PosGlobal")
    if (!is.null(data)) output$tblPosGlobal = updTableMultiple(data)

#     if (is.null(pnl$data$dfGlobal)) return()
#     pnl$cookies$position = flags$position
#     # if (input$radPosition == "Cameras") {
#     #     shinyjs::hide("posGlobal")
#     # } else {
#           shinyjs::show("posGlobal")
# shinyjs::show("posGlobalFull")

#         output$tblPosGlobalFull = updTableMultiple(data)
#         sel = c(which(data$df$currency %in% pnl$vars$selected[["PosGlobal"]]))
#         updTableSelection("tblPosGlobalFull", sel)
#
#         df = data$df
#         data$df = df[df$balance > 0,]
#
#         output$tblPosGlobal = updTableMultiple(data)
#         sel = c(which(data$df$currency %in% pnl$vars$selected[["PosGlobal"]]))
#         updTableSelection("tblPosGlobal", sel)
#     # }
#
#     #cameras = pnl$data$position
#     #JGG Pendiente el tema de detalle por camaras
#     # shinyjs::hide("posCameras")
#     #
#     # if (input$radPosition == "Global" || length(cameras) == 0) {
#     #     shinyjs::hide("posCameras")
#     # } else {
#     #     shinyjs::show("posCameras")
#     #     lapply(names(pnl$data$position), function(camera) {
#     #            if (!is.null(pnl$data$position[[camera]])) {
#     #                sfx = str_to_title(camera)
#     #                data  = preparePosition(pnl$data$position[[camera]], paste0("Pos", sfx))
#     #                eval(parse(text=paste0("output$tblPos", sfx, " = updTable(data)")))
#     #            }
#     #     })
#     # }
})
# observeEvent(flags$best, ignoreInit = TRUE, {
#    from = as.numeric(input$cboBestFrom)
#    if (is.na(from)) return()
#    if (pnl$cookies$best$from == from && pnl$cookies$best$top == input$numBestTop) return()
#    pnl$cookies$best$from      = from
#    pnl$cookies$best$top       = input$numBestTop
#    pnl$updateBest()
#    renderTablesBest()
# })
# observeEvent(flags$update, ignoreInit = TRUE, {
#     pnl$vars$start =   0
#     pnl$vars$limit = 500
#     getTickers()
#
#     pnl$server$GET("latest")
#    pnl$monitors$update()
#    flags$position = isolate(!flags$position)
#    flags$plots    = isolate(!flags$plots)
#    renderTablesBest()
#    renderTrendingTable()
#    renderPlotSession()
#    cat("flags$refresh end\n")
#})
observeEvent(flags$rest, ignoreInit = TRUE, {
    if (pnl$vars$tickers) {
        pnl$vars$start = pnl$vars$start + 1
        getTickers()
    }
})

observeEvent(flags$refresh, ignoreInit = TRUE, {
   cat("flags$refresh beg\n")
   renderTablesBest()
   renderTablesPos()
   renderPlotsBest()
#   renderPlotsHistory()

#
#    future_promise ({
#       pnl$server$GET("latest")
#    }) %>% then (
#    onFulfilled = function(df) {
#        browser()
#        pnl$data$dfLast = df
#
#       df
#    },onRejected = function(err) {
#         browser()
#         pnl$updateLatest()
#         NULL
#    })
#
#     pnl$server$GET("latest")
#    pnl$monitors$update()
#    flags$position = isolate(!flags$position)
#    flags$plots    = isolate(!flags$plots)

#    renderTrendingTable()
#    renderPlotSession()
   cat("flags$refresh end\n")
})
# observeEvent(flags$plots, ignoreInit = TRUE, {
#     cat("flags$plots beg\n")
#     plot = pnl$plots$history
#     for (item in c("Best", "Top", "Fav", "Trend")) {
#         plot$removeData()
#         df = eval(parse(text=paste0("pnl$data$df", item)))
#         browser()
#
#     }
#         #     ,addData    = function(name, df, ui) {
#         # if (is.null(df)) return(invisible(self))
#         # dftype = "Value"
#         # private$info$datasource = "value"
#         # if (missing(name)) name = paste0("data", length(private$data))
#         # if (ncol(df) > 3) {
#         #     if (sum(colnames(df) %in% c("high", "low", "open", "close")) > 0) {
#         #         dftype = "session"
#         #         if (info$datasource != "session") private$info$datasource = "session"
#         #     }
#         # }
#         # # Se actualizan datos. Hay que refrescar todo
#         # if (!is.null(private$data$name)) {
#         #     self$plot = private$base()
#         #     private$generated = FALSE
#         # }
#         private$data[[name]] = list(source=dftype, data=df, visible=TRUE)
#         # if (!generated) {
#         #     render(ui, NULL, info$type)
#         # } else {
#         #     idx = which(names(data) == name)[1]
#         #     prepareData(idx)
#         #     plotly::renderPlotly({plot})
#         # }
#         private$generated = FALSE
#         invisible(self)
#      }
#     ,removeData = function(name) {
#
#    table = pnl$vars$table
#    plot = pnl$getPlot(paste0("plot", table$target))
#    sym = table$symbol
#    plotted = plot$hasSource(sym)
#    if (!plotted) {
#        data =  pnl$data$lstHist[[sym]]
#        plot$addData(data$df, sym)
#    } else {
#        plot$removeData(sym)
#    }
#    if (table$target == "Best") output$plotBest = plot$render()
#    if (table$target == "Top")  output$plotTop  = plot$render()
#    if (table$target == "Fav")  output$plotFav  = plot$render()

#    # Update plots
#    plot = pnl$plots[["plotSession"]]
#    data = plot$getSourceNames()
#    names = plot$getColumnNames(data)
#    plot$selectColumns("session", pnl$vars$selected[["PosGlobal"]])
#    renderPlotSession()
#
#    plot = pnl$plots[["plotPos"]]
#    plot$setSourceNames(pnl$vars$selected[["PosGlobal"]])
#    output$plotPos = plot$render()

   # blocks = c( "Plot Position"  = "plotPos" , "Plot Session" = "plotSession"
   #            ,"Plot Best"      = "plotBest", "Plot Top"     = "plotTop"
   #            ,"Plot Favorites" = "plotFav"
   #            ,"Position"       = "Position", "Full Position"  = "PositionFull"
   #            ,"Best"           = "blkBest"
   #            ,"Best of Top"    = "blkTop"  , "Best of favorites" = "blkFav"
   #            ,"Trending"       = "blkTrend"

#     cat("flags$plots end\n")
# })
# observeEvent(flags$history, ignoreInit = TRUE, ignoreNULL = TRUE, {
#    if (is.na(flags$history)) return()
#
#    if (flags$history != pnl$cookies$history) {
#        pnl$cookies$history = flags$history
#    }
# })
# observeEvent(flags$table, ignoreInit = TRUE, {
#     table = pnl$vars$table$target
#     row   = pnl$vars$table$row
#     df    = pnl$getDFTable(table)
#
#     # Update table
#     symbol = df[row,"symbol"]
#     id     = df[row,"id"]
#     sel = pnl$vars$selected[[table]]
#     if (!is.null(sel)) {
#         idx = which(sel == symbol)
#         if (length(idx) > 0) sel = sel[-idx]
#         else                 sel = c(sel, symbol)
#     } else {
#         sel = c(symbol)
#     }
#     pnl$vars$selected[[table]] = sel
#     updateReactable(paste0("tbl", table), selected = c(which(df$symbol == sel)))
#
#     # Update plot
#     browser()
#     df = pnl$getHistory(symbol)
#     pnl$vars$table$symbol = symbol
#     if (is.null(df)) {
#         getHistorical(paste(symbol, id, sep="-"), table)
#     } else {
#         flags$plotBest = isolate(!flags$plotBest)
#     }
# })
# observeEvent(flags$tablePos, ignoreInit = TRUE, {
#    table = "PosGlobal"
#    row   = pnl$vars$table$row
#    df    = pnl$data$dfGlobal
# browser()
#    # Update table
#    symbol = df[row,"currency"]
#    id     = df[row,"id"]
#    sel = pnl$vars$selected[[table]]
#    if (!is.null(sel)) {
#        idx = which(sel == symbol)
#        if (length(idx) > 0) sel = sel[-idx]
#        else                 sel = c(sel, symbol)
#    } else {
#        sel = c(symbol)
#    }
#    pnl$vars$selected[[table]] = sel
#
#    updTableSelection(paste0("tbl", table),c(which(df$currency %in% sel)))
#
#    # Update plots
#    plot = pnl$plots[["plotSession"]]
#    data = plot$getSourceNames()
#    names = plot$getColumnNames(data)
#    plot$selectColumns("session", pnl$vars$selected[["PosGlobal"]])
#    renderPlotSession()
#
#    plot = pnl$plots[["plotPos"]]
#    plot$setSourceNames(pnl$vars$selected[["PosGlobal"]])
#    output$plotPos = plot$render()
# })
#
# observeEvent(flags$tab, ignoreInit = TRUE, {
#    table = pnl$vars$table$target
#    row   = pnl$vars$table$row
#    df    = pnl$getDFTable(table)
#
#    action = strsplit(pnl$vars$table$colName, "_")[[1]][2]
#
#    if (action == "buy") {
#        carea = pnl$getCommarea()
#        carea$action = action
#        carea$pending = TRUE
#        carea$data = list(id=df[row,"id"], symbol=df[row,"symbol"], price=df[row,"price"])
#        pnl$setCommarea(carea)
#        updateTabsetPanel(parent, inputId="mainMenu", selected=panel$oper)
#    }
# })
# observeEvent(flags$plotBest, ignoreInit = TRUE, {
#    table = pnl$vars$table
#    plot = pnl$getPlot(paste0("plot", table$target))
#    sym = table$symbol
#    plotted = plot$hasSource(sym)
#    if (!plotted) {
#        data =  pnl$data$lstHist[[sym]]
#        plot$addData(data$df, sym)
#    } else {
#        plot$removeData(sym)
#    }
#    if (table$target == "Best") output$plotBest = plot$render()
#    if (table$target == "Top")  output$plotTop  = plot$render()
#    if (table$target == "Fav")  output$plotFav  = plot$render()
# })
# observeEvent(flags$plotPos, {
#    #JGG SUELE FALLAR
#    plot = pnl$plots[["plotPos"]]
#    plot$setTitle(pnl$MSG$get("PLOT.TIT.HISTORY"))
#    name = pnl$vars$symbol
#    if (!is.null(name)) {
#       if(!plot$hasSource(name)) {
#          df = pnl$getHistory(name)
#          if (!is.null(df)) plot$addData(df, name, "parm ui")
#       }
#    }
#    output$plotPos = plot$render("plotPos")
# })
# observeEvent(flags$trending, { if (pnl$storeTrending()) renderTrendingTable() })

###########################################################
### OBSERVERS
###########################################################

# observeEvent(input$tableBest, ignoreInit = TRUE, {
#    pnl$vars$table = input$tableBest
#    if (!startsWith(input$tableBest$colName, "Button")) {
#        flags$table = isolate(!flags$table)
#    } else {
#        flags$tab = isolate(!flags$tab)
#    }
# })
# observeEvent(input$tablePos, {
#    pnl$vars$table = input$tablePos
#    if (!startsWith(input$tablePos$colName, "Button")) {
#        flags$tablePos = isolate(!flags$tablePos)
#    } else {
#        flags$tab = isolate(!flags$tab)
#    }
# })
#
# observeEvent(input$modebar, {
#    info = input$modebar
#    pnl$vars$info[[info$render]] = info
#    eval(parse(text=paste0("output$", info$ui, "=", info$render, "('", info$ui, "', info)")))
# })

###########################################################
### LEFT PANEL
###########################################################

# observeEvent(input$radPosition, ignoreInit = TRUE, { flags$position = isolate(!flags$position) })
observeEvent(input$cboBestPeriod, ignoreInit = TRUE, {
    pnl$cookies$best$period = as.integer(input$cboBestPeriod)
    renderTablesBest()
})
observeEvent(input$numBestTop,    ignoreInit = TRUE, {
    if (!is.integer(input$numBestTop)) return()
    pnl$cookies$best$top = input$numBestTop
    renderTablesBest()
})
observeEvent(input$numInterval, ignoreInit = TRUE, {
   if (is.numeric(input$numInterval)) {
       pnl$cookies$interval = input$numInterval
   }
})
observeEvent(input$numHistory,   ignoreInit = TRUE, {
   if (is.numeric(input$numHistory)) {
       pnl$cookies$history = input$numInterval
       flags$history = isolate(input$numHistory)
   }
})
observeEvent(input$numSelective, ignoreInit = TRUE, {
   if (is.numeric(input$numSelective)) {
       pnl$cookies$selective = input$numSelective
       flags$refresh = isolate(!flags$refresh)
   }
})
observeEvent(input$chkMonitors, ignoreInit = TRUE, {
   pnl$cookies$monitor = input$chkMonitors
   #JGGshinyjs::toggle("monitor", anim=TRUE)
})
observeEvent(input$btnSave, {
   pnl$setCookies()
   session$sendCustomMessage('leftside_close')
})
observeEvent(input$btnClose, {
    #JGG Reset values (hay que guardarlos antes)
   session$sendCustomMessage('leftside_close')
})

if (!pnl$loaded || pnl$getCommarea(item="position")) {
    pnl$loadData()
    renderTablesPos()
    pnl$createPlots(as.integer(input$cboBestPeriod))
    #* @get /slow/<k>
# function() {
#   promises::future_promise({
#     slow_calc()
#   })
# }
           pnl$loaded = TRUE
    pnl$setCommarea(position=FALSE)
#    flags$refresh = isolate(!flags$refresh)
}

#####################################################
### Timers                                        ###
###  Despues de cargar SIEMPRE
#####################################################

observe({
   invalidateLater(pnl$cookies$interval * 60000)
   pnl$updateData()
   flags$refresh = isolate(!flags$refresh)
})
cat("moduleserver end\n")
})   # END MODULE
}, Warning = function(cond) {
    cat("Warning\n")
    browser()
}, error = function(cond) {
    cat("error\n")
    browser()
})
}    # END SOURCE
