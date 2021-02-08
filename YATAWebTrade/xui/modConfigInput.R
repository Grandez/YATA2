modConfigInput = function(id) {
    ns = NS(id)
    tagList(
      fluidRow(
         h2("Cambiar Base de datos")
        ,fluidRow("Base de datos actual", textOutput(ns("txtDB")))
        ,yataComboSelect(ns("cboDB"), label = "Bases de datos", choices=list(" "))
        ,yataBtnDanger(ns("btnDB"), label="Cambiar DB")
      )
      ,fluidRow(
        h2("Crear camara")
      )
      ,fluidRow(
        h2("Crear moneda")
      )
)}
