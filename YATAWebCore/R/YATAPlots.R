# Se encarga de gestionar los plots
# Se invoca desde widgetPlots

# Iconos de la modebar
# los cogemos de https://fontawesome.com
# Cogemos el d de path
# Jugamos con el escale

yataPlot = function(info, df, title) {
  plot = NULL
   if (info$type == "Candlestick") plot = pltCandle(info, df, title)
   if (info$type == "Linear")    {
       if (info$src == "session") df = df[,-(2:7)]
       plot = pltLines (info, df, title)
   }
   if (info$type == "Variation")   plot = pltBars (info, prepareVariation(df), title)
   plot
}

#########################################
# https://plotly-r.com/control-modebar.html

# La lista de botones esta en
# https://github.com/plotly/plotly.js/blob/master/src/components/modebar/buttons.js
#############################################

# createJS = function(info, type) {
#   js = "function(gd) { Shiny.setInputValue('"
#   js = paste0(js, info$id, "', {")
#   js = paste0(js, " type: '", type, "'")
#   for (item in names(info)) {
#       js = paste0(js, ",", item, ": '", info[[item]], "'")
#   }
#   js = paste(js,"}, {priority: 'event'});}")
#   js
# }
#
pltModeBar = function(info) {
#     if (info$src == "full") {
#         icoAnim = list(name="Animate", icon = list(svg=typeAnim), click=jscript("Animate"))
#     }
# }
#     ,transform = "scale(2)"
#    ,transform = "matrix(0.75 0 0 -0.75 0 1000)"

# scale (x, y) =  matrix(x 0 0 y 0 0).
# barTickers = function(info) {
# pathVar = paste0( "M16 128h416c8.84 0 16-7.16 16-16V48c0-8.84-7.16-16-16-16H16C7.16 32 0 39.16 0 "
#                 ,"48v64c0 8.84 7.16 16 16 16zm480 80H80c-8.84 0-16 7.16-16 16v64c0 8.84 7.16 16 16 "
#                 ,"16h416c8.84 0 16-7.16 16-16v-64c0-8.84-7.16-16-16-16zm-64 176H16c-8.84 0-16 "
#                 ,"7.16-16 16v64c0 8.84 7.16 16 16 16h416c8.84 0 16-7.16 16-16v-64c0-8.84-7.16-16-16-16z")
#    pathCandle = paste0("M410.916,375.428v22.415H0V13.072h22.413v362.355H410.916z "
#                   ,"M89.193,315.652h11.208v-50.431h10.27V145.689h-10.27V93.393"
# 		          ,"H89.193v52.296H78.917v119.533h10.277V315.652z M152.69,241.872h11.207v-51.365"
#                   ,"h10.276V70.971h-10.276V19.606H152.69v51.365h-10.27"
# 		          ,"v119.536h10.27V241.872z M215.727,279.229h11.207v-49.488h10.271V110.194h-10.271"
# 		          ,"V56.963h-11.207v53.231h-10.276V229.73h10.276V279.229z M287.169,300.243h11.21"
# 		          ,"v-49.965h10.273V130.742h-10.273V77.976h-11.21v52.767h-10.269v119.536h10.269V300.243z"
# 		          ,"M360.484,242.349h11.206v-51.833h10.271V70.971H371.69V20.077h-11.206v50.895"
# 		          ,"h-10.276v119.536h10.276V242.349z"
#    )
#    pathLine = paste0( "M 15.332031 14.667969 L 1.75 14.667969 L 4.226562 9.71875 L 7.574219 12.511719"
#                      ,"C 7.722656 12.636719 7.917969 12.691406 8.113281 12.65625 C 8.304688 12.625"
#                      ,"8.472656 12.511719 8.574219 12.34375 L 12.5 5.808594 L 12.828125 6.832031 C 12.914062"
#                      ,"7.109375 13.171875 7.296875 13.460938 7.296875 C 13.53125 7.296875 13.601562 7.285156"
#                      ,"13.664062 7.265625 C 14.015625 7.152344 14.207031 6.777344 14.097656 6.425781"
#                      ,"L 13.25 3.835938 C 13.195312 3.667969 13.078125 3.527344 12.921875 3.445312"
#                      ,"C 12.765625 3.363281 12.582031 3.347656 12.414062 3.402344 L 9.882812 4.210938"
#                      ,"C 9.550781 4.335938 9.375 4.699219 9.484375 5.035156 C 9.589844 5.375 9.945312"
#                      ,"5.570312 10.289062 5.480469 L 11.335938 5.148438 L 7.828125 11 L 4.425781 8.15625"
#                      ,"C 4.269531 8.023438 4.0625 7.972656 3.863281 8.015625 C 3.664062 8.054688 3.496094"
#                      ,"8.1875 3.402344 8.367188 L 1.332031 12.5 L 1.332031 0.667969 C 1.347656 0.417969"
#                      ,"1.222656 0.183594 1.011719 0.0546875 C 0.800781 -0.0742188 0.53125 -0.0742188"
#                      ,"0.320312 0.0546875 C 0.109375 0.183594 -0.015625 0.417969 0 0.667969 L 0 15.332031"
#                      ,"C 0.00390625 15.363281 0.0117188 15.394531 0.015625 15.425781 C 0.0234375 15.472656"
#                      ,"0.03125 15.519531 0.046875 15.566406 C 0.0664062 15.605469 0.0859375 15.644531"
#                      ,"0.109375 15.675781 C 0.128906 15.714844 0.152344 15.75 0.179688 15.78125 C 0.214844"
#                      ,"15.816406 0.25 15.84375 0.292969 15.871094 C 0.316406 15.890625 0.339844 15.914062"
#                      ,"0.367188 15.929688 L 0.394531 15.929688 L 0.433594 15.941406 C 0.507812 15.972656"
#                      ,"0.585938 15.988281 0.664062 15.988281 L 15.332031 15.988281 C 15.582031 16.003906"
#                      ,"15.816406 15.882812 15.945312 15.667969 C 16.074219 15.457031 16.074219 15.191406"
#                      ,"15.945312 14.976562 C 15.816406 14.765625 15.582031 14.640625 15.332031 14.65625"
#                      ,"Z M 15.332031 14.667969 ")
#
#    pathLog = paste("m 1752,3846 c 0,-45 -37,-82 -82,-82 -45,0 -82,37 -82,82 v 1732 c 0,45 37,82 82,82 45,0 82,-37 82,-82 z"
#                      ,"m 2876,3758 c 0,-45 -37,-82 -82,-82 -45,0 -82,37 -82,82 v 1819 c 0,45 37,82 82,82 45,0 82,-37 82,-82 z"
#    ,"m 4001,3433 c 0,-45 -37,-82 -82,-82 -45,0 -82,37 -82,82 v 2145 c 0,45 37,82 82,82 45,0 82,-37 82,-82 z"
#    ,"m 5125,2841 c 0,-45 -37,-82 -82,-82 -45,0 -82,37 -82,82 v 2737 c 0,45 37,82 82,82 45,0 82,-37 82,-82 z"
#    ,"m 885,3466 c -45,-2 -83,33 -85,78 -2,45 33,83 78,85 8,0 2803,157 5016,-2426 29,-34 25,-86 -9,-115 -34,-29 -86,-25 -115,9 C 3610,3618 893,3466 885,3466 Z"
#    ,"m 4399,1061 c -45,0 -82,36 -82,82 0,45 36,82 82,82 h 1358 v 1358 c 0,45 36,82 82,82 45,0 82,-36 82,-82 0,-480 0,-960 0,-1439 0,-45 -37,-82 -82,-82 H 4400 Z"
#    )
#
#    icoCandle = list(name="Candle", icon = list(
#       path = pathCandle
#      ,width  = 1000
#      ,height = 1000
#      ,transform = "scale(2.5 2.5) translate(2, -2)"
#   ), click = htmlwidgets::JS(createJS(info,"candle")))
#    icoLinear = list(name="Linear", icon = list(
#        path = pathLine
#        # path= "M 15.332031 14.667969 L 1.75 14.667969 L 4.226562 9.71875 L 7.574219 12.511719
#        #        C 7.722656 12.636719 7.917969 12.691406 8.113281 12.65625 C 8.304688 12.625
#        #        8.472656 12.511719 8.574219 12.34375 L 12.5 5.808594 L 12.828125 6.832031 C 12.914062
#        #        7.109375 13.171875 7.296875 13.460938 7.296875 C 13.53125 7.296875 13.601562 7.285156
#        #        13.664062 7.265625 C 14.015625 7.152344 14.207031 6.777344 14.097656 6.425781
#        #        L 13.25 3.835938 C 13.195312 3.667969 13.078125 3.527344 12.921875 3.445312
#        #        C 12.765625 3.363281 12.582031 3.347656 12.414062 3.402344 L 9.882812 4.210938
#        #        C 9.550781 4.335938 9.375 4.699219 9.484375 5.035156 C 9.589844 5.375 9.945312
#        #        5.570312 10.289062 5.480469 L 11.335938 5.148438 L 7.828125 11 L 4.425781 8.15625
#        #        C 4.269531 8.023438 4.0625 7.972656 3.863281 8.015625 C 3.664062 8.054688 3.496094
#        #        8.1875 3.402344 8.367188 L 1.332031 12.5 L 1.332031 0.667969 C 1.347656 0.417969
#        #        1.222656 0.183594 1.011719 0.0546875 C 0.800781 -0.0742188 0.53125 -0.0742188
#        #        0.320312 0.0546875 C 0.109375 0.183594 -0.015625 0.417969 0 0.667969 L 0 15.332031
#        #        C 0.00390625 15.363281 0.0117188 15.394531 0.015625 15.425781 C 0.0234375 15.472656
#        #        0.03125 15.519531 0.046875 15.566406 C 0.0664062 15.605469 0.0859375 15.644531
#        #        0.109375 15.675781 C 0.128906 15.714844 0.152344 15.75 0.179688 15.78125 C 0.214844
#        #        15.816406 0.25 15.84375 0.292969 15.871094 C 0.316406 15.890625 0.339844 15.914062
#        #        0.367188 15.929688 L 0.394531 15.929688 L 0.433594 15.941406 C 0.507812 15.972656
#        #        0.585938 15.988281 0.664062 15.988281 L 15.332031 15.988281 C 15.582031 16.003906
#        #        15.816406 15.882812 15.945312 15.667969 C 16.074219 15.457031 16.074219 15.191406
#        #        15.945312 14.976562 C 15.816406 14.765625 15.582031 14.640625 15.332031 14.65625
#        #        Z M 15.332031 14.667969 "
#      ,width  = 1000
#      ,height = 1000
#      ,transform = "scale(2.5 2.5) translate(2, -2)"
#   ), click = htmlwidgets::JS(createJS(info,"linear")))
#    icoLog = list(name="Log", icon = list(
#        path= pathLog
#      ,width  = 1000
#      ,height = 1000
#      ,transform = "matrix(0.75 0 0 -0.75 0 1000)"
#   ), click = htmlwidgets::JS(createJS(info,"log")))
#    icoBar = list(name="Bar", icon = list(
#        path= "M332.8 320h38.4c6.4 0 12.8-6.4 12.8-12.8V172.8c0-6.4-6.4-12.8-12.8-12.8h-38.4c-6.4 0-12.8 6.4-12.8 12.8v134.4c0 6.4 6.4 12.8 12.8 12.8zm96 0h38.4c6.4 0 12.8-6.4 12.8-12.8V76.8c0-6.4-6.4-12.8-12.8-12.8h-38.4c-6.4 0-12.8 6.4-12.8 12.8v230.4c0 6.4 6.4 12.8 12.8 12.8zm-288 0h38.4c6.4 0 12.8-6.4 12.8-12.8v-70.4c0-6.4-6.4-12.8-12.8-12.8h-38.4c-6.4 0-12.8 6.4-12.8 12.8v70.4c0 6.4 6.4 12.8 12.8 12.8zm96 0h38.4c6.4 0 12.8-6.4 12.8-12.8V108.8c0-6.4-6.4-12.8-12.8-12.8h-38.4c-6.4 0-12.8 6.4-12.8 12.8v198.4c0 6.4 6.4 12.8 12.8 12.8zM496 384H64V80c0-8.84-7.16-16-16-16H16C7.16 64 0 71.16 0 80v336c0 17.67 14.33 32 32 32h464c8.84 0 16-7.16 16-16v-32c0-8.84-7.16-16-16-16z"
#      ,width  = 1000
#      ,height = 1000
#      ,transform = "matrix(2.5 0 0 -2 0 1000)"
#   ), click = htmlwidgets::JS(createJS(info,"bar")))
#
#    icoVar = list(name="Variationr", icon = list(
#        path= pathVar
#      ,width  = 1000
#      ,height = 1000
#      ,transform = "matrix(2.5 0 0 -2 0 1000)"
#   ), click = htmlwidgets::JS(createJS(info,"var")))
#
#   list(icoCandle, icoLinear, icoLog, icoVar, icoBar)
}
.pltBase = function(info) {
   p = plot_ly() %>%
       plotly::config( displaylogo = FALSE
                  ,modeBarButtonsToRemove = c(
                 'sendDataToCloud'
           #     ,'autoScale2d'
           #     ,'resetScale2d'
                 ,'toggleSpikelines'
                ,'hoverClosestCartesian'
                ,'hoverCompareCartesian'
           #     ,'zoom2d'
                ,'pan2d'
           #     ,'select2d'
                ,'lasso2d'
               ,'zoomIn2d'
               ,'zoomOut2d'
            ,'toImage'
           )
          )
   svg = YATAWEB$factory$getObject("SVG")
   buttons = svg$getSVGGroup(info, info$src)
   if (!is.null(buttons)) p = p %>% plotly::config(modeBarButtonsToAdd = buttons)
   p
}

