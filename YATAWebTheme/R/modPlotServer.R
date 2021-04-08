modPltServer <- function(id, full, pnlParent, invalidate=FALSE) {
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
         ,df1 = NULL
         ,df2 = NULL
         ,df3 = NULL
         ,plotsInfo = list()
         ,plots     = list()
         ,initialize    = function(id, pnlParent, session) {
             super$initialize(id, pnlParent, session)
             self$df1 = read.csv("VNLA.csv")
             self$df2 = read.csv("ATT.csv")
             self$df3 = read.csv("STORJ.csv")
         }
         ,updatePlot = function (ui, plot) {
            nfo = plot$getInfo()
            nfo$changed = !nfo$changed
            self$plotsInfo[[ui]] = nfo
            self$plots[[ui]] = plot
         }
         ,getPlot = function(idPlot, ...) {
            plt = self$plots$get(idPlot)
            if (is.null(plt)) {
               plt = OBJPlot$new(idPlot, ...)
               self$plots$put(idPlot, plt)
            }
            plt
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
         
      )
     ,private = list(
       )
    )
   moduleServer(id, function(input, output, session) {
      tpl = list(
          observer=ns("modebar")
         ,datasource="session"
         ,datavalue="Value"
         ,count=0
      )
      
      pnl = YATAWEB$getPanel(id)
      if (is.null(pnl)) pnl = YATAWEB$addPanel(PNLPos$new(id, pnlParent, session))

      # plot1 = function(info) {#
      #    browser()
         plot1 = OBJPlot$new("plot1", plot="Line", observer=ns("modebar"), df = pnl$df1)
         
#         plot = pnl$getPlot("plot1", plot="Line", observer=ns("modebar"))
#         plot$setInfo(info)
        # plt = OBJPLOT$new("plot1")   
        # if (!plt$hasData()) {
        #     plt$addData(pnl$df1, "VNLA")
        #     plt$addData(pnl$df2, "ATT")
        # }
        #  info$plot = "Line"   
        # df = pnl$df1
        # if (info$plot != "Candlestick") df = df[,c("tms","close")]
        # colnames(df) = c("Date", "VNLA")
        
        #eval(parse(text=paste0("plt$", info$plot, "(df)")))
        # plot$addData(df, "VNLA")
        # browser()
        # plt$addData(pnl$df1, "session")
        # 
        # plot = yata2PlotBase()
        # df = pnl$df1
        # if (info$plot != "Candlestick") df = df[,c("tms","close")]
        # colnames(df) = c("Date", "VNLA")
        # info$name = "VNLA"
        # df$Date = as.Date(df$Date)
        # plot = eval(parse(text=paste0("yata2Plot", info$plot, "(plot, df, info)")))
        # df = pnl$df2
        # if (info$plot != "Candlestick") df = df[,c("tms","close")]
        # colnames(df) = c("Date", "ATT")
        # plot$addData(df, "ATT")
        # plot$setScale("date")
        
        # info$name = "ATT"
        # df$Date = as.Date(df$Date)
        # plot = eval(parse(text=paste0("yata2Plot", info$plot, "(plot, df, info)")))
        # 
        # info$count = 2
        # info$render = "plot1"
      # }

      # info = tpl
      # info$id="plot1"
      # info$ui="plot11"
      # info$plot="Line"
      # info$type = "value"
      # plot1(info)
      # output$plot11 = upd2Plot(plot, "plot11")
      # output$plot12 = upd2Plot(plot, "plot12")
      
      # plot = yata2PlotBase()
      # df = pnl$df3[,c("tms","high")]
      # df$tms = as.Date(df$tms)
      # info$name = "STORJ"
      # plot = yata2PlotBar(plot, df, info)
      # df = pnl$df1[,c("tms","high")]
      # df$tms = as.Date(df$tms)
      # info$name = "VNLA"
      # plot = yata2PlotBar(plot, df, info)
      # 
      # info$id="plot2"
      # info$ui="plot12"
      # info$plot="Bar"
      # 
      # output$plot12 = upd2Plot(plot, info)
      # 
      # plot = yata2PlotBase()
      # df = pnl$df1
      # df$tms = as.Date(df$tms)
      # info$name = "VNLA"
      # plot = yata2PlotCandlestick(plot, df, info)
      # df = pnl$df2
      # df$tms = as.Date(df$tms)
      # info$name = "ATT"
      # plot = yata2PlotCandlestick(plot, df, info)
      # df = pnl$df3
      # df$tms = as.Date(df$tms)
      # plot = yata2PlotCandlestick(plot, df, "STORJ")
      # 
      # info$id="plot3"
      # info$ui="plot21"
      # info$plot="Candlestick"
      # 
      # output$plot21 = upd2Plot(plot, info)
       plot1 = OBJPlot$new("plot1", plot="Line", observer=ns("modebar")
                                  , data = pnl$df1, scale = "date")
       browser()
       output$plot11 = forceAndCall(1, upd2Plot, plot1, "plot11")
       pnl$updatePlot("plot11", plot1)
       output$plot12 = upd2Plot(plot1, "plot12", plot1$getInfo())
       pnl$updatePlot("plot12", plot1)
       observeEvent(input$modebar, {
         # Podemos tener el mismo plot en dos sitios
         # Asi que los atributos van con el ui
         mode = input$modebar
         info = pnl$plotsInfo[[mode$ui]]
         # Esto va el JS
         if (as.logical(mode$tagvalue)) {
             if (info$tag == mode$datavalue) return()
             info$datavalue = mode$tag
         } else {
            info$type = mode$tag
         }
         eval(parse(text=paste0("output$", mode$ui, " = upd2Plot(plot, '", mode$ui, "',info=info)")))
         pnl$updatePlot(mode$ui, plot)

         # plot$setInfo(info)
         # 
         # 
         # eval(parse(text=paste0(input$modebar$render, "(info)")))
          
      })
      

  })
}    
