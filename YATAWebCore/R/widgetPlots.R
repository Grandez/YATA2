###################################################
### Widgets que dibujan graficos
### Utiliza YATAPlots para hacer los graficos
###################################################
yuiPlot = function(id) {
   plotlyOutput(id)
}
updPlot = function(plot) {
   renderPlotly({plot})
}


plotDay = function(df, title) {
   pltLines(df, title)
}
plotDayVar = function(df, title) {
   dftmp = df
   for (idx in 2:ncol(dftmp)) {
      dftmp[,idx] = rollapply(dftmp[,idx], 2, function(x) ((x[2]/x[1]) - 1) * 100, align="right", fill=0)
   }
   pltLines(dftmp, title)
}

# plotBar = function(pnl) {
#     browser()
#    pltBars(pnl$df, x="symbol",y="prc")
# }
#
# plotSession = function(pnl, df) {
#    browser()
#    if (missing(df)) df = pnl$getDFSession()
#    pltLog(df)
# }

# PLOT el valor o la vaiacion.
# Espera tms, monedas
plotTicker = function(df, title) {
   pltLines(df, title)
}

plotTickerVar = function(df,title) {
   dftmp = df
   for (idx in 2:ncol(dftmp)) {
      dftmp[,idx] = rollapply(dftmp[,idx], 2, function(x) ((x[2]/x[1]) - 1) * 100, align="right", fill=0)
   }
   pltLines(dftmp, title)
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
