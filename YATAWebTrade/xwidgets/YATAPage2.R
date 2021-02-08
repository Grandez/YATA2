

YATAPage3 = function(...) {
dep1 = htmlDependency( name = "shinydashboard"
               ,version = "0.7.1"
               ,src = ""
               ,script = "shinydashboard.js"
               ,stylesheet = "shinydashboard.css"
               ,package = "shinydashboard"
    )

dep2 = htmlDependency( name = "shinydashboardPlus"
               ,version = "0.7.5"
               ,src = "shinydashboardPlus-0.6.0"
               ,script = c("js/app.min.js", "js/custom.js")
               ,stylesheet = c("css/AdminLTE.min.css", "css/_all-skins.min.css")
               ,package = "shinydashboardPlus"
    )
browser()
  p = navbarPage("YATA", ...)
  p
}

# YATAPage <- function(title,
#                        ...,
#                        id = NULL,
#                        selected = NULL,
#                        header = NULL,
#                        footer = NULL,
#                        leftSide = c("menu-right", "menu-left"),
#                        rightSide = c("menu-left", "menu-right"),
#                        fluid = TRUE,
#                        theme = NULL,
#                        windowTitle = title
#                      #,tabs = NULL
#                      ) {
#   #addDependencies()
#
#   # alias title so we can avoid conflicts w/ title in withTags
#   pageTitle <- title
#
#   # navbar class based on options
# #  navbarClass <- "navbar navbar-expand-lg fixed-top navbar-dark bg-primary"
#   navbarClass <- "navbar-main"
#
#   if (!is.null(id))    selected <- restoreInput(id = id, default = selected)
#
#   #JGG list(...) coge todo lo que no esta nombrado: shijs, tags$, etc
#   # build the tabset
#   tabs <- list(...)
#
#   tabset <- buildTabset(tabs, "nav navbar-nav", NULL, id, selected)
#
#   # function to return plain or fluid class name
#   className <- function(name) {
#     if (fluid)
#       paste(name, "-fluid", sep="")
#     else
#       name
#   }
#   # Limpiar
#   lis = tabset[[1]][[3]][[1]]
#   lin = lis[grepl("data-value", lis)]
#   tabset[[1]][[3]][[1]] = lin
#
#
#     containerDiv <- div(class=className("container"),
#       div(class="navbar-header"
#         ,span(class="navbar-brand", pageTitle)
#         ,span(hidden(textInput("nsPreffix", label = NULL, value = "")))
#       )
#     )
#
#     # Limpiar navlist
#     tabs = tabset$navList
#     # mask = grepl("data-value", tabs[[3]][[1]])
#     # tabs = tabs[[3]][[1]][mask]
#
#     ls = alist(leftSide)
#     rs = alist(rightSide)
#     navbarResponsive = div(id="navbarResponsive", display="flex")
#     if (!is.null(leftSide)) navbarResponsive = tagAppendChild(navbarResponsive, YATAIconNav(TRUE, leftSide))
#     navbarResponsive = tagAppendChild(navbarResponsive, div(tabs)) #div(tabset$navList))
#     if (!is.null(rightSide)) navbarResponsive = tagAppendChild(navbarResponsive, YATAIconNav(FALSE,rightSide))
#     containerDiv     = tagAppendChild(containerDiv, navbarResponsive)
#
#     mainDiv  = div(id="YATAMainSide") # ,  class="col-sm-12")
#     leftDiv  = div(id="YATALeftSide", style="background-color:powderblue;")
#     rightDiv = div(id="YATARightSide", style="background-color:red;")
#
#     mainDiv <- tagAppendChild(mainDiv, tabset$content)
#
#     # build the main tab content div
#     contentDiv <- div(id="main-container", class=className("main-container"))
#     if (!is.null(header)) contentDiv <- tagAppendChild(contentDiv, div(class="row", header))
#
#     contentDiv <- tagAppendChild(contentDiv, hidden(leftDiv))
#     contentDiv <- tagAppendChild(contentDiv, mainDiv)
#     contentDiv <- tagAppendChild(contentDiv, hidden(rightDiv))
#
#   if (!is.null(footer))
#     contentDiv <- tagAppendChild(contentDiv, div(class="row", footer))
#
#
#   # build the page
#   YATABootstrapPage(
#     title = windowTitle,
#     theme = theme,
#     tags$nav(class=navbarClass, role="navigation", containerDiv),
#     contentDiv
#   )
# }
#
# # Helpers to build tabsetPanels (& Co.) and their elements
# markTabAsSelected <- function(x) {
#   attr(x, "selected") <- TRUE
#   x
# }
#
# isTabSelected <- function(x) {
#   isTRUE(attr(x, "selected", exact = TRUE))
# }
#
# containsSelectedTab <- function(tabs) {
#   any(vapply(tabs, isTabSelected, logical(1)))
# }
#
# findAndMarkSelectedTab <- function(tabs, selected, foundSelected) {
#
#   tabs <- lapply(tabs, function(div) {
#     if (foundSelected || is.character(div)) {
#       # Strings are not selectable items
#
#     } else if (inherits(div, "shiny.navbarmenu")) {
#       # Recur for navbarMenus
#       res <- findAndMarkSelectedTab(div$tabs, selected, foundSelected)
#       div$tabs <- res$tabs
#       foundSelected <<- res$foundSelected
#
#     } else {
#       # Base case: regular tab item. If the `selected` argument is
#       # provided, check for a match in the existing tabs; else,
#       # mark first available item as selected
#       if (is.null(selected)) {
#         foundSelected <<- TRUE
#         div <- markTabAsSelected(div)
#       } else {
#         tabValue <- div$attribs$`data-value` %OR% div$attribs$title
#         if (identical(selected, tabValue)) {
#           foundSelected <<- TRUE
#           div <- markTabAsSelected(div)
#         }
#       }
#     }
#     return(div)
#   })
#   return(list(tabs = tabs, foundSelected = foundSelected))
# }
#
# # Returns the icon object (or NULL if none), provided either a
# # tabPanel, OR the icon class
# getIcon <- function(tab = NULL, iconClass = NULL) {
#   if (!is.null(tab)) iconClass <- tab$attribs$`data-icon-class`
#   if (!is.null(iconClass)) {
#     if (grepl("fa-", iconClass, fixed = TRUE)) {
#       # for font-awesome we specify fixed-width
#       iconClass <- paste(iconClass, "fa-fw")
#     }
#     icon(name = NULL, class = iconClass)
#   } else NULL
# }
#
# # Text filter for navbarMenu's (plain text) separators
# navbarMenuTextFilter <- function(text) {
#   if (grepl("^\\-+$", text)) tags$li(class = "divider")
#   else tags$li(class = "dropdown-header", text)
# }
#
# # This function is called internally by navbarPage, tabsetPanel
# # and navlistPanel
# buildTabset <- function(tabs, ulClass, textFilter = NULL, id = NULL,
#                         selected = NULL, foundSelected = FALSE) {
#
#   res <- findAndMarkSelectedTab(tabs, selected, foundSelected)
#   tabs <- res$tabs
#   #JGG No se por que, pero incluye un tag vacio al principio
#   #tabs[[1]] = NULL
#
#   foundSelected <- res$foundSelected
#
#   # add input class if we have an id
#   if (!is.null(id)) ulClass <- paste(ulClass, "shiny-tab-input")
#
#   if (anyNamed(tabs)) {
#     nms <- names(tabs)
#     nms <- nms[nzchar(nms)]
#     stop("Tabs should all be unnamed arguments, but some are named: ",
#       paste(nms, collapse = ", "))
#   }
#
#   tabsetId <- p_randomInt(1000, 10000)
#   tabs <- lapply(seq_len(length(tabs)), buildTabItem,
#             tabsetId = tabsetId, foundSelected = foundSelected,
#             tabs = tabs, textFilter = textFilter)
#
#   tabNavList <- tags$ul(class = ulClass, id = id,
#                   `data-tabsetid` = tabsetId, lapply(tabs, "[[", 1))
#
#   tabContent <- tags$div(class = "tab-content",
#                   `data-tabsetid` = tabsetId, lapply(tabs, "[[", 2))
#
#   list(navList = tabNavList, content = tabContent)
# }
#
# # Builds tabPanel/navbarMenu items (this function used to be
# # declared inside the buildTabset() function and it's been
# # refactored for clarity and reusability). Called internally
# # by buildTabset.
# buildTabItem <- function(index, tabsetId, foundSelected, tabs = NULL,
#                          divTag = NULL, textFilter = NULL) {
#
#   divTag <- if (!is.null(divTag)) divTag else tabs[[index]]
#
#   if (is.character(divTag) && !is.null(textFilter)) {
#     # text item: pass it to the textFilter if it exists
#     liTag <- textFilter(divTag)
#     divTag <- NULL
#
#   } else if (inherits(divTag, "shiny.navbarmenu")) {
#     # navbarMenu item: build the child tabset
#     tabset <- buildTabset(divTag$tabs, "dropdown-menu",
#       navbarMenuTextFilter, foundSelected = foundSelected)
#
#     # if this navbarMenu contains a selected item, mark it active
#     containsSelected <- containsSelectedTab(divTag$tabs)
#     liTag <- tags$li(
#       class = paste0("dropdown", if (containsSelected) " active"),
#       tags$a(href = "#",
#         class = "dropdown-toggle", `data-toggle` = "dropdown",
#         `data-value` = divTag$menuName,
#         getIcon(iconClass = divTag$iconClass),
#         divTag$title, tags$b(class = "caret")
#       ),
#       tabset$navList   # inner tabPanels items
#     )
#     # list of tab content divs from the child tabset
#     divTag <- tabset$content$children
#
#   } else {
#     # tabPanel item: create the tab's liTag and divTag
#     tabId <- paste("tab", tabsetId, index, sep = "-")
#     liTag <- tags$li(
#                tags$a(
#                  href = paste("#", tabId, sep = ""),
#                  `data-toggle` = "tab",
#                  `data-value` = divTag$attribs$`data-value`,
#                  getIcon(iconClass = divTag$attribs$`data-icon-class`),
#                  divTag$attribs$title
#                )
#     )
#     # if this tabPanel is selected item, mark it active
#     if (isTabSelected(divTag)) {
#       liTag$attribs$class <- "active"
#       divTag$attribs$class <- "tab-pane active"
#     }
#     divTag$attribs$id <- tabId
#     divTag$attribs$title <- NULL
#   }
#   return(list(liTag = liTag, divTag = divTag))
# }
#
#
#
#
#
#
# #JGG   #' @include shinyUtils.R
# #JGG   NULL
# #JGG
# #JGG   #' Create a Bootstrap page
# #JGG   #'
# #JGG   #' Create a Shiny UI page that loads the CSS and JavaScript for
# #JGG   #' \href{http://getbootstrap.com/}{Bootstrap}, and has no content in the page
# #JGG   #' body (other than what you provide).
# #JGG   #'
# #JGG   #' This function is primarily intended for users who are proficient in HTML/CSS,
# #JGG   #' and know how to lay out pages in Bootstrap. Most applications should use
# #JGG   #' \code{\link{fluidPage}} along with layout functions like
# #JGG   #' \code{\link{fluidRow}} and \code{\link{sidebarLayout}}.
# #JGG   #'
# #JGG   #' @param ... The contents of the document body.
# #JGG   #' @param title The browser window title (defaults to the host URL of the page)
# #JGG   #' @param responsive This option is deprecated; it is no longer optional with
# #JGG   #'   Bootstrap 3.
# #JGG   #' @param theme Alternative Bootstrap stylesheet (normally a css file within the
# #JGG   #'   www directory, e.g. \code{www/bootstrap.css})
# #JGG   #'
# #JGG   #' @return A UI defintion that can be passed to the \link{shinyUI} function.
# #JGG   #'
# #JGG   #' @note The \code{basicPage} function is deprecated, you should use the
# #JGG   #'   \code{\link{fluidPage}} function instead.
# #JGG   #'
# #JGG   #' @seealso \code{\link{fluidPage}}, \code{\link{fixedPage}}
# #JGG   #' @export
#    YATABootstrapPage <- function(..., title = NULL, theme = NULL) {
#
#      bootstrapLib <- function(theme = NULL) {
#          htmlDependency("bootstrap", "3.3.7",
#          c(
#             href = "shared/bootstrap",
#             file = system.file("www/shared/bootstrap", package = "shiny")
#           ),
#           script = c(
#              "js/bootstrap.min.js",
#             # These shims are necessary for IE 8 compatibility
#              "shim/html5shiv.min.js",
#              "shim/respond.min.js"
#             ),
#             stylesheet = if (is.null(theme)) "css/bootstrap.min.css",
#             meta = list(viewport = "width=device-width, initial-scale=1")
#          )
#      }
#
#      YATALibs <- function(theme = NULL) {
#        bootstrapLib(theme)
#        # deps = list()
#        # deps = list.append(deps, bootstrapLib(theme))
#        # browser()
#        # for (dirname in list.files("www")) {
#        #   #dirName = paste("www", dirs, sep="/")
#        #   files = list.files(paste0("www/",dirname), recursive=TRUE)
#        #   lcss = files[grepl(".css$", files)]
#        #   ljs  = files[grepl(".js$", files)]
#        #   hDep = htmlDependency(dirname, "1.0", src=dirname, stylesheet = lcss, script=ljs)
#        #   deps = list.append(deps, hDep)
#        #   # for (css in files[grepl(".css$", files)])  {
#        #   #   tags$head(tags$link(rel = "stylesheet", type = "text/css", href=paste(dirs, css, sep="/")))
#        #   #   # htmlDependency(dirs, "1.0", src=dirName, stylesheet = css)
#        #   # }
#        #   # for (js in files[grepl(".js$", files)])  {
#        #   #   htmlDependency(dirs, "1.0", src=dirName, script = css)
#        #   # }
#        #
#        # }
#        # deps
#      }
#
#      attachDependencies(
#        tagList(
#          if (!is.null(title)) tags$head(tags$title(title)),
#          if (!is.null(theme)) {
#            tags$head(tags$link(rel="stylesheet", type="text/css", href = theme))
#          }
#          ,htmlDependency(  "font-awesome", "5.3.1"
#                          , "www/shared/fontawesome"
#                          , package = "shiny"
#                          , stylesheet = c("css/all.min.css", "css/v4-shims.min.css"))
#          ,htmlDependency("YATA", "1.0", src="www/yata", script="yata.js", stylesheet="yata.css")
#          ,htmlDependency( "dashboardplus", "1.0"
#                          , src="www/dashboardplus"
#                          , script="dashboardplus.js"
#                         , stylesheet=c("_all-skins.css", "AdminLTE.css"))
#          # ,htmlDependency("materialdesign", "1.0", src="www/materialdesign", script=c("init.js", "material.min.js", "ripples.min.js")
#          #                 , stylesheet=c("all-md-skins.min.css", "bootstrap-material-design.min.css", "MaterialAdminLTE.min.css", "ripples.min.css"))
#
#          # remainder of tags passed to the function
#          ,list(...)
#        )
#        ,YATALibs()
#
#      )
#    }
# #JGG
# #JGG   #' Bootstrap libraries
# #JGG   #'
# #JGG   #' This function returns a set of web dependencies necessary for using Bootstrap
# #JGG   #' components in a web page.
# #JGG   #'
# #JGG   #' It isn't necessary to call this function if you use
# #JGG   #' \code{\link{bootstrapPage}} or others which use \code{bootstrapPage}, such
# #JGG   #' \code{\link{basicPage}}, \code{\link{fluidPage}}, \code{\link{fillPage}},
# #JGG   #' \code{\link{pageWithSidebar}}, and \code{\link{navbarPage}}, because they
# #JGG   #' already include the Bootstrap web dependencies.
# #JGG   #'
# #JGG   #' @inheritParams bootstrapPage
# #JGG   #' @export
# #JGG   bootstrapLib <- function(theme = NULL) {
# #JGG     htmlDependency("bootstrap", "3.3.7",
# #JGG       c(
# #JGG         href = "shared/bootstrap",
# #JGG         file = system.file("www/shared/bootstrap", package = "shiny")
# #JGG       ),
# #JGG       script = c(
# #JGG         "js/bootstrap.min.js",
# #JGG         # These shims are necessary for IE 8 compatibility
# #JGG         "shim/html5shiv.min.js",
# #JGG         "shim/respond.min.js"
# #JGG       ),
# #JGG       stylesheet = if (is.null(theme)) "css/bootstrap.min.css",
# #JGG       meta = list(viewport = "width=device-width, initial-scale=1")
# #JGG     )
# #JGG   }
# #JGG
# #JGG   #' @rdname bootstrapPage
# #JGG   #' @export
# #JGG   basicPage <- function(...) {
# #JGG     bootstrapPage(div(class="container-fluid", list(...)))
# #JGG   }
# #JGG
# #JGG
# #JGG   #' Create a page that fills the window
# #JGG   #'
# #JGG   #' \code{fillPage} creates a page whose height and width always fill the
# #JGG   #' available area of the browser window.
# #JGG   #'
# #JGG   #' The \code{\link{fluidPage}} and \code{\link{fixedPage}} functions are used
# #JGG   #' for creating web pages that are laid out from the top down, leaving
# #JGG   #' whitespace at the bottom if the page content's height is smaller than the
# #JGG   #' browser window, and scrolling if the content is larger than the window.
# #JGG   #'
# #JGG   #' \code{fillPage} is designed to latch the document body's size to the size of
# #JGG   #' the window. This makes it possible to fill it with content that also scales
# #JGG   #' to the size of the window.
# #JGG   #'
# #JGG   #' For example, \code{fluidPage(plotOutput("plot", height = "100\%"))} will not
# #JGG   #' work as expected; the plot element's effective height will be \code{0},
# #JGG   #' because the plot's containing elements (\code{<div>} and \code{<body>}) have
# #JGG   #' \emph{automatic} height; that is, they determine their own height based on
# #JGG   #' the height of their contained elements. However,
# #JGG   #' \code{fillPage(plotOutput("plot", height = "100\%"))} will work because
# #JGG   #' \code{fillPage} fixes the \code{<body>} height at 100\% of the window height.
# #JGG   #'
# #JGG   #' Note that \code{fillPage(plotOutput("plot"))} will not cause the plot to fill
# #JGG   #' the page. Like most Shiny output widgets, \code{plotOutput}'s default height
# #JGG   #' is a fixed number of pixels. You must explicitly set \code{height = "100\%"}
# #JGG   #' if you want a plot (or htmlwidget, say) to fill its container.
# #JGG   #'
# #JGG   #' One must be careful what layouts/panels/elements come between the
# #JGG   #' \code{fillPage} and the plots/widgets. Any container that has an automatic
# #JGG   #' height will cause children with \code{height = "100\%"} to misbehave. Stick
# #JGG   #' to functions that are designed for fill layouts, such as the ones in this
# #JGG   #' package.
# #JGG   #'
# #JGG   #' @param ... Elements to include within the page.
# #JGG   #' @param padding Padding to use for the body. This can be a numeric vector
# #JGG   #'   (which will be interpreted as pixels) or a character vector with valid CSS
# #JGG   #'   lengths. The length can be between one and four. If one, then that value
# #JGG   #'   will be used for all four sides. If two, then the first value will be used
# #JGG   #'   for the top and bottom, while the second value will be used for left and
# #JGG   #'   right. If three, then the first will be used for top, the second will be
# #JGG   #'   left and right, and the third will be bottom. If four, then the values will
# #JGG   #'   be interpreted as top, right, bottom, and left respectively.
# #JGG   #' @param title The title to use for the browser window/tab (it will not be
# #JGG   #'   shown in the document).
# #JGG   #' @param bootstrap If \code{TRUE}, load the Bootstrap CSS library.
# #JGG   #' @param theme URL to alternative Bootstrap stylesheet.
# #JGG   #'
# #JGG   #' @examples
# #JGG   #' fillPage(
# #JGG   #'   tags$style(type = "text/css",
# #JGG   #'     ".half-fill { width: 50%; height: 100%; }",
# #JGG   #'     "#one { float: left; background-color: #ddddff; }",
# #JGG   #'     "#two { float: right; background-color: #ccffcc; }"
# #JGG   #'   ),
# #JGG   #'   div(id = "one", class = "half-fill",
# #JGG   #'     "Left half"
# #JGG   #'   ),
# #JGG   #'   div(id = "two", class = "half-fill",
# #JGG   #'     "Right half"
# #JGG   #'   ),
# #JGG   #'   padding = 10
# #JGG   #' )
# #JGG   #'
# #JGG   #' fillPage(
# #JGG   #'   fillRow(
# #JGG   #'     div(style = "background-color: red; width: 100%; height: 100%;"),
# #JGG   #'     div(style = "background-color: blue; width: 100%; height: 100%;")
# #JGG   #'   )
# #JGG   #' )
# #JGG   #' @export
# #JGG   fillPage <- function(..., padding = 0, title = NULL, bootstrap = TRUE,
# #JGG     theme = NULL) {
# #JGG
# #JGG     fillCSS <- tags$head(tags$style(type = "text/css",
# #JGG       "html, body { width: 100%; height: 100%; overflow: hidden; }",
# #JGG       sprintf("body { padding: %s; margin: 0; }", collapseSizes(padding))
# #JGG     ))
# #JGG
# #JGG     if (isTRUE(bootstrap)) {
# #JGG       bootstrapPage(title = title, theme = theme, fillCSS, ...)
# #JGG     } else {
# #JGG       tagList(
# #JGG         fillCSS,
# #JGG         if (!is.null(title)) tags$head(tags$title(title)),
# #JGG         ...
# #JGG       )
# #JGG     }
# #JGG   }
# #JGG
# #JGG   collapseSizes <- function(padding) {
# #JGG     paste(
# #JGG       sapply(padding, shiny::validateCssUnit, USE.NAMES = FALSE),
# #JGG       collapse = " ")
# #JGG   }
# #JGG
# #JGG   #' Create a page with a sidebar
# #JGG   #'
# #JGG   #' Create a Shiny UI that contains a header with the application title, a
# #JGG   #' sidebar for input controls, and a main area for output.
# #JGG   #'
# #JGG   #' @param headerPanel The \link{headerPanel} with the application title
# #JGG   #' @param sidebarPanel The \link{sidebarPanel} containing input controls
# #JGG   #' @param mainPanel The \link{mainPanel} containing outputs
# #JGG
# #JGG   #' @return A UI defintion that can be passed to the \link{shinyUI} function
# #JGG   #'
# #JGG   #' @note This function is deprecated. You should use \code{\link{fluidPage}}
# #JGG   #' along with \code{\link{sidebarLayout}} to implement a page with a sidebar.
# #JGG   #'
# #JGG   #' @examples
# #JGG   #' # Define UI
# #JGG   #' pageWithSidebar(
# #JGG   #'
# #JGG   #'   # Application title
# #JGG   #'   headerPanel("Hello Shiny!"),
# #JGG   #'
# #JGG   #'   # Sidebar with a slider input
# #JGG   #'   sidebarPanel(
# #JGG   #'     sliderInput("obs",
# #JGG   #'                 "Number of observations:",
# #JGG   #'                 min = 0,
# #JGG   #'                 max = 1000,
# #JGG   #'                 value = 500)
# #JGG   #'   ),
# #JGG   #'
# #JGG   #'   # Show a plot of the generated distribution
# #JGG   #'   mainPanel(
# #JGG   #'     plotOutput("distPlot")
# #JGG   #'   )
# #JGG   #' )
# #JGG   #' @export
# #JGG   pageWithSidebar <- function(headerPanel,
# #JGG                               sidebarPanel,
# #JGG                               mainPanel) {
# #JGG
# #JGG     bootstrapPage(
# #JGG       # basic application container divs
# #JGG       div(
# #JGG         class="container-fluid",
# #JGG         div(class="row",
# #JGG             headerPanel
# #JGG         ),
# #JGG         div(class="row",
# #JGG             sidebarPanel,
# #JGG             mainPanel
# #JGG         )
# #JGG       )
# #JGG     )
# #JGG   }
# #JGG
# #JGG   #' Create a page with a top level navigation bar
# #JGG   #'
# #JGG   #' Create a page that contains a top level navigation bar that can be used to
# #JGG   #' toggle a set of \code{\link{tabPanel}} elements.
# #JGG   #'
# #JGG   #' @param title The title to display in the navbar
# #JGG   #' @param ... \code{\link{tabPanel}} elements to include in the page. The
# #JGG   #'   \code{navbarMenu} function also accepts strings, which will be used as menu
# #JGG   #'   section headers. If the string is a set of dashes like \code{"----"} a
# #JGG   #'   horizontal separator will be displayed in the menu.
# #JGG   #' @param id If provided, you can use \code{input$}\emph{\code{id}} in your
# #JGG   #'   server logic to determine which of the current tabs is active. The value
# #JGG   #'   will correspond to the \code{value} argument that is passed to
# #JGG   #'   \code{\link{tabPanel}}.
# #JGG   #' @param selected The \code{value} (or, if none was supplied, the \code{title})
# #JGG   #'   of the tab that should be selected by default. If \code{NULL}, the first
# #JGG   #'   tab will be selected.
# #JGG   #' @param position Determines whether the navbar should be displayed at the top
# #JGG   #'   of the page with normal scrolling behavior (\code{"static-top"}), pinned at
# #JGG   #'   the top (\code{"fixed-top"}), or pinned at the bottom
# #JGG   #'   (\code{"fixed-bottom"}). Note that using \code{"fixed-top"} or
# #JGG   #'   \code{"fixed-bottom"} will cause the navbar to overlay your body content,
# #JGG   #'   unless you add padding, e.g.: \code{tags$style(type="text/css", "body
# #JGG   #'   {padding-top: 70px;}")}
# #JGG   #' @param header Tag or list of tags to display as a common header above all
# #JGG   #'   tabPanels.
# #JGG   #' @param footer Tag or list of tags to display as a common footer below all
# #JGG   #'   tabPanels
# #JGG   #' @param inverse \code{TRUE} to use a dark background and light text for the
# #JGG   #'   navigation bar
# #JGG   #' @param collapsible \code{TRUE} to automatically collapse the navigation
# #JGG   #'   elements into a menu when the width of the browser is less than 940 pixels
# #JGG   #'   (useful for viewing on smaller touchscreen device)
# #JGG   #' @param collapsable Deprecated; use \code{collapsible} instead.
# #JGG   #' @param fluid \code{TRUE} to use a fluid layout. \code{FALSE} to use a fixed
# #JGG   #'   layout.
# #JGG   #' @param responsive This option is deprecated; it is no longer optional with
# #JGG   #'   Bootstrap 3.
# #JGG   #' @param theme Alternative Bootstrap stylesheet (normally a css file within the
# #JGG   #'   www directory). For example, to use the theme located at
# #JGG   #'   \code{www/bootstrap.css} you would use \code{theme = "bootstrap.css"}.
# #JGG   #' @param windowTitle The title that should be displayed by the browser window.
# #JGG   #'   Useful if \code{title} is not a string.
# #JGG   #' @param icon Optional icon to appear on a \code{navbarMenu} tab.
# #JGG   #'
# #JGG   #' @return A UI defintion that can be passed to the \link{shinyUI} function.
# #JGG   #'
# #JGG   #' @details The \code{navbarMenu} function can be used to create an embedded
# #JGG   #'   menu within the navbar that in turns includes additional tabPanels (see
# #JGG   #'   example below).
# #JGG   #'
# #JGG   #' @seealso \code{\link{tabPanel}}, \code{\link{tabsetPanel}},
# #JGG   #'   \code{\link{updateNavbarPage}}, \code{\link{insertTab}},
# #JGG   #'   \code{\link{showTab}}
# #JGG   #'
# #JGG   #' @examples
# #JGG   #' navbarPage("App Title",
# #JGG   #'   tabPanel("Plot"),
# #JGG   #'   tabPanel("Summary"),
# #JGG   #'   tabPanel("Table")
# #JGG   #' )
# #JGG   #'
# #JGG   #' navbarPage("App Title",
# #JGG   #'   tabPanel("Plot"),
# #JGG   #'   navbarMenu("More",
# #JGG   #'     tabPanel("Summary"),
# #JGG   #'     "----",
# #JGG   #'     "Section header",
# #JGG   #'     tabPanel("Table")
# #JGG   #'   )
# #JGG   #' )
# #JGG   #' @export
#
# #JGG   #' @param menuName A name that identifies this \code{navbarMenu}. This
# #JGG   #'   is needed if you want to insert/remove or show/hide an entire
# #JGG   #'   \code{navbarMenu}.
# #JGG   #'
# #JGG   #' @rdname navbarPage
# #JGG   #' @export
# #JGG   navbarMenu <- function(title, ..., menuName = title, icon = NULL) {
# #JGG     structure(list(title = title,
# #JGG                    menuName = menuName,
# #JGG                    tabs = list(...),
# #JGG                    iconClass = iconClass(icon)),
# #JGG               class = "shiny.navbarmenu")
# #JGG   }
# #JGG
# #JGG   #' Create a header panel
# #JGG   #'
# #JGG   #' Create a header panel containing an application title.
# #JGG   #'
# #JGG   #' @param title An application title to display
# #JGG   #' @param windowTitle The title that should be displayed by the browser window.
# #JGG   #'   Useful if \code{title} is not a string.
# #JGG   #' @return A headerPanel that can be passed to \link{pageWithSidebar}
# #JGG   #'
# #JGG   #' @examples
# #JGG   #' headerPanel("Hello Shiny!")
# #JGG   #' @export
# #JGG   headerPanel <- function(title, windowTitle=title) {
# #JGG     tagList(
# #JGG       tags$head(tags$title(windowTitle)),
# #JGG       div(class="col-sm-12",
# #JGG         h1(title)
# #JGG       )
# #JGG     )
# #JGG   }
# #JGG
# #JGG   #' Create a well panel
# #JGG   #'
# #JGG   #' Creates a panel with a slightly inset border and grey background. Equivalent
# #JGG   #' to Bootstrap's \code{well} CSS class.
# #JGG   #'
# #JGG   #' @param ... UI elements to include inside the panel.
# #JGG   #' @return The newly created panel.
# #JGG   #' @export
# #JGG   wellPanel <- function(...) {
# #JGG     div(class="well", ...)
# #JGG   }
# #JGG
# #JGG   #' Create a sidebar panel
# #JGG   #'
# #JGG   #' Create a sidebar panel containing input controls that can in turn be passed
# #JGG   #' to \code{\link{sidebarLayout}}.
# #JGG   #'
# #JGG   #' @param ... UI elements to include on the sidebar
# #JGG   #' @param width The width of the sidebar. For fluid layouts this is out of 12
# #JGG   #'   total units; for fixed layouts it is out of whatever the width of the
# #JGG   #'   sidebar's parent column is.
# #JGG   #' @return A sidebar that can be passed to \code{\link{sidebarLayout}}
# #JGG   #'
# #JGG   #' @examples
# #JGG   #' # Sidebar with controls to select a dataset and specify
# #JGG   #' # the number of observations to view
# #JGG   #' sidebarPanel(
# #JGG   #'   selectInput("dataset", "Choose a dataset:",
# #JGG   #'               choices = c("rock", "pressure", "cars")),
# #JGG   #'
# #JGG   #'   numericInput("obs", "Observations:", 10)
# #JGG   #' )
# #JGG   #' @export
# #JGG   sidebarPanel <- function(..., width = 4) {
# #JGG     div(class=paste0("col-sm-", width),
# #JGG       tags$form(class="well",
# #JGG         ...
# #JGG       )
# #JGG     )
# #JGG   }
# #JGG
# #JGG   #' Create a main panel
# #JGG   #'
# #JGG   #' Create a main panel containing output elements that can in turn be passed to
# #JGG   #' \code{\link{sidebarLayout}}.
# #JGG   #'
# #JGG   #' @param ... Output elements to include in the main panel
# #JGG   #' @param width The width of the main panel. For fluid layouts this is out of 12
# #JGG   #'   total units; for fixed layouts it is out of whatever the width of the main
# #JGG   #'   panel's parent column is.
# #JGG   #' @return A main panel that can be passed to \code{\link{sidebarLayout}}.
# #JGG   #'
# #JGG   #' @examples
# #JGG   #' # Show the caption and plot of the requested variable against mpg
# #JGG   #' mainPanel(
# #JGG   #'    h3(textOutput("caption")),
# #JGG   #'    plotOutput("mpgPlot")
# #JGG   #' )
# #JGG   #' @export
# #JGG   mainPanel <- function(..., width = 8) {
# #JGG     div(class=paste0("col-sm-", width),
# #JGG       ...
# #JGG     )
# #JGG   }
# #JGG
# #JGG   #' Conditional Panel
# #JGG   #'
# #JGG   #' Creates a panel that is visible or not, depending on the value of a
# #JGG   #' JavaScript expression. The JS expression is evaluated once at startup and
# #JGG   #' whenever Shiny detects a relevant change in input/output.
# #JGG   #'
# #JGG   #' In the JS expression, you can refer to \code{input} and \code{output}
# #JGG   #' JavaScript objects that contain the current values of input and output. For
# #JGG   #' example, if you have an input with an id of \code{foo}, then you can use
# #JGG   #' \code{input.foo} to read its value. (Be sure not to modify the input/output
# #JGG   #' objects, as this may cause unpredictable behavior.)
# #JGG   #'
# #JGG   #' @param condition A JavaScript expression that will be evaluated repeatedly to
# #JGG   #'   determine whether the panel should be displayed.
# #JGG   #' @param ns The \code{\link[=NS]{namespace}} object of the current module, if
# #JGG   #'   any.
# #JGG   #' @param ... Elements to include in the panel.
# #JGG   #'
# #JGG   #' @note You are not recommended to use special JavaScript characters such as a
# #JGG   #'   period \code{.} in the input id's, but if you do use them anyway, for
# #JGG   #'   example, \code{inputId = "foo.bar"}, you will have to use
# #JGG   #'   \code{input["foo.bar"]} instead of \code{input.foo.bar} to read the input
# #JGG   #'   value.
# #JGG   #' @examples
# #JGG   #' ## Only run this example in interactive R sessions
# #JGG   #' if (interactive()) {
# #JGG   #'   ui <- fluidPage(
# #JGG   #'     sidebarPanel(
# #JGG   #'       selectInput("plotType", "Plot Type",
# #JGG   #'         c(Scatter = "scatter", Histogram = "hist")
# #JGG   #'       ),
# #JGG   #'       # Only show this panel if the plot type is a histogram
# #JGG   #'       conditionalPanel(
# #JGG   #'         condition = "input.plotType == 'hist'",
# #JGG   #'         selectInput(
# #JGG   #'           "breaks", "Breaks",
# #JGG   #'           c("Sturges", "Scott", "Freedman-Diaconis", "[Custom]" = "custom")
# #JGG   #'         ),
# #JGG   #'         # Only show this panel if Custom is selected
# #JGG   #'         conditionalPanel(
# #JGG   #'           condition = "input.breaks == 'custom'",
# #JGG   #'           sliderInput("breakCount", "Break Count", min = 1, max = 50, value = 10)
# #JGG   #'         )
# #JGG   #'       )
# #JGG   #'     ),
# #JGG   #'     mainPanel(
# #JGG   #'       plotOutput("plot")
# #JGG   #'     )
# #JGG   #'   )
# #JGG   #'
# #JGG   #'   server <- function(input, output) {
# #JGG   #'     x <- rnorm(100)
# #JGG   #'     y <- rnorm(100)
# #JGG   #'
# #JGG   #'     output$plot <- renderPlot({
# #JGG   #'       if (input$plotType == "scatter") {
# #JGG   #'         plot(x, y)
# #JGG   #'       } else {
# #JGG   #'         breaks <- input$breaks
# #JGG   #'         if (breaks == "custom") {
# #JGG   #'           breaks <- input$breakCount
# #JGG   #'         }
# #JGG   #'
# #JGG   #'         hist(x, breaks = breaks)
# #JGG   #'       }
# #JGG   #'     })
# #JGG   #'   }
# #JGG   #'
# #JGG   #'   shinyApp(ui, server)
# #JGG   #' }
# #JGG   #' @export
# #JGG   conditionalPanel <- function(condition, ..., ns = NS(NULL)) {
# #JGG     div(`data-display-if`=condition, `data-ns-prefix`=ns(""), ...)
# #JGG   }
# #JGG
# #JGG   #' Create a help text element
# #JGG   #'
# #JGG   #' Create help text which can be added to an input form to provide additional
# #JGG   #' explanation or context.
# #JGG   #'
# #JGG   #' @param ... One or more help text strings (or other inline HTML elements)
# #JGG   #' @return A help text element that can be added to a UI definition.
# #JGG   #'
# #JGG   #' @examples
# #JGG   #' helpText("Note: while the data view will show only",
# #JGG   #'          "the specified number of observations, the",
# #JGG   #'          "summary will be based on the full dataset.")
# #JGG   #' @export
# #JGG   helpText <- function(...) {
# #JGG     span(class="help-block", ...)
# #JGG   }
# #JGG
# #JGG
# #JGG   #' Create a tab panel
# #JGG   #'
# #JGG   #' Create a tab panel that can be included within a \code{\link{tabsetPanel}}.
# #JGG   #'
# #JGG   #' @param title Display title for tab
# #JGG   #' @param ... UI elements to include within the tab
# #JGG   #' @param value The value that should be sent when \code{tabsetPanel} reports
# #JGG   #'   that this tab is selected. If omitted and \code{tabsetPanel} has an
# #JGG   #'   \code{id}, then the title will be used..
# #JGG   #' @param icon Optional icon to appear on the tab. This attribute is only
# #JGG   #' valid when using a \code{tabPanel} within a \code{\link{navbarPage}}.
# #JGG   #' @return A tab that can be passed to \code{\link{tabsetPanel}}
# #JGG   #'
# #JGG   #' @seealso \code{\link{tabsetPanel}}
# #JGG   #'
# #JGG   #' @examples
# #JGG   #' # Show a tabset that includes a plot, summary, and
# #JGG   #' # table view of the generated distribution
# #JGG   #' mainPanel(
# #JGG   #'   tabsetPanel(
# #JGG   #'     tabPanel("Plot", plotOutput("plot")),
# #JGG   #'     tabPanel("Summary", verbatimTextOutput("summary")),
# #JGG   #'     tabPanel("Table", tableOutput("table"))
# #JGG   #'   )
# #JGG   #' )
# #JGG   #' @export
# #JGG   tabPanel <- function(title, ..., value = title, icon = NULL) {
# #JGG     divTag <- div(class="tab-pane",
# #JGG                   title=title,
# #JGG                   `data-value`=value,
# #JGG                   `data-icon-class` = iconClass(icon),
# #JGG                   ...)
# #JGG   }
# #JGG
# #JGG   #' Create a tabset panel
# #JGG   #'
# #JGG   #' Create a tabset that contains \code{\link{tabPanel}} elements. Tabsets are
# #JGG   #' useful for dividing output into multiple independently viewable sections.
# #JGG   #'
# #JGG   #' @param ... \code{\link{tabPanel}} elements to include in the tabset
# #JGG   #' @param id If provided, you can use \code{input$}\emph{\code{id}} in your
# #JGG   #'   server logic to determine which of the current tabs is active. The value
# #JGG   #'   will correspond to the \code{value} argument that is passed to
# #JGG   #'   \code{\link{tabPanel}}.
# #JGG   #' @param selected The \code{value} (or, if none was supplied, the \code{title})
# #JGG   #'   of the tab that should be selected by default. If \code{NULL}, the first
# #JGG   #'   tab will be selected.
# #JGG   #' @param type Use "tabs" for the standard look; Use "pills" for a more plain
# #JGG   #'   look where tabs are selected using a background fill color.
# #JGG   #' @param position This argument is deprecated; it has been discontinued in
# #JGG   #'   Bootstrap 3.
# #JGG   #' @return A tabset that can be passed to \code{\link{mainPanel}}
# #JGG   #'
# #JGG   #' @seealso \code{\link{tabPanel}}, \code{\link{updateTabsetPanel}},
# #JGG   #'   \code{\link{insertTab}}, \code{\link{showTab}}
# #JGG   #'
# #JGG   #' @examples
# #JGG   #' # Show a tabset that includes a plot, summary, and
# #JGG   #' # table view of the generated distribution
# #JGG   #' mainPanel(
# #JGG   #'   tabsetPanel(
# #JGG   #'     tabPanel("Plot", plotOutput("plot")),
# #JGG   #'     tabPanel("Summary", verbatimTextOutput("summary")),
# #JGG   #'     tabPanel("Table", tableOutput("table"))
# #JGG   #'   )
# #JGG   #' )
# #JGG   #' @export
# #JGG   tabsetPanel <- function(...,
# #JGG                           id = NULL,
# #JGG                           selected = NULL,
# #JGG                           type = c("tabs", "pills"),
# #JGG                           position = NULL) {
# #JGG     if (!is.null(position)) {
# #JGG       shinyDeprecated(msg = paste("tabsetPanel: argument 'position' is deprecated;",
# #JGG                                   "it has been discontinued in Bootstrap 3."),
# #JGG                       version = "0.10.2.2")
# #JGG     }
# #JGG
# #JGG     if (!is.null(id))
# #JGG       selected <- restoreInput(id = id, default = selected)
# #JGG
# #JGG     # build the tabset
# #JGG     tabs <- list(...)
# #JGG     type <- match.arg(type)
# #JGG
# #JGG     tabset <- buildTabset(tabs, paste0("nav nav-", type), NULL, id, selected)
# #JGG
# #JGG     # create the content
# #JGG     first <- tabset$navList
# #JGG     second <- tabset$content
# #JGG
# #JGG     # create the tab div
# #JGG     tags$div(class = "tabbable", first, second)
# #JGG   }
# #JGG
# #JGG   #' Create a navigation list panel
# #JGG   #'
# #JGG   #' Create a navigation list panel that provides a list of links on the left
# #JGG   #' which navigate to a set of tabPanels displayed to the right.
# #JGG   #'
# #JGG   #' @param ... \code{\link{tabPanel}} elements to include in the navlist
# #JGG   #' @param id If provided, you can use \code{input$}\emph{\code{id}} in your
# #JGG   #'   server logic to determine which of the current navlist items is active. The
# #JGG   #'   value will correspond to the \code{value} argument that is passed to
# #JGG   #'   \code{\link{tabPanel}}.
# #JGG   #' @param selected The \code{value} (or, if none was supplied, the \code{title})
# #JGG   #'   of the navigation item that should be selected by default. If \code{NULL},
# #JGG   #'   the first navigation will be selected.
# #JGG   #' @param well \code{TRUE} to place a well (gray rounded rectangle) around the
# #JGG   #'   navigation list.
# #JGG   #' @param fluid \code{TRUE} to use fluid layout; \code{FALSE} to use fixed
# #JGG   #'   layout.
# #JGG   #' @param widths Column withs of the navigation list and tabset content areas
# #JGG   #'   respectively.
# #JGG   #'
# #JGG   #' @details You can include headers within the \code{navlistPanel} by including
# #JGG   #'   plain text elements in the list. Versions of Shiny before 0.11 supported
# #JGG   #'   separators with "------", but as of 0.11, separators were no longer
# #JGG   #'   supported. This is because version 0.11 switched to Bootstrap 3, which
# #JGG   #'   doesn't support separators.
# #JGG   #'
# #JGG   #' @seealso \code{\link{tabPanel}}, \code{\link{updateNavlistPanel}},
# #JGG   #'    \code{\link{insertTab}}, \code{\link{showTab}}
# #JGG   #'
# #JGG   #' @examples
# #JGG   #' fluidPage(
# #JGG   #'
# #JGG   #'   titlePanel("Application Title"),
# #JGG   #'
# #JGG   #'   navlistPanel(
# #JGG   #'     "Header",
# #JGG   #'     tabPanel("First"),
# #JGG   #'     tabPanel("Second"),
# #JGG   #'     tabPanel("Third")
# #JGG   #'   )
# #JGG   #' )
# #JGG   #' @export
# #JGG   navlistPanel <- function(...,
# #JGG                            id = NULL,
# #JGG                            selected = NULL,
# #JGG                            well = TRUE,
# #JGG                            fluid = TRUE,
# #JGG                            widths = c(4, 8)) {
# #JGG
# #JGG     # text filter for headers
# #JGG     textFilter <- function(text) {
# #JGG         tags$li(class="navbar-brand", text)
# #JGG     }
# #JGG
# #JGG     if (!is.null(id))
# #JGG       selected <- restoreInput(id = id, default = selected)
# #JGG
# #JGG     # build the tabset
# #JGG     tabs <- list(...)
# #JGG     tabset <- buildTabset(tabs,
# #JGG                           "nav nav-pills nav-stacked",
# #JGG                           textFilter,
# #JGG                           id,
# #JGG                           selected)
# #JGG
# #JGG     # create the columns
# #JGG     columns <- list(
# #JGG       column(widths[[1]], class=ifelse(well, "well", ""), tabset$navList),
# #JGG       column(widths[[2]], tabset$content)
# #JGG     )
# #JGG
# #JGG     # return the row
# #JGG     if (fluid)
# #JGG       fluidRow(columns)
# #JGG     else
# #JGG       fixedRow(columns)
# #JGG   }
# #JGG
#
# #JGG   #' Create a text output element
# #JGG   #'
# #JGG   #' Render a reactive output variable as text within an application page. The
# #JGG   #' text will be included within an HTML \code{div} tag by default.
# #JGG   #' @param outputId output variable to read the value from
# #JGG   #' @param container a function to generate an HTML element to contain the text
# #JGG   #' @param inline use an inline (\code{span()}) or block container (\code{div()})
# #JGG   #'   for the output
# #JGG   #' @return A text output element that can be included in a panel
# #JGG   #' @details Text is HTML-escaped prior to rendering. This element is often used
# #JGG   #'   to display \link{renderText} output variables.
# #JGG   #' @examples
# #JGG   #' h3(textOutput("caption"))
# #JGG   #' @export
# #JGG   textOutput <- function(outputId, container = if (inline) span else div, inline = FALSE) {
# #JGG     container(id = outputId, class = "shiny-text-output")
# #JGG   }
# #JGG
# #JGG   #' Create a verbatim text output element
# #JGG   #'
# #JGG   #' Render a reactive output variable as verbatim text within an
# #JGG   #' application page. The text will be included within an HTML \code{pre} tag.
# #JGG   #' @param outputId output variable to read the value from
# #JGG   #' @param placeholder if the output is empty or \code{NULL}, should an empty
# #JGG   #'   rectangle be displayed to serve as a placeholder? (does not affect
# #JGG   #'   behavior when the the output in nonempty)
# #JGG   #' @return A verbatim text output element that can be included in a panel
# #JGG   #' @details Text is HTML-escaped prior to rendering. This element is often used
# #JGG   #'   with the \link{renderPrint} function to preserve fixed-width formatting
# #JGG   #'   of printed objects.
# #JGG   #' @examples
# #JGG   #' ## Only run this example in interactive R sessions
# #JGG   #' if (interactive()) {
# #JGG   #'   shinyApp(
# #JGG   #'     ui = basicPage(
# #JGG   #'       textInput("txt", "Enter the text to display below:"),
# #JGG   #'       verbatimTextOutput("default"),
# #JGG   #'       verbatimTextOutput("placeholder", placeholder = TRUE)
# #JGG   #'     ),
# #JGG   #'     server = function(input, output) {
# #JGG   #'       output$default <- renderText({ input$txt })
# #JGG   #'       output$placeholder <- renderText({ input$txt })
# #JGG   #'     }
# #JGG   #'   )
# #JGG   #' }
# #JGG   #' @export
# #JGG   verbatimTextOutput <- function(outputId, placeholder = FALSE) {
# #JGG     pre(id = outputId,
# #JGG         class = paste(c("shiny-text-output", if (!placeholder) "noplaceholder"),
# #JGG                       collapse = " ")
# #JGG         )
# #JGG   }
# #JGG
# #JGG
# #JGG   #' @name plotOutput
# #JGG   #' @rdname plotOutput
# #JGG   #' @export
# #JGG   imageOutput <- function(outputId, width = "100%", height="400px",
# #JGG                           click = NULL, dblclick = NULL,
# #JGG                           hover = NULL, hoverDelay = NULL, hoverDelayType = NULL,
# #JGG                           brush = NULL,
# #JGG                           clickId = NULL, hoverId = NULL,
# #JGG                           inline = FALSE) {
# #JGG
# #JGG     if (!is.null(clickId)) {
# #JGG       shinyDeprecated(
# #JGG         msg = paste("The 'clickId' argument is deprecated. ",
# #JGG                     "Please use 'click' instead. ",
# #JGG                     "See ?imageOutput or ?plotOutput for more information."),
# #JGG         version = "0.11.1"
# #JGG       )
# #JGG       click <- clickId
# #JGG     }
# #JGG
# #JGG     if (!is.null(hoverId)) {
# #JGG       shinyDeprecated(
# #JGG         msg = paste("The 'hoverId' argument is deprecated. ",
# #JGG                     "Please use 'hover' instead. ",
# #JGG                     "See ?imageOutput or ?plotOutput for more information."),
# #JGG         version = "0.11.1"
# #JGG       )
# #JGG       hover <- hoverId
# #JGG     }
# #JGG
# #JGG     if (!is.null(hoverDelay) || !is.null(hoverDelayType)) {
# #JGG       shinyDeprecated(
# #JGG         msg = paste("The 'hoverDelay'and 'hoverDelayType' arguments are deprecated. ",
# #JGG                     "Please use 'hoverOpts' instead. ",
# #JGG                     "See ?imageOutput or ?plotOutput for more information."),
# #JGG         version = "0.11.1"
# #JGG       )
# #JGG       hover <- hoverOpts(id = hover, delay = hoverDelay, delayType = hoverDelayType)
# #JGG     }
# #JGG
# #JGG     style <- if (!inline) {
# #JGG       paste("width:", validateCssUnit(width), ";", "height:", validateCssUnit(height))
# #JGG     }
# #JGG
# #JGG
# #JGG     # Build up arguments for call to div() or span()
# #JGG     args <- list(
# #JGG       id = outputId,
# #JGG       class = "shiny-image-output",
# #JGG       style = style
# #JGG     )
# #JGG
# #JGG     # Given a named list with options, replace names like "delayType" with
# #JGG     # "data-hover-delay-type" (given a prefix "hover")
# #JGG     formatOptNames <- function(opts, prefix) {
# #JGG       newNames <- paste("data", prefix, names(opts), sep = "-")
# #JGG       # Replace capital letters with "-" and lowercase letter
# #JGG       newNames <- gsub("([A-Z])", "-\\L\\1", newNames, perl = TRUE)
# #JGG       names(opts) <- newNames
# #JGG       opts
# #JGG     }
# #JGG
# #JGG     if (!is.null(click)) {
# #JGG       # If click is a string, turn it into clickOpts object
# #JGG       if (is.character(click)) {
# #JGG         click <- clickOpts(id = click)
# #JGG       }
# #JGG       args <- c(args, formatOptNames(click, "click"))
# #JGG     }
# #JGG
# #JGG     if (!is.null(dblclick)) {
# #JGG       if (is.character(dblclick)) {
# #JGG         dblclick <- clickOpts(id = dblclick)
# #JGG       }
# #JGG       args <- c(args, formatOptNames(dblclick, "dblclick"))
# #JGG     }
# #JGG
# #JGG     if (!is.null(hover)) {
# #JGG       if (is.character(hover)) {
# #JGG         hover <- hoverOpts(id = hover)
# #JGG       }
# #JGG       args <- c(args, formatOptNames(hover, "hover"))
# #JGG     }
# #JGG
# #JGG     if (!is.null(brush)) {
# #JGG       if (is.character(brush)) {
# #JGG         brush <- brushOpts(id = brush)
# #JGG       }
# #JGG       args <- c(args, formatOptNames(brush, "brush"))
# #JGG     }
# #JGG
# #JGG     container <- if (inline) span else div
# #JGG     do.call(container, args)
# #JGG   }
# #JGG
# #JGG   #' Create an plot or image output element
# #JGG   #'
# #JGG   #' Render a \code{\link{renderPlot}} or \code{\link{renderImage}} within an
# #JGG   #' application page.
# #JGG   #'
# #JGG   #' @section Interactive plots:
# #JGG   #'
# #JGG   #'   Plots and images in Shiny support mouse-based interaction, via clicking,
# #JGG   #'   double-clicking, hovering, and brushing. When these interaction events
# #JGG   #'   occur, the mouse coordinates will be sent to the server as \code{input$}
# #JGG   #'   variables, as specified by \code{click}, \code{dblclick}, \code{hover}, or
# #JGG   #'   \code{brush}.
# #JGG   #'
# #JGG   #'   For \code{plotOutput}, the coordinates will be sent scaled to the data
# #JGG   #'   space, if possible. (At the moment, plots generated by base graphics and
# #JGG   #'   ggplot2 support this scaling, although plots generated by lattice and
# #JGG   #'   others do not.) If scaling is not possible, the raw pixel coordinates will
# #JGG   #'   be sent. For \code{imageOutput}, the coordinates will be sent in raw pixel
# #JGG   #'   coordinates.
# #JGG   #'
# #JGG   #'   With ggplot2 graphics, the code in \code{renderPlot} should return a ggplot
# #JGG   #'   object; if instead the code prints the ggplot2 object with something like
# #JGG   #'   \code{print(p)}, then the coordinates for interactive graphics will not be
# #JGG   #'   properly scaled to the data space.
# #JGG   #'
# #JGG   #' @param outputId output variable to read the plot/image from.
# #JGG   #' @param width,height Image width/height. Must be a valid CSS unit (like
# #JGG   #'   \code{"100\%"}, \code{"400px"}, \code{"auto"}) or a number, which will be
# #JGG   #'   coerced to a string and have \code{"px"} appended. These two arguments are
# #JGG   #'   ignored when \code{inline = TRUE}, in which case the width/height of a plot
# #JGG   #'   must be specified in \code{renderPlot()}. Note that, for height, using
# #JGG   #'   \code{"auto"} or \code{"100\%"} generally will not work as expected,
# #JGG   #'   because of how height is computed with HTML/CSS.
# #JGG   #' @param click This can be \code{NULL} (the default), a string, or an object
# #JGG   #'   created by the \code{\link{clickOpts}} function. If you use a value like
# #JGG   #'   \code{"plot_click"} (or equivalently, \code{clickOpts(id="plot_click")}),
# #JGG   #'   the plot will send coordinates to the server whenever it is clicked, and
# #JGG   #'   the value will be accessible via \code{input$plot_click}. The value will be
# #JGG   #'   a named list  with \code{x} and \code{y} elements indicating the mouse
# #JGG   #'   position.
# #JGG   #' @param dblclick This is just like the \code{click} argument, but for
# #JGG   #'   double-click events.
# #JGG   #' @param hover Similar to the \code{click} argument, this can be \code{NULL}
# #JGG   #'   (the default), a string, or an object created by the
# #JGG   #'   \code{\link{hoverOpts}} function. If you use a value like
# #JGG   #'   \code{"plot_hover"} (or equivalently, \code{hoverOpts(id="plot_hover")}),
# #JGG   #'   the plot will send coordinates to the server pauses on the plot, and the
# #JGG   #'   value will be accessible via \code{input$plot_hover}. The value will be a
# #JGG   #'   named list with \code{x} and \code{y} elements indicating the mouse
# #JGG   #'   position. To control the hover time or hover delay type, you must use
# #JGG   #'   \code{\link{hoverOpts}}.
# #JGG   #' @param clickId Deprecated; use \code{click} instead. Also see the
# #JGG   #'   \code{\link{clickOpts}} function.
# #JGG   #' @param hoverId Deprecated; use \code{hover} instead. Also see the
# #JGG   #'   \code{\link{hoverOpts}} function.
# #JGG   #' @param hoverDelay Deprecated; use \code{hover} instead. Also see the
# #JGG   #'   \code{\link{hoverOpts}} function.
# #JGG   #' @param hoverDelayType Deprecated; use \code{hover} instead. Also see the
# #JGG   #'   \code{\link{hoverOpts}} function.
# #JGG   #' @param brush Similar to the \code{click} argument, this can be \code{NULL}
# #JGG   #'   (the default), a string, or an object created by the
# #JGG   #'   \code{\link{brushOpts}} function. If you use a value like
# #JGG   #'   \code{"plot_brush"} (or equivalently, \code{brushOpts(id="plot_brush")}),
# #JGG   #'   the plot will allow the user to "brush" in the plotting area, and will send
# #JGG   #'   information about the brushed area to the server, and the value will be
# #JGG   #'   accessible via \code{input$plot_brush}. Brushing means that the user will
# #JGG   #'   be able to draw a rectangle in the plotting area and drag it around. The
# #JGG   #'   value will be a named list with \code{xmin}, \code{xmax}, \code{ymin}, and
# #JGG   #'   \code{ymax} elements indicating the brush area. To control the brush
# #JGG   #'   behavior, use \code{\link{brushOpts}}. Multiple
# #JGG   #'   \code{imageOutput}/\code{plotOutput} calls may share the same \code{id}
# #JGG   #'   value; brushing one image or plot will cause any other brushes with the
# #JGG   #'   same \code{id} to disappear.
# #JGG   #' @inheritParams textOutput
# #JGG   #' @note The arguments \code{clickId} and \code{hoverId} only work for R base
# #JGG   #'   graphics (see the \pkg{\link[graphics:graphics-package]{graphics}} package). They do not work for
# #JGG   #'   \pkg{\link[grid:grid-package]{grid}}-based graphics, such as \pkg{ggplot2},
# #JGG   #'   \pkg{lattice}, and so on.
# #JGG   #'
# #JGG   #' @return A plot or image output element that can be included in a panel.
# #JGG   #' @seealso For the corresponding server-side functions, see
# #JGG   #'   \code{\link{renderPlot}} and  \code{\link{renderImage}}.
# #JGG   #'
# #JGG   #' @examples
# #JGG   #' # Only run these examples in interactive R sessions
# #JGG   #' if (interactive()) {
# #JGG   #'
# #JGG   #' # A basic shiny app with a plotOutput
# #JGG   #' shinyApp(
# #JGG   #'   ui = fluidPage(
# #JGG   #'     sidebarLayout(
# #JGG   #'       sidebarPanel(
# #JGG   #'         actionButton("newplot", "New plot")
# #JGG   #'       ),
# #JGG   #'       mainPanel(
# #JGG   #'         plotOutput("plot")
# #JGG   #'       )
# #JGG   #'     )
# #JGG   #'   ),
# #JGG   #'   server = function(input, output) {
# #JGG   #'     output$plot <- renderPlot({
# #JGG   #'       input$newplot
# #JGG   #'       # Add a little noise to the cars data
# #JGG   #'       cars2 <- cars + rnorm(nrow(cars))
# #JGG   #'       plot(cars2)
# #JGG   #'     })
# #JGG   #'   }
# #JGG   #' )
# #JGG   #'
# #JGG   #'
# #JGG   #' # A demonstration of clicking, hovering, and brushing
# #JGG   #' shinyApp(
# #JGG   #'   ui = basicPage(
# #JGG   #'     fluidRow(
# #JGG   #'       column(width = 4,
# #JGG   #'         plotOutput("plot", height=300,
# #JGG   #'           click = "plot_click",  # Equiv, to click=clickOpts(id="plot_click")
# #JGG   #'           hover = hoverOpts(id = "plot_hover", delayType = "throttle"),
# #JGG   #'           brush = brushOpts(id = "plot_brush")
# #JGG   #'         ),
# #JGG   #'         h4("Clicked points"),
# #JGG   #'         tableOutput("plot_clickedpoints"),
# #JGG   #'         h4("Brushed points"),
# #JGG   #'         tableOutput("plot_brushedpoints")
# #JGG   #'       ),
# #JGG   #'       column(width = 4,
# #JGG   #'         verbatimTextOutput("plot_clickinfo"),
# #JGG   #'         verbatimTextOutput("plot_hoverinfo")
# #JGG   #'       ),
# #JGG   #'       column(width = 4,
# #JGG   #'         wellPanel(actionButton("newplot", "New plot")),
# #JGG   #'         verbatimTextOutput("plot_brushinfo")
# #JGG   #'       )
# #JGG   #'     )
# #JGG   #'   ),
# #JGG   #'   server = function(input, output, session) {
# #JGG   #'     data <- reactive({
# #JGG   #'       input$newplot
# #JGG   #'       # Add a little noise to the cars data so the points move
# #JGG   #'       cars + rnorm(nrow(cars))
# #JGG   #'     })
# #JGG   #'     output$plot <- renderPlot({
# #JGG   #'       d <- data()
# #JGG   #'       plot(d$speed, d$dist)
# #JGG   #'     })
# #JGG   #'     output$plot_clickinfo <- renderPrint({
# #JGG   #'       cat("Click:\n")
# #JGG   #'       str(input$plot_click)
# #JGG   #'     })
# #JGG   #'     output$plot_hoverinfo <- renderPrint({
# #JGG   #'       cat("Hover (throttled):\n")
# #JGG   #'       str(input$plot_hover)
# #JGG   #'     })
# #JGG   #'     output$plot_brushinfo <- renderPrint({
# #JGG   #'       cat("Brush (debounced):\n")
# #JGG   #'       str(input$plot_brush)
# #JGG   #'     })
# #JGG   #'     output$plot_clickedpoints <- renderTable({
# #JGG   #'       # For base graphics, we need to specify columns, though for ggplot2,
# #JGG   #'       # it's usually not necessary.
# #JGG   #'       res <- nearPoints(data(), input$plot_click, "speed", "dist")
# #JGG   #'       if (nrow(res) == 0)
# #JGG   #'         return()
# #JGG   #'       res
# #JGG   #'     })
# #JGG   #'     output$plot_brushedpoints <- renderTable({
# #JGG   #'       res <- brushedPoints(data(), input$plot_brush, "speed", "dist")
# #JGG   #'       if (nrow(res) == 0)
# #JGG   #'         return()
# #JGG   #'       res
# #JGG   #'     })
# #JGG   #'   }
# #JGG   #' )
# #JGG   #'
# #JGG   #'
# #JGG   #' # Demo of clicking, hovering, brushing with imageOutput
# #JGG   #' # Note that coordinates are in pixels
# #JGG   #' shinyApp(
# #JGG   #'   ui = basicPage(
# #JGG   #'     fluidRow(
# #JGG   #'       column(width = 4,
# #JGG   #'         imageOutput("image", height=300,
# #JGG   #'           click = "image_click",
# #JGG   #'           hover = hoverOpts(
# #JGG   #'             id = "image_hover",
# #JGG   #'             delay = 500,
# #JGG   #'             delayType = "throttle"
# #JGG   #'           ),
# #JGG   #'           brush = brushOpts(id = "image_brush")
# #JGG   #'         )
# #JGG   #'       ),
# #JGG   #'       column(width = 4,
# #JGG   #'         verbatimTextOutput("image_clickinfo"),
# #JGG   #'         verbatimTextOutput("image_hoverinfo")
# #JGG   #'       ),
# #JGG   #'       column(width = 4,
# #JGG   #'         wellPanel(actionButton("newimage", "New image")),
# #JGG   #'         verbatimTextOutput("image_brushinfo")
# #JGG   #'       )
# #JGG   #'     )
# #JGG   #'   ),
# #JGG   #'   server = function(input, output, session) {
# #JGG   #'     output$image <- renderImage({
# #JGG   #'       input$newimage
# #JGG   #'
# #JGG   #'       # Get width and height of image output
# #JGG   #'       width  <- session$clientData$output_image_width
# #JGG   #'       height <- session$clientData$output_image_height
# #JGG   #'
# #JGG   #'       # Write to a temporary PNG file
# #JGG   #'       outfile <- tempfile(fileext = ".png")
# #JGG   #'
# #JGG   #'       png(outfile, width=width, height=height)
# #JGG   #'       plot(rnorm(200), rnorm(200))
# #JGG   #'       dev.off()
# #JGG   #'
# #JGG   #'       # Return a list containing information about the image
# #JGG   #'       list(
# #JGG   #'         src = outfile,
# #JGG   #'         contentType = "image/png",
# #JGG   #'         width = width,
# #JGG   #'         height = height,
# #JGG   #'         alt = "This is alternate text"
# #JGG   #'       )
# #JGG   #'     })
# #JGG   #'     output$image_clickinfo <- renderPrint({
# #JGG   #'       cat("Click:\n")
# #JGG   #'       str(input$image_click)
# #JGG   #'     })
# #JGG   #'     output$image_hoverinfo <- renderPrint({
# #JGG   #'       cat("Hover (throttled):\n")
# #JGG   #'       str(input$image_hover)
# #JGG   #'     })
# #JGG   #'     output$image_brushinfo <- renderPrint({
# #JGG   #'       cat("Brush (debounced):\n")
# #JGG   #'       str(input$image_brush)
# #JGG   #'     })
# #JGG   #'   }
# #JGG   #' )
# #JGG   #'
# #JGG   #' }
# #JGG   #' @export
# #JGG   plotOutput <- function(outputId, width = "100%", height="400px",
# #JGG                          click = NULL, dblclick = NULL,
# #JGG                          hover = NULL, hoverDelay = NULL, hoverDelayType = NULL,
# #JGG                          brush = NULL,
# #JGG                          clickId = NULL, hoverId = NULL,
# #JGG                          inline = FALSE) {
# #JGG
# #JGG     # Result is the same as imageOutput, except for HTML class
# #JGG     res <- imageOutput(outputId, width, height, click, dblclick,
# #JGG                        hover, hoverDelay, hoverDelayType, brush,
# #JGG                        clickId, hoverId, inline)
# #JGG
# #JGG     res$attribs$class <- "shiny-plot-output"
# #JGG     res
# #JGG   }
# #JGG
# #JGG   #' Create a table output element
# #JGG   #'
# #JGG   #' Render a \code{\link{renderTable}} or \code{\link{renderDataTable}} within an
# #JGG   #' application page. \code{renderTable} uses a standard HTML table, while
# #JGG   #' \code{renderDataTable} uses the DataTables Javascript library to create an
# #JGG   #' interactive table with more features.
# #JGG   #'
# #JGG   #' @param outputId output variable to read the table from
# #JGG   #' @return A table output element that can be included in a panel
# #JGG   #'
# #JGG   #' @seealso \code{\link{renderTable}}, \code{\link{renderDataTable}}.
# #JGG   #' @examples
# #JGG   #' ## Only run this example in interactive R sessions
# #JGG   #' if (interactive()) {
# #JGG   #'   # table example
# #JGG   #'   shinyApp(
# #JGG   #'     ui = fluidPage(
# #JGG   #'       fluidRow(
# #JGG   #'         column(12,
# #JGG   #'           tableOutput('table')
# #JGG   #'         )
# #JGG   #'       )
# #JGG   #'     ),
# #JGG   #'     server = function(input, output) {
# #JGG   #'       output$table <- renderTable(iris)
# #JGG   #'     }
# #JGG   #'   )
# #JGG   #'
# #JGG   #'
# #JGG   #'   # DataTables example
# #JGG   #'   shinyApp(
# #JGG   #'     ui = fluidPage(
# #JGG   #'       fluidRow(
# #JGG   #'         column(12,
# #JGG   #'           dataTableOutput('table')
# #JGG   #'         )
# #JGG   #'       )
# #JGG   #'     ),
# #JGG   #'     server = function(input, output) {
# #JGG   #'       output$table <- renderDataTable(iris)
# #JGG   #'     }
# #JGG   #'   )
# #JGG   #' }
# #JGG   #' @export
# #JGG   tableOutput <- function(outputId) {
# #JGG     div(id = outputId, class="shiny-html-output")
# #JGG   }
# #JGG
# #JGG   dataTableDependency <- list(
# #JGG     htmlDependency(
# #JGG       "datatables", "1.10.5", c(href = "shared/datatables"),
# #JGG       script = "js/jquery.dataTables.min.js"
# #JGG     ),
# #JGG     htmlDependency(
# #JGG       "datatables-bootstrap", "1.10.5", c(href = "shared/datatables"),
# #JGG       stylesheet = c("css/dataTables.bootstrap.css", "css/dataTables.extra.css"),
# #JGG       script = "js/dataTables.bootstrap.js"
# #JGG     )
# #JGG   )
# #JGG
# #JGG   #' @rdname tableOutput
# #JGG   #' @export
# #JGG   dataTableOutput <- function(outputId) {
# #JGG     attachDependencies(
# #JGG       div(id = outputId, class="shiny-datatable-output"),
# #JGG       dataTableDependency
# #JGG     )
# #JGG   }
# #JGG
# #JGG   #' Create an HTML output element
# #JGG   #'
# #JGG   #' Render a reactive output variable as HTML within an application page. The
# #JGG   #' text will be included within an HTML \code{div} tag, and is presumed to
# #JGG   #' contain HTML content which should not be escaped.
# #JGG   #'
# #JGG   #' \code{uiOutput} is intended to be used with \code{renderUI} on the server
# #JGG   #' side. It is currently just an alias for \code{htmlOutput}.
# #JGG   #'
# #JGG   #' @param outputId output variable to read the value from
# #JGG   #' @param ... Other arguments to pass to the container tag function. This is
# #JGG   #'   useful for providing additional classes for the tag.
# #JGG   #' @inheritParams textOutput
# #JGG   #' @return An HTML output element that can be included in a panel
# #JGG   #' @examples
# #JGG   #' htmlOutput("summary")
# #JGG   #'
# #JGG   #' # Using a custom container and class
# #JGG   #' tags$ul(
# #JGG   #'   htmlOutput("summary", container = tags$li, class = "custom-li-output")
# #JGG   #' )
# #JGG   #' @export
# #JGG   htmlOutput <- function(outputId, inline = FALSE,
# #JGG     container = if (inline) span else div, ...)
# #JGG   {
# #JGG     if (anyUnnamed(list(...))) {
# #JGG       warning("Unnamed elements in ... will be replaced with dynamic UI.")
# #JGG     }
# #JGG     container(id = outputId, class="shiny-html-output", ...)
# #JGG   }
# #JGG
# #JGG   #' @rdname htmlOutput
# #JGG   #' @export
# #JGG   uiOutput <- htmlOutput
# #JGG
# #JGG   #' Create a download button or link
# #JGG   #'
# #JGG   #' Use these functions to create a download button or link; when clicked, it
# #JGG   #' will initiate a browser download. The filename and contents are specified by
# #JGG   #' the corresponding \code{\link{downloadHandler}} defined in the server
# #JGG   #' function.
# #JGG   #'
# #JGG   #' @param outputId The name of the output slot that the \code{downloadHandler}
# #JGG   #'   is assigned to.
# #JGG   #' @param label The label that should appear on the button.
# #JGG   #' @param class Additional CSS classes to apply to the tag, if any.
# #JGG   #' @param ... Other arguments to pass to the container tag function.
# #JGG   #'
# #JGG   #' @examples
# #JGG   #' \dontrun{
# #JGG   #' # In server.R:
# #JGG   #' output$downloadData <- downloadHandler(
# #JGG   #'   filename = function() {
# #JGG   #'     paste('data-', Sys.Date(), '.csv', sep='')
# #JGG   #'   },
# #JGG   #'   content = function(con) {
# #JGG   #'     write.csv(data, con)
# #JGG   #'   }
# #JGG   #' )
# #JGG   #'
# #JGG   #' # In ui.R:
# #JGG   #' downloadLink('downloadData', 'Download')
# #JGG   #' }
# #JGG   #'
# #JGG   #' @aliases downloadLink
# #JGG   #' @seealso \code{\link{downloadHandler}}
# #JGG   #' @export
# #JGG   downloadButton <- function(outputId,
# #JGG                              label="Download",
# #JGG                              class=NULL, ...) {
# #JGG     aTag <- tags$a(id=outputId,
# #JGG                    class=paste('btn btn-default shiny-download-link', class),
# #JGG                    href='',
# #JGG                    target='_blank',
# #JGG                    download=NA,
# #JGG                    icon("download"),
# #JGG                    label, ...)
# #JGG   }
# #JGG
# #JGG   #' @rdname downloadButton
# #JGG   #' @export
# #JGG   downloadLink <- function(outputId, label="Download", class=NULL, ...) {
# #JGG     tags$a(id=outputId,
# #JGG            class=paste(c('shiny-download-link', class), collapse=" "),
# #JGG            href='',
# #JGG            target='_blank',
# #JGG            download=NA,
# #JGG            label, ...)
# #JGG   }
# #JGG
# #JGG
# #JGG   #' Create an icon
# #JGG   #'
# #JGG   #' Create an icon for use within a page. Icons can appear on their own, inside
# #JGG   #' of a button, or as an icon for a \code{\link{tabPanel}} within a
# #JGG   #' \code{\link{navbarPage}}.
# #JGG   #'
# #JGG   #' @param name Name of icon. Icons are drawn from the
# #JGG   #'   \href{https://fontawesome.com/}{Font Awesome Free} (currently icons from
# #JGG   #'   the v5.3.1 set are supported with the v4 naming convention) and
# #JGG   #'   \href{http://getbootstrap.com/components/#glyphicons}{Glyphicons}
# #JGG   #'   libraries. Note that the "fa-" and "glyphicon-" prefixes should not be used
# #JGG   #'   in icon names (i.e. the "fa-calendar" icon should be referred to as
# #JGG   #'   "calendar")
# #JGG   #' @param class Additional classes to customize the style of the icon (see the
# #JGG   #'   \href{http://fontawesome.io/examples/}{usage examples} for details on
# #JGG   #'   supported styles).
# #JGG   #' @param lib Icon library to use ("font-awesome" or "glyphicon")
# #JGG   #'
# #JGG   #' @return An icon element
# #JGG   #'
# #JGG   #' @seealso For lists of available icons, see
# #JGG   #'   \href{http://fontawesome.io/icons/}{http://fontawesome.io/icons/} and
# #JGG   #'   \href{http://getbootstrap.com/components/#glyphicons}{http://getbootstrap.com/components/#glyphicons}.
# #JGG   #'
# #JGG   #'
# #JGG   #' @examples
# #JGG   #' # add an icon to a submit button
# #JGG   #' submitButton("Update View", icon = icon("refresh"))
# #JGG   #'
# #JGG   #' navbarPage("App Title",
# #JGG   #'   tabPanel("Plot", icon = icon("bar-chart-o")),
# #JGG   #'   tabPanel("Summary", icon = icon("list-alt")),
# #JGG   #'   tabPanel("Table", icon = icon("table"))
# #JGG   #' )
# #JGG   #' #JGG
# #JGG   # #' @export
# #JGG   # icon <- function(name, class = NULL, lib = "font-awesome") {
# #JGG   #   prefixes <- list(
# #JGG   #     "font-awesome" = "fa",
# #JGG   #     "glyphicon" = "glyphicon"
# #JGG   #   )
# #JGG   #   prefix <- prefixes[[lib]]
# #JGG   #
# #JGG   #   # determine stylesheet
# #JGG   #   if (is.null(prefix)) {
# #JGG   #     stop("Unknown font library '", lib, "' specified. Must be one of ",
# #JGG   #          paste0('"', names(prefixes), '"', collapse = ", "))
# #JGG   #   }
# #JGG   #
# #JGG   #   # build the icon class (allow name to be null so that other functions
# #JGG   #   # e.g. buildTabset can pass an explicit class value)
# #JGG   #   iconClass <- ""
# #JGG   #   if (!is.null(name)) {
# #JGG   #     prefix_class <- prefix
# #JGG   #     if (prefix_class == "fa" && name %in% font_awesome_brands) {
# #JGG   #       prefix_class <- "fab"
# #JGG   #     }
# #JGG   #     iconClass <- paste0(prefix_class, " ", prefix, "-", name)
# #JGG   #   }
# #JGG   #   if (!is.null(class))
# #JGG   #     iconClass <- paste(iconClass, class)
# #JGG   #
# #JGG   #   iconTag <- tags$i(class = iconClass)
# #JGG   #
# #JGG   #   # font-awesome needs an additional dependency (glyphicon is in bootstrap)
# #JGG   #   if (lib == "font-awesome") {
# #JGG   #     htmlDependencies(iconTag) <- htmlDependency(
# #JGG   #       "font-awesome", "5.3.1", "www/shared/fontawesome", package = "shiny",
# #JGG   #       stylesheet = c(
# #JGG   #         "css/all.min.css",
# #JGG   #         "css/v4-shims.min.css"
# #JGG   #       )
# #JGG   #     )
# #JGG   #   }
# #JGG   #
# #JGG   #   htmltools::browsable(iconTag)
# #JGG   # }
# #JGG
# #JGG   # Helper funtion to extract the class from an icon
# #JGG   iconClass <- function(icon) {
# #JGG     if (!is.null(icon)) icon$attribs$class
# #JGG   }
# #JGG
