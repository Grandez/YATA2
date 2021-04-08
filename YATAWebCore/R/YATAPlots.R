yuiPlot = function(id)   {
  cls  = "yata_plot_nodata"
  data = h3(style="padding-top: 16px", "No data selected")
  tagList( plotlyOutput(id)
          ,hidden(tags$div(id=paste0(id, "_nodata"), class=cls
            ,tags$img(src="yata/img/warning.png", width="48px", height="48px", style="margin-right: 32px")
            ,data))
          )
}
updPlot = function(plot, ui, info) {
   # si no hay info es la primera vez
   if (is.null(plot)) {
       shinyjs::hide(ui)
       shinyjs::show(paste0(ui, "_nodata"))
       return(NULL)
   }
   shinyjs::show(ui)
   shinyjs::hide(paste0(ui, "_nodata"))
   if (missing(info))
       plot$render(ui)
   else
       plot$refresh(ui, info)
}
# .yataPlotConfig = function(plot) {
# # Configuracion en https://github.com/plotly/plotly.js/blob/master/src/plot_api/plot_config.js
#   noButtons = c('autoScale2d', 'resetScale2d'
#                 ,'hoverClosestCartesian','hoverCompareCartesian'
#                 ,'zoomIn2d', 'zoomOut2d'
#                 ,'zoom2d' ,'pan2d','select2d','lasso2d'
#                 ,'sendDataToCloud'
#                 ,'toggleSpikelines'
#
#             ,'toImage'
#            )
#    plot %>% plotly::config( displaylogo = FALSE, locale = "es"
#                  ,modeBarButtonsToRemove = noButtons
#           )
# }
# yataPlotBase = function(id=NULL) {
# #  src = ifelse(is.missing(id), "A", info$plotly)
#    p = plot_ly(source=id) %>% .yataPlotConfig()
#    p %>% layout(legend = list(orientation = 'h'))
# }
#
# .yataPlotTrace = function(plot, x, y, type, mode, name, ...) {
#     plot %>% add_trace(x=x,y=y,type=type, mode=mode, name=name, ...)
# }
# .yataPlotScatter = function(plot, df, info, mode, ...) {
#    if (info$datavalue == "Variation") df = .calcVariation(df)
# #    dfp = .getXY(df, cols)
# #    plot = plot %>% add_trace( data=dfp, x=~x,y=~y
#      names = colnames(df)
#
#      for (col in 2:ncol(df)) {
#         plot = plot %>% .yataPlotTrace(df[,1],df[,col],"scatter", mode, names[col], ...)#
#        # plot = plot %>% add_trace( data=df, x=df[,1],y=df[,col]
#        #                        ,type="scatter", mode=mode, name=names[col]
# #                              ,hoverinfo = 'text', text = ~.hoverValue(name, x, y)
#            # ,hovertemplate = paste('<b>', title, '</b><br>'
#            #     , 'Date: ', as.Date(df[,1], format="%d/%m/%Y")
#            #     , '<br>Value: ', round(df[,2], digits=0))
#
#        # hovertemplate = paste('<i>Price</i>: $%{y:.2f}',
#        #                  '<br><b>X</b>: %{x}<br>',
#        #                  '<b>%{text}</b>'),
# #                              ,...)
#      }
#        plot
# }
# .yataPlotBar = function(plot, df, info, mode, ...) {
#     if (info$datavalue == "Variation") df = .calcVariation(df)
#     names = colnames(df)
#     for (col in 2:ncol(df)) {
#         plot =  plot %>% .yataPlotTrace(df[,1],df[,col],"bar", mode, names[col], ...)
#     }
#     plot
# }
#
# yataPlotLine = function(plot, df, info) {
#   .yataPlotScatter(plot,df,info,mode="lines", line=list(width=0.75))
# }
# yataPlotMarker = function(plot, df, info) {
#   .yataPlotScatter(plot, df, info, mode="lines+markers", line=list(width=0.75))
# }
# yataPlotPoint = function(plot, df, info) {
#   .yataPlotScatter(plot,df, info, mode="markers")
# }
# yataPlotBar = function(plot, df, info) {
#   .yataPlotBar(plot, df, info, mode="group")
# }
# yataPlotCandlestick = function(plot, df, info) {
#
# #  p = yataPlotBase(info)
#   p =  plot %>% add_trace(data=df, x=~tms, open=~open, close=~close, high=~high, low=~low, type="candlestick")
#   p =  p %>% layout(xaxis = list(rangeslider = list(visible = F)))
#   p =  p %>% layout(legend = list(orientation = 'h'))
#   p
# }
#
# yataPlot = function(info, df) {
#    if (is.null(df)) return (NULL)
#    plot = yataPlotBase()
#    eval(parse(text=paste0("yataPlot", info$plot, "(plot, df, info)")))
# }
#
# .hoverValue = function(title, x, y) {
#     paste('<b>', title, '</b><br>'
#                , 'Date: ', as.Date(x, format="%d/%m/%Y")
#                , '<br>Value: ', round(y, digits=0))
# }
#
# .getXY = function(df, cols) {
#     if (is.null(cols)) {
#        df2 = df[,1:2]
#     } else {
#        df2 = df[,cols]
#     }
#     colnames(df2) = c("x", "y")
#     df2
# }
#
# .calcVariation = function(df) {
#    dfz = rollapply(df[,2:ncol(df)], 2, function(x) ((x[2] / x[1]) - 1) * 100, fill=0,align="right")
#    cbind(df[,1], dfz)
# }
