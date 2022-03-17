# Widgets from shinyWidgets
guiCheck = function(id, value=TRUE) {
  shinyWidgets::awesomeCheckbox(id, NULL, value = value)
}
guiRadio = function(id, label=NULL, choices, selected=NULL) {
   shinyWidgets::awesomeRadio(id,label,choices,selected,inline = TRUE,checkbox = TRUE)
}
updRadio = function(id, selected=NULL) {
   shinyWidgets::updateAwesomeRadio(getDefaultReactiveDomain(), id, selected=selected)
}


