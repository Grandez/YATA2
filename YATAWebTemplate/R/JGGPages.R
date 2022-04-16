JGGDashboard = function( id       = NULL
                              ,...
                                  ,title    = NULL
                              ,theme    = bs_theme()
                              ,paths    = NULL
                              ,cssFiles = NULL
                              ,jsFiles  = NULL
                              ,jsInit   = NULL
                              ,titleActive = FALSE
                              ,lang    = NULL

) {

#JGG    pathShiny = normalizePath(system.file("extdata/www", package = packageName()))
#JGG    shiny::addResourcePath("yatashiny", "www/yata")
browser()
    if (!is.null(paths)) {
        lapply(names(paths), function(path) shiny::addResourcePath(path, paths[[path]]))
    }
    page = yata_bslib_navs_bar_full(webtitle = title, titleActive = titleActive, id = id, ... )

    heads = tags$head(
               extendShinyjs(script="yatashiny_shiny.js", functions=parseYATAShinyJS())
               ,custom_css(cssFiles)
              ,custom_js(jsFiles)
              ,document_ready_script(jsInit, title, id)
            )

    bspage = yata_dashboard_bslib_page( title = title, theme = theme, lang = lang
                                      ,shinyjs::useShinyjs()
                                      ,heads
                                      ,page
              )
    bspage
   addDeps(shiny::tags$body(bspage))
}
yata_dashboard_bslib_page = function(..., title = NULL, theme = bs_theme(), lang = NULL) {
   data = shiny::bootstrapPage(..., title = title, theme = theme, lang = lang)
   class(data) <- c("bslib_page", class(data))  # bslib_as_page
   data
}

