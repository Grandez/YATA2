# Copiado de navbar
YATAPage <- function(title = NULL,id = NULL,
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

  # pageTitle = ifelse(is.null(title), "YATA!", title)
  # id = ifelse(is.null(id), "mainMenu", id)
  # navbarPage2(pageTitle, id=id, ...)
  # if (!missing(collapsable)) {
  #   shinyDeprecated("`collapsable` is deprecated; use `collapsible` instead.")
  #   collapsible <- collapsable
  # }

  # alias title so we can avoid conflicts w/ title in withTags
  pageTitle <- title
  pageTitle <- "YATA - Sin conexion"

  # navbar class based on options
  navbarClass <- "navbar yata-navbar" # navbar-default
  position <- match.arg(position)
  if (!is.null(position))
    navbarClass <- paste(navbarClass, " navbar-", position, sep = "")
  # if (inverse)
  #   navbarClass <- paste(navbarClass, "navbar-inverse")

  if (!is.null(id))
    selected <- restoreInput(id = id, default = selected)

  # build the tabset
  # Devuelve una lista con: navlist y content
  tabs <- list(...)

  tabset <- shiny:::buildTabset(tabs, "nav navbar-nav yata-menu", NULL, id, selected)

  # function to return plain or fluid class name
  className <- function(name) {
    if (fluid)
      paste(name, "-fluid", sep="")
    else
      name
  }

  # built the container div dynamically to support optional collapsibility
  # if (collapsible) {
  #   navId <- paste("navbar-collapse-", p_randomInt(1000, 10000), sep="")
  #   containerDiv <- div(class=className("container"),
  #     div(class="navbar-header",
  #       tags$button(type="button", class="navbar-toggle collapsed",
  #         `data-toggle`="collapse", `data-target`=paste0("#", navId),
  #         span(class="sr-only", "Toggle navigation"),
  #         span(class="icon-bar"),
  #         span(class="icon-bar"),
  #         span(class="icon-bar")
  #       ),
  #       #span(class="navbar-brand", pageTitle)
  #       span(class="navbar-brand", textOutput("appTitle"))
  #     ),
  #     div(class="navbar-collapse collapse yata-brand", id=navId, tabset$navList)
  #   )
  # } else {
    containerDiv <- div(class=className("container"),
      div(class="navbar-header",
        span(class="navbar-brand", textOutput("appTitle"))
      ),
      tabset$navList
    )
#  }

  # build the main tab content div
  contentDiv = shiny::tags$div(id="yataContent")
  # leftDiv    = shiny::tags$div(id="yataContentLeft")
  # rightDiv   = shiny::tags$div(id="yataContentRight")
  mainDiv    = shiny::tags$div(id="yataContentMain")

  mainDiv    = tagAppendChild(mainDiv, tabset$content)
  contentDiv = tagAppendChildren(contentDiv, mainDiv)

  options = list(sidebarExpandOnHover = TRUE)

  shinydashboardPlus:::addDeps(
    shiny::tags$body(
      shiny::bootstrapPage(
         useShinyjs()
        ,tags$head(
             tags$link  (rel="stylesheet", type="text/css", href="yata/yataoverride.css")
            ,tags$link  (rel="stylesheet", type="text/css", href="yata/yata2.css")
            ,tags$link  (rel="stylesheet", type="text/css", href="yata/yataDT.css")
            ,tags$link  (rel="stylesheet", type="text/css", href="yatadt.css")
            ,tags$script(src="yata/yata.js")
            ,tags$script(src="yata/yataapp.js")
            ,tags$script("Shiny.addCustomMessageHandler('setPanel', function(data) { $.YATA.yataSetPanel(data); })")
        )
        ,shiny::tags$div(id="yataHeader",
                  .yataPageHeader(tabnav=tabset$navList) #,tags$nav(class=navbarClass, role="navigation", containerDiv)
          )
        , contentDiv
#        ,shiny::tags$div(id="yataFooter", tags$span("YATA - Grandez"))
        ,shiny::tags$footer("YATA - Grandez")
      ,theme = theme, lang="es") # end boostrappage
    ),
    md = FALSE
  )
}
