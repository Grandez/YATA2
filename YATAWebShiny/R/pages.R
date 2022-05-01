.JGGDashboard = function(...) {
   args = list(...)
   tabs = args[names(args) == ""]
#   tabs[[1]] = NULL  # Primer argumento es el titulo

   tabset = bslib_navbarPage(args$id, tabs)
   pathShiny = normalizePath(system.file("extdata/www", package = "YATAWebShiny"))
   shiny::addResourcePath("jggshiny", pathShiny)

   if (!is.null(args$paths)) {
       lapply(names(args$paths), function(path) shiny::addResourcePath(path, args$paths[[path]]))
   }

   divNav = div(class = "container-fluid", tabset$navList)

   classNav = "navbar jgg_navbar"
   nav = tags$nav(class = classNav, role = "navigation", divNav)

   page = make_container_full(nav, tabset$content, args$title, args$titleActive)

   heads = tags$head( extendShinyjs(script="jggshiny/jggshiny_shiny.js", functions=parseShinyJS())
                     ,custom_css(args$cssFiles), custom_js(args$jsFiles)
                     ,document_ready_script(args$jsInit, args$title, args$id)
   )

   bspage = dashboard_bslib_page(title=args$title,theme=args$theme,lang=args$lang,shinyjs::useShinyjs(),heads,page)
   addDeps(shiny::tags$body(bspage))
}
JGGDashboard = function( title, id = title,  ...
                        ,theme       = bs_theme()
                        ,paths       = NULL,  cssFiles = NULL,jsFiles  = NULL,jsInit   = NULL
                        ,titleActive = FALSE, lang     = NULL) {
    # Hay un problema con ... no lo ejecuta
    # Pasamos todo a una funcion privada para hacer list(...)
    .JGGDashboard(id = id,title=title,theme=theme,paths=paths, cssFiles=cssFiles,jsFiles=jsFiles,jsInit=jsInit
                        ,titleActive=titleActive,lang=lang,...)
}


# parseShinyJS = function() {
#     jsfile = system.file("extdata/www/yata/yatashiny.js", package=packageName())
#     lines = readLines(jsfile)
#     resp = regexpr("^shinyjs\\.[a-zA-Z0-9_-]+[ ]*=", lines)
#     lens = attr(resp, "match.length")
#     res = lapply(which(resp != -1), function(idx) {
#         txt = substr(lines[idx], resp[idx], lens[idx] - 1)
#         substr(trimws(txt), 9, nchar(txt))
#     })
#     unlist(res)
# }

JGGDashboardRaw = function( id = NULL
                        ,title       = NULL,  theme    = bs_theme()
                        ,paths       = NULL,  cssFiles = NULL,jsFiles  = NULL,jsInit   = NULL
                        ,titleActive = FALSE, lang     = NULL, ...) {
    webtitle=NULL

    tabset = bslib_navbarPage(id, ...)

    divNav = div(class = "container-fluid"
                       # ,div(class = "navbar-header"
                       #      ,span(class = "navbar-brand", webtitle)
                       #  )
                        ,tabset$navList)

    classNav = "navbar jgg_navbar"
    nav = tags$nav(class = classNav, role = "navigation", divNav)

    # content = div(class = containerClass)
    # content = tagAppendChild(content, tabset$content)

    make_container(nav, tabset$content, titleActive)

}
JGGLoader = function(title,  id="loader"
                       ,theme    = theme
                       ,paths    = paths
                       ,cssFiles = customCSS
                       ,jsFiles  = customJS
                       ,jsInit   = jsInit
                       ,titleActive = TRUE
                       ,lang    = NULL
                       ,background = NULL
                       ,...) {

# JGGLoader = function( title, id=NULL, ...
#                      ,paths=NULL,  cssFiles = NULL,jsFiles  = NULL,jsInit   = NULL
#                      ,background=NULL) {
    pathShiny = normalizePath(system.file("extdata/www", package = "YATAWebShiny"))
    shiny::addResourcePath("jggshiny", pathShiny)
   if (!is.null(paths)) {
       lapply(names(paths), function(path) shiny::addResourcePath(path, paths[[path]]))
   }

#    page  = bslib_navs_bar_full(webtitle = title, titleActive = titleActive, id = id, ... )
# bslib_navs_bar_full = function (webtitle, titleActive, id, ...) {
    # Tiene Panel derecho y panel izquiero
    webtitle=NULL

#    tabset = bslib_navbarPage(id, ...)

    divNav = div(class = "container-fluid"
                       # ,div(class = "navbar-header"
                       #      ,span(class = "navbar-brand", webtitle)
                       #  )
                        ) # ,tabset$navList)

    classNav = "navbar jgg_navbar"
    nav = tags$nav(class = classNav, role = "navigation", divNav)

    # content = div(class = containerClass)
    # content = tagAppendChild(content, tabset$content)

    page = make_container_loader(nav, ...)
#}
cssback = ""
if (!is.null(background)) {
    cssback = paste0("background-image: url('", background, "');")
    cssback = paste(cssback, "background-repeat: no-repeat;")
    cssback = paste(cssback, "background-attachment: fixed;")
    cssback = paste(cssback, "background-size: 100% 100%;")
}
sty = tags$style(HTML(paste(".jgg_page_loader {", cssback, "}")))


   heads = tags$head( sty
#                     ,extendShinyjs(script="jggshiny/jggshiny_shiny.js")
#                     ,functions=parseShinyJS())
                     ,custom_css(cssFiles)
                     # ,custom_js(jsFiles)
                     # ,document_ready_script(jsInit, title, id)
       )

#   bspage = dashboard_bslib_page(title=title,theme=theme,lang=lang,shinyjs::useShinyjs(),heads,page)
   addDeps(shiny::tags$body(heads, page))
}






