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
          if (type != "session") buttons = c("Candlestick")
          if (type == "session") buttons = c("Candlestick", "Linear", "Markers", "Variation")
          lapply(buttons, function(x) getButton(info, x))
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
           btn$click=createJS(info, name)
           btn
       }
       ,svgLinear      = function(name) { list(name=name, icon=list(svg=readSVG("plot.svg")))                 }
       ,svgMarkers     = function(name) { list(name=name, icon=list(svg=readSVG("plot-line-markers.svg")))    }
       ,svgCandlestick = function(name) { list(name=name, icon=list(svg=readSVG("plot-candlestick-alt.svg"))) }
       ,svgVariation   = function(name) { list(name=name, icon=list(svg=readSVG("plot-bar-axes.svg")))      }
       ,createJS = function(info, type) {
           info$type = type
           js = "function(gd) { Shiny.setInputValue('"
           js = paste0(js, info$observer, "', {")
           js = paste0(js, " tag: '", type, "'")
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
