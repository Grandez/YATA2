modConfigInput = function(id, title) {
    ns = NS(id)
    tagList(
      fluidRow(
         h2("Cambiar Base de datos")
        ,fluidRow("Base de datos actual", textOutput(ns("txtDB")))
        ,yuiComboSelect(ns("cboDB"), label = "Bases de datos", choices=list(" "))
        ,yuiBtnDanger(ns("btnDB"), label="Cambiar DB")
      )
      ,fluidRow(
        h2("Crear camara")
      )
      ,fluidRow(
        h2("Crear moneda")
      )
)}