plotLineTypes = c("solid", "dot", "dash", "longdash", "dashdot", "longdashdot")


axis <- list(
  autotick = TRUE,
  ticks = "outside",
  tick0 = 0,
  dtick = 0.25,
  ticklen = 5,
  tickwidth = 2,
  tickcolor = "blue" # toRGB("blue")
)

vline <- function(x = 0, color = "red") {
    list( type = "line"
         ,y0 = 0
         ,y1 = 1
         ,yref = "paper"
         ,x0 = x
         ,x1 = x
         ,line = list(color = color)
    )
}
zone = function(x0, x1) {
    list( type = "rect"
         ,fillcolor = "blue"
         ,line = list(color = "blue")
         ,opacity = 0.2
         ,x0 = x0
         ,x1 = x1
         ,xref = "x"
         ,yref = "paper"
         ,y0 = 0
         ,y1 = 1
    )
}

pltLines  = function(info, df, title=NULL, markers=TRUE) {
 # Espera el eje X en la columna 1, una columna por linea
  p = .pltBase(info)
  mode = "lines"
  names = colnames(df)
  if (markers) mode = paste0(mode, "+markers")
  for (icol in 2:ncol(df)) {
       p = p %>% add_trace(data=df, x=df[,1], y=df[,icol], type = 'scatter', mode = mode, name=names[icol])
  }
  p = p %>% layout(legend = list(orientation = 'h'))
  if (!is.null(title)) p = p %>% layout(title = title)
  p
}

