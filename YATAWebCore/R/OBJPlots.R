isPlot = function(obj, full=TRUE) {
    if ("YATA.PLOT" %in% class(obj)) return (TRUE)
    if (full && "plotly" %in% class(obj)) return(TRUE)
    FALSE
}
yuiPlot = function(id, height=NULL)   {
   cls  = "yata_plot_nodata"
   data = h3(style="padding-top: 16px", "No data selected")
   tagList( plotlyOutput(id, height=height)
           ,hidden(tags$div(id=paste0(id, "_nodata"), class=cls
                  ,tags$img(src="yata/img/warning.png", width="48px", height="48px", style="margin-right: 32px")
                  ,data))
          )
}
yuiSubPlots = function(..., nrows=2) {
  args = list(...)
  if (nrows > 1) {
      plotly::subplot(lapply(list(...), function(plot) if (isPlot(plot, FALSE)) plot$getPlot() else plot),shareX = TRUE, nrows=nrows, heights= c(0.75, 0.25))
  } else {
      plotly::subplot(lapply(list(...), function(plot) if (isPlot(plot, FALSE)) plot$getPlot() else plot))
  }
}
updSubPlots = function(subplot) {plotly::renderPlotly(subplot) }

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
YATAPlot = R6::R6Class("YATA.PLOT"
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = TRUE
    ,public = list(
        plot    = NULL
       ,id      = NULL
       ,print      = function() { message("Plotly Object")}
       ,initialize = function(id, ...) {
           self$id = id
           private$info$object = id
           args = list(...)
           if (!is.null(args$info))     private$info          = list.merge(info, args$info)
           if (!is.null(args$type))     private$info$type     = args$type
           if (!is.null(args$observer)) private$info$observer = args$observer
           if (!is.null(args$ui))       private$info$ui       = args$ui

           if (!is.null(args$scale))    private$scale         = args$scale
           if (!is.null(args$title))    private$title         = args$title
           if (!is.null(args$data))     addData(args$data)

           private$svg = HashMap$new()
           self$plot = private$base()
       }
      ,getPlot = function() {
          if (!generated) generatePlot()
          self$plot %>% layout(showlegend = FALSE)
       }
       ,setObserver = function(observer) { private$info$observer = observer }
       ,setTitle    = function(title)    { private$title = title }
       ,refresh = function(ui, info=NULL, type) {
           self$plot = private$base()
           render(ui,info,type)
        }
       ,render = function(ui=NULL, info=NULL, type=NULL) {
           if (!private$generatePlot(ui, info, type)) return (NULL)
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
       ,getSourceNames = function() { names(data) }
       ,setSourceNames = function(sources) {
          lapply(names(data), function(src)
                              private$data[[src]]$visible = ifelse (src %in% sources, TRUE, FALSE))
          invisible(self)
        }
       ,getColumnNames = function(source) { colnames(data[[source]]$data)}
       ,selectSource   = function(source, visible=TRUE) {
           private$data[[source]]$visible = visible
           invisible(self)
       }
       ,selectColumns  = function(source, columns) {
         if (!is.null(private$data[[source]])) private$data[[source]]$columns = columns
         invisible(self)
       }
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
           if (private$current$visible) candle(df)
           invisible(self)
       }
       ,Pie = function(df) {
           if (private$current$visible) self$plot = plotly::add_pie(plot, labels=df[,1],values=~count)
           invisible(self)
        }
       ,hasData   = function()     { ifelse(length(private$data) == 0, FALSE, TRUE) }
       ,hasSource = function(name) { !is.null(data[[name]]) }
       ,setData   = function(df, name, add=FALSE)   {
           if (is.null(df)) return (invisible(self))
           dftype = "Value"
           if (missing(name)) name = paste0("data", length(private$data))
           if (ncol(df) > 3 && sum(colnames(df) %in% c("high", "low", "open", "close")) > 0) {
                   dftype = "session"
                   private$info$datasource = "session"
           }
           if (add) {
               if (is.null(private$data[[name]])) {
                   private$data[[name]] = list(source=dftype, data=df)
               } else {
                   private$data[[name]]$data = df
               }
           }
           else     {
               private$data = list(list(source=dftype, data=df))
               names(private$data) = name
           }
           private$generated = FALSE
           invisible(self)
       }
       ,addData = function(df, name, ui) {
          if (is.null(df)) return(invisible(self))
           dftype = "Value"
           private$info$datasource = "value"
           if (missing(name)) name = paste0("data", length(private$data))
           if (ncol(df) > 3) {
               if (sum(colnames(df) %in% c("high", "low", "open", "close")) > 0) {
                   dftype = "session"
                   if (info$datasource != "session") private$info$datasource = "session"
               }
           }
         # # Se actualizan datos. Hay que refrescar todo
         # if (!is.null(private$data$name)) {
         #     self$plot = private$base()
         #     private$generated = FALSE
         # }
         private$data[[name]] = list(source=dftype, data=df)
         # if (!generated) {
         #     render(ui, NULL, info$type)
         # } else {
         #     idx = which(names(data) == name)[1]
         #     prepareData(idx)
         #     plotly::renderPlotly({plot})
         # }
         private$generated = FALSE
         invisible(self)
       }
       ,removeData = function(name) {
           private$data[name] = NULL
           private$generated = FALSE
           invisible(self)
       }
      ,addXLines = function(data) {

      }
      ,removeXLines = function() {
         private$xLines = NULL
      }
    )
    ,private = list(
         info = list(
             datavalue  = "Value"
            ,datasource = "price"
            ,observer   = "modebar"
            ,type       = "Line"
            ,ui         = ""
            ,changed    = FALSE
         )
        ,current = NULL
        ,svg   = NULL
        ,scale = NULL
        ,title = NULL
        ,generated = FALSE # Flag para si insertamos datos
        ,xAxis = 1     # Que columna es el eje X?
        ,xLines = NULL
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
            if (!is.null(private$current$visible) && !private$current$visible) return (self$plot)
            names = colnames(df)
            if (info$datavalue == "Variation") {
                df = rollapply(df[,2:ncol(df)], 2, function(x) ((x[2] / x[1]) - 1) * 100, fill=0,align="right")
            }
            for (col in 2:ncol(df)) {
              if (is.null(private$current$columns) || names[col] %in% private$current$columns) {
                  self$plot = plotly::add_trace(plot, x=df[,xAxis],y=df[,col]
                                                    , type=type, mode=mode
                                                    , name=names[col]
                                                    , ...)
              }
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
           private$current = dat
           eval(parse(text=paste0(info$type, "(df)")))
       }
       ,generatePlot = function(ui=NULL, info=NULL, type=NULL) {
           private$generated = FALSE
           self$plot = private$base()
           if (!is.null(info)) private$info = list.merge(private$info, info)
           if (!is.null(type)) private$info$type = calcType(type)
           if (length(data) > 0) {
               lapply(1:length(data), function(idx) prepareData(idx))
               if (!is.null(ui)) private$info$ui = ui
               buttons = getSVGGroup()
               if (!is.null(buttons))       self$plot = plotly::config(plot, modeBarButtonsToAdd = buttons)
               if (!is.null(private$title)) self$plot = plotly::layout(plot, title = private$title)
               private$generated = TRUE
           }
           private$generated
       }
       ######################################################################
       ### MODEBAR                                                        ###
       ######################################################################
      ,getSVGGroup = function() {
          modes = c("Log", "Variation", "Value")
          values = c("Line", "Marker", "Bar", "Point")
          if (info$datasource != "session") buttons = values
          if (info$datasource == "session") buttons = c("Candlestick", values)
          buttons = buttons[buttons != info$type]
          btn0 = lapply(buttons, function(x) getButton(x))
          btn1 = lapply(modes,   function(x) getButtonOnOff(x))

          c(btn0, btn1)
      }
       ,getButton = function(name) {
           btn = svg$get(name)
           if (is.null(btn)) {
               btn = eval(parse(text=paste0("svg", name, "(name)")))
               svg$put(name, btn)
           }
           btn$click=createJS(name, info$ui, FALSE)
           btn
       }
       ,getButtonOnOff = function(name) {
           btn = eval(parse(text=paste0("svg", name, "On(name, '", info$datavalue, "')")))
           btn$click=createJS(name, info$ui, TRUE)
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
