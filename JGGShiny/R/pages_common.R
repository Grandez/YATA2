custom_css = function(cssFiles) {
    base = tagList(
         tags$link  (rel="stylesheet", type="text/css", href="jggshiny/jggshiny.css")
        ,tags$link  (rel="stylesheet", type="text/css", href="jggshiny/template.css")
        ,tags$link  (rel="stylesheet", type="text/css", href="jggshiny/skin_bootstrap_default.css")
        ,tags$link  (rel="stylesheet", type="text/css", href="jggshiny/jgg_dashboard.css")
        ,tags$link  (rel="stylesheet", type="text/css", href="jggshiny/jgg_reactable.css")
        ,tags$link  (rel="stylesheet", type="text/css", href="jggshiny/skin_default.css")
    )
    cssLink = NULL
    if (!is.null(cssFiles)) {
        cssLink = lapply(cssFiles, function (css)
                                   tags$link(rel="stylesheet",type="text/css",href=css))
    }
    tagList(base, cssLink)
}
custom_js = function(jsFiles) {
    base = tagList( tags$script(src='jggshiny/jggapp.js')
                   ,tags$script(src='jggshiny/js_cookie.js'))
    jsLink = NULL
    if (is.null(jsFiles)) return (tagList(base))
    if (!is.null(jsFiles$shiny)) {
        extendShinyjs(script=jsFiles$shiny$script, functions=jsFiles$shiny$functions)
    }
    jsLink = lapply(jsFiles$js, function (js) tags$script(src=js))
    tagList(base, jsLink)
}
document_ready_script = function(jsInit, title, id) {
    # This is the javascript to execute on document ready
    code = paste( " jQuery(document).ready(function() {\n")
    code = paste0(code, "   globalThis.jggshiny = new JGGShiny('YATA');  \n")
    code = paste0(code, "    jggshiny.init('", title, "','", id, "');   \n")
    if (!is.null(jsInit)) {
        for (js in jsInit) code = paste(code, js, sep="\n")
    }
    code = paste0(code, "\n});\n")
    tags$script(code)
}


