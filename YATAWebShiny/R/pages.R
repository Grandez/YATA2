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
