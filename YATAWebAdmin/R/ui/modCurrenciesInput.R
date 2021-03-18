modCurrenciesInput = function(id, title) {
    ns = NS(id)
    tagList(
      fluidRow(column(1, yataBtnOK(ns("btnAddL"), "Agregar"))
        ,column(4, yataTitle("Monedas activas"), DT::dataTableOutput(ns("tblCtcOK")))
        ,column(2)
        ,column(4, yataTitle("Monedas inactivas"), DT::dataTableOutput(ns("tblCtcKO")))
        ,column(1, yataBtnOK(ns("btnAddR"), "Agregar"))
      )
)}
