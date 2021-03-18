modParmsGralInput = function(id, title) {
    ns = NS(id)
    tagList(
            yataFormTable(
                list("External data", yataTextInput (ns("txtPlugins")))
               ,list("Base de datos", yataCombo(ns("cboDB")))
               ,list("Auto abrir",    yataSwitch(ns("swAutoOpen")))
               ,list("Alertas",       yataIntegerInput(ns("intAlert")))
           )
      ,fluidRow(column(1)
          ,column(4, yataBtnOK(ns("btnOK"), "Guardar"), yataBtnKO(ns("btnEsc"), "Reset"))
    )

)}