############################
#### Shiny
###########################

yuiTitle1 = function(txt) { h1(class="yata-title-1", txt) }
yuiTitle2 = function(txt) { h2(class="yata-title-2", txt) }
yuiTitle3 = function(txt) { h3(class="yata-title-3", txt) }
yuiTitle4 = function(txt) { h4(class="yata-title-4", txt) }
yuiTitle5 = function(txt) { h5(class="yata-title-5", txt) }

yuiMessage = function(id) {
  htmlOutput(outputId=id, inline=TRUE)
}
# .updLabelNumber = function(value, text,bold,color) {
#   cls = "yata_num"
#   if (bold) cls = paste(cls, "yata_num_bold")
#   if (color) {
#      col = if(value > 0) cls = paste(cls, "yata_num_pos")
#      col = if(value < 0) cls = paste(cls, "yata_num_neg")
#   }
#   lbl = paste0("<span class='", cls, "'>",text,"</span>")
#   renderUI({HTML(lbl)})
# }

updMessageReset = function(txt) {

}

updMessage = function(txt) {
  lbl = paste0("<span class='", cls, "'>",text,"</span>")
  renderUI({HTML(lbl)})

}
.updMessage = function(id, txt, class) {
  idm = paste0(id, "-msg_dat")
  shiny::removeUI(paste0("#", idm), immediate=TRUE)
  dat = tags$span(id=idm, class = class, txt)
  shiny::insertUI(paste0("#", id, "-msg"),where="afterBegin",immediate=TRUE,ui=dat)

}
updMessageOK      = function(id, txt) { .updMessage(id, txt, "yata_msg_success") }
updMessageKO      = function(id, txt) { .updMessage(id, txt, "yata_msg_error")   }
updMessageWarning = function(id, txt) { .updMessage(id, txt, "yata_msg_warning") }

yuiTextInput = function(id, label=NULL, value="") {
  textInput(inputId=id, label=label, value = value, width = NULL, placeholder = NULL)
}
yuiLabelText = function(id, label=NULL, value="") {
  textOutput(outputId=id, inline=TRUE)
}
updLabelText = function(txt) {
  renderText({ txt })
}
# yuiLabelText = function(id, label=NULL, inline=TRUE) {
#   htmlOutput(outputId=id, inline=TRUE, class="yataTextRight")
# }
yuiLabelNumber = function(id, label=NULL, inline=TRUE) {
  htmlOutput(outputId=id, inline=TRUE, class="yataTextRight")
}

yuiLabelNumeric = function(id, label=NULL, inline=TRUE) {
  htmlOutput(outputId=id, inline=TRUE, class="yataTextRight")
}
updLabelNumber   = function(value, dec=-1, bold=TRUE, color=FALSE) {
  text = format(value, big.mark = ".", decimal.mark=",")
  if (dec > -1) text = format(value, big.mark = ".", decimal.mark=",", nsmall=dec)
  .updLabelNumber(value, text, bold, color)
}
yuiLabelInteger = function(id, label=NULL, inline=TRUE) {
  htmlOutput(outputId=id, inline=TRUE, class="yataTextRight")
}
updLabelInteger   = function(value, bold=TRUE, color=FALSE) {
  text = format(round(value), big.mark = ".", decimal.mark=",")
  .updLabelNumber(value, text, bold, color)
}
yuiLabelPercentage = function(id, label=NULL, inline=TRUE) {
  htmlOutput(outputId=id, inline=TRUE, class="yataTextRight")
}

updLabelPercentage   = function(value, bold=TRUE, color=FALSE) {
  text = format(value, big.mark = ".", decimal.mark=",", nsmall=2)
  .updLabelNumber(value, text, bold, color)
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
  widget = numericInput(id, label = label, value = value, mn, ma,st)
  widget[[3]][[2]]$attribs$class = "form-control yata-number"
  widget
}
updNumericInput = function(id, value, session=getDefaultReactiveDomain()) {
  updateNumericInput(session, id, value = value)
}

yuiIntegerInput = function(id, label=NULL, value=0, step, min, max) {
  st = NA ; if (!missing(step)) st=step
  mn = NA ; if (!missing(min))  mn=min
  ma = NA ; if (!missing(max))  ma=max
  widget = numericInput(id, label = label, value = value, mn, ma,st)
  widget[[3]][[2]]$attribs$class = "form-control yata-number"
  widget
}
updIntegerInput = function(id, value, session=getDefaultReactiveDomain()) {
  updateNumericInput(session, id, value = value)
}

yuiCombo = function( id, label=NULL, choices=NULL, selected = NULL) {
    lbl = NULL
    choice = c("")
    if (!is.null(label))   lbl    = label
    if (!is.null(choices)) choice = choices
    selectInput(id, lbl, choice, selected,selectize=FALSE)
}
updCombo = function(id, choices=NULL, selected=NULL, session = getDefaultReactiveDomain()) {
    updateSelectInput(session=session, inputId=id, choices = choices, selected = selected)
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
yuiSwitch = function(id, value=FALSE, onLbl="Yes", offLbl="No") {
    switchInput( inputId = id
                ,onLabel = onLbl ,offLabel = offLbl
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

updListBox = function(id, choices, selected=NULL, session=getDefaultReactiveDomain()) {
    updateSelectInput(session, id, choices = c("base 1"=1, "base 2"=2, "base 3"=3), selected = selected)
  #updateSelectInput(session, id, choices = as.list(choices), selected = selected)
}

# Copiadode TextArea
yuiTextArea = function (inputId, label=NULL, value = "", width = NULL, height = NULL,
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
updTextArea = function(id, text, label=NULL, session=getDefaultReactiveDomain()) {
  updateTextAreaInput(session, id, label=label, value=text)
}
.updLabelNumber = function(value, text,bold,color) {
  cls = "yata_num"
  if (bold) cls = paste(cls, "yata_num_bold")
  if (color) {
     col = if(value > 0) cls = paste(cls, "yata_num_pos")
     col = if(value < 0) cls = paste(cls, "yata_num_neg")
  }
  lbl = paste0("<span class='", cls, "'>",text,"</span>")
  renderUI({HTML(lbl)})
}