pltCandle = function(info, df, title=NULL, markers=TRUE) {
  p = .pltBase(info)
  p =  p %>% add_trace(data=df, x=~tms, open=~open, close=~close, high=~high, low=~low, type="candlestick")
  p =  p %>% layout(xaxis = list(rangeslider = list(visible = F)))
  p =  p %>% layout(legend = list(orientation = 'h'))
  if (!is.null(title)) p = p %>% layout(title = title)
  p
}

#########################################################################
#########################################################################
#########################################################################
#########################################################################
















pltLines2 = function(df) {
   p = plot_ly(df, x=df[,1])
   for (idx in 2:ncol(df)) {
        nm = colnames(df)[idx]
        p = p %>%  add_trace(y = df[,idx], name = nm, type='scatter', mode='lines+markers')
   }
   p
}
pltLog = function(df, x=NULL, y=NULL, lType="solid", hoverText="titulo") {
    plot = pltBase()
    title = hoverText[1]
    if (is.null(x)) x=df[,1]
    plot = plot_ly(df, x = x, type = 'scatter', mode = 'line+markers')
    if (is.null(y)) {
        from = 2
        to   = ncol(df)
    }
    else {

    }
    for (idx in from:to) {
       plot = plot %>% plotly::add_trace(y = df[,idx], name = colnames(df)[idx])
    }
    if (length(hoverText) > 1) title = paste0(title, " (", hoverText[2], ")")
    plotly::layout(plot, yaxis = list(type = "log"))
}

# p <-
#   plot_ly(
#     atc_seg_master,
#     x = ~ Month_considered,
#     type = 'scatter',
#     mode = 'line+markers',
#     line = list(color = 'rgb(205, 12, 24)', width = 4)
#   )
#
# for (trace in colNames) {
#   p <-
#     p %>% plotly::add_trace(y = as.formula(paste0("~`", trace, "`")), name = trace)
# }
#
# p %>%
#   layout(
#     title = "Trend Over Time",
#     xaxis = list(title = ""),
#     yaxis = list (title = "Monthly Count of Products Sold")
#   )
# p

.plotBase = function(plot, type, x, y=NULL, title=NULL, attr=NULL, ...) {
    if (is.null(y) || is.na(y)) return (NULL)
    PLOT = FACT_PLOT$new()

    if (type == PLOT$LOG)    return (plotLog (plot, x, y, ...))
    if (type == PLOT$BAR)    return (plotBar (plot, x, y, ...))
    if (type == PLOT$POINT)  return (plotPoint (plot, x, y, ...))
    if (type == PLOT$CANDLE) {
        p = list(...)
        return (plotCandle(plot, x, p$open, p$close, p$high, p$low, ...))
    }
    #if (type == PLOT$LINE)   return (
        plotLine(plot, x, y, title, attr, ...)
}

pltBars = function(info, df, title=NULL, markers=TRUE) {
  p = .pltBase(info)
  cols = colnames(df)
  for (idx in 2:ncol(df)) {
     p = p %>% add_trace(y = df[,idx], name = cols[idx], type='bar')
  }
  p %>% layout(yaxis = list(title = 'Count'), barmode = 'group')
}

