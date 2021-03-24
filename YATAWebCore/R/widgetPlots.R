###################################################
### Widgets que dibujan graficos por su nombre o tipo
### Utiliza YATAPlots para hacer los graficos
### En funcion de la fuente sabemos que datos puede manejar
### Con esta info establecemos los botones
### Ejemplo:
###   Si tenemos open/close/high/etc.
###   Podemos hacer linea, diferencia, log, candle, etc
###################################################
yuiPlot = function(id) {
   plotlyOutput(id)
}
updPlot = function(plot) {
   renderPlotly({plot})
}

plotSession = function(info, df, title=NULL) {
   browser()
   if (is.null(info$type)) info$type = "Candlestick"
   genPlot(info,df,title)
}
plotPrice = function(info, df, title=NULL) {
   dfp = df
   if (info$src == "session") dfp = df[,c("tms","close")]
   if (is.null(info$type)) info$type = "Linear"
   genPlot(info,dfp,title)
}
plotVolume = function(info, df, title=NULL) {
   dfp = df
   if (info$src == "session") dfp = df[,c("tms","volume")]
   if (is.null(info$type)) info$type = "Bar"
   genPlot(info,dfp,title)
}

genPlot = function(info, df, title) {
   if (info$type == "Candlestick") return (pltCandle(info, df, title))
   if (info$type == "Linear")      return (pltLines (info, prepareLines(info, df), title))
   if (info$type == "Variation")   return (pltBars  (info, prepareVariation(df), title))
   if (info$type == "Bar")         return (pltBars  (info, df, title))
}
plotDay = function(info, df, title) {
   pltLines(info, df, title)
}
plotDayVar = function(info, df, title) {
   dftmp = df
   for (idx in 2:ncol(dftmp)) {
      dftmp[,idx] = rollapply(dftmp[,idx], 2, function(x) ((x[2]/x[1]) - 1) * 100, align="right", fill=0)
   }
   pltLines(info, dftmp, title)
}

# plotBar = function(pnl) {
#    pltBars(pnl$df, x="symbol",y="prc")
# }
#
# plotSession = function(pnl, df) {

#    if (missing(df)) df = pnl$getDFSession()
#    pltLog(df)
# }

# PLOT el valor o la vaiacion.
# Espera tms, monedas
plotTicker = function(info, df, title) {
   pltLines(info, df, title)
}

plotTickerVar = function(info, df,title) {
   dftmp = df
   for (idx in 2:ncol(dftmp)) {
      dftmp[,idx] = rollapply(dftmp[,idx], 2, function(x) ((x[2]/x[1]) - 1) * 100, align="right", fill=0)
   }
   pltLines(info, dftmp, title)
}

plotBest = function(info, df, title) {
   dft = df
   if (is.null(info$type))        return (pltCandle(info, df, title))
   if (info$type == "Linear")     return (pltLines (info, df[,-(2:7)], title))
   if (info$type == "Variation")  return (pltBars (info, prepareVariation(df), title))
   NULL
}
# https://plotly-r.com/control-modebar.html

# La lista de botones esta en
# https://github.com/plotly/plotly.js/blob/master/src/components/modebar/buttons.js

# plot_ly() %>%
#   config(modeBarButtonsToRemove = c("zoomIn2d", "zoomOut2d"))

# plot_ly() %>%
#   config(displaylogo = FALSE)

# plot_ly() %>%
#   config(displayModeBar = FALSE)

prepareVariation = function(info, df) {
   prcVar = function(x) { ifelse (x[1] == 0, 0, (x[2] / x[1] - 1) * 100) }
   # Obtiene las variaciones
   cols = colnames(df)
   idx = which(cols == "close")
   if (length(idx) > 0) {
      if (length(cols) > 7) {
          dft = rollapply(df[,8:ncol(df)], 2, prcVar, by.column=TRUE,fill=0, na.pad=0, align="right")
      } else {
         dft = rollapply(df[,"close"], 2, prcVar, by.column=TRUE,fill=0, partial=TRUE)
      }
      df2 = as.data.frame(cbind(df[,"tms"], dft))
      colnames(df2) = c("tms", cols[8:length(cols)])
   }
   df2
}
prepareLines = function(info, df) {
   dfp = df
   if (info$src == "session") { # Tenemos high,low, etc y posiblemente mas
      if (ncol(df) == 8) {
         dfp = df[,c("tms","close")]
         if (!is.null(info$symbol)) colnames(dfp) = c("tms", info$symbol)
      } else {
         dfp = df[,-(2:7)]
      }
   }
   dfp
}
