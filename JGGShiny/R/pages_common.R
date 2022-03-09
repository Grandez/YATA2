custom_css = function(cssFiles) {
    base = tagList(
         tags$link  (rel="stylesheet", type="text/css", href="jggshiny/jggshiny.css")
        ,tags$link  (rel="stylesheet", type="text/css", href="jggshiny/template.css")
    )
    cssLink = NULL
    if (!is.null(cssFiles)) {
        cssLink = lapply(cssFiles, function (css)
                                   tags$link(rel="stylesheet",type="text/css",href=css))
    }
    tagList(base, cssLink)
}
custom_js = function(jsFiles) {
    base = tags$script(src='jggshiny/jggapp.js')
    jsLink = NULL
    if (!is.null(jsFiles)) {
         jsLink = lapply(jsFiles, function (js) tags$script(src=js))
    }
    tagList(base, jsLink)
}
document_ready_script = function(jsInit, title) {
    # This is the javascript to execute on document ready
    code = "jQuery(document).ready(function() {\n"
    #code = paste0(code, "alert('Iniciado documento');\n")
    code = paste(code, "   $.jggshiny.init('", title, "');\n")
    if (!is.null(jsInit)) {
        for (js in jsInit) {
             txt = paste0("   $.", js, ".init();")
             code = paste(code, txt, sep="\n")
        }
    }
    code = paste0(code, "\n});\n")
    tags$script(code)
}


