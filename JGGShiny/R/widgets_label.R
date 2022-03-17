guiLabelNumber = function(id, label=NULL, inline=TRUE) {
  textOutput(id) %>% tagAppendAttributes(class = 'jgg_number')
}
guiLabelText = function(id, label=NULL, value="") {
  textOutput(outputId=id, inline=TRUE)
}
guiLabelBold = function(id, class) {
  cls = "yata_txt_bold"
  if (!missing(class)) cls = class
  tags$span(class=cls, textOutput(outputId=id, inline=TRUE))
}
updLabelText = function(txt) {
  renderText({ txt })
}
guiLabelNumber = function(id, label=NULL, inline=TRUE) {
  htmlOutput(outputId=id, inline=TRUE, class="yataTextRight")
}
guiLabelNumeric = function(id, label=NULL, inline=TRUE) {
  htmlOutput(outputId=id, inline=TRUE, class="yataTextRight")
}
updLabelNumber   = function(value, dec=-1, bold=TRUE, color=FALSE) {
  text = format(value, big.mark = ".", decimal.mark=",")
  if (dec > -1) text = format(value, big.mark = ".", decimal.mark=",", nsmall=dec)
  .updLabelNumber(value, text, bold, color)
}
guiLabelInteger = function(id, label=NULL, inline=TRUE) {
  htmlOutput(outputId=id, inline=TRUE, class="yataTextRight")
}
updLabelInteger   = function(value, bold=TRUE, color=FALSE) {
  text = format(round(value), big.mark = ".", decimal.mark=",")
  .updLabelNumber(value, text, bold, color)
}
guiLabelPercentage = function(id, label=NULL, inline=TRUE) {
  htmlOutput(outputId=id, inline=TRUE, class="yataTextRight")
}
updLabelPercentage   = function(value, bold=TRUE, color=FALSE) {
  text = format(value, big.mark = ".", decimal.mark=",", nsmall=2)
  .updLabelNumber(value, text, bold, color)
}
guiLabelDate = function(id, label=NULL, inline=TRUE) {
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
  renderText({txt = format(as.POSIXct(epoch, origin="1970-01-01"),"%H:%M:%S") })
  # renderText({txt = format(as.POSIXct(epoch, origin="1970-01-01"),"%H:%M:%S")
  #             HTML(paste0("<span style=\"text-align: right;\">", txt, "</span>"))
  # })
}
guiLabelTime = function(id, label=NULL, inline=TRUE) {
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
updLabelTime = function(epoch) {
  if (missing(epoch)) epoch=as.numeric(Sys.time())
  renderText({format(as.POSIXct(epoch, origin="1970-01-01"),"%H:%M:%S")})
}
