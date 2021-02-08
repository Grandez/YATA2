############################
#### Shiny
###########################
yataTextInput = function(id, label=NULL, value="") {
  textInput(inputId=id, label=label, value = value, width = NULL, placeholder = NULL)
}
yataTextLabel = function(id, label=NULL, value="") {
  textOutput(outputId=id, inline=TRUE)
}
yataTextDate = function(id, label=NULL, inline=TRUE) {
  if (!is.null(label)) {
      if (!inline) {
          tags$div( class="form-group shiny-input-container"
                   ,tags$label(class="control-label", label)
                   ,textOutput(outputId=id, inline=TRUE)
          )
      } else {
        tags$div( tags$label(class="control-label", label)
                 ,textOutput(outputId=id, inline=TRUE))
      }
  }
  else {
     textOutput(outputId=id, inline=TRUE)
  }
}
updateTextDate = function(epoch) {
  renderText({format(as.POSIXct(epoch),"%H:%M:%S")})
}
