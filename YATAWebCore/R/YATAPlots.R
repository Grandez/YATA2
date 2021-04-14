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
OBJPlot = R6::R6Class("OBJ.PLOT"
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = TRUE
    ,public = list(
        plot    = NULL
       ,id      = NULL
       ,print          = function() { message("Plotly Object")}
       ,initialize     = function(id, ...) {
           self$id = id
           private$info$object = id
           args = list(...)
           if (!is.null(args$info))     private$info          = list.merge(info, args$info)
           if (!is.null(args$type))     private$info$type     = args$type
           if (!is.null(args$observer)) private$info$observer = args$observer
           if (!is.null(args$scale))    private$scale         = args$scale
           if (!is.null(args$data))     addData(args$data)

           private$svg = HashMap$new()
           self$plot = private$base()
       }
       ,setObserver = function(observer) { private$info$observer = observer }
       ,refresh = function(ui, info=NULL, type) {
           self$plot = private$base()
           render(ui,info,type)
        }
       ,render = function(ui, info=NULL, type) {
           # Genera el plot
           if (!missing(info) && !is.null(info)) private$info = list.merge(private$info, info)
           private$info$type = calcType(type)
           lapply(1:length(data), function(idx) prepareData(idx))

           buttons = getSVGGroup(ui)
           if (!is.null(buttons))            self$plot = plotly::config(plot, modeBarButtonsToAdd = buttons)
           if (!is.null(private$info$title)) self$plot = plotly::layout(plot, title = info$title)
           private$generated = TRUE
           plotly::renderPlotly({plot}) # %>% event_register("plotly_legendclick")
       }
       ,calcType = function(type) {
          # Define el tipo de plot a hacer
          if (!missing(type))      return (type)
          if (!is.null(info$type)) return (info$type)
          dt = data[[length(data)]]
          ifelse (dt$source == "session", "Candlestick", "Line")
       }
       ,setType = function(type)   { private$info$type = type }
       ,setInfo = function(info)   { private$info = info      }
       ,getInfo = function(info)   { private$info             }
       ,setScale = function(scale) { private$scale = scale    }
       ,Bar = function(df, ...) {
         trace(df,"bar", mode="group", ...)
         invisible(self)
      }
       ,Line = function(df, ...) {
          private$info$plot="Line"
          trace(df, type="scatter", mode="lines", line=list(width=0.75))
          invisible(self)
       }
       ,Marker = function(df, ...) {
          trace(df, type="scatter", mode="lines+markers", line=list(width=0.75))
          invisible(self)
       }
       ,Point = function(df, ...) {
          trace(df, type="scatter", mode="markers")
          invisible(self)
       }
       ,Candlestick = function(df) {
           candle(df)
           invisible(self)
        }
       ,hasData   = function()     { ifelse(length(private$data) == 0, FALSE, TRUE) }
       ,hasSource = function(name) { !is.null(data[[name]]) }
       ,addData = function(df, name, ui) {
         dftype = "Value"
         private$info$datasource = "value"
         if (missing(name)) name = paste0("data", length(private$data))
         if (ncol(df) > 3) {
             if (sum(colnames(df) %in% c("high", "low", "open", "close")) > 0) {
                 dftype = "session"
                 if (info$datasource != "session") private$info$datasource = "session"
             }
         }
         # Se actualizan datos. Hay que refrescar todo
         if (!is.null(private$data$name)) {
             self$plot = private$base()
             private$generated = FALSE
         }
         private$data[[name]] = list(source=dftype, data=df)
         if (!generated) {
             render(ui, NULL, info$type)
         } else {
             idx = which(names(data) == name)[1]
             prepareData(idx)
             plotly::renderPlotly({plot})
         }
       }
    )
    ,private = list(
         info = list(
             datavalue = "Value"
            ,datasource = "price"
            ,observer   = "modebar"
            ,type       = "Line"
            ,changed    = FALSE
         )
        ,svg   = NULL
        ,scale = NULL
        ,generated = FALSE # Flag para si insertamos datos
        ,xAxis = 1     # Que columna es el eje X?
         # Data contiene los datos de cada trace
         # name, type, data
        ,data   = list()
        ,base = function(id=NULL) {
            #  src = ifelse(is.missing(id), "A", info$plotly)
            p = plot_ly(source=id)
            p = config(p)
            plotly::layout(p, legend = list(orientation = 'h'))
        }
        ,trace = function(df, type, mode, name, ...) {
            names = colnames(df)
            if (info$datavalue == "Variation") {
                df = rollapply(df[,2:ncol(df)], 2, function(x) ((x[2] / x[1]) - 1) * 100, fill=0,align="right")
            }
            for (col in 2:ncol(df)) {
               self$plot = plotly::add_trace(plot, x=df[,xAxis],y=df[,col],type=type, mode=mode, name=names[col], ...)
            }
            self$plot
        }
       ,candle = function(df) {
           self$plot = add_trace(plot, data=df, x=~tms, open=~open, close=~close, high=~high, low=~low
                                     , type="candlestick")
           self$plot =  layout(plot, xaxis = list(rangeslider = list(visible = F)))
           self$plot
        }
        ,applyScale = function(x) {
           if (is.null(scale)) return(x)
           if (scale == "date") return (as.Date(x))
           if (scale == "time") return (as.POSIXct(x, format="%H:%M:%S"))
           x
        }
        ,config = function(plot) {
# Configuracion en https://github.com/plotly/plotly.js/blob/master/src/plot_api/plot_config.js
            noButtons = c('autoScale2d', 'resetScale2d'
                          ,'hoverClosestCartesian','hoverCompareCartesian'
                ,'zoomIn2d', 'zoomOut2d'
                ,'zoom2d' ,'pan2d','select2d','lasso2d'
                ,'sendDataToCloud'
                ,'toggleSpikelines'

            ,'toImage'
           )
           plotly::config(plot, displaylogo = FALSE, locale = "es"
                              ,modeBarButtonsToRemove = noButtons
                         )
        }
       ,prepareData = function(idx) {
           dat = data[[idx]]
           df = dat$data
           df[,xAxis] = applyScale(df[,xAxis])
           if (info$type == "Candlestick") return (Candlestick(df))
           if (dat$source == "session") {
               df = dat$data[,c("tms", "close")]
               colnames(df) = c("tms", names(data)[idx])
               df[,xAxis] = applyScale(df[,xAxis])
           }
           eval(parse(text=paste0(info$type, "(df)")))
       }
       ######################################################################
       ### MODEBAR                                                        ###
       ######################################################################
      ,getSVGGroup = function(ui) {
          modes = c("Log", "Variation", "Value")
          values = c("Line", "Marker", "Bar", "Point")
          if (info$datasource != "session") buttons = values
          if (info$datasource == "session") buttons = c("Candlestick", values)
          buttons = buttons[buttons != info$type]
          btn0 = lapply(buttons, function(x) getButton(x, ui))
          btn1 = lapply(modes,   function(x) getButtonOnOff(x, ui))

          c(btn0, btn1)
      }
       ,getButton = function(name, ui) {
           btn = svg$get(name)
           if (is.null(btn)) {
               btn = eval(parse(text=paste0("svg", name, "(name)")))
               svg$put(name, btn)
           }
           btn$click=createJS(name, ui, FALSE)
           btn
       }
       ,getButtonOnOff = function(name, ui) {
           btn = eval(parse(text=paste0("svg", name, "On(name, '", info$datavalue, "')")))
           btn$click=createJS(name, ui, TRUE)
           btn
       }

       ,svgLine        = function(name) { list(name=name, icon=list(svg=readSVG("plot.svg")))                 }
       ,svgMarker      = function(name) { list(name=name, icon=list(svg=readSVG("line-chart-2.svg")))    }
       ,svgCandlestick = function(name) { list(name=name, icon=list(svg=readSVG("plot-candlestick-alt.svg"))) }
       ,svgBar         = function(name) { list(name=name, icon=list(svg=readSVG("plot-bar-axes.svg")))      }
       ,svgPoint       = function(name) { list(name=name, icon=list(svg=readSVG("scatter-graph.svg")))      }
       ,svgLogOn       = function(name, act) {
           svg = ifelse(act == name, "log-on.svg", "log-off.svg")
           list(name=name, icon=list(svg=readSVG(svg)))
        }
       ,svgVariationOn       = function(name, act) {
           svg = ifelse(act == name, "var-on.svg", "var-off.svg")
           list(name=name, icon=list(svg=readSVG(svg)))
        }
       ,svgValueOn       = function(name, act) {
           svg = ifelse(act == name, "euro-on.svg", "euro-off.svg")
           list(name=name, icon=list(svg=readSVG(svg)))
        }
       ,createJS = function(type, ui, data) {
          force(ui)
#          message("Para ", ui)
           private$info$plot = type
           js = paste0("function(gd) { ")
           # msg = paste("entra en el boton",  force(ui))
           # js = paste(js, "alert('", msg, "');")
           # js = paste(js, "throw('JGG');")
           # js = paste0(js, "alert(this.name + '", type, "');")
           # js = paste0(js, "throw('Parate');")
           # js = paste0(js, "if (this.name == '", type, "') return; ")
           # js = paste(js, "alert('Envia');")
           js = paste0(js, "Shiny.setInputValue('", info$observer, "', {")

           info$tag = type
           info$tagvalue = data
           info$ui = force(ui)

           js = paste0(js,"ui: '", force(ui), "'")
           for (item in names(info)) js = paste0(js, ",", item, ": '", info[[item]], "'")
           js = paste(js,"}, {priority: 'event'});}")
           htmlwidgets::JS(js)
       }
       ,readSVG = function(fname) {
           sf = system.file(paste0("extdata/svg/", fname), package="YATACore")
           data = readLines(sf)
           tit = grep("<title>",data)
           if (length(tit) > 0) data = data[-tit[1]]
           data = paste(data, collapse=" ")
           idx = str_locate(data, "<svg")
           substr(data, idx[1], nchar(data))
       }
    )
)

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