#' @description
#' Genera el plot general de una criptomoneda
#' @param vars Conjunto de vriables reactivas, entre ella tickers
#' @param model Modelo a aplicar
# renderPlotSession = function(tickers, sources, types) {
#     if (is.null(tickers) || is.null(tickers$df)) return (NULL)
#
#     heights = list(c(1.0), c(0.6, 0.4), c(0.5, 0.25, 0.25), c(0.4, 0.2, 0.2, 0.2))
#     DT::renderDataTable({ renderTable() })
#     items = length(sources)
#     plots = list()
#     df    = tickers$df
#
#     idx = 0
#     while (idx < items) {
#         idx = idx + 1
#         p = plot_ly()
#
#         if (!is.null(sources[idx]) && !is.na(sources[idx])) {
#             p = YATACore::plotBase(p, types[idx], x=df[,tickers$DATE]
#                                    , y=df[,sources[idx]]
#                                    , open      = df[,tickers$OPEN]
#                                    , close     = df[,tickers$CLOSE]
#                                    , high      = df[,tickers$HIGH]
#                                    , low       = df[,tickers$LOW]
#                                    , hoverText = tickers$symbol)
#             if (!is.null(p)) plots = list.append(plots, plotly_build(hide_legend(p)))
#         }
#     }
#
#     rows = items - sum(is.na(sources))
#      sp = subplot( plots, nrows = rows, shareX=T, heights=heights[[rows]]) %>% config(displayModeBar=F)
#      sp$elementId = NULL
#      sp
# }
#
# renderPlot2 = function(vars, model, term, input, showInd) {
#     print("Entra en renderPlot")
#
#     if (is.null(vars$tickers)) return (NULL)
#
#     if (showInd) showInd = input$chkShowInd
#     type=PLOT_LINEAR
#     if (term == TERM_LONG) type = PLOT_CANDLE
#     plots = plotData(vars$clicks, term, vars$tickers, case$model,  showInd, type )
#     if (is.null(plots)) return (NULL)
#
#     sp = subplot( hide_legend(plots[[1]])
#                  ,hide_legend(plots[[2]])
#                  ,hide_legend(plots[[3]])
#                  ,nrows = 3
#                  ,shareX=T
#                  ,heights=c(0.5,0.25, 0.25)) %>%
#          config(displayModeBar=F)
#
#     sp$elementId = NULL
#     sp
# }
#
# plotData = function(flag, term, data, model, showIndicators, type=PLOT_LINEAR) {
#
#     FUN=function(x) {
#         if (x[1] == x[2]) return (0)
#         if (x[2] == 0)    return (0)
#         vv = x[1]/x[2];
#         if ( vv > 1.03) rr = 1
#         else { if (vv < .97) rr = -1
#                else rr = 0
#         }
#         rr
#     }
#
#       if (is.null(data)) return (NULL)
#
#       tickers = data$getTickers(term)
#       if (is.null(tickers) || is.null(tickers$df)) return (NULL)
#
#       df = tickers$df
#       if (nrow(df) == 0) return(NULL)
#       if (type == PLOT_LINEAR) {
#           p1 <- plot_ly(df, x = df[,tickers$DATE], y = df[,tickers$PRICE], type = 'scatter', mode = 'lines')
#           p1 <- layout(p1, xaxis = axis)
#       }
#       if (type == PLOT_LOG) {
#           p1 <- plot_ly(df, x = df[,tickers$DATE], y = df[,tickers$PRICE], type = 'scatter', mode = 'lines')
#           p1 <- layout(p1, xaxis = axis, yaxis = list(type = "log"))
#       }
#       if (type == PLOT_CANDLE) {
#           p1 <- plot_ly(df, type="candlestick",x=df[,tickers$DATE]
#                                                    ,open=df[,tickers$OPEN]
#                                                    ,close=df[,tickers$CLOSE]
#                                                    ,high=df[,tickers$HIGH]
#                                                    ,low=df[,tickers$LOW])
#           p1 <- layout(p1, xaxis = list(rangeslider = list(visible = F)))
#       }
#
#       p1$elementId <- NULL # Evitar aviso del widget ID
#
#       cc = rollapply(df[,tickers$VOLUME],2,FUN, fill=0,align="right")
#
#       p2 <- plot_ly(df, x = df[,tickers$DATE], y = df[,tickers$VOLUME], type = 'bar', marker=list(color=cc))
#       p2$elementId = NULL
#
#       p3 = plot_ly(df)
#
#       plots = list(p1, p2, p3)
#       if (showIndicators) {
#           plots = model$plotIndicators  (term, plots, data, indicators)
#       }
#       #if (showIndicators) plots = model$plotIndicators  (term, plots, tickers, indicators)
#       plots
# #
# #
# # #        plots = case$model$plotIndicatorsSecundary(case$data, plots, input$chkPlots2)
# #
# #         shapes = list()
# #         shapes = list.append( shapes
# #                              ,vline(vars$df[vars$fila, "Date"])
# #         #                     ,zone(vars$df[vars$fila, "Date"], df[nrow(df),"Date"])
# #                              )
# #
# #         plots[[1]] = plots[[1]] %>% layout(xaxis = axis, shapes=shapes)
# #         plots[[2]] = plots[[2]] %>% layout(shapes=shapes)
# #
#
# }
#
# basicTheme <- function() {
#     t0 = theme( panel.background = element_blank()
#                 ,axis.text.y=element_text(angle=90)
#                 ,axis.text.x=element_blank()
#                 ,panel.border = element_rect(colour = "black", fill=NA, size=1)
#                 ,legend.position="none"
#
#     )
# }
#
# basePlot1 <- function(data) {
#     t0 = basicTheme()
#
#     p1 = ggplot(data,aes(x=date, y=price)) +
#         geom_line() # +
#         #geom_smooth(method="lm") +
# #        ylab("Precio")
#
#     t1 = t0 # + theme(axis.text.x=element_blank(),legend.position="none")
#     t1 = t1 + theme(axis.title.x=element_blank(), axis.ticks.x = element_blank())
#     p1 + t1
# }
#
# basePlot2 <- function(data) {
#     t0 = basicTheme()
#
#     tmp = data
#     tmp$c = rollapply(df,2,FUN=function(x) { v = x[1]/x[2];
#                                             if ( v > 1.03) r = 1
#                                             else { if (v < .97) r = -1
#                                                    else r = 0
#                                                  }
#                                             r }, fill=0,align="right")
#
#     p2 = ggplot(data,aes(date, volume/1000,fill=c)) +
#         geom_bar(stat="identity") +
#         ylab("Volumen (Miles)") #+
#         #scale_x_date(date_breaks = "1 week", date_labels = "%d/%m/%Y") +
#         #scale_fill_continuous(low="red", high="green")
#
#     t2 = t0 + theme(axis.text.x=element_text(angle=45, hjust=1))
#     p2 + t2
# }
#
# basicPlot <- function(data) {
#
#     p1 = ggplot(data,aes(x=date, y=price)) +
#         geom_line() +
#         geom_smooth(method="lm") +
#         ylab("Precio")
#
#     p2 = ggplot(data,aes(date, volume/1000,fill=Volume)) +
#         geom_bar(stat="identity") +
#         ylab("Volumen (Miles)") +
#         scale_x_date(date_breaks = "1 week", date_labels = "%d/%m/%Y") +
#         scale_fill_continuous(low="red", high="green")
#
#     t0 = theme( panel.background = element_blank()
#                 ,axis.text.y=element_text(angle=90)
#                 ,panel.border = element_rect(colour = "black", fill=NA, size=1)
#     )
#
#     t1 = t0 + theme(axis.title.x=element_blank(),axis.ticks.x = element_blank())
#     t2 = t0 + theme(axis.text.x=element_text(angle=45, hjust=1))
#
#     p1A = p1 + t1
#     p2A = p2 + t2
#     grid.arrange(p1A,p2A,heights=c(6,4))
# }




