dashboard_bslib_page = function(..., title = NULL, theme = bs_theme(), lang = NULL) {
   data = shiny::bootstrapPage(..., title = title, theme = theme, lang = lang)
   class(data) <- c("bslib_page", class(data))  # bslib_as_page
   data
}

bslib_navs_bar_full = function (webtitle, titleActive, id, ...) {
    # Tiene Panel derecho y panel izquiero
    webtitle=NULL
    tabset = bslib_navbarPage(id, ...)

    containerDiv = div(class = "container-fluid"
                       ,div(class = "navbar-header"
                            ,span(class = "navbar-brand", webtitle)
                        )
                       , tabset$navList)

    containerClass = "navbar navbar-default"
    nav = tags$nav(class = containerClass, role = "navigation", containerDiv)

    # content = div(class = containerClass)
    # content = tagAppendChild(content, tabset$content)

    make_container_full(nav, tabset$content, titleActive)
}

# This function is called internally by navbarPage, tabsetPanel
# and navlistPanel
mi_buildTabset <- function(..., ulClass, textFilter = NULL, id = NULL,
                        selected = NULL, foundSelected = FALSE) {
    browser()
  #JGG tabs <- dropNulls(list2(...))
  tabs <- list2(...)
  res <- findAndMarkSelectedTab(tabs, selected, foundSelected)
  tabs <- res$tabs
  foundSelected <- res$foundSelected

  # add input class if we have an id
  if (!is.null(id)) ulClass <- paste(ulClass, "shiny-tab-input")

  if (anyNamed(tabs)) {
    nms <- names(tabs)
    nms <- nms[nzchar(nms)]
    stop("Tabs should all be unnamed arguments, but some are named: ",
         paste(nms, collapse = ", "))
  }

  tabsetId <- p_randomInt(1000, 10000)
  tabs <- lapply(seq_len(length(tabs)), buildTabItem,
                 tabsetId = tabsetId, foundSelected = foundSelected,
                 tabs = tabs, textFilter = textFilter)

  tabNavList <- tags$ul(class = ulClass, id = id,
                        `data-tabsetid` = tabsetId, !!!lapply(tabs, "[[", "liTag"))

  tabContent <- tags$div(class = "tab-content",
                         `data-tabsetid` = tabsetId, !!!lapply(tabs, "[[", "divTag"))

  list(navList = tabNavList, content = tabContent)
}
parseYATAShinyJS = function() {
    #JGg jsfile = system.file("extdata/www/yatashiny_shiny.js", package=packageName())

    lines = readLines("www/jggshiny_shiny.js")
    resp = regexpr("[ ]*shinyjs\\.[a-zA-Z0-9_-]+[ ]*=", lines)
    lens = attr(resp, "match.length")
    res = lapply(which(resp != -1), function(idx) {
        txt = substr(lines[idx], resp[idx], lens[idx] - 1)
        substr(trimws(txt), 9, nchar(txt))
    })
    unlist(res)
}



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
