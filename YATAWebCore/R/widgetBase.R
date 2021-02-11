############################
#### Shiny
###########################
yuiTextInput = function(id, label=NULL, value="") {
  textInput(inputId=id, label=label, value = value, width = NULL, placeholder = NULL)
}
yuiLabelText = function(id, label=NULL, value="") {
  textOutput(outputId=id, inline=TRUE)
}
# yuiLabelText = function(id, label=NULL, inline=TRUE) {
#   htmlOutput(outputId=id, inline=TRUE, class="yataTextRight")
# }
yuiLabelNumber = function(id, label=NULL, inline=TRUE) {
  htmlOutput(outputId=id, inline=TRUE, class="yataTextRight")
}
yuiLabelInteger = function(id, label=NULL, inline=TRUE) {
  htmlOutput(outputId=id, inline=TRUE, class="yataTextRight")
}

yuiLabelDate = function(id, label=NULL, inline=TRUE) {
  if (!is.null(label)) {
      if (!inline) {
          tags$div( class="form-group shiny-input-container"
                   ,tags$label(class="control-label", label)
                   ,htmlOutput(outputId=id, inline=TRUE)
          )
      } else {
        tags$div( tags$label(class="control-label", label)
                 ,htmlOtput(outputId=id, inline=TRUE))
      }
  }
  else {
     textOutput(outputId=id, inline=TRUE)
  }
}
updLabelDate = function(epoch) {
  if (missing(epoch)) epoch=as.numeric(Sys.time())

  renderText({txt = format(as.POSIXct(epoch, origin="1970-01-01"),"%H:%M:%S")
              HTML(paste0("<span style=\"text-align: right;\">", txt, "</span>"))
  })
}

yuiNumericInput = function(id, label=NULL, value=0, step, min, max) {
  st = NA ; if (!missing(step)) st=step
  mn = NA ; if (!missing(min))  mn=min
  ma = NA ; if (!missing(max))  ma=max
  numericInput(id, label = label, value = value, mn, ma,st)
}
updNumericInput = function(id, value, session=getDefaultReactiveDomain()) {
  updateNumericInput(session, id, value = value)
}

yuiIntegerInput = function(id, label=NULL, value=0, step, min, max) {
  st = NA ; if (!missing(step)) st=step
  mn = NA ; if (!missing(min))  mn=min
  ma = NA ; if (!missing(max))  ma=max
  numericInput(id, label = label, value = value, mn, ma,st)
}
updIntegerInput = function(id, value, session=getDefaultReactiveDomain()) {
  updateNumericInput(session, id, value = value)
}

yuiCombo = function( id, label=NULL, choices=NULL, selected = NULL) {
    lbl = NULL
    choice = c("")
    if (!is.null(label))   lbl    = label
    if (!is.null(choices)) choice = choices
    selectInput(id, lbl, choice, selected)
}
updCombo = function(id, lbl=NULL, choices=NULL, selected=NULL, session = getDefaultReactiveDomain()) {
    updateSelectInput(session=session, inputId=id,label=lbl,choices = choices, selected = selected)
}

yuiComboSelect = function( id, label=NULL, choices=NULL, text=NULL, selected = NULL) {
    lbl = NULL
    choice = c("")
    if (!is.null(label))   lbl    = label
    if (!is.null(choices)) choice = choices
    selectizeInput(id,lbl,choice,
                   options = list( placeholder = text
                                  ,onInitialize = I('function() { this.setValue(""); }')
                            ))
}
yuiSwitch = function(id, value=FALSE) {
    switchInput( inputId = id
                ,onLabel = "Yes" ,offLabel = "No"
                ,onStatus = "success" ,offStatus = "danger"
                , value = value)
}
yuiListBox = function( id, label=NULL, choices=NULL, size=10, ...) {
#                                values
#  selectInput('in3', 'Options', state.name, multiple=TRUE, selectize=FALSE, size=10)
    lbl = NULL
    choice = c("")
    if (!is.null(label))   lbl    = label
    if (!is.null(choices)) choice = choices
    selectInput(id,lbl,choice, size, selectize=FALSE,...)
}

# Copiadode TextArea
yuiArea = function (inputId, label=NULL, value = "", width = NULL, height = NULL,
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
    if (length(style) == 0)
        style <- NULL
    div(class = "form-group",
        tags$label(label, `for` = inputId), tags$textarea(id = inputId,
        class = "form-control", placeholder = placeholder, style = style,
        rows = rows, cols = cols, value))
}