.hoverlbl = function(title, x, y) {
    paste('<b>', title, '</b><br>'
               , 'Date: ', as.Date(x, format="%d/%m/%Y")
               , '<br>Value: ', round(y, digits=0))
}




#' @export
plotLine = function(plot, x, y, title=NULL, attr=NULL, ...) {
    name = title

    l=list(width=0.75, dash="solid")
    if (!is.null(attr)) l = attr

    add_trace(plot, x=x, y=y, type = "scatter", mode = "lines"
               , line=l
               , name = title
               , hoverinfo = 'text'
               , text = ~.hoverlbl(title, x, y)
    )
}
#' @export
plotPoint = function(plot, x, y, title=NULL, color=NULL, ...) {

    #title = hover[1]
    #if (length(hover) > 1) title = paste0(title, " (", hover[2], ")")

    add_trace(plot, x=x, y=y, type="scatter", mode = "markers"
                  , color=I(color)
                  , name = title
                  # , hoverinfo = 'text'
                  # , text = ~.hoverlbl(title, x, y)
    )
}

#' @export
plotMarker = function(plot, x, y, hover=c(""), line=NULL, ...) {
    title = hover[1]

    p = add_trace(plot, x=x, y=y, type = "scatter", mode = "lines+markers"
                  , line=list(width=0.75, dash=lType)
                  , name = title
                  , hoverinfo = 'text'
                  , text = ~.hoverlbl(title, x, y)
    )
    p
}

#' @export
plotLines = function(plot, x, data, hoverText) {

    cols = ncol(data)
    if (cols > 2) lTypes = c(plotLineTypes[2], plotLineTypes[3], plotLineTypes[2])
    if (cols > 4) lTypes = c(plotLineTypes[4], lTypes,           plotLineTypes[4])

    for (i in 1:cols) {
        title = hoverText[1]
        if (length(hoverText) > 1) title = paste0(hoverText[1], " (", hoverText[i+1], ")")
        plot = plotLine(plot, x, as.vector(data[,i]), cols[((i-1) %% cols) + 1], hoverText = title)
    }
    plot
}

#' @export
plotBar = function(plot, x, y, ...) {
    colors = c('rgba(0,0,255,1)', 'rgba(0,255,0,1)', 'rgba(255,0,0,1)')
    FUN=function(x) {
        if (length(x) != 2) return (1)
        if (is.na(x[1]) || is.na(x[2])) return (1)
        if (x[1] == x[2])           return (1)
        if (x[2] == 0)              return (1)
        vv = x[1]/x[2];
        if ( vv > 1.03) rr = 3
        else { if (vv < .97) rr = 2
                else rr = 1
        }
        rr
    }

    cc = rollapply(y, 2, FUN, fill=0, align="right")
    add_trace(plot, x=x, y=y, type='bar', orientation='v'
                  , marker=list(color=colors[cc])
                  # , hoverinfo = 'text'
                  # , name = hoverText
                  # , text = ~.hoverlbl(hoverText, x, y)
    )

}


# plotCandle = function(plot, x, open, close, high, low, ...) {
#     p = list(...)
#     title = p$hover[1]
#     if (length(p$hover) > 1) title = paste0(title, " (", p$hover[2], ")")
#
#     add_trace(plot, type = "candlestick"
#               , x=x, open=open, close=close, high=high, low=low
#               , line=list(width=0.75)
#               ,alist(attrs)
#               , name = title
#               , hoverinfo = 'text'
#               , text = ~.hoverlbl(title, x, close)
#     ) %>% layout(xaxis = list(rangeslider = list(visible = F)))
# }





# plotLogs = function(plot, x, data, hoverText) {
#
#     cols = ncol(data)
#     if (cols > 2) lTypes = c(plotLineTypes[2], plotLineTypes[3], plotLineTypes[2])
#     if (cols > 4) lTypes = c(plotLineTypes[4], lTypes,           plotLineTypes[4])
#
#     for (i in 1:cols) {
#         title = hoverText[1]
#         if (length(hoverText) > 1) title = paste0(hoverText[1], " (", hoverText[i+1], ")")
#         plot = plotLog(plot, x, as.vector(data[,i]), cols[((i-1) %% cols) + 1], hoverText = title)
#     }
#     plot
# }

# Tipo de lineas
# Sets the dash style of lines.
# Set to a dash type string ("solid", "dot", "dash", "longdash", "dashdot", or "longdashdot")
# or a dash length list in px (eg "5px,10px,2px,2px").



