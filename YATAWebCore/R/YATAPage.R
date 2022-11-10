YATAPage = function (title="YATA", id = "mainMenu", titleActive = TRUE, ...) {
#         ,theme =  my_theme,lang = NULL, css=NULL, js=NULL, ...) {

#     args = list(...)
# , theme =  my_theme,lang = NULL
#    theme = bs_theme(bootswatch = "default",
#                      base_font = font_collection(font_google("Source Sans Pro"),
#     "-apple-system", "BlinkMacSystemFont", "Segoe UI",
#     font_google("Roboto"), "Helvetica Neue", "Arial",
#     "sans-serif", "Apple Color Emoji", "Segoe UI Emoji"),
#     font_scale = NULL
#     )
    jsShiny = list( script="yata/yatashiny.js",functions = parseShinyJS())
    paths = list(
       yata = normalizePath(system.file("extdata/www/yata", package = packageName()))
      ,icons = paste0(Sys.getenv("YATA_SITE"), "/ext/icons")
#      ,icons2 = normalizePath(system.file("extdata/www/icons", package = packageName()))
      ,img    = normalizePath(system.file("extdata/www/img", package = packageName()))
      ,yata   = normalizePath(system.file("extdata/www/yata", package = packageName()))
    )

    customJS  = list(shiny=jsShiny,js=c("yata/yataapp.js"))
    customCSS = list( "yata/yata.css","yata/yata_reactable.css")  # Paquete reactable
    jsInit = c( "   globalThis.yata = new YATA();"
               ,"   yata.init();"
              )

    JGGDashboard( title = title, id = id, theme = bs_theme(bootswatch = "default"), ...
                 ,paths    = paths,    cssFiles = customCSS
                 ,jsFiles  = customJS, jsInit   = jsInit
                 ,titleActive = TRUE,  lang     = NULL)
}
YATATab  = function (id, title=id, icon=NULL, module=NULL) { JGGTab(id,title,icon,module) }
YATAUI    = function (id, title="", mod=NULL, ...)         { JGGUI(id, title, mod, ...)   }
# makeMessageHandler = function(name, funcName) {
#    if (missing(funcName)) funcName = name
#    scr = "Shiny.addCustomMessageHandler('yata"
#    scr = paste0(scr, YATABase$str$titleCase(name), "', function(data) {")
#    scr = paste0(scr, YATAWEBDEF$jsapp, ".", funcName, "(data); })")
#    scr
# }
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
#
# # Wrappers

# YATATabsetPanel = function (id, selected = NULL, ...) {
#     shiny::tabsetPanel(...,id=id,selected=selected,type="tabs")
# #    JGGTabsetPanel(..., id=id,selected=selected)
# }
#
