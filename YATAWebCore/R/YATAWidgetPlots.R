###################################################
### Widgets que dibujan graficos
### Permite definir los panles dinamicamente
###################################################

plotDay = function(pnl) {
   p = NULL
   sess = pnl$getSessionDay()
   df = sess$get("BTC")
   if (nrow(df) > 0) p = plot_ly(df, x = df[,"tms"], y = df[,"close"], type = 'scatter', mode = 'lines')
   p
}
plotBar = function(pnl) {
    browser()
   pltBars(pnl$df, x="symbol",y="prc")
}

plotSession = function(pnl, df) {
   browser()
   if (missing(df)) df = pnl$getDFSession()
   pltLog(df)
}

# PLOT el valor o la vaiacion.
# Espera tms, monedas
plotTicker = function(df) {
   p = pltBase()
   p %>% pltLog(p, df$tms, df$price, hoverText="titulo")
}

plotTickerVar = function(df) {
   dftmp = df
   for (idx in 2:ncol(dftmp)) {
      dftmp[,idx] = rollapply(dftmp[,idx], 2, function(x) ((x[2]/x[1]) - 1) * 100, align="right", fill=0)
   }
   pltLines(dftmp)
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