# plotLine = function(data, indicator, plots) {
#     for (iList in 1:length(indicator$result)) {
#         ind = indicator$result[[iList]]
#         for (idx in 1:length(ind)) {
#            cName = indicator$columns[[idx]]
#            df = .plotMakeDF(data, ind[[idx]], cName)
#            plots[[iList]] = add_trace(plots[[iList]],x=df[,1],y=df[,2],name=cName,type="scatter",mode="lines")
#         }
#     }
#     plots
# }


plotSegment = function(data, indicator, plots) {
    res = indicator$result[[1]]
    inter = res$coefficients[1]
    slope = res$coefficients[2]

    plots[[1]] = add_segments(plots[[1]], x = data$df[1,"Date"], xend = data$df[nrow(data$df),"Date"]
                                        , y = inter,             yend = inter + (nrow(data$df) * slope))
    plots
}

plotTrend = function(data, indicator, plots) {
    # ticks =   data$tickers
    # df = ticks$getData()
    # res = indicator$result
    # inter = res$coefficients[1]
    # slope = res$coefficients[2]
    #
    # x=c(df[1,ticks$DATE], df[nrow(df),ticks$DATE])
    # y = c(inter, nrow(df) * slope)
    # plots[[1]] = add_trace(plots[[1]], x=x, y=y, mode="lines")
    plots
}

plotOverlay = function(data, indicator, plots) {

    styles = list( list(width = 1,   dash = 'solid')
                  ,list(width = 0.6, dash = 'dash' )
                  ,list(width = 0.3, dash = 'dot'  ))

    for (idx in 1:length(indicator$result)) {
        groups = round(length(indicator$columns))

        df = cbind(data$df[,data$DATE],indicator$result[[idx]])
        colnames(df) = c(data$DATE, indicator$columns)

        nCol = 1
        for (col in indicator$columns) {
            plots[[idx]] = add_trace(plots[[idx]], x=df[,data$DATE], y=df[,col], name=col
                                         ,type="scatter", mode="lines", line=styles[[(nCol %% groups)+1]])
            nCol = nCol + 1
        }
    }
    plots
}

plotOverlay2 = function(data, indicator, plots) {
    styles = list( list(width = 1,   dash = 'solid')
                  ,list(width = 0.6, dash = 'dash' )
                  ,list(width = 0.3, dash = 'dot'  ))

    for (idx in 1:length(indicator$result)) {
        groups = round(length(indicator$columns))

        df = cbind(data$df[,data$DATE],indicator$result[[idx]])
        colnames(df) = c(data$DATE, indicator$columns)

        nCol = 1
        for (col in indicator$columns) {
            plots[[idx]] = add_trace(plots[[idx]], x=df[,data$DATE], y=df[,col], name=col
                                         ,type="scatter", mode="lines", line=styles[[(nCol %% groups)+1]])
            nCol = nCol + 1
        }
    }
    plots
}

plotMaxMin = function(data, indicator, plots) {
    dfr = as.data.frame(indicator$result)
    dfb = data$df
    col = parse(text=paste0("dfb$",data$PRICE))
    names(dfr) = "MaxMin"

    max = dfr %>% group_by(MaxMin) %>% summarise(veces=n()) %>% arrange(desc(MaxMin)) %>% head(n=3)
    dfM = dfb[eval(col) %in% c(max$MaxMin),]
    plots[[1]] = add_trace(plots[[1]], data=dfM, x=~Date, y=~Price, mode="markers", marker=list(color="green"))

    min = dfr %>% group_by(MaxMin) %>% summarise(veces=n()) %>% arrange(desc(MaxMin)) %>% head(n=3)
    min$MaxMin = min$MaxMin * -1
    dfm = dfb[eval(col) %in% c(min$MaxMin),]
    plots[[1]] = add_trace(plots[[1]], data=dfm, x=~Date, y=~Price, mode="markers", marker=list(color="red"))
    plots
}

.plotMakeDF = function(data, ind, colName) {
    df = as.data.frame(data$df[,data$DATE])
    df = cbind(df, ind)
    colnames(df) = c(data$DATE, colName)
    df
}

.plotAttr = function(...) {
    p = eval(substitute(alist(...)))
    eval(p$title, env=parent.env(parent.frame()))
    p = list(...)
    res = list()

    if (!is.null(p$hover)) {
        title = p$hover[1]
        if (length(p$hover) > 1) title = paste0(title, " (", p$hover[2], ")")
        res = list.append(res, name=title)
        res = list.append(res, hoverinfo = 'text')
        res = list.append(res, text = quote(~.hoverlbl(title, x, y)))
    }
    if (!is.null(p$title)) res = list.append(res, name=p$title)
    res
}


