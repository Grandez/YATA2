# Copiado de navbar
YATAPage =  function(title = NULL,id = NULL,
                       ...,
                       selected = NULL,
                       header = NULL,
                       footer = NULL,
                       leftSide = c("menu-right", "menu-left"),
                       rightSide = c("menu-left", "menu-right"),
                       fluid = TRUE,
                       theme = YATATheme(),
    collapsible = FALSE,
    responsive = NULL,
                       windowTitle = title,
    position = c("static-top", "fixed-top", "fixed-bottom")
                     #,tabs = NULL
                     ) {

markTabAsSelected <- function(x) {
  attr(x, "selected") <- TRUE
  x
}

findAndMarkSelectedTab = function (tabs, selected, foundSelected)
{
    tabs <- lapply(tabs, function(div) {
        if (foundSelected || is.character(div)) {
        }
        else if (inherits(div, "shiny.navbarmenu")) {
            res <- findAndMarkSelectedTab(div$tabs, selected,
                foundSelected)
            div$tabs <- res$tabs
            foundSelected <<- res$foundSelected
        }
        else {
            if (is.null(selected)) {
                foundSelected <<- TRUE
                div <- markTabAsSelected(div)
            }
            else {
                tabValue <- div$attribs$`data-value` %||%
                  div$attribs$title
                if (identical(selected, tabValue)) {
                  foundSelected <<- TRUE
                  div <- markTabAsSelected(div)
                }
            }
        }
        return(div)
    })
    return(list(tabs = tabs, foundSelected = foundSelected))
}
anyNamed = function (x) {
    if (length(x) == 0)
        return(FALSE)
    nms <- names(x)
    if (is.null(nms))
        return(FALSE)
    any(nzchar(nms))
}
withPrivateSeed = function (expr) {
    .globals = list() # No tenemos .globals
    if (exists(".Random.seed", envir = .GlobalEnv, inherits = FALSE)) {
        hasOrigSeed <- TRUE
        origSeed <- .GlobalEnv$.Random.seed
    }
    else {
        hasOrigSeed <- FALSE
    }

    if (is.null(.globals$ownSeed)) {
        if (hasOrigSeed) {
            rm(.Random.seed, envir = .GlobalEnv, inherits = FALSE)
        }
    }
    else {
        .GlobalEnv$.Random.seed <- .globals$ownSeed
    }
    on.exit({
        .globals$ownSeed <- .GlobalEnv$.Random.seed
        if (hasOrigSeed) {
            .GlobalEnv$.Random.seed <- origSeed
        } else {
            rm(.Random.seed, envir = .GlobalEnv, inherits = FALSE)
        }
        httpuv::getRNGState()
    })
    expr
}
randomInt <- function(min, max) {
  if (missing(max)) {
    max <- min
    min <- 0
  }
  if (min < 0 || max <= min)
    stop("Invalid min/max values")

  min + sample(max-min, 1)-1
}

p_randomInt = function (...)
{
    withPrivateSeed(randomInt(...))
}
isTabSelected <- function(x) {
  isTRUE(attr(x, "selected", exact = TRUE))
}

# Returns the icon object (or NULL if none), provided either a
# tabPanel, OR the icon class
getIcon <- function(tab = NULL, iconClass = NULL) {
  if (!is.null(tab)) iconClass <- tab$attribs$`data-icon-class`
  if (!is.null(iconClass)) {
    if (grepl("fa-", iconClass, fixed = TRUE)) {
      # for font-awesome we specify fixed-width
      iconClass <- paste(iconClass, "fa-fw")
    }
    icon(name = NULL, class = iconClass)
  } else NULL
}

# Builds tabPanel/navbarMenu items (this function used to be
# declared inside the buildTabset() function and it's been
# refactored for clarity and reusability). Called internally
# by buildTabset.
buildTabItem <- function(index, tabsetId, foundSelected, tabs = NULL,
                         divTag = NULL, textFilter = NULL) {

  divTag <- if (!is.null(divTag)) divTag else tabs[[index]]

  if (is.character(divTag) && !is.null(textFilter)) {
    # text item: pass it to the textFilter if it exists
    liTag <- textFilter(divTag)
    divTag <- NULL

  } else if (inherits(divTag, "shiny.navbarmenu")) {
    # navbarMenu item: build the child tabset
    tabset <- buildTabset(divTag$tabs, "dropdown-menu",
      navbarMenuTextFilter, foundSelected = foundSelected)

    # if this navbarMenu contains a selected item, mark it active
    containsSelected <- containsSelectedTab(divTag$tabs)
    liTag <- tags$li(
      class = paste0("dropdown", if (containsSelected) " active"),
      tags$a(href = "#",
        class = "dropdown-toggle", `data-toggle` = "dropdown",
        `data-value` = divTag$menuName,
        getIcon(iconClass = divTag$iconClass),
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

buildTabset = function (tabs, ulClass, textFilter = NULL, id = NULL, selected = NULL,
    foundSelected = FALSE)
{
    res <- findAndMarkSelectedTab(tabs, selected, foundSelected)
    tabs <- res$tabs
    foundSelected <- res$foundSelected
    if (!is.null(id))
        ulClass <- paste(ulClass, "shiny-tab-input")
    if (anyNamed(tabs)) {
        nms <- names(tabs)
        nms <- nms[nzchar(nms)]
        stop("Tabs should all be unnamed arguments, but some are named: ",
            paste(nms, collapse = ", "))
    }
    tabsetId <- p_randomInt(1000, 10000)
    tabs <- lapply(seq_len(length(tabs)), buildTabItem, tabsetId = tabsetId,
        foundSelected = foundSelected, tabs = tabs, textFilter = textFilter)
    tabNavList <- tags$ul(class = ulClass, id = id, `data-tabsetid` = tabsetId,
        lapply(tabs, "[[", 1))
    tabContent <- tags$div(class = "tab-content", `data-tabsetid` = tabsetId,
        lapply(tabs, "[[", 2))
    list(navList = tabNavList, content = tabContent)
}

    makeMessageHandler = function(name, funcName) {
       if (missing(funcName)) funcName = name
       scr = "Shiny.addCustomMessageHandler('yata"
       scr = paste0(scr, titleCase(name), "', function(data) {")
       scr = paste0(scr, YATAWEBDEF$jsapp, ".", funcName, "(data); })")
       scr
    }

  # alias title so we can avoid conflicts w/ title in withTags
  pageTitle <- title
  pageTitle <- "YATA - Sin conexion"

  # navbar class based on options
  navbarClass <- "navbar yata_navbar" # navbar-default
  position <- match.arg(position)
  if (!is.null(position))
    navbarClass <- paste(navbarClass, " navbar-", position, sep = "")

  if (!is.null(id))
    selected <- restoreInput(id = id, default = selected)

  # build the tabset Devuelve una lista con: navlist y content
  tabs <- list(...)

  #tabset <- shiny:::buildTabset(tabs, "nav navbar-nav yata_menu", NULL, id, selected)
  tabset = buildTabset(tabs, "nav navbar-nav yata_menu", NULL, id, selected)
  # function to return plain or fluid class name
  className <- function(name) {
    if (fluid)
      paste(name, "-fluid", sep="")
    else
      name
  }
    containerDiv <- div(class=className("container"),
      div(class="navbar-header",
        span(class="navbar-brand", textOutput("appTitle"))
      ),
      tabset$navList
    )

  # build the main tab content div
  contentDiv = shiny::tags$div(id="yataContent")
  mainDiv    = shiny::tags$div(id="yataContentMain")

  mainDiv    = tagAppendChild(mainDiv, tabset$content)
  contentDiv = tagAppendChildren(contentDiv, mainDiv)

  options = list(sidebarExpandOnHover = TRUE)

  divFooter = "YATA - Grandez"
  divHeader = .yataPageHeader(tabnav=tabset$navList)
  divMain   =  contentDiv
  page = tags$div( class="yata_page", divHeader
           ,tags$div(class="yata_main",   divMain)
           ,tags$div(class="yata_footer", divFooter)
  )

  mainFormErr = hidden(tags$div(id="yata_main_err", class="yata_panel_err"
                                ,tags$div(class="yata_panel_err_container"
                                ,tags$div( class="yata_clearfix",fluidRow(
                                           imageOutput("yata_main_img_err", inline=TRUE)
                                          ,tags$span(class="yata_text_err", textOutput("yata_main_text_err"))))))
  )

   container   = tags$div(id="yata_container", class="yata_container", page, shinyjs::hidden(mainFormErr))
   srcUpdLayout = paste0("function(id, tgt) { yataUpdateLayout(id, tgt);}")
   jsUpdLayout  = paste("shinyjs.yataUpdateLayout = ", srcUpdLayout)
   # srcUpdLayout = paste0("function(id, tgt) {", YATAWEBDEF$jsapp, ".", YATAMSG$updateLayout, "(id, tgt);}")
   # jsUpdLayout  = paste("shinyjs.yataUpdateLayout = ", srcUpdLayout)
   srcAddPage   = paste0("function(data) { ", YATAWEBDEF$jsapp, ".", YATAMSG$addPage, "(data); }")
   jsAddPage    = paste("shinyjs.yataAddPage =", srcAddPage)
   srcSetPage   = paste0("function(data) { ", YATAWEBDEF$jsapp, ".", YATAMSG$setPage, "(data); }")
   jsSetPage    = paste("shinyjs.yataSetPage =", srcSetPage)

   bspage =   shiny::bootstrapPage(
         useShinyjs()
        ,tags$head(
              tags$link  (rel="stylesheet", type="text/css", href="yata/yatabootstrap.css")
             ,tags$link  (rel="stylesheet", type="text/css", href="yata/yatabase2.css")
             ,tags$link  (rel="stylesheet", type="text/css", href="yata/yata_reactable.css")
             ,tags$link  (rel="stylesheet", type="text/css", href="yata/yata_adminlte.css")

             ,tags$script(src="yata/yataapp.js")
             ,tags$script(makeMessageHandler(YATAMSG$setPage))
             ,tags$script(makeMessageHandler(YATAMSG$showBlock))
             ,tags$script(makeMessageHandler(YATAMSG$movePanel))

             # ,tags$script("Shiny.addCustomMessageHandler('setPanel', function(data) { $.YATA.yataSetPanel(data); })")
             # ,tags$script("Shiny.addCustomMessageHandler('yataShowBlock', function(data) { $.YATA.showBlock(data); })")
             # ,tags$script("Shiny.addCustomMessageHandler('yataMovePanel', function(data) { $.YATA.movePanel(data); })")
             #X ,tags$script('Shiny.addCustomMessageHandler("closeLeftSide",
             #X               function(message) { $("[data-toggle=\'yataoffcanvas\']").trigger("click");});')
             ,initShinyCookie("YATA")
             ,extendShinyjs(text = jsUpdLayout, functions = c("yataUpdateLayout"))
             ,extendShinyjs(text = jsAddPage,   functions = c("yataAddPage"))
             ,extendShinyjs(text = jsSetPage,   functions = c("yataSetPage"))
        )
        ,container
        # ,tags$script('
        #                         var dimension = [0, 0];
        #                         $(document).on("shiny:connected", function(e) {
        #                             dimension[0] = window.innerWidth;
        #                             dimension[1] = window.innerHeight;
        #                             Shiny.onInputChange("dimension", dimension);
        #                         });
        #                         $(window).resize(function(e) {
        #                             dimension[0] = window.innerWidth;
        #                             dimension[1] = window.innerHeight;
        #                             Shiny.onInputChange("dimension", dimension);
        #                         });
        #                     ')
      ,theme = theme, lang=YATAWEBDEF$lang # ) # end boostrap page

   )

   yataDeps(shiny::tags$body(bspage),md = FALSE)

}

