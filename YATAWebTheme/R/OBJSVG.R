OBJSVG = R6::R6Class("OBJ.SVG"
    ,inherit    = OBJBase
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = TRUE
    ,public = list(
        print          = function() { message("SVG Generator")}
       ,initialize     = function(factory) {
           super$initialize(factory)
           private$svg = HashMap$new()
       }
      ,getSVGGroup = function(info, type) {
          modes = c("Log", "Variation", "Value")
          values = c("Line", "Marker", "Bar", "Point")
          if (type != "session") buttons = values
          if (type == "session") buttons = c("Candlestick", values)
          buttons = buttons[buttons != info$plot]
          btn0 = lapply(buttons, function(x) getButton(info, x))
          btn1 = lapply(modes,   function(x) getButtonOnOff(info, x))
          c(btn0, btn1)
      }
      ,getSVG = function(info, ...)  {
          svgs = args2list(...)
          res = lapply(svgs, function(x) getButton(info, x))
          res
      }
    )
    ,private = list(
        svg = NULL
       ,getButton = function(info, name) {
           btn = svg$get(name)
           if (is.null(btn)) {
               btn = eval(parse(text=paste0("svg", name, "(name)")))
               svg$put(name, btn)
           }
           btn$click=createJS(info, name, FALSE)
           btn
       }
       ,getButtonOnOff = function(info, name) {
           btn = eval(parse(text=paste0("svg", name, "On(name,'", info$datavalue, "')")))
           btn$click=createJS(info, name, TRUE)
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
       ,createJS = function(info, type, data) {
           info$plot = type
           js = "function(gd) { Shiny.setInputValue('"
           js = paste0(js, info$observer, "', {")
           js = paste0(js, " tag: '"    , type, "'")
           js = paste0(js, " ,tagvalue: '", data, "'")
           for (item in names(info)) {
                js = paste0(js, ",", item, ": '", info[[item]], "'")
           }
           js = paste(js,"}, {priority: 'event'});}")
           htmlwidgets::JS(js)
       }
       ,readSVG = function(fname) {
           sf = system.file(paste0("extdata/svg/", fname), package=packageName())
           data = readLines(sf)
           tit = grep("<title>",data)
           if (length(tit) > 0) data = data[-tit[1]]
           data = paste(data, collapse=" ")
           idx = str_locate(data, "<svg")
           substr(data, idx[1], nchar(data))
       }
    )
)
