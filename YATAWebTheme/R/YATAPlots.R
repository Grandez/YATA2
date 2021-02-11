# Se encarga de gestionar los plots
# Se invoca desde widgetPlots

hover = paste('<b>%{fullData.name}</b><br>'
              ,'value: %{y:.2f}<br>'
              ,'%{x}')

#########################################
# https://plotly-r.com/control-modebar.html

# La lista de botones esta en
# https://github.com/plotly/plotly.js/blob/master/src/components/modebar/buttons.js
#############################################

.pltBase = function() {
   p = plot_ly()
   p %>% .pltToolbar()
}

plotLineTypes = c("solid", "dot", "dash", "longdash", "dashdot", "longdashdot")

.pltToolbar = function(p) {
    p %>% config(displaylogo = FALSE, collaborate = FALSE
           # ,modeBarButtonsToRemove = c(
           #      'sendDataToCloud'
           #     ,'autoScale2d'
           #     ,'resetScale2d'
           #     ,'toggleSpikelines'
           #     ,'hoverClosestCartesian'
           #     ,'hoverCompareCartesian'
           #     ,'zoom2d'
           #     ,'pan2d'
           #     ,'select2d'
           #     ,'lasso2d'
           #     ,'zoomIn2d'
           #     ,'zoomOut2d'
           # )
          )
}

##################################################
### Parametros generales
##################################################

lines = list(width = 0.75)
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


pltLines  = function(df, x=1, options = list()) {
   xx = x
   if (is.character(x)) xx = which(colnames(df) == x)
   lay = list(title="")
  p = .pltBase()
  mode = "lines"
  if (!is.null(options$markers)) mode = paste0(mode, "+markers")
  for (idx in 1:ncol(df)) {
      if (idx != xx) {
          p = p %>% add_trace( data=df, x=df[,xx], y=df[,idx]
                              ,name=colnames(df)[idx]
                              ,type = 'scatter', mode = mode, line = lines
                              ,hovertemplate = hover
             )      
      }
  }
  
  if (!is.null(options$title)) lay$title = options$title
   p = p %>% layout(title=lay$title)
# x <- list(
#   title = "x Axis",
#   titlefont = f
# )   
   # layout(xaxis = x, yaxis = y)
  p
}

pltBars  = function(df, x=1, options = list()) {
   xx = x
   if (is.character(x)) xx = which(colnames(df) == x)
   lay = list(title="")
  p = .pltBase()

  for (idx in 1:ncol(df)) {
      if (idx != xx) {
          p = p %>% add_trace(data=df, x=df[,xx], y=df[,idx], name=colnames(df)[idx], type = 'bar')      
      }
  }
  
  if (!is.null(options$title)) lay$title = options$title
   p = p %>% layout(title=lay$title)
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



#
# Animals <- c("giraffes", "orangutans", "monkeys")
# SF_Zoo <- c(20, 14, 23)
# LA_Zoo <- c(12, 18, 29)
# data <- data.frame(Animals, SF_Zoo, LA_Zoo)
#
# fig <- plot_ly(data, x = ~Animals, y = ~SF_Zoo, type = 'bar', name = 'SF Zoo')
# fig <- fig %>% add_trace(y = ~LA_Zoo, name = 'LA Zoo')
# fig <- fig %>% layout(yaxis = list(title = 'Count'), barmode = 'group')

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
#     # if (term == 4) {
#     #     browser()
#     # }
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

#' @export
plotCandle = function(plot, x, open, close, high, low, ...) {
    p = list(...)
    title = p$hover[1]
    if (length(p$hover) > 1) title = paste0(title, " (", p$hover[2], ")")

    add_trace(plot, type = "candlestick"
              , x=x, open=open, close=close, high=high, low=low
              , line=list(width=0.75)
              ,alist(attrs)
              , name = title
              , hoverinfo = 'text'
              , text = ~.hoverlbl(title, x, close)
    ) %>% layout(xaxis = list(rangeslider = list(visible = F)))
}




#' @export
plotLogs = function(plot, x, data, hoverText) {

    cols = ncol(data)
    if (cols > 2) lTypes = c(plotLineTypes[2], plotLineTypes[3], plotLineTypes[2])
    if (cols > 4) lTypes = c(plotLineTypes[4], lTypes,           plotLineTypes[4])

    for (i in 1:cols) {
        title = hoverText[1]
        if (length(hoverText) > 1) title = paste0(hoverText[1], " (", hoverText[i+1], ")")
        plot = plotLog(plot, x, as.vector(data[,i]), cols[((i-1) %% cols) + 1], hoverText = title)
    }
    plot
}

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
