YATAPage = function( title="YATA", id = "mainMenu"
         ,titleActive = TRUE
         ,theme =  my_theme,lang = NULL, ...) {
   theme = bs_theme(bootswatch = "default",
                     base_font = font_collection(font_google("Source Sans Pro"),
    "-apple-system", "BlinkMacSystemFont", "Segoe UI",
    font_google("Roboto"), "Helvetica Neue", "Arial",
    "sans-serif", "Apple Color Emoji", "Segoe UI Emoji"),
    font_scale = NULL
    )


    # Messages from Server
    #Shiny.addCustomMessageHandler("closeLeftSide",
    #X               function(message) { $("[data-toggle=\'yataoffcanvas\']").trigger("click");});')


             # ,tags$script(makeMessageHandler(YATAMSG$setPage))
             # ,tags$script(makeMessageHandler(YATAMSG$showBlock))
             # ,tags$script(makeMessageHandler(YATAMSG$movePanel))
    paths = list(
       yata = normalizePath(system.file("extdata/www/yata", package = packageName()))
      ,icons = paste0(Sys.getenv("YATA_SITE"), "/YATAExt/icons")
    )
    jsShiny = list( script="yata/yatashiny.js",functions = parseShinyJS())

    customJS  = list(shiny=jsShiny,js=("yata/yataapp.js"))
    customCSS = list( "yata/yata.css"             # Base
                     ,"yata/yata_reactable.css")  # Paquete reactable
    jsInit = c( "   globalThis.yata = new YATA();"
               ,"   yata.init();"
#               ,"   Shiny.addCustomMessageHandler('yataShowBlock', function(data) { yata.show_block(data); });"
              )

    JGGDashboardFull( title,  id
                       ,theme    = theme
                       ,paths    = paths
                       ,cssFiles = customCSS
                       ,jsFiles  = customJS
                       ,jsInit   = jsInit
                       ,titleActive = TRUE
                       ,lang    = NULL
                       , ...)

}

makeMessageHandler = function(name, funcName) {
   if (missing(funcName)) funcName = name
   scr = "Shiny.addCustomMessageHandler('yata"
   scr = paste0(scr, YATABase$str$titleCase(name), "', function(data) {")
   scr = paste0(scr, YATAWEBDEF$jsapp, ".", funcName, "(data); })")
   scr
}
parseShinyJS = function() {
    jsfile = system.file("extdata/www/yata/yatashiny.js", package=packageName())
    lines = readLines(jsfile)
    resp = regexpr("^shinyjs\\.[a-zA-Z0-9_-]+[ ]*=", lines)
    lens = attr(resp, "match.length")
    res = lapply(which(resp != -1), function(idx) {
        txt = substr(lines[idx], resp[idx], lens[idx] - 1)
        substr(trimws(txt), 9, nchar(txt))
    })
    unlist(res)
}
