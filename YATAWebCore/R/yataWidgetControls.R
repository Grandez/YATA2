############################
#### ShinyWidgets
###########################

yataCombo = function( id, label=NULL, choices=NULL, selected = NULL) {
    lbl = NULL
    choice = c("")
    if (!is.null(label))   lbl    = label
    if (!is.null(choices)) choice = choices
    selectInput(id, lbl, choice, selected)
}
updCombo = function(id, lbl=NULL, choices=NULL, selected=NULL, session = getDefaultReactiveDomain()) {
    updateSelectInput(session=session, inputId=id,label=lbl,choices = choices, selected = selected)
}

yataComboSelect = function( id, label=NULL, choices=NULL, text=NULL, selected = NULL) {
    lbl = NULL
    choice = c("")
    if (!is.null(label))   lbl    = label
    if (!is.null(choices)) choice = choices
    selectizeInput(id,lbl,choice,
                   options = list( placeholder = text
                                  ,onInitialize = I('function() { this.setValue(""); }')
                            ))
}

yataSwitch = function(id, value=FALSE) {
    switchInput( inputId = id
                ,onLabel = "Yes" ,offLabel = "No"
                ,onStatus = "success" ,offStatus = "danger"
                , value = value)
}
yataListBox = function( id, label=NULL, choices=NULL, size=10, ...) {
#                                values
#  selectInput('in3', 'Options', state.name, multiple=TRUE, selectize=FALSE, size=10)
    lbl = NULL
    choice = c("")
    if (!is.null(label))   lbl    = label
    if (!is.null(choices)) choice = choices
    selectInput(id,lbl,choice, size, selectize=FALSE,...)
}
