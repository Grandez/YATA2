guiTitle = function(level, txt, ...) {
  data = sprintf(txt, ...)
  eval(parse(text=paste0("h", level, "(class='jgg_title_", level, "', '", data, "')")))
}

guiRow = function(id=NULL, style=NULL, class=NULL, ...) {
  tags$div(id=id,style=style,class=c("row", class),...)
}
guiColumn = function(width, ...) {
    if (!is.numeric(width) || (width < 1) || (width > 12)) stop("column width must be between 1 and 12")
    colClass <- paste0("col-xl-", width)
    tags$div(class = colClass, ...)
}

guiCombo = function( id, label=NULL, choices=NULL, selected = NULL) {
    lbl = NULL
    choice = c("")
    if (!is.null(label))   lbl    = label
    if (!is.null(choices)) choice = choices
    shiny::selectInput(id, lbl, choice, selected=selected,width="auto", selectize=FALSE)
}
guiComboSelect = function( id, label=NULL, choices=NULL, text=NULL, selected = NULL) {
    lbl = NULL
    choice = c("")
    if (!is.null(label))   lbl    = label
    if (!is.null(choices)) choice = choices
    shiny::selectizeInput(id,lbl,choice,selected=selected,
                   options = list( placeholder = text
                                  ,onInitialize = I('function() { this.setValue(""); }')
                            ))
}
updCombo = function(id, choices=NULL, selected=NULL, session = getDefaultReactiveDomain()) {
    shiny::updateSelectInput(session=session, inputId=id, choices = choices, selected = selected)
}
guiListBox = function( id, label=NULL, choices=NULL, size=10, ...) {
    lbl = NULL
    choice = c("")
    if (!is.null(label))   lbl    = label
    if (!is.null(choices)) choice = choices
    selectInput(id,lbl,choice, size=size, selectize=FALSE,...)
}

updListBox = function(id, choices, selected=NULL, session=getDefaultReactiveDomain()) {
    updateSelectInput(session, id, choices = choices, selected = selected)
}
guiNumericInput = function(id, label=NULL, value=0, step, min, max) {
  st = NA ; if (!missing(step)) st=step
  mn = NA ; if (!missing(min))  mn=min
  ma = NA ; if (!missing(max))  ma=max
  widget = shiny::numericInput(id, label = label, value = value, mn, ma,st, width="auto")
  widget[[3]][[2]]$attribs$class = "form-control yata_number"
  widget
}
updNumericInput = function(id, value, session=getDefaultReactiveDomain()) {
  shiny::updateNumericInput(session, id, value = value)
}

guiIntegerInput = function(id, label=NULL, value=0, step, min, max) {
  st = NA ; if (!missing(step)) st=step
  mn = NA ; if (!missing(min))  mn=min
  ma = NA ; if (!missing(max))  ma=max
  widget = shiny::numericInput(id, label = label, value = value, mn, ma,st)
  widget[[3]][[2]]$attribs$class = "form-control yata-number"
  widget
}
updIntegerInput = function(id, value, session=getDefaultReactiveDomain()) {
  shiny::updateNumericInput(session, id, value = value)
}

guiTextArea = function (inputId, label=NULL, value = "", width = NULL, height = NULL,
    cols = NULL, rows = NULL, placeholder = NULL, resize = NULL) {
    value <- restoreInput(id = inputId, default = value)
    if (!is.null(resize)) {
        resize <- match.arg(resize, c("both", "none", "vertical",
            "horizontal"))
    }
    style <- paste("max-width: 100%;", if (!is.null(width))
        paste0("width: ", validateCssUnit(width), ";"), if (!is.null(height))
        paste0("height: ", validateCssUnit(height), ";"), if (!is.null(resize))
        paste0("resize: ", resize, ";"))
    if (length(style) == 0) style = NULL
    div(class = "form-group",
        tags$label(label, `for` = inputId), tags$textarea(id = inputId,
        class = "form-control", placeholder = placeholder, style = style,
        rows = rows, cols = cols, value))
}
updTextArea = function(id, text, label=NULL, session=getDefaultReactiveDomain()) {
  updateTextAreaInput(session, id, label=label, value=text)
}

# Cambiamos selectInput para añadir la clase yata_layout
guiLayoutSelect = function (inputId, choices, selected = NULL, full=TRUE) {
   cls = "form-control"
   if (full) cls = paste(cls, "jgg_layout")
   else      cls = paste(cls, "jgg_layout_notify")

   selected = restoreInput(id = inputId, default = selected)
   choices = shiny:::choicesWithNames(choices)
   if (is.null(selected)) selected = shiny:::firstChoice(choices)
   else                   selected = as.character(selected)

   selectTag <- tags$select( id = inputId, class = cls, size = NULL
                            ,shiny:::selectOptions(choices, selected, inputId, FALSE))
   div( class = "form-group shiny-input-container"
       ,style = css(width = validateCssUnit("auto"))
       ,shiny:::shinyInputLabel(inputId, NULL), div(selectTag))
}
