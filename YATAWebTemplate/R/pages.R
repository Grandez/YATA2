JGGDashboard = function( id = NULL, ...
                        ,title       = NULL,  theme    = bs_theme()
                        ,paths       = NULL,  cssFiles = NULL,jsFiles  = NULL,jsInit   = NULL
                        ,titleActive = FALSE, lang     = NULL) {
#JGG    pathShiny = normalizePath(system.file("extdata/www", package = packageName()))
#JGG    shiny::addResourcePath("yatashiny", "www/yata")

   if (!is.null(paths)) {
       lapply(names(paths), function(path) shiny::addResourcePath(path, paths[[path]]))
   }
   page  = bslib_navs_bar_full(webtitle = title, titleActive = titleActive, id = id, ... )
   heads = tags$head( extendShinyjs(script="jggshiny_shiny.js", functions=parseShinyJS())
                     ,custom_css(cssFiles), custom_js(jsFiles)
                     ,document_ready_script(jsInit, title, id))

   bspage = dashboard_bslib_page(title=title,theme=theme,lang=lang,shinyjs::useShinyjs(),heads,page)
   addDeps(shiny::tags$body(bspage))
}




# This function is called internally by navbarPage, tabsetPanel
# and navlistPanel
# mi_buildTabset <- function(..., ulClass, textFilter = NULL, id = NULL,
#                         selected = NULL, foundSelected = FALSE) {
#   #JGG tabs <- dropNulls(list2(...))
#   tabs <- list2(...)
#   res <- findAndMarkSelectedTab(tabs, selected, foundSelected)
#   tabs <- res$tabs
#   foundSelected <- res$foundSelected
#
#   # add input class if we have an id
#   if (!is.null(id)) ulClass <- paste(ulClass, "shiny-tab-input")
#
#   if (anyNamed(tabs)) {
#     nms <- names(tabs)
#     nms <- nms[nzchar(nms)]
#     stop("Tabs should all be unnamed arguments, but some are named: ",
#          paste(nms, collapse = ", "))
#   }
#
#   tabsetId <- p_randomInt(1000, 10000)
#   tabs <- lapply(seq_len(length(tabs)), buildTabItem,
#                  tabsetId = tabsetId, foundSelected = foundSelected,
#                  tabs = tabs, textFilter = textFilter)
#
#   tabNavList <- tags$ul(class = ulClass, id = id,
#                         `data-tabsetid` = tabsetId, !!!lapply(tabs, "[[", "liTag"))
#
#   tabContent <- tags$div(class = "tab-content",
#                          `data-tabsetid` = tabsetId, !!!lapply(tabs, "[[", "divTag"))
#
#   list(navList = tabNavList, content = tabContent)
# }



# makeMessageHandler = function(name, funcName) {
#    if (missing(funcName)) funcName = name
#    scr = "Shiny.addCustomMessageHandler('yata"
#    scr = paste0(scr, YATABase$str$titleCase(name), "', function(data) {")
#    scr = paste0(scr, YATAWEBDEF$jsapp, ".", funcName, "(data); })")
#    scr
# }
# parseShinyJS = function() {
#     jsfile = system.file("extdata/www/yata/yatashiny.js", package="YATAWebCore")
#     lines = readLines(jsfile)
#     resp = regexpr("^shinyjs\\.[a-zA-Z0-9_-]+[ ]*=", lines)
#     lens = attr(resp, "match.length")
#     res = lapply(which(resp != -1), function(idx) {
#         txt = substr(lines[idx], resp[idx], lens[idx] - 1)
#         substr(trimws(txt), 9, nchar(txt))
#     })
#     unlist(res)
# }
