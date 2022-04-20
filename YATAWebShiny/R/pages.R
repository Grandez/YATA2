JGGDashboard = function( id = NULL
                        ,title       = NULL,  theme    = bs_theme()
                        ,paths       = NULL,  cssFiles = NULL,jsFiles  = NULL,jsInit   = NULL
                        ,titleActive = FALSE, lang     = NULL, ...) {
    pathShiny = normalizePath(system.file("extdata/www", package = "YATAWebShiny"))
    shiny::addResourcePath("jggshiny", pathShiny)
   if (!is.null(paths)) {
       lapply(names(paths), function(path) shiny::addResourcePath(path, paths[[path]]))
   }

#    page  = bslib_navs_bar_full(webtitle = title, titleActive = titleActive, id = id, ... )
# bslib_navs_bar_full = function (webtitle, titleActive, id, ...) {
    # Tiene Panel derecho y panel izquiero
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

    page = make_container_full(nav, tabset$content, titleActive)
#}

   heads = tags$head( extendShinyjs(script="jggshiny/jggshiny_shiny.js", functions=parseShinyJS())
                     ,custom_css(cssFiles), custom_js(jsFiles)
                     ,document_ready_script(jsInit, title, id))

   bspage = dashboard_bslib_page(title=title,theme=theme,lang=lang,shinyjs::useShinyjs(),heads,page)
   addDeps(shiny::tags$body(bspage))
}

JGGTabsetPanel = function (..., id = NULL, selected = NULL) {
#    shiny::tabsetPanel(..., id=id,selected=selected,type="tabs")
# function (..., id = NULL, selected = NULL, type = c("tabs",
#     "pills", "hidden"), header = NULL, footer = NULL)
#{

#    func <- switch(match.arg(type), tabs = bslib::navs_tab, pills = bslib::navs_pill,
#        func <- switch(match.arg(type), tabs = bslib::navs_tab, pills = bslib::navs_pill,
#        hidden = bslib::navs_hidden)
browser()
    data = bslib::navs_tab(..., id = id, selected = selected,
        header = NULL, footer = NULL)
    data$attribs$class = c(data$attribs$class, "jgg_navbar")
    # remove_first_class(func(..., id = id, selected = selected,
    #     header = header, footer = footer))
data
}
JGGTab = function(id, title=id, ...) {
    bslib::nav(title, ..., value=id, icon=NULL)
}
