jgg_dashboard_full = function( title       = NULL,  id      = NULL, ...
                              ,theme = bs_theme()
                              ,cssFiles    = NULL,  jsFiles = NULL, jsInit = NULL
                              ,titleActive = FALSE, lang    = NULL) {
  # Quitamos:
  # position = c("static-top", "fixed-top", "fixed-bottom")
  #            static-top
  # header = NULL, footer = NULL,
  # bg = NULL, inverse = "auto",
  # collapsible = TRUE, fluid = TRUE,
  # window_title = NA,
  #   Ya tenemos title

    pathShiny = normalizePath(system.file("extdata/www", package = packageName()))
    shiny::addResourcePath("jggshiny", pathShiny)

    page = jgg_bslib_navs_bar(webtitle = title, titleActive = titleActive, id = id, ... )

    heads = tags$head(
               extendShinyjs(script="jggshiny/jggshiny.js", functions=c("init", "jgg_set_page"))
               ,custom_css(cssFiles)
              ,custom_js(jsFiles)
              ,document_ready_script(jsInit, title)
            )

    bspage = jgg_dashboard_bslib_page( title = title, theme = theme, lang = lang
                                      ,shinyjs::useShinyjs()
                                      ,heads
                                      ,page
              )

    # bspage = shiny::bootstrapPage(
    #      shinyjs::useShinyjs()
    #     ,shiny::bootstrapLib("cosmo")
    #     ,tags$head(
    #         tags$link  (rel="stylesheet", type="text/css", href="jggshiny/jggshiny.css")
    #        ,tags$script(src="jggshiny/jggshiny.js")
    #     )
    #     ,page
    #     ,title = title
    #     ,theme = theme
    #     ,lang = lang
    # )
    #jgg_dashboard_deps(shiny::tags$body(bspage),md = FALSE)
    bspage
}
jgg_dashboard_bslib_page <- function(..., title = NULL, theme = bs_theme(), lang = NULL) {
#JGG Para debug

data = shiny::bootstrapPage(..., title = title, theme = theme, lang = lang)
  jgg_bslib_as_page(data)

  # bslib_as_page(
  #   shiny::bootstrapPage(..., title = title, theme = theme, lang = lang)
  # )
}
jgg_bslib_as_page <- function(x) {
  class(x) <- c("bslib_page", class(x))
  x
}

jgg_bslib_navs_bar = function (webtitle, titleActive, id, ...) {
    webtitle=NULL
    tabset = jgg_bslib_navbarPage_(id, ...)

    containerDiv = div(class = "container-fluid"
                       ,div(class = "navbar-header"
                            ,span(class = "navbar-brand", webtitle)
                        )
                       , tabset$navList)

    containerClass = "navbar navbar-default"
    nav = tags$nav(class = containerClass, role = "navigation", containerDiv)

    # content = div(class = containerClass)
    # content = tagAppendChild(content, tabset$content)

    jgg_make_container(nav, tabset$content, titleActive)
}

# -----------------------------------------------------------------------
# 'Internal' tabset logic that was pulled directly from shiny/R/bootstrap.R
#  (with minor modifications)
# -----------------------------------------------------------------------

jgg_bslib_navbarPage_ <- function(id, ...) {

  # navbar class based on options
  navbarClass <- "navbar navbar-default navbar-static-top"
  # position <- match.arg(position)
  # if (!is.null(position)) navbarClass <- paste0(navbarClass, " navbar-", position)
  # if (inverse)            navbarClass <- paste(navbarClass, "navbar-inverse")
  #if (!is.null(id))       selected <- shiny::restoreInput(id = id, default = selected)

  # build the tabset
  tabset = bslib_buildTabset(..., ulClass = "nav navbar-nav", textFilter=NULL, id = id,
                             selected = NULL, foundSelected = FALSE)
  # Aqui tenemos las dos partes
  tabset

  # containerClass <- paste0("container", if (fluid) "-fluid")
  #
  # # built the container div dynamically to support optional collapsibility
  # if (collapsible) {
  #   navId <- paste0("navbar-collapse-", bslib_p_randomInt(1000, 10000))
  #   containerDiv <- div(
  #     class = containerClass,
  #     div(
  #       class = "navbar-header",
  #       tags$button(
  #         type = "button",
  #         class = "navbar-toggle collapsed",
  #         `data-toggle` = "collapse",
  #         `data-target` = paste0("#", navId),
  #         # data-bs-* is for BS5+
  #         `data-bs-toggle` = "collapse",
  #         `data-bs-target` = paste0("#", navId),
  #         span(class="sr-only", "Toggle navigation"),
  #         span(class = "icon-bar"),
  #         span(class = "icon-bar"),
  #         span(class = "icon-bar")
  #       ),
  #       span(class = "navbar-brand", pageTitle)
  #     ),
  #     div(
  #       class = "navbar-collapse collapse",
  #       id = navId, tabset$navList
  #     )
  #   )
  # } else {
  #   containerDiv <- div(
  #     class = containerClass,
  #     div(
  #       class = "navbar-header",
  #       span(class = "navbar-brand", pageTitle)
  #     ),
  #     tabset$navList
  #   )
  # }
  #
  # # Bootstrap 3 explicitly supported "dropup menus" via .navbar-fixed-bottom,
  # # but BS4+ requires .dropup on menus with .navbar.fixed-bottom
  # if (position == "fixed-bottom") {
  #   containerDiv <- tagQuery(containerDiv)$
  #     find(".dropdown-menu")$
  #     parent()$
  #     addClass("dropup")$
  #     allTags()
  # }
  #
  # # build the main tab content div
  # contentDiv <- div(class = containerClass)
  # if (!is.null(header)) contentDiv <- tagAppendChild(contentDiv, div(class = "row", header))
  # contentDiv <- tagAppendChild(contentDiv, tabset$content)
  # if (!is.null(footer)) contentDiv <- tagAppendChild(contentDiv, div(class = "row", footer))
  #
  # # *Don't* wrap in bootstrapPage() (shiny::navbarPage()) does that part
  # tagList(
  #   tags$nav(class = navbarClass, role = "navigation", containerDiv),
  #   contentDiv
  # )
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

