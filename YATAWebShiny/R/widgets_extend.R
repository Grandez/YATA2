# Widgets from shinyWidgets
guiCheck = function(id, value=TRUE) {
  shinyWidgets::awesomeCheckbox(id, NULL, value = value)
}
guiRadio = function(id, label=NULL, choices, selected=NULL, inline=TRUE, tooltip=NULL) {
   wdg = shinyWidgets::awesomeRadio(id,label,choices,selected,inline = inline,checkbox = TRUE)
   if (!is.null(tooltip)) {
       tagList(wdg, tooltip(id, tooltip))
   } else {
       wdg
   }
}
updRadio = function(id, selected=NULL) {
   shinyWidgets::updateAwesomeRadio(getDefaultReactiveDomain(), id, selected=selected)
}
guiYesNo = function(id=ns("tag"), lblOK, lblKO, left = 0, width = 12) {
    # el tag es para crear el nombre completo
    toks = strsplit(id, "-")[[1]]
    prfx = toks[length(toks) - 2]
    toks = paste(toks[1:(length(toks)- 1)], collapse="-")
    if (missing(lblOK)) lblOK = "OK"
    if (missing(lblKO)) lblKO = "KO"
    divMsg = tags$div(class="row",tags$div( id=paste0(toks, "-", "msg")
                                           ,tags$span(id=paste0(toks, "-", "msg"), "")))

    divBtns = tags$div(class="row yata_buttons"
                      ,tags$div(yuiBtnOK(paste0(toks, "-", "btnOK"), lblOK))
                      ,tags$div(yuiBtnKO(paste0(toks, "-", "btnKO"), lblKO))
              )

    if (left > 0) {
      tagList( fluidRow(yuiColumn(left), guiColumn(width, divMsg))
              ,fluidRow(yuiColumn(left), guiColumn(width, divBtns)))
    } else {
      tagList( tags$div(class="container-fluid", divMsg)
              ,tags$div(class="container-fluid", divBtns))
    }
}
guiButtons = function(...) { tags$div(class="yata_flex_row", ...) }


