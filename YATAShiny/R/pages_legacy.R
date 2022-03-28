JGGDashboardFull = function( title    = NULL
                              ,id       = NULL
                              ,theme    = bs_theme()
                              ,paths    = NULL
                              ,cssFiles = NULL
                              ,jsFiles  = NULL
                              ,jsInit   = NULL
                              ,titleActive = FALSE
                              ,lang    = NULL
                              ,...) {
  # Quitamos:
  # position = c("static-top", "fixed-top", "fixed-bottom")
  #            static-top
  # header = NULL, footer = NULL,
  # bg = NULL, inverse = "auto",
  # collapsible = TRUE, fluid = TRUE,
  # window_title = NA,
  #   Ya tenemos title
  #jsFiles es una lista de listas:
  # shiny
  #   source
  #   functions
    pathShiny = normalizePath(system.file("extdata/www", package = packageName()))
    shiny::addResourcePath("jggshiny", pathShiny)

    if (!is.null(paths)) {
        lapply(names(paths), function(path) shiny::addResourcePath(path, paths[[path]]))
    }
    page = jgg_bslib_navs_bar_full(webtitle = title, titleActive = titleActive, id = id, ... )

    jsshiny = parseJGGShinyJS()
    heads = tags$head(
               extendShinyjs(script="jggshiny/jggshiny.js", functions=jsshiny)
               ,custom_css(cssFiles)
              ,custom_js(jsFiles)
              ,document_ready_script(jsInit, title, id)
            )

    bspage = jgg_dashboard_bslib_page( title = title, theme = theme, lang = lang
                                      ,shinyjs::useShinyjs()
                                      ,heads
                                      ,page
              )
    bspage
   addDeps(shiny::tags$body(bspage))
}
jgg_dashboard_bslib_page = function(..., title = NULL, theme = bs_theme(), lang = NULL) {
   data = shiny::bootstrapPage(..., title = title, theme = theme, lang = lang)
   class(data) <- c("bslib_page", class(data))  # bslib_as_page
   data
}




# This function is called internally by navbarPage, tabsetPanel
# and navlistPanel
mi_buildTabset <- function(..., ulClass, textFilter = NULL, id = NULL,
                        selected = NULL, foundSelected = FALSE) {
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
old_buildTabset = function (tabs, ulClass, textFilter = NULL, id = NULL, selected = NULL,
    foundSelected = FALSE) {

    res <- old_findAndMarkSelectedTab(tabs, selected, foundSelected)
    tabs <- res$tabs
    foundSelected <- res$foundSelected
    if (!is.null(id))
        ulClass <- paste(ulClass, "shiny-tab-input")
    if (old_anyNamed(tabs)) {
        nms <- names(tabs)
        nms <- nms[nzchar(nms)]
        stop("Tabs should all be unnamed arguments, but some are named: ",
            paste(nms, collapse = ", "))
    }
    tabsetId <- old_p_randomInt(1000, 10000)
    tabs <- lapply(seq_len(length(tabs)), old_buildTabItem, tabsetId = tabsetId,
        foundSelected = foundSelected, tabs = tabs, textFilter = textFilter)
    tabNavList <- tags$ul(class = ulClass, id = id, `data-tabsetid` = tabsetId,
        lapply(tabs, "[[", 1))
    tabContent <- tags$div(class = "tab-content", `data-tabsetid` = tabsetId,
        lapply(tabs, "[[", 2))
    list(navList = tabNavList, content = tabContent)
}

old_findAndMarkSelectedTab = function (tabs, selected, foundSelected) {
    tabs <- lapply(tabs, function(div) {
        if (foundSelected || is.character(div)) {
        }
        else if (inherits(div, "shiny.navbarmenu")) {
            res <- old_findAndMarkSelectedTab(div$tabs, selected,
                foundSelected)
            div$tabs <- res$tabs
            foundSelected <<- res$foundSelected
        }
        else {
            if (is.null(selected)) {
                foundSelected <<- TRUE
                div <- old_markTabAsSelected(div)
            }
            else {
                tabValue <- div$attribs$`data-value` %||%
                  div$attribs$title
                if (identical(selected, tabValue)) {
                  foundSelected <<- TRUE
                  div <- old_markTabAsSelected(div)
                }
            }
        }
        return(div)
    })
    return(list(tabs = tabs, foundSelected = foundSelected))
}

# Builds tabPanel/navbarMenu items (this function used to be
# declared inside the buildTabset() function and it's been
# refactored for clarity and reusability). Called internally
# by buildTabset.
old_buildTabItem <- function(index, tabsetId, foundSelected, tabs = NULL,
                         divTag = NULL, textFilter = NULL) {

  divTag <- if (!is.null(divTag)) divTag else tabs[[index]]

  if (is.character(divTag) && !is.null(textFilter)) {
    # text item: pass it to the textFilter if it exists
    liTag <- textFilter(divTag)
    divTag <- NULL

  } else if (inherits(divTag, "shiny.navbarmenu")) {
    # navbarMenu item: build the child tabset
    tabset <- old_buildTabset(divTag$tabs, "dropdown-menu",
      navbarMenuTextFilter, foundSelected = foundSelected)

    # if this navbarMenu contains a selected item, mark it active
    containsSelected <- old_containsSelectedTab(divTag$tabs)
    liTag <- tags$li(
      class = paste0("dropdown", if (containsSelected) " active"),
      tags$a(href = "#",
        class = "dropdown-toggle", `data-toggle` = "dropdown",
        `data-value` = divTag$menuName,
        old_getIcon(iconClass = divTag$iconClass),
        divTag$title, tags$b(class = "caret")
      ),
      tabset$navList   # inner tabPanels items
    )
    # list of tab content divs from the child tabset
    divTag <- tabset$content$children

  } else {
    # tabPanel item: create the tab's liTag and divTag
    tabId <- paste("tab", tabsetId, index, sep = "-")
    liTag <- tags$li(
               tags$a(
                 href = paste("#", tabId, sep = ""),
                 `data-toggle` = "tab",
                 `data-value` = divTag$attribs$`data-value`,
                 getIcon(iconClass = divTag$attribs$`data-icon-class`),
                 divTag$attribs$title
               )
    )
    # if this tabPanel is selected item, mark it active
    if (isTabSelected(divTag)) {
      liTag$attribs$class <- "active"
      divTag$attribs$class <- "tab-pane active"
    }
    divTag$attribs$id <- tabId
    divTag$attribs$title <- NULL
  }
  return(list(liTag = liTag, divTag = divTag))
}
parseJGGShinyJS = function() {
    jsfile = system.file("extdata/www/jggshiny.js", package=packageName())
    lines = readLines(jsfile)
    resp = regexpr("[ ]*shinyjs\\.[a-zA-Z0-9_-]+[ ]*=", lines)
    lens = attr(resp, "match.length")
    res = lapply(which(resp != -1), function(idx) {
        txt = substr(lines[idx], resp[idx], lens[idx] - 1)
        substr(trimws(txt), 9, nchar(txt))
    })
    unlist(res)
}