#   octocat <- list(
#   name = "octocat",
#   icon = "Icons.camera",
#   # icon = list(
#   #   path = "yata/img/graph_log.svg"
#   # ,transform = 'matrix(1 0 0 1 -2 -2) scale(0.7)'
#   # ),
#   click = htmlwidgets::JS(
# #    "function() { Shiny.setInputValue('plotlyJGG', {plot: 'id', type='linear'}, {priority: 'event'});}"
#     "function() { alert('Icono clickado'); Shiny.setInputValue('JGGFOO', 'bar', {priority: 'event'});}"
#   )
# )
#
# mc_icon_svg_path = "M29.375 16c0-1.438-0.375-2.813-1.063-4.063-0.75-1.188-1.75-2.125-2.938-2.875-1.313-0.688-2.625-1.063-4-1.063-1.813 0-3.438 0.563-4.875 1.625 1.313 1.188 2.125 2.563 2.563 4.188h-0.75c-0.375-1.375-1.125-2.688-2.313-3.75-1.188 1.063-1.938 2.375-2.313 3.75h-0.75c0.438-1.625 1.25-3 2.563-4.188-1.438-1.063-3.063-1.625-4.875-1.625-1.375 0-2.688 0.375-4 1.063-1.188 0.75-2.188 1.688-2.938 2.875-0.688 1.25-1.063 2.625-1.063 4.063s0.375 2.813 1.063 4.063c0.75 1.188 1.75 2.125 2.938 2.875 1.313 0.688 2.625 1.063 4 1.063 1.813 0 3.438-0.563 4.875-1.625-1.188-1.063-2-2.313-2.5-3.875h0.75c0.438 1.313 1.188 2.5 2.25 3.438 1.063-0.938 1.813-2.125 2.25-3.438h0.75c-0.5 1.563-1.313 2.813-2.5 3.875 1.438 1.063 3.063 1.625 4.875 1.625 1.375 0 2.688-0.375 4-1.063 1.188-0.75 2.188-1.688 2.938-2.875 0.688-1.25 1.063-2.625 1.063-4.063zM6.125 14.063h1.25l-0.625 3.875h-0.813l0.5-2.938-1.063 2.938h-0.625v-2.938l-0.5 2.938h-0.813l0.688-3.875h1.188v2.375zM9.875 15.688c0 0.188-0.063 0.375-0.063 0.563-0.063 0.313-0.125 0.625-0.188 0.875 0 0.25-0.063 0.438-0.125 0.625v0.188h-0.625v-0.375c-0.188 0.313-0.5 0.438-0.875 0.438-0.25 0-0.375-0.063-0.5-0.188-0.188-0.188-0.25-0.438-0.25-0.688 0-0.375 0.125-0.688 0.375-0.875 0.313-0.188 0.688-0.313 1.125-0.313h0.313v-0.188c0-0.188-0.188-0.25-0.563-0.25-0.188 0-0.5 0-0.813 0.125 0-0.188 0.063-0.438 0.125-0.688 0.313-0.125 0.625-0.188 0.938-0.188 0.75 0 1.125 0.313 1.125 0.938zM8.938 16.5h-0.188c-0.438 0-0.688 0.188-0.688 0.5 0 0.188 0.063 0.313 0.25 0.313s0.313-0.063 0.438-0.188c0.125-0.125 0.188-0.313 0.188-0.625zM12.188 14.813l-0.125 0.75c-0.188-0.063-0.375-0.063-0.625-0.063s-0.375 0.063-0.375 0.25c0 0.063 0 0.125 0.063 0.188l0.25 0.125c0.375 0.25 0.563 0.5 0.563 0.875 0 0.688-0.375 1.063-1.25 1.063-0.375 0-0.688-0.063-0.813-0.063 0-0.188 0.063-0.438 0.125-0.75 0.313 0.063 0.563 0.125 0.688 0.125 0.313 0 0.5-0.063 0.5-0.25 0-0.063-0.063-0.188-0.063-0.188-0.125-0.125-0.188-0.188-0.375-0.188-0.375-0.188-0.563-0.5-0.563-0.875 0-0.688 0.375-1.063 1.188-1.063 0.375 0 0.688 0 0.813 0.063zM13.438 14.813h0.375l-0.063 0.813h-0.438c0 0.188-0.063 0.375-0.063 0.563 0 0.063-0.063 0.125-0.063 0.25 0 0.188-0.063 0.25-0.125 0.313v0.25c0 0.188 0.125 0.25 0.313 0.25 0.063 0 0.125 0 0.25-0.063l-0.125 0.75c-0.125 0-0.313 0.063-0.625 0.063-0.438 0-0.625-0.25-0.625-0.688 0-0.25 0-0.563 0.125-0.875l0.313-2.063h0.813zM16.375 15.875c0 0.313 0 0.563-0.063 0.813h-1.625c0 0.188 0.063 0.375 0.125 0.438 0.125 0.125 0.313 0.188 0.563 0.188 0.313 0 0.563-0.063 0.875-0.25l-0.125 0.813c-0.188 0.063-0.5 0.125-0.875 0.125-0.875 0-1.375-0.5-1.375-1.375 0-0.625 0.125-1.063 0.438-1.375 0.25-0.313 0.563-0.5 0.938-0.5s0.688 0.125 0.875 0.313c0.188 0.188 0.25 0.438 0.25 0.813zM14.75 16h0.938v-0.188l-0.063-0.125c0-0.063-0.063-0.125-0.063-0.125-0.063 0-0.125-0.063-0.188-0.063h-0.125c-0.25 0-0.438 0.125-0.5 0.5zM18.438 14.813c-0.063 0.063-0.125 0.375-0.313 0.938-0.188-0.063-0.313 0.063-0.5 0.313-0.125 0.5-0.188 1.125-0.313 1.875h-0.875l0.063-0.188c0.188-1.25 0.313-2.25 0.438-2.938h0.813l-0.125 0.438c0.188-0.188 0.313-0.313 0.438-0.375 0.125-0.125 0.25-0.125 0.375-0.063zM21.25 14.188l-0.188 0.813c-0.25-0.125-0.5-0.188-0.688-0.188-0.375 0-0.625 0.125-0.813 0.375s-0.25 0.563-0.25 1.063c0 0.313 0.063 0.563 0.188 0.688 0.125 0.188 0.313 0.25 0.563 0.25 0.188 0 0.438-0.063 0.688-0.188l-0.125 0.875c-0.188 0.063-0.438 0.125-0.75 0.125-0.438 0-0.75-0.188-1.063-0.5-0.25-0.25-0.375-0.625-0.375-1.188 0-0.625 0.188-1.188 0.563-1.625 0.313-0.438 0.75-0.688 1.313-0.688 0.188 0 0.5 0.063 0.938 0.188zM23.625 15.688c0 0-0.063 0.125-0.063 0.25s0 0.25 0 0.313c-0.063 0.25-0.125 0.563-0.188 0.938 0 0.375-0.063 0.625-0.125 0.75h-0.625v-0.375c-0.188 0.313-0.5 0.438-0.875 0.438-0.25 0-0.375-0.063-0.5-0.188-0.188-0.188-0.25-0.438-0.25-0.688 0-0.375 0.125-0.688 0.375-0.875 0.313-0.188 0.625-0.313 1.063-0.313h0.313c0.063-0.063 0.063-0.125 0.063-0.188 0-0.188-0.188-0.25-0.5-0.25-0.25 0-0.563 0-0.875 0.125 0-0.188 0-0.438 0.125-0.688 0.375-0.125 0.625-0.188 0.938-0.188 0.75 0 1.125 0.313 1.125 0.938zM22.688 16.5h-0.188c-0.438 0-0.688 0.188-0.688 0.5 0 0.188 0.125 0.313 0.25 0.313 0.188 0 0.313-0.063 0.438-0.188s0.188-0.313 0.188-0.625zM25.625 14.813c-0.125 0.188-0.25 0.5-0.313 0.938-0.188-0.063-0.313 0.063-0.438 0.313s-0.188 0.875-0.375 1.875h-0.813l0.063-0.188c0.188-1 0.313-2 0.375-2.938h0.813c0 0.188-0.063 0.313-0.063 0.438 0.125-0.188 0.25-0.313 0.375-0.375 0.188-0.063 0.313-0.125 0.375-0.063zM27.688 14.063h0.875l-0.688 3.875h-0.75l0.063-0.313c-0.188 0.25-0.438 0.375-0.75 0.375-0.375 0-0.563-0.125-0.688-0.375-0.25-0.25-0.375-0.563-0.375-0.875 0-0.625 0.188-1.063 0.5-1.438 0.188-0.313 0.5-0.5 0.875-0.5 0.313 0 0.563 0.125 0.813 0.375zM27.375 16.125c0-0.375-0.188-0.563-0.438-0.563-0.188 0-0.375 0.063-0.5 0.313-0.063 0.125-0.125 0.375-0.125 0.75s0.125 0.563 0.375 0.563c0.188 0 0.375-0.063 0.5-0.25s0.188-0.438 0.188-0.813z"
#
# icon2="M61.33,58.67H7l9.9-19.8L30.29,50.05a2.67,2.67,0,0,0,4-.68L50,23.24l1.31,4.09a2.67,2.67,0,0,0,2.54,1.86,2.54,2.54,0,0,0,.81-.13,2.68,2.68,0,0,0,1.73-3.35L53,15.34a2.66,2.66,0,0,0-3.35-1.73L39.53,16.84a2.67,2.67,0,0,0,1.62,5.08l4.19-1.33L31.32,44,17.71,32.62a2.68,2.68,0,0,0-4.1.85L5.33,50V2.67A2.67,2.67,0,1,0,0,2.67V61.33a3.49,3.49,0,0,0,.07.37,2.62,2.62,0,0,0,.12.57,2.76,2.76,0,0,0,.25.44,2.79,2.79,0,0,0,.28.42,2.58,2.58,0,0,0,.45.35,2.25,2.25,0,0,0,.3.24l.11,0,.15.05a2.58,2.58,0,0,0,.93.19H61.33a2.67,2.67,0,1,0,0-5.33Z"
# # (2) Scale/translate works, after some trial and error
#
#
# mc_button <- list(
#   name = "MasterCard",
#   icon = list(
#     path = mc_icon_svg_path[[1]]
#     ,transform = "scale(0.6 0.6) translate(-3, -2)"
#   ),
#   click = htmlwidgets::JS(
#     "function(gd) {window.open('http://www.mastercard.com', '_blank')}"
#   )
# )
#
# barras = list(
#   name="BARRAS"
#   ,icon = list(
#     path= "M332.8 320h38.4c6.4 0 12.8-6.4 12.8-12.8V172.8c0-6.4-6.4-12.8-12.8-12.8h-38.4c-6.4 0-12.8 6.4-12.8 12.8v134.4c0 6.4 6.4 12.8 12.8 12.8zm96 0h38.4c6.4 0 12.8-6.4 12.8-12.8V76.8c0-6.4-6.4-12.8-12.8-12.8h-38.4c-6.4 0-12.8 6.4-12.8 12.8v230.4c0 6.4 6.4 12.8 12.8 12.8zm-288 0h38.4c6.4 0 12.8-6.4 12.8-12.8v-70.4c0-6.4-6.4-12.8-12.8-12.8h-38.4c-6.4 0-12.8 6.4-12.8 12.8v70.4c0 6.4 6.4 12.8 12.8 12.8zm96 0h38.4c6.4 0 12.8-6.4 12.8-12.8V108.8c0-6.4-6.4-12.8-12.8-12.8h-38.4c-6.4 0-12.8 6.4-12.8 12.8v198.4c0 6.4 6.4 12.8 12.8 12.8zM496 384H64V80c0-8.84-7.16-16-16-16H16C7.16 64 0 71.16 0 80v336c0 17.67 14.33 32 32 32h464c8.84 0 16-7.16 16-16v-32c0-8.84-7.16-16-16-16z"
#    ,width= 1000
#    ,height= 1000
#      ,transform = "scale(3)"
# #    ,transform = "matrix(0.75 0 0 -0.75 0 1000)"
#   )
#     ,click = htmlwidgets::JS("function(gd) { Shiny.setInputValue('pot-plotly', {plot: 'id', type:'linear'}, {priority: 'event'});"
# #    "function(gd) {alert('Pulsado');}"
#   )
#
# )
#
# lockIcon = list(
#   name = "LOCK"
#   ,icon = list(
#   path= "M320 768h512v192q0 106 -75 181t-181 75t-181 -75t-75 -181v-192zM1152 672v-576q0 -40 -28 -68t-68 -28h-960q-40 0 -68 28t-28 68v576q0 40 28 68t68 28h32v192q0 184 132 316t316 132t316 -132t132 -316v-192h32q40 0 68 -28t28 -68z"
#    ,width= 1000
#    ,height= 1000
#     ,transform = "matrix(0.75 0 0 -0.75 0 1000)"
#
#   )
#   ,click = htmlwidgets::JS("function(gd) { Shiny.setInputValue('pos-plotly', {id: 'unid', type:'grafico'}, {priority: 'event'});}")
# #   ,click = htmlwidgets::JS("function(gd) {alert('Pulsado');}")
# )
#
#
# 	otro <- list(
#   name = "Barrras",
#   icon = list(svg="yata/img/graph_line2.svg",width=16,height=16),
# #     path = icon2[[1]]
# # #    ,transform = "scale(0.7 0.7) translate(-3, -2)"
# #     ,transform = "scale(0.7 0.7) translate(-3, -2)"
# #   ),
#   click = htmlwidgets::JS("function(gd) {alert('Boton pulsado');}")
# )
#
# # fig.show(config={'modeBarButtonsToAdd':['drawline',
# #                                         'drawopenpath',
# #                                         'drawclosedpath',
# #                                         'drawcircle',
# #                                         'drawrect',
# #                                         'eraseshape'
#                                        ]})