make_container_loader = function (nav, ...) {
   contentDiv = shiny::tags$div(id="jgg_page")
   divHeader  = shiny::tags$header()
   divBody    = shiny::tags$div(id="jgg_body",   class="jgg_body"   )
   divFooter  = shiny::tags$footer()
   divHeader  = make_loader_header(divHeader, nav, FALSE)

   divMain  = shiny::tags$div(id="jgg_page_main",  class="jgg_page_main"  )
   # divLeft  = shiny::tags$div( id="jgg_page_left"
   #                            ,class="w-25 h-100 jgg_page_left jgg_side_hide"  )
   #
   # divRight = shiny::tags$div( id="jgg_page_right"
   #                            ,class="w-25 h-100 jgg_page_right jgg_side_hide" )

   divFooter = tagAppendChild(divFooter, tags$span("Grandez"))

  #  children = content$children
  #  children = children[[1]]$children
  #  pages = content$children
  #  for (idx in 1:length(pages)) {
  #      page = pages[[idx]]$children[[1]] # Aqui son 5
  #      if (!is.null(page$left))  divLeft  = tagAppendChild(divLeft,  page$left)
  #      if (!is.null(page$right)) divRight = tagAppendChild(divRight, page$right)
  #      page$left  = NULL
  #      page$right = NULL
  #      divMain    = tagAppendChild(divMain, page)
  #  }

  # contentDiv <- div(class = containerClass)
  # if (!is.null(header))
  #   contentDiv <- tagAppendChild(contentDiv, div(class = "row", header))
  # contentDiv <- tagAppendChild(contentDiv, tabset$content)
  # if (!is.null(footer))
  #   contentDiv <- tagAppendChild(contentDiv, div(class = "row", footer))

   divBody   = tagAppendChildren(divBody, ...) # divLeft, divMain, divRight)
   page = tags$div(id="jgg_page_loader", class="jgg_page jgg_page_loader", divHeader, divBody, divFooter)
   tags$div(id="jgg_container", class="jgg_container", page) # , .mainFormError())
}
make_loader_header <- function(parent, nav, titleActive = FALSE, titleWidth = NULL,
                            disable = FALSE, .list = NULL,
                            controlbarIcon = shiny::icon("chevron-left"), fixed = FALSE) {
    # Hacemos 3 columnas
    # Titulo y iconos de abrr cerrar
    # Menu principal
    # Iconos de la barra derecha

    # button_left = shiny::tags$a( href = "#", id="jgg_left_side"
    #     ,class = "jgg_sidebar_toggle"
    #     ,role  = "button"
    #     ,`data-toggle` = "jgg_left_button" # javascript
    #     ,shiny::tags$span( id="jgg_left_side_open"
    #            ,shiny::icon( "chevron-right" ,"fa-lg"
    #                         ,style="padding-top: 12px")
    #           )
    #           ,shiny::tags$span( id="jgg_left_side_close"
    #                             ,class="jgg_button_side_hide"
    #                             ,shiny::icon( "chevron-left" ,"fa-lg"
    #                             ,style= "padding-top: 12px")
    #            )
    # )
    # button_right = shiny::tags$a( href = "#", id="jgg_right_side"
    #     ,class = "jgg_sidebar_toggle"
    #     ,role  = "button"
    #     ,`data-toggle` = "jgg_right_button" # javascript
    #     ,shiny::tags$span( id="jgg_right_side_open"
    #                       ,shiny::icon( "cog" ,"fa-lg"
    #                       ,style="padding-top: 12px"))
    #     ,shiny::tags$span( id="jgg_right_side_close"
    #                       ,class="jgg_button_side_hide"
    #                       ,shiny::icon( "chevron-right" ,"fa-lg"
    #                       ,style= "padding-top: 12px"))
    # )

    divBrand = tags$div(id="jgg_brand", class="col-lg-1")
    span = shiny::tags$span( class="navbar-brand jgg_brand")
    span     = tagAppendChild(span, textOutput("appTitle", inline=TRUE))
    divBrand = tagAppendChildren(divBrand, span)

    divNav = tags$div(id="jgg_nav_bar", class="navbar jgg_nav_left col-lg-10", nav)

    tagAppendChildren(parent, divBrand, divNav)
}
makeMessageHandler = function(name, funcName) {
   if (missing(funcName)) funcName = name
   scr = "Shiny.addCustomMessageHandler('yata"
   scr = paste0(scr, YATABase$str$titleCase(name), "', function(data) {")
   scr = paste0(scr, YATAWEBDEF$jsapp, ".", funcName, "(data); })")
   scr
}
