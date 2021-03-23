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
