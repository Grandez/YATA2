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
          if (type != "session") buttons = c("visa", "candle")
          if (type == "session") buttons = c("candle", "line", "markers", "variation")
          group = lapply(buttons, function(x) getButton(info, x))
          # browser()
#          names(group) = buttons
          group
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
           if (!is.null(btn)) return(btn)
           btn = eval(parse(text=paste0("svg", name, "(info, name)")))
           svg$put(name, btn)
           btn
       }
       ,svgline   = function(info, name) {
           name="Linear"
           fname = "plot.svg"
           list(name=name, icon = list(svg=readSVG(fname)), click=createJS(info, name))
       }
       ,svgmarkers   = function(info, name) {
           name="Markers"
           fname = "plot-line-markers.svg"
           list(name=name, icon = list(svg=readSVG(fname)), click=createJS(info, name))
        }

       ,svgcandle = function(info, name) {
           name="Candlestick"
           fname = "plot-candlestick-alt.svg"
           list(name=name, icon = list(svg=readSVG(fname)), click=createJS(info, name))
       }
       ,svgvariation = function(info, name) {
           name="Variation"
           fname = "plot-bar-axes.svg"
           list(name=name, icon = list(svg=readSVG(fname)), click=createJS(info, name))
       }
       ,svgvisa = function(info, name) {
           name="Visa"
           fname = "logo-visa.svg"
           l = list(name=name, icon = list(svg=readSVG(fname)), click=createJS(info, name))
           l
       }
       ,createJS = function(info, type) {
           info$type = type
           js = "function(gd) { Shiny.setInputValue('"
           js = paste0(js, info$observer, "', {")
           js = paste0(js, " tag: '", type, "'")
           for (item in names(info)) {
                js = paste0(js, ",", item, ": '", info[[item]], "'")
           }
           js = paste(js,"}, {priority: 'event'});}")
           message(js)
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
