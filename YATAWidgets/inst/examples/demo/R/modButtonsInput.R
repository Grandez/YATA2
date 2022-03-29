
modButtonsInput = function(id, title) {
ns <- NS(id)
    h2("Aqui los botones")
    tabler_button(ns( "btn"),textOutput("val"),icon = icon("thumbs-up"),width = "25%")
}
