parseShinyJS = function() {
    # Obtiene la extensiones a shiny
    #JGg jsfile = system.file("extdata/www/yatashiny_shiny.js", package=packageName())

    lines = readLines("www/jggshiny_shiny.js")
    resp = regexpr("[ ]*shinyjs\\.[a-zA-Z0-9_-]+[ ]*=", lines)
    lens = attr(resp, "match.length")
    res = lapply(which(resp != -1), function(idx) {
        txt = substr(lines[idx], resp[idx], lens[idx] - 1)
        substr(trimws(txt), 9, nchar(txt))
    })
    unlist(res)
}

custom_css = function(cssFiles) {
    # Take care for order: bootstrap, shiny. sass, css, theme
    base = tagList(
         tags$link  (rel="stylesheet", type="text/css", href="jgg_bootstrap.css")
        ,tags$link  (rel="stylesheet", type="text/css", href="jgg_shiny.css")
        ,tags$link  (rel="stylesheet", type="text/css", href="jgg_sass.css")
        ,tags$link  (rel="stylesheet", type="text/css", href="jgg_theme.css")
        ,tags$link  (rel="stylesheet", type="text/css", href="jgg_css.css")
    )
    cssLink = NULL
    if (!is.null(cssFiles)) {
        cssLink = lapply(cssFiles, function (css)
                                   tags$link(rel="stylesheet",type="text/css",href=css))
    }
    tagList(base, cssLink)
}
custom_js = function(jsFiles) {
    base = tagList( tags$script(src='js_cookie.js')
                   ,tags$script(src='jggshiny.js')
                   ,tags$script(src='jggshiny_shiny.js')
                   )
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
    code = paste0(code, "   globalThis.jggshiny = new JGGShiny('", id, "');  \n")
    code = paste0(code, "   globalThis.jggshiny.init('", title, "','", id, "');   \n")
    # if (!is.null(jsInit)) {
    #     for (js in jsInit) code = paste(code, js, sep="\n")
    # }
    code = paste0(code, "\n});\n")
    tags$script(code)
}


