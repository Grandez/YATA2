yataForm = function() {

}
yuiFormUI = function(id, uiName, title=NULL, ...) {
    # Quitar el que exista
    #volver  a crear
    shinyjs::show("form-panel")
    if (!is.null(title)) {
        yataBoxClosable(id,title, eval(parse(text=paste0("frm", uiName, "Input('", id, "', ...)"))))
    }
    else {
        eval(parse(text=paste0("frm", uiName, "Input('", id, "', ...)")))
    }
}

YATAFormServer = function(id, modName, input, output, session, ...) {
    eval(parse(text=paste0("frm", modName, "Server('", id, "', input, output, session, ...)")))
}

YATAFormClose = function() {
    shinyjs::hide("form-panel")
}
